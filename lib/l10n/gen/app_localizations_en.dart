// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Prep Simulator for USAT';

  @override
  String loadError(String code) {
    return 'Could not load this. Please restart the app. ($code)';
  }

  @override
  String get tabTests => 'Tests';

  @override
  String get tabPractice => 'Study';

  @override
  String get tabGuide => 'Guide';

  @override
  String get tabProgress => 'Progress';

  @override
  String get about => 'About';

  @override
  String testsIntro(int count, int minutes) {
    return 'Part I: $count MCQs in $minutes minutes. Part II: two essays in 40 minutes. 20 full mock tests per category.';
  }

  @override
  String testNumber(int number) {
    return 'Test $number';
  }

  @override
  String bestScore(int percent) {
    return 'Best $percent%';
  }

  @override
  String get inProgress => 'In progress';

  @override
  String get notStarted => 'Not taken';

  @override
  String sectionCount(int count) {
    return '$count questions';
  }

  @override
  String minutesLabel(int minutes) {
    return '$minutes minutes';
  }

  @override
  String get useEthics => 'I will sit Ethics instead of Islamiat';

  @override
  String get useEthicsHelp =>
      'Non-Muslim candidates take Ethics in place of Islamiat. Check your roll-number slip.';

  @override
  String get startTest => 'Start test';

  @override
  String get resumeTest => 'Resume test';

  @override
  String get restartTest => 'Start again';

  @override
  String get paperRules =>
      'Timed like the real test: Part I first, then Part II essays. You can move between questions, flag them and change answers. No calculator. The timer pauses if you leave the test.';

  @override
  String get unofficialNote =>
      'Independent practice test following HEC\'s published USAT content weightages. Real papers can differ, so always follow ETC\'s own instructions.';

  @override
  String get previousAttempts => 'Previous attempts';

  @override
  String questionOf(int number, int total) {
    return 'Question $number of $total';
  }

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get flag => 'Flag';

  @override
  String get unflag => 'Unflag';

  @override
  String get questions => 'Questions';

  @override
  String get clearAnswer => 'Clear answer';

  @override
  String get submit => 'Submit Part I';

  @override
  String get submitTitle => 'Submit Part I?';

  @override
  String submitBody(int answered, int total, int flagged) {
    return 'Answered $answered of $total. Flagged $flagged. You cannot change answers after submitting. Part II (essays) comes next.';
  }

  @override
  String get keepWorking => 'Keep working';

  @override
  String get leaveTitle => 'Leave this test?';

  @override
  String get leaveBody =>
      'Your answers are saved and the timer pauses. You can resume from the test page.';

  @override
  String get leave => 'Leave';

  @override
  String get stay => 'Stay';

  @override
  String get readPassage => 'Show passage';

  @override
  String get hidePassage => 'Hide passage';

  @override
  String get timeLeft => 'Time left';

  @override
  String get results => 'Your result';

  @override
  String scoreOutOf(int correct, int total) {
    return '$correct / $total';
  }

  @override
  String percentLabel(int percent) {
    return '$percent%';
  }

  @override
  String scoreNote(int answered, int skipped) {
    return 'Answered $answered, skipped $skipped. This is a practice score, not an official USAT result.';
  }

  @override
  String get bySection => 'By section';

  @override
  String get weakTopics => 'Topics to work on';

  @override
  String get reviewAnswers => 'Review answers and explanations';

  @override
  String get backHome => 'Back to tests';

  @override
  String get filterAll => 'All';

  @override
  String get filterWrong => 'Wrong';

  @override
  String get filterSkipped => 'Skipped';

  @override
  String get filterEmpty => 'Nothing here.';

  @override
  String get yourAnswer => 'Your answer';

  @override
  String get correctAnswer => 'Correct answer';

  @override
  String get notAnswered => 'Not answered';

  @override
  String get explanation => 'Explanation';

  @override
  String get practiceIntro =>
      'Study notes and short practice sets for every topic in HEC\'s USAT weightages. You see the answer and explanation straight away. These questions are separate from the mock tests.';

  @override
  String practiceTally(int correct, int total) {
    return '$correct of $total right';
  }

  @override
  String get practiceEmpty => 'Questions for this topic are on the way.';

  @override
  String get checkAnswer => 'Check';

  @override
  String get finish => 'Finish';

  @override
  String get practiceAgain => 'Practise again';

  @override
  String get practiceDone => 'Practice finished';

  @override
  String get guideLoading => 'Guide';

  @override
  String get progressEmpty => 'Finish a test or a practice set to see your progress here.';

  @override
  String get testsTaken => 'Tests taken';

  @override
  String get averageScore => 'Average';

  @override
  String get bestOverall => 'Best';

  @override
  String get history => 'Test history';

  @override
  String get topicMastery => 'Weakest topics';

  @override
  String get deleteAttempt => 'Delete';

  @override
  String get aboutBody =>
      'Prep Simulator for USAT is an independent practice app by HomiLabs. It is not affiliated with, endorsed by or connected to the Higher Education Commission (HEC), its Education Testing Council (ETC) or any university. All questions, passages, essay prompts and model answers are original practice material, not real USAT papers, and scores are for practice only.';

  @override
  String get privacy => 'Privacy policy';

  @override
  String get privacyChoices => 'Privacy choices';

  @override
  String get terms => 'Terms of use';

  @override
  String get website => 'Website';

  @override
  String get contact => 'Contact: homilabs.smc@gmail.com';

  @override
  String get version => 'Version 1.0.0';

  @override
  String get reviewTitle => 'Review answers';

  @override
  String get lesson => 'Study notes';

  @override
  String get lessonHelp => 'Key ideas, worked examples and traps';

  @override
  String get practiceSet => 'Practice questions';

  @override
  String practicePool(int count) {
    return '$count questions';
  }

  @override
  String readingTime(int minutes) {
    return 'About $minutes min read';
  }

  @override
  String get practiceNow => 'Practise this topic';

  @override
  String get memoryGroup => 'Memory tricks';

  @override
  String get memoryIntro => 'Formula sheets, mnemonics and rules worth learning by heart.';

  @override
  String memoryTitle(String section) {
    return '$section: memory tricks';
  }

  @override
  String memoryCount(int count) {
    return '$count cards';
  }

  @override
  String get partTwo => 'Part II: Essays';

  @override
  String partTwoIntro(int minutes) {
    return '$minutes minutes for both essays. Choose one prompt of each kind and write in English. Switch between the two with the buttons below; your writing is kept.';
  }

  @override
  String argumentEssay(int marks) {
    return 'Argument ($marks)';
  }

  @override
  String narrativeEssay(int marks) {
    return 'Narrative ($marks)';
  }

  @override
  String get choosePrompt => 'Choose one prompt';

  @override
  String get choosePromptFirst => 'Choose a prompt above to start writing';

  @override
  String get essayHint => 'Write your essay here';

  @override
  String wordCount(int count) {
    return '$count words';
  }

  @override
  String get finishPartTwo => 'Finish Part II';

  @override
  String get finishPartTwoTitle => 'Finish Part II?';

  @override
  String get finishPartTwoBody =>
      'Your essays are saved. Next you see your Part I result and can rate your essays against the marking points.';

  @override
  String get skipPartTwo => 'Skip Part II';

  @override
  String get skipPartTwoTitle => 'Skip Part II?';

  @override
  String get skipPartTwoBody =>
      'Part II will count as 0 out of 25. You can practise essays any time from the Study tab.';

  @override
  String get rateEssays => 'Rate your essays';

  @override
  String get reviewEssays => 'Your essays and model answers';

  @override
  String get noPromptChosen => 'You did not write this essay, so it earns 0.';

  @override
  String get qualifies => 'At or above the qualifying score of 50';

  @override
  String get belowQualifying => 'Below the qualifying score of 50';

  @override
  String get rateToFinish => 'Rate your two essays to see your total out of 100.';

  @override
  String partOneMarks(int marks, int max, int percent) {
    return 'Part I: $marks / $max ($percent%)';
  }

  @override
  String partTwoMarks(int marks, int max) {
    return 'Part II: $marks / $max';
  }

  @override
  String partTwoUnrated(int max) {
    return 'Part II: not rated yet (out of $max)';
  }

  @override
  String get yourEssay => 'Your essay';

  @override
  String get essayEmpty => '(nothing written)';

  @override
  String get strongResponse => 'What a strong answer covers';

  @override
  String get modelEssay => 'Model answer';

  @override
  String get modelEssayNote => 'One good answer, not the only one';

  @override
  String get rateYourself => 'Rate yourself';

  @override
  String get rateYourselfHelp =>
      'Tick what your essay really does. The suggestion is a guide; set the marks you honestly think it earns.';

  @override
  String get criterionPosition => 'States a clear position early and keeps to it';

  @override
  String get criterionReasons => 'Gives at least two reasons, each with a specific example';

  @override
  String get criterionCounter => 'Answers the other side fairly';

  @override
  String get criterionOrganisation => 'Has an introduction, linked paragraphs and a conclusion';

  @override
  String get criterionLanguage => 'Uses varied, accurate vocabulary and sentences';

  @override
  String get criterionMechanics => 'Has few spelling, grammar or punctuation errors';

  @override
  String get criterionOpening => 'Opens in a way that makes the reader want to go on';

  @override
  String get criterionSequence => 'Tells events in a clear order with a turning point';

  @override
  String get criterionDetail => 'Brings people and places alive with detail or dialogue';

  @override
  String get criterionEnding => 'Ends with a meaningful outcome or reflection';

  @override
  String suggestedMarks(int marks, int max) {
    return 'Suggested: $marks / $max';
  }

  @override
  String saveMarks(int marks, int max) {
    return 'Save $marks / $max';
  }

  @override
  String get scoreSaved => 'Marks saved';

  @override
  String get finishEssay => 'Finish and assess';

  @override
  String get essaySection => 'Part II: Essay writing';

  @override
  String get argumentPractice => 'Argument essays';

  @override
  String get narrativePractice => 'Narrative essays';

  @override
  String get argumentPracticeIntro =>
      'Take a position and defend it. In the test you choose 1 of 3 prompts; it carries 15 marks. A 20-minute clock runs, half of Part II.';

  @override
  String get narrativePracticeIntro =>
      'Tell a story with a clear beginning, turning point and ending. In the test you choose 1 of 3 prompts; it carries 10 marks. A 20-minute clock runs, half of Part II.';

  @override
  String get homeTitle => 'USAT Simulator';

  @override
  String partOneLabel(int minutes) {
    return 'Part I: 75 MCQs, $minutes minutes';
  }

  @override
  String partTwoLabel(int minutes) {
    return 'Part II: Essays, $minutes minutes';
  }

  @override
  String chooseOneOf(int count) {
    return 'choose 1 of $count';
  }

  @override
  String get continuePartTwo => 'Continue to Part II';
}
