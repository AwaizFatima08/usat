import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:usat_prep/app.dart';
import 'package:usat_prep/attempts/attempt.dart';
import 'package:usat_prep/attempts/attempt_repository.dart';
import 'package:usat_prep/content/content_repository.dart';
import 'package:usat_prep/core/result.dart';
import 'package:usat_prep/features/exam/exam_notifier.dart';
import 'package:usat_prep/router.dart';

import '../test/attempts/attempt_repository_test.dart' show MemoryStore;

/// Play Store phone screenshots, 1080 × 2400, drawn with the real Roboto and Material Icons fonts.
/// Run: flutter test test_screenshots, then copy shots/ to store-assets/screenshots/ (as RGB, no alpha).
void main() {
  late ProviderContainer container;
  final root = GlobalKey();

  setUpAll(() async {
    final fonts = '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts';
    Future<void> load(String family, List<String> files) async {
      final loader = FontLoader(family);
      for (final file in files) {
        final bytes = File('$fonts/$file').readAsBytesSync();
        loader.addFont(Future.value(ByteData.sublistView(bytes)));
      }
      await loader.load();
    }

    await load('Roboto', [
      'Roboto-Regular.ttf',
      'Roboto-Medium.ttf',
      'Roboto-Bold.ttf',
      'Roboto-Italic.ttf',
      'Roboto-Light.ttf',
    ]);
    await load('MaterialIcons', ['MaterialIcons-Regular.otf']);
  });

  Future<void> settle(WidgetTester tester, {int rounds = 10}) async {
    for (var i = 0; i < rounds; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 120)));
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> shot(WidgetTester tester, String name) async {
    await settle(tester, rounds: 4);
    final boundary = root.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: tester.view.devicePixelRatio);
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      File('test_screenshots/shots/$name.png')
        ..createSync(recursive: true)
        ..writeAsBytesSync(png!.buffer.asUint8List());
    });
  }

  Future<void> go(WidgetTester tester, String location) async {
    container.read(routerProvider).go(location);
    await settle(tester);
  }

  testWidgets('store screenshots', (tester) async {
    WidgetsApp.debugAllowBannerOverride = false;
    addTearDown(() => WidgetsApp.debugAllowBannerOverride = true);
    // A 1080 × 2400 phone at 2.625 dpr: 411 × 914 logical pixels.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
    container = ProviderContainer(
      overrides: [
        assetReaderProvider.overrideWithValue((path) async => File(path).readAsString()),
        attemptStoreProvider.overrideWithValue(MemoryStore()),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      RepaintBoundary(
        key: root,
        child: UncontrolledProviderScope(container: container, child: const UsatApp()),
      ),
    );
    await settle(tester, rounds: 20);
    await shot(tester, '01-home');

    await go(tester, '/paper/usat-m-01');
    await shot(tester, '02-paper');

    // A mock with most answers right, so the results look like a strong candidate's.
    final started = await tester.runAsync(
      () => container
          .read(attemptRepositoryProvider)
          .start(paperId: 'usat-m-01', useEthics: false, minutes: 100),
    );
    final id = (started! as Ok<Attempt, StorageFailure>).value.id;
    await go(tester, '/exam/$id');
    await settle(tester, rounds: 20);
    final notifier = container.read(examProvider(id).notifier);
    final exam = container.read(examProvider(id)).value!;
    final questions = exam.sitting.questions;
    for (var i = 0; i < questions.length; i++) {
      final q = questions[i];
      await tester.runAsync(() => notifier.goTo(i));
      await tester.runAsync(() => notifier.choose(i % 6 == 5 ? (q.answer + 1) % 4 : q.answer));
    }
    await tester.runAsync(() => notifier.goTo(64));
    await settle(tester);
    await shot(tester, '03-question');

    unawaited(notifier.submit());
    await settle(tester, rounds: 20);
    await tester.tap(find.byType(RadioListTile<String>).first);
    await settle(tester, rounds: 3);
    await tester.enterText(
      find.byType(TextField),
      'In my view, technology has made learning easier for students in Pakistan, but only when '
      'it is used with discipline. A student in a small town can now watch a lesson from a good '
      'teacher, practise questions and check answers at once.',
    );
    await settle(tester, rounds: 3);
    FocusManager.instance.primaryFocus?.unfocus();
    await settle(tester, rounds: 3);
    await shot(tester, '04-essay');

    await tester.runAsync(
      () => container
          .read(attemptRepositoryProvider)
          .update(
            id,
            (a) => a.copyWith(
              essay: EssayPart(
                remainingSeconds: 0,
                done: true,
                argumentId: exam.sitting.paper.essays!.argument.first,
                argumentText: 'In my view, technology has made learning easier.',
                narrativeId: exam.sitting.paper.essays!.narrative.first,
                narrativeText: 'The bus was late again.',
                argumentScore: 11,
                narrativeScore: 7,
              ),
            ),
          ),
    );
    container.invalidate(reviewProvider(id));
    await go(tester, '/results/$id');
    await settle(tester, rounds: 10);
    await shot(tester, '05-results');

    await go(tester, '/review/$id');
    await shot(tester, '06-review');

    await go(tester, '/lesson/biology/genetics');
    await shot(tester, '07-lesson');

    await go(tester, '/memory/chemistry');
    await tester.tap(find.byType(ExpansionTile).first);
    await settle(tester);
    await shot(tester, '08-memory');
  });
}
