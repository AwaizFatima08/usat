import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Prep Simulator for USAT'**
  String get appTitle;

  /// No description provided for @loadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load this. Please restart the app. ({code})'**
  String loadError(String code);

  /// No description provided for @tabTests.
  ///
  /// In en, this message translates to:
  /// **'Tests'**
  String get tabTests;

  /// No description provided for @tabPractice.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get tabPractice;

  /// No description provided for @tabGuide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get tabGuide;

  /// No description provided for @tabProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get tabProgress;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @testsIntro.
  ///
  /// In en, this message translates to:
  /// **'Part I: {count} MCQs in {minutes} minutes. Part II: two essays in 40 minutes. 20 full mock tests per category.'**
  String testsIntro(int count, int minutes);

  /// No description provided for @testNumber.
  ///
  /// In en, this message translates to:
  /// **'Test {number}'**
  String testNumber(int number);

  /// No description provided for @bestScore.
  ///
  /// In en, this message translates to:
  /// **'Best {percent}%'**
  String bestScore(int percent);

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgress;

  /// No description provided for @notStarted.
  ///
  /// In en, this message translates to:
  /// **'Not taken'**
  String get notStarted;

  /// No description provided for @sectionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} questions'**
  String sectionCount(int count);

  /// No description provided for @minutesLabel.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String minutesLabel(int minutes);

  /// No description provided for @useEthics.
  ///
  /// In en, this message translates to:
  /// **'I will sit Ethics instead of Islamiat'**
  String get useEthics;

  /// No description provided for @useEthicsHelp.
  ///
  /// In en, this message translates to:
  /// **'Non-Muslim candidates take Ethics in place of Islamiat. Check your roll-number slip.'**
  String get useEthicsHelp;

  /// No description provided for @startTest.
  ///
  /// In en, this message translates to:
  /// **'Start test'**
  String get startTest;

  /// No description provided for @resumeTest.
  ///
  /// In en, this message translates to:
  /// **'Resume test'**
  String get resumeTest;

  /// No description provided for @restartTest.
  ///
  /// In en, this message translates to:
  /// **'Start again'**
  String get restartTest;

  /// No description provided for @paperRules.
  ///
  /// In en, this message translates to:
  /// **'Timed like the real test: Part I first, then Part II essays. You can move between questions, flag them and change answers. No calculator. The timer pauses if you leave the test.'**
  String get paperRules;

  /// No description provided for @unofficialNote.
  ///
  /// In en, this message translates to:
  /// **'Independent practice test following HEC\'s published USAT content weightages. Real papers can differ, so always follow ETC\'s own instructions.'**
  String get unofficialNote;

  /// No description provided for @previousAttempts.
  ///
  /// In en, this message translates to:
  /// **'Previous attempts'**
  String get previousAttempts;

  /// No description provided for @questionOf.
  ///
  /// In en, this message translates to:
  /// **'Question {number} of {total}'**
  String questionOf(int number, int total);

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @flag.
  ///
  /// In en, this message translates to:
  /// **'Flag'**
  String get flag;

  /// No description provided for @unflag.
  ///
  /// In en, this message translates to:
  /// **'Unflag'**
  String get unflag;

  /// No description provided for @questions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get questions;

  /// No description provided for @clearAnswer.
  ///
  /// In en, this message translates to:
  /// **'Clear answer'**
  String get clearAnswer;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit Part I'**
  String get submit;

  /// No description provided for @submitTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit Part I?'**
  String get submitTitle;

  /// No description provided for @submitBody.
  ///
  /// In en, this message translates to:
  /// **'Answered {answered} of {total}. Flagged {flagged}. You cannot change answers after submitting. Part II (essays) comes next.'**
  String submitBody(int answered, int total, int flagged);

  /// No description provided for @keepWorking.
  ///
  /// In en, this message translates to:
  /// **'Keep working'**
  String get keepWorking;

  /// No description provided for @leaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave this test?'**
  String get leaveTitle;

  /// No description provided for @leaveBody.
  ///
  /// In en, this message translates to:
  /// **'Your answers are saved and the timer pauses. You can resume from the test page.'**
  String get leaveBody;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// No description provided for @readPassage.
  ///
  /// In en, this message translates to:
  /// **'Show passage'**
  String get readPassage;

  /// No description provided for @hidePassage.
  ///
  /// In en, this message translates to:
  /// **'Hide passage'**
  String get hidePassage;

  /// No description provided for @timeLeft.
  ///
  /// In en, this message translates to:
  /// **'Time left'**
  String get timeLeft;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Your result'**
  String get results;

  /// No description provided for @scoreOutOf.
  ///
  /// In en, this message translates to:
  /// **'{correct} / {total}'**
  String scoreOutOf(int correct, int total);

  /// No description provided for @percentLabel.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String percentLabel(int percent);

  /// No description provided for @scoreNote.
  ///
  /// In en, this message translates to:
  /// **'Answered {answered}, skipped {skipped}. This is a practice score, not an official USAT result.'**
  String scoreNote(int answered, int skipped);

  /// No description provided for @bySection.
  ///
  /// In en, this message translates to:
  /// **'By section'**
  String get bySection;

  /// No description provided for @weakTopics.
  ///
  /// In en, this message translates to:
  /// **'Topics to work on'**
  String get weakTopics;

  /// No description provided for @reviewAnswers.
  ///
  /// In en, this message translates to:
  /// **'Review answers and explanations'**
  String get reviewAnswers;

  /// No description provided for @backHome.
  ///
  /// In en, this message translates to:
  /// **'Back to tests'**
  String get backHome;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get filterWrong;

  /// No description provided for @filterSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get filterSkipped;

  /// No description provided for @filterEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here.'**
  String get filterEmpty;

  /// No description provided for @yourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get yourAnswer;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get correctAnswer;

  /// No description provided for @notAnswered.
  ///
  /// In en, this message translates to:
  /// **'Not answered'**
  String get notAnswered;

  /// No description provided for @explanation.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get explanation;

  /// No description provided for @practiceIntro.
  ///
  /// In en, this message translates to:
  /// **'Study notes and short practice sets for every topic in HEC\'s USAT weightages. You see the answer and explanation straight away. These questions are separate from the mock tests.'**
  String get practiceIntro;

  /// No description provided for @practiceTally.
  ///
  /// In en, this message translates to:
  /// **'{correct} of {total} right'**
  String practiceTally(int correct, int total);

  /// No description provided for @practiceEmpty.
  ///
  /// In en, this message translates to:
  /// **'Questions for this topic are on the way.'**
  String get practiceEmpty;

  /// No description provided for @checkAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get checkAnswer;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @practiceAgain.
  ///
  /// In en, this message translates to:
  /// **'Practise again'**
  String get practiceAgain;

  /// No description provided for @practiceDone.
  ///
  /// In en, this message translates to:
  /// **'Practice finished'**
  String get practiceDone;

  /// No description provided for @guideLoading.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get guideLoading;

  /// No description provided for @progressEmpty.
  ///
  /// In en, this message translates to:
  /// **'Finish a test or a practice set to see your progress here.'**
  String get progressEmpty;

  /// No description provided for @testsTaken.
  ///
  /// In en, this message translates to:
  /// **'Tests taken'**
  String get testsTaken;

  /// No description provided for @averageScore.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get averageScore;

  /// No description provided for @bestOverall.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get bestOverall;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'Test history'**
  String get history;

  /// No description provided for @topicMastery.
  ///
  /// In en, this message translates to:
  /// **'Weakest topics'**
  String get topicMastery;

  /// No description provided for @deleteAttempt.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAttempt;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'Prep Simulator for USAT is an independent practice app by HomiLabs. It is not affiliated with, endorsed by or connected to the Higher Education Commission (HEC), its Education Testing Council (ETC) or any university. All questions, passages, essay prompts and model answers are original practice material, not real USAT papers, and scores are for practice only.'**
  String get aboutBody;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacy;

  /// No description provided for @privacyChoices.
  ///
  /// In en, this message translates to:
  /// **'Privacy choices'**
  String get privacyChoices;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get terms;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact: homilabs.smc@gmail.com'**
  String get contact;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review answers'**
  String get reviewTitle;

  /// No description provided for @lesson.
  ///
  /// In en, this message translates to:
  /// **'Study notes'**
  String get lesson;

  /// No description provided for @lessonHelp.
  ///
  /// In en, this message translates to:
  /// **'Key ideas, worked examples and traps'**
  String get lessonHelp;

  /// No description provided for @practiceSet.
  ///
  /// In en, this message translates to:
  /// **'Practice questions'**
  String get practiceSet;

  /// No description provided for @practicePool.
  ///
  /// In en, this message translates to:
  /// **'{count} questions'**
  String practicePool(int count);

  /// No description provided for @readingTime.
  ///
  /// In en, this message translates to:
  /// **'About {minutes} min read'**
  String readingTime(int minutes);

  /// No description provided for @practiceNow.
  ///
  /// In en, this message translates to:
  /// **'Practise this topic'**
  String get practiceNow;

  /// No description provided for @memoryGroup.
  ///
  /// In en, this message translates to:
  /// **'Memory tricks'**
  String get memoryGroup;

  /// No description provided for @memoryIntro.
  ///
  /// In en, this message translates to:
  /// **'Formula sheets, mnemonics and rules worth learning by heart.'**
  String get memoryIntro;

  /// No description provided for @memoryTitle.
  ///
  /// In en, this message translates to:
  /// **'{section}: memory tricks'**
  String memoryTitle(String section);

  /// No description provided for @memoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} cards'**
  String memoryCount(int count);

  /// No description provided for @partTwo.
  ///
  /// In en, this message translates to:
  /// **'Part II: Essays'**
  String get partTwo;

  /// No description provided for @partTwoIntro.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes for both essays. Choose one prompt of each kind and write in English. Switch between the two with the buttons below; your writing is kept.'**
  String partTwoIntro(int minutes);

  /// No description provided for @argumentEssay.
  ///
  /// In en, this message translates to:
  /// **'Argument ({marks})'**
  String argumentEssay(int marks);

  /// No description provided for @narrativeEssay.
  ///
  /// In en, this message translates to:
  /// **'Narrative ({marks})'**
  String narrativeEssay(int marks);

  /// No description provided for @choosePrompt.
  ///
  /// In en, this message translates to:
  /// **'Choose one prompt'**
  String get choosePrompt;

  /// No description provided for @choosePromptFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose a prompt above to start writing'**
  String get choosePromptFirst;

  /// No description provided for @essayHint.
  ///
  /// In en, this message translates to:
  /// **'Write your essay here'**
  String get essayHint;

  /// No description provided for @wordCount.
  ///
  /// In en, this message translates to:
  /// **'{count} words'**
  String wordCount(int count);

  /// No description provided for @finishPartTwo.
  ///
  /// In en, this message translates to:
  /// **'Finish Part II'**
  String get finishPartTwo;

  /// No description provided for @finishPartTwoTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish Part II?'**
  String get finishPartTwoTitle;

  /// No description provided for @finishPartTwoBody.
  ///
  /// In en, this message translates to:
  /// **'Your essays are saved. Next you see your Part I result and can rate your essays against the marking points.'**
  String get finishPartTwoBody;

  /// No description provided for @skipPartTwo.
  ///
  /// In en, this message translates to:
  /// **'Skip Part II'**
  String get skipPartTwo;

  /// No description provided for @skipPartTwoTitle.
  ///
  /// In en, this message translates to:
  /// **'Skip Part II?'**
  String get skipPartTwoTitle;

  /// No description provided for @skipPartTwoBody.
  ///
  /// In en, this message translates to:
  /// **'Part II will count as 0 out of 25. You can practise essays any time from the Study tab.'**
  String get skipPartTwoBody;

  /// No description provided for @rateEssays.
  ///
  /// In en, this message translates to:
  /// **'Rate your essays'**
  String get rateEssays;

  /// No description provided for @reviewEssays.
  ///
  /// In en, this message translates to:
  /// **'Your essays and model answers'**
  String get reviewEssays;

  /// No description provided for @noPromptChosen.
  ///
  /// In en, this message translates to:
  /// **'You did not write this essay, so it earns 0.'**
  String get noPromptChosen;

  /// No description provided for @qualifies.
  ///
  /// In en, this message translates to:
  /// **'At or above the qualifying score of 50'**
  String get qualifies;

  /// No description provided for @belowQualifying.
  ///
  /// In en, this message translates to:
  /// **'Below the qualifying score of 50'**
  String get belowQualifying;

  /// No description provided for @rateToFinish.
  ///
  /// In en, this message translates to:
  /// **'Rate your two essays to see your total out of 100.'**
  String get rateToFinish;

  /// No description provided for @partOneMarks.
  ///
  /// In en, this message translates to:
  /// **'Part I: {marks} / {max} ({percent}%)'**
  String partOneMarks(int marks, int max, int percent);

  /// No description provided for @partTwoMarks.
  ///
  /// In en, this message translates to:
  /// **'Part II: {marks} / {max}'**
  String partTwoMarks(int marks, int max);

  /// No description provided for @partTwoUnrated.
  ///
  /// In en, this message translates to:
  /// **'Part II: not rated yet (out of {max})'**
  String partTwoUnrated(int max);

  /// No description provided for @yourEssay.
  ///
  /// In en, this message translates to:
  /// **'Your essay'**
  String get yourEssay;

  /// No description provided for @essayEmpty.
  ///
  /// In en, this message translates to:
  /// **'(nothing written)'**
  String get essayEmpty;

  /// No description provided for @strongResponse.
  ///
  /// In en, this message translates to:
  /// **'What a strong answer covers'**
  String get strongResponse;

  /// No description provided for @modelEssay.
  ///
  /// In en, this message translates to:
  /// **'Model answer'**
  String get modelEssay;

  /// No description provided for @modelEssayNote.
  ///
  /// In en, this message translates to:
  /// **'One good answer, not the only one'**
  String get modelEssayNote;

  /// No description provided for @rateYourself.
  ///
  /// In en, this message translates to:
  /// **'Rate yourself'**
  String get rateYourself;

  /// No description provided for @rateYourselfHelp.
  ///
  /// In en, this message translates to:
  /// **'Tick what your essay really does. The suggestion is a guide; set the marks you honestly think it earns.'**
  String get rateYourselfHelp;

  /// No description provided for @criterionPosition.
  ///
  /// In en, this message translates to:
  /// **'States a clear position early and keeps to it'**
  String get criterionPosition;

  /// No description provided for @criterionReasons.
  ///
  /// In en, this message translates to:
  /// **'Gives at least two reasons, each with a specific example'**
  String get criterionReasons;

  /// No description provided for @criterionCounter.
  ///
  /// In en, this message translates to:
  /// **'Answers the other side fairly'**
  String get criterionCounter;

  /// No description provided for @criterionOrganisation.
  ///
  /// In en, this message translates to:
  /// **'Has an introduction, linked paragraphs and a conclusion'**
  String get criterionOrganisation;

  /// No description provided for @criterionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Uses varied, accurate vocabulary and sentences'**
  String get criterionLanguage;

  /// No description provided for @criterionMechanics.
  ///
  /// In en, this message translates to:
  /// **'Has few spelling, grammar or punctuation errors'**
  String get criterionMechanics;

  /// No description provided for @criterionOpening.
  ///
  /// In en, this message translates to:
  /// **'Opens in a way that makes the reader want to go on'**
  String get criterionOpening;

  /// No description provided for @criterionSequence.
  ///
  /// In en, this message translates to:
  /// **'Tells events in a clear order with a turning point'**
  String get criterionSequence;

  /// No description provided for @criterionDetail.
  ///
  /// In en, this message translates to:
  /// **'Brings people and places alive with detail or dialogue'**
  String get criterionDetail;

  /// No description provided for @criterionEnding.
  ///
  /// In en, this message translates to:
  /// **'Ends with a meaningful outcome or reflection'**
  String get criterionEnding;

  /// No description provided for @suggestedMarks.
  ///
  /// In en, this message translates to:
  /// **'Suggested: {marks} / {max}'**
  String suggestedMarks(int marks, int max);

  /// No description provided for @saveMarks.
  ///
  /// In en, this message translates to:
  /// **'Save {marks} / {max}'**
  String saveMarks(int marks, int max);

  /// No description provided for @scoreSaved.
  ///
  /// In en, this message translates to:
  /// **'Marks saved'**
  String get scoreSaved;

  /// No description provided for @finishEssay.
  ///
  /// In en, this message translates to:
  /// **'Finish and assess'**
  String get finishEssay;

  /// No description provided for @essaySection.
  ///
  /// In en, this message translates to:
  /// **'Part II: Essay writing'**
  String get essaySection;

  /// No description provided for @argumentPractice.
  ///
  /// In en, this message translates to:
  /// **'Argument essays'**
  String get argumentPractice;

  /// No description provided for @narrativePractice.
  ///
  /// In en, this message translates to:
  /// **'Narrative essays'**
  String get narrativePractice;

  /// No description provided for @argumentPracticeIntro.
  ///
  /// In en, this message translates to:
  /// **'Take a position and defend it. In the test you choose 1 of 3 prompts; it carries 15 marks. A 20-minute clock runs, half of Part II.'**
  String get argumentPracticeIntro;

  /// No description provided for @narrativePracticeIntro.
  ///
  /// In en, this message translates to:
  /// **'Tell a story with a clear beginning, turning point and ending. In the test you choose 1 of 3 prompts; it carries 10 marks. A 20-minute clock runs, half of Part II.'**
  String get narrativePracticeIntro;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'USAT Simulator'**
  String get homeTitle;

  /// No description provided for @partOneLabel.
  ///
  /// In en, this message translates to:
  /// **'Part I: 75 MCQs, {minutes} minutes'**
  String partOneLabel(int minutes);

  /// No description provided for @partTwoLabel.
  ///
  /// In en, this message translates to:
  /// **'Part II: Essays, {minutes} minutes'**
  String partTwoLabel(int minutes);

  /// No description provided for @chooseOneOf.
  ///
  /// In en, this message translates to:
  /// **'choose 1 of {count}'**
  String chooseOneOf(int count);

  /// No description provided for @continuePartTwo.
  ///
  /// In en, this message translates to:
  /// **'Continue to Part II'**
  String get continuePartTwo;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
