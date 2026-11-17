import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:usat_prep/content/models.dart';
import 'package:usat_prep/features/about/about_screen.dart';
import 'package:usat_prep/features/essay/essay_part_screen.dart';
import 'package:usat_prep/features/essay/essay_practice_screen.dart';
import 'package:usat_prep/features/exam/exam_screen.dart';
import 'package:usat_prep/features/guide/guide_article_screen.dart';
import 'package:usat_prep/features/home/home_screen.dart';
import 'package:usat_prep/features/home/paper_screen.dart';
import 'package:usat_prep/features/practice/practice_screen.dart';
import 'package:usat_prep/features/results/results_screen.dart';
import 'package:usat_prep/features/results/review_screen.dart';
import 'package:usat_prep/features/study/memory_screen.dart';
import 'package:usat_prep/features/study/topic_screen.dart';

final routerProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
      GoRoute(path: '/about', builder: (_, _) => const AboutScreen()),
      GoRoute(
        path: '/paper/:id',
        builder: (_, state) => PaperScreen(paperId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/exam/:id',
        builder: (_, state) => ExamScreen(attemptId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/essay/:id',
        builder: (_, state) => EssayPartScreen(attemptId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/essay-rate/:id',
        builder: (_, state) => EssayRateScreen(attemptId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/essays/:kind',
        builder: (_, state) =>
            EssayListScreen(kind: EssayKind.values.byName(state.pathParameters['kind']!)),
      ),
      GoRoute(
        path: '/write/:id',
        builder: (_, state) => EssayPracticeScreen(promptId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/results/:id',
        builder: (_, state) => ResultsScreen(attemptId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/review/:id',
        builder: (_, state) => ReviewScreen(attemptId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/guide/:id',
        builder: (_, state) => GuideArticleScreen(articleId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/topic/:section/:topic',
        builder: (_, state) => TopicScreen(
          section: state.pathParameters['section']!,
          topic: state.pathParameters['topic']!,
        ),
      ),
      GoRoute(
        path: '/lesson/:section/:topic',
        builder: (_, state) => LessonScreen(
          section: state.pathParameters['section']!,
          topic: state.pathParameters['topic']!,
        ),
      ),
      GoRoute(
        path: '/memory/:section',
        builder: (_, state) => MemoryScreen(section: state.pathParameters['section']!),
      ),
      GoRoute(
        path: '/practice/:section/:topic',
        builder: (_, state) => PracticeScreen(
          section: state.pathParameters['section']!,
          topic: state.pathParameters['topic']!,
        ),
      ),
    ],
  ),
);
