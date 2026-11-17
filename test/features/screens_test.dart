import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
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

import '../attempts/attempt_repository_test.dart' show MemoryStore;

/// Opens real screens with the built content, so a broken layout or a hang fails here, not on a phone.
void main() {
  late ProviderContainer container;

  /// Lets file reads and isolates finish, then draws.
  Future<void> settle(WidgetTester tester, {int rounds = 10}) async {
    for (var i = 0; i < rounds; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 120)));
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> open(WidgetTester tester, String location) async {
    // A tall phone (412 × 1000 logical pixels).
    tester.view.physicalSize = const Size(1236, 3000);
    tester.view.devicePixelRatio = 3;
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
      UncontrolledProviderScope(container: container, child: const UsatApp()),
    );
    container.read(routerProvider).go(location);
    await settle(tester, rounds: 20);
  }

  testWidgets('the paper screen shows both parts', (tester) async {
    await open(tester, '/paper/usat-m-01');
    expect(find.text('Verbal Reasoning'), findsOneWidget);
    expect(find.text('Biology'), findsOneWidget);
    expect(find.text('Part II: Essays, 40 minutes'), findsOneWidget);
  });

  testWidgets('a whole mock runs from Part I through Part II to marks out of 100', (tester) async {
    await open(tester, '/');
    final started = await tester.runAsync(
      () => container
          .read(attemptRepositoryProvider)
          .start(paperId: 'usat-e-01', useEthics: false, minutes: 100),
    );
    final id = (started! as Ok<Attempt, StorageFailure>).value.id;
    container.read(routerProvider).go('/exam/$id');
    await settle(tester, rounds: 30);
    final notifier = container.read(examProvider(id).notifier);
    final exam = container.read(examProvider(id)).value!;
    expect(exam.sitting.questions, hasLength(75));

    // Answer every question correctly, then submit: Part II opens.
    for (var i = 0; i < exam.sitting.questions.length; i++) {
      await tester.runAsync(() => notifier.goTo(i));
      await tester.runAsync(() => notifier.choose(exam.sitting.questions[i].answer));
    }
    // Not awaited inside runAsync: submitting navigates, which needs frames to finish.
    unawaited(notifier.submit());
    for (var i = 0; i < 20; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 120)));
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('Part II: Essays'), findsOneWidget);

    // Choose an argument prompt and write a little, then finish.
    await tester.tap(find.byType(RadioListTile<String>).first);
    await settle(tester, rounds: 3);
    await tester.enterText(find.byType(TextField), 'Technology helps students learn faster. ' * 40);
    await settle(tester, rounds: 3);
    final finish = find.widgetWithText(FilledButton, 'Finish Part II');
    await tester.scrollUntilVisible(finish, 300, scrollable: find.byType(Scrollable).first);
    await tester.tap(finish);
    await settle(tester, rounds: 3);
    await tester.tap(find.widgetWithText(FilledButton, 'Finish Part II').last);
    await settle(tester, rounds: 20);
    expect(find.text('75 + ?'), findsOneWidget);
    expect(find.text('Part I: 75 / 75 (100%)'), findsOneWidget);

    // Rate both essays: the argument with the slider's suggestion, the empty narrative as 0.
    await tester.tap(find.text('Rate your essays'));
    await settle(tester);
    final list = find.descendant(of: find.byType(ListView), matching: find.byType(Scrollable));
    await tester.scrollUntilVisible(find.textContaining('Save '), 300, scrollable: list.first);
    await tester.drag(list.first, const Offset(0, -300));
    await settle(tester, rounds: 3);
    await tester.tap(find.textContaining('Save '));
    await settle(tester);
    await tester.tap(find.text('Narrative (10)'));
    await settle(tester);
    await tester.tap(find.text('Save 0 / 10'));
    await settle(tester);
    final part = (await tester.runAsync(
      () => container.read(attemptRepositoryProvider).byId(id),
    ))!.essay!;
    expect(part.argumentScore, isNotNull);
    expect(part.narrativeScore, 0);
    expect(part.argumentText, contains('Technology'));

    container.read(routerProvider).go('/results/$id');
    await settle(tester, rounds: 20);
    expect(find.text('${75 + part.score} / 100'), findsOneWidget);
    expect(find.text('At or above the qualifying score of 50'), findsOneWidget);

    for (final location in ['/review/$id', '/essay-rate/$id']) {
      container.read(routerProvider).go(location);
      await settle(tester);
      expect(tester.takeException(), isNull, reason: location);
    }
  });

  testWidgets('study, essay practice, memory, guide and about screens open', (tester) async {
    await open(tester, '/');
    const locations = [
      '/topic/verbal/analogy',
      '/lesson/verbal/analogy',
      '/lesson/quant/scenario',
      '/lesson/accounting/basics',
      '/practice/stats/probability',
      '/practice/verbal/comprehension',
      '/memory/physics',
      '/memory/accounting',
      '/essays/argument',
      '/essays/narrative',
      '/write/ea-p0001',
      '/write/en-p0001',
      '/guide/glance',
      '/guide/memorise',
      '/paper/usat-a-01',
      '/about',
    ];
    for (final location in locations) {
      container.read(routerProvider).go(location);
      await settle(tester);
      expect(tester.takeException(), isNull, reason: location);
      expect(find.textContaining('Could not load'), findsNothing, reason: location);
    }
  });
}
