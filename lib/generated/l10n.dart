// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Sign in`
  String get signIn {
    return Intl.message(
      'Sign in',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get signOut {
    return Intl.message(
      'Sign out',
      name: 'signOut',
      desc: '',
      args: [],
    );
  }

  /// `Go back`
  String get goBack {
    return Intl.message(
      'Go back',
      name: 'goBack',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Select profile`
  String get selectProfile {
    return Intl.message(
      'Select profile',
      name: 'selectProfile',
      desc: '',
      args: [],
    );
  }

  /// `Add profile`
  String get addProfile {
    return Intl.message(
      'Add profile',
      name: 'addProfile',
      desc: '',
      args: [],
    );
  }

  /// `Manage Users`
  String get manageProfile {
    return Intl.message(
      'Manage Users',
      name: 'manageProfile',
      desc: '',
      args: [],
    );
  }

  /// `Create Profile`
  String get createProfile {
    return Intl.message(
      'Create Profile',
      name: 'createProfile',
      desc: '',
      args: [],
    );
  }

  /// `Student Last Name`
  String get lastNameLabel {
    return Intl.message(
      'Student Last Name',
      name: 'lastNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Smith`
  String get lastNameHint {
    return Intl.message(
      'Smith',
      name: 'lastNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter student's last name`
  String get lastNameValidation {
    return Intl.message(
      'Please enter student\'s last name',
      name: 'lastNameValidation',
      desc: '',
      args: [],
    );
  }

  /// `Student First Name`
  String get firstNameLabel {
    return Intl.message(
      'Student First Name',
      name: 'firstNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `John`
  String get firstNameHint {
    return Intl.message(
      'John',
      name: 'firstNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter student's first name`
  String get firstNameValidation {
    return Intl.message(
      'Please enter student\'s first name',
      name: 'firstNameValidation',
      desc: '',
      args: [],
    );
  }

  /// `Student Date of Birth`
  String get dateOfBirthLabel {
    return Intl.message(
      'Student Date of Birth',
      name: 'dateOfBirthLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please select student's date of birth`
  String get dateOfBirthValidation {
    return Intl.message(
      'Please select student\'s date of birth',
      name: 'dateOfBirthValidation',
      desc: '',
      args: [],
    );
  }

  /// `Enter referral code`
  String get referralLabel {
    return Intl.message(
      'Enter referral code',
      name: 'referralLabel',
      desc: '',
      args: [],
    );
  }

  /// `Invalid referral code`
  String get referralValidation {
    return Intl.message(
      'Invalid referral code',
      name: 'referralValidation',
      desc: '',
      args: [],
    );
  }

  /// `Student Profile Information`
  String get studentProfile {
    return Intl.message(
      'Student Profile Information',
      name: 'studentProfile',
      desc: '',
      args: [],
    );
  }

  /// `Teacher Profile Information`
  String get teacherProfile {
    return Intl.message(
      'Teacher Profile Information',
      name: 'teacherProfile',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Referral Code`
  String get myCode {
    return Intl.message(
      'Referral Code',
      name: 'myCode',
      desc: '',
      args: [],
    );
  }

  /// `Copy Code`
  String get copy {
    return Intl.message(
      'Copy Code',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Code Copied!`
  String get copied {
    return Intl.message(
      'Code Copied!',
      name: 'copied',
      desc: '',
      args: [],
    );
  }

  /// `Manage Subscriptions`
  String get manageSubscription {
    return Intl.message(
      'Manage Subscriptions',
      name: 'manageSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Free Lesson - $40/month`
  String get minimumCourse {
    return Intl.message(
      'Free Lesson - \$40/month',
      name: 'minimumCourse',
      desc: '',
      args: [],
    );
  }

  /// `Free Lesson + Preschool Class - $50/month`
  String get minimumPreschoolCourse {
    return Intl.message(
      'Free Lesson + Preschool Class - \$50/month',
      name: 'minimumPreschoolCourse',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Payment Only - $10/month`
  String get monthlyCourse {
    return Intl.message(
      'Monthly Payment Only - \$10/month',
      name: 'monthlyCourse',
      desc: '',
      args: [],
    );
  }

  /// `14 days free trial`
  String get freeTrial {
    return Intl.message(
      '14 days free trial',
      name: 'freeTrial',
      desc: '',
      args: [],
    );
  }

  /// `$50 sign up fee due after trial`
  String get signUpFee {
    return Intl.message(
      '\$50 sign up fee due after trial',
      name: 'signUpFee',
      desc: '',
      args: [],
    );
  }

  /// `Choose a subscription plan`
  String get pickPlan {
    return Intl.message(
      'Choose a subscription plan',
      name: 'pickPlan',
      desc: '',
      args: [],
    );
  }

  /// `No subscription plan`
  String get noPlan {
    return Intl.message(
      'No subscription plan',
      name: 'noPlan',
      desc: '',
      args: [],
    );
  }

  /// `Continue to subscription purchase`
  String get stripePurchase {
    return Intl.message(
      'Continue to subscription purchase',
      name: 'stripePurchase',
      desc: '',
      args: [],
    );
  }

  /// `Continue to points purchase`
  String get stripePointsPurchase {
    return Intl.message(
      'Continue to points purchase',
      name: 'stripePointsPurchase',
      desc: '',
      args: [],
    );
  }

  /// `Time Zone`
  String get timeZoneLabel {
    return Intl.message(
      'Time Zone',
      name: 'timeZoneLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please select a valid time zone`
  String get timeZoneValidation {
    return Intl.message(
      'Please select a valid time zone',
      name: 'timeZoneValidation',
      desc: '',
      args: [],
    );
  }

  /// `A verification link has been sent to your email at {address}`
  String verifyEmailMessage(Object address) {
    return Intl.message(
      'A verification link has been sent to your email at $address',
      name: 'verifyEmailMessage',
      desc: '',
      args: [address],
    );
  }

  /// `Please click on the link in your email to continue the registration process. If you don't see a message in your inbox, please check your spam or junk mail folder.`
  String get verifyEmailAction {
    return Intl.message(
      'Please click on the link in your email to continue the registration process. If you don\'t see a message in your inbox, please check your spam or junk mail folder.',
      name: 'verifyEmailAction',
      desc: '',
      args: [],
    );
  }

  /// `Reload page`
  String get reloadPage {
    return Intl.message(
      'Reload page',
      name: 'reloadPage',
      desc: '',
      args: [],
    );
  }

  /// `Select Profile`
  String get changeProfile {
    return Intl.message(
      'Select Profile',
      name: 'changeProfile',
      desc: '',
      args: [],
    );
  }

  /// `View Profile`
  String get viewProfile {
    return Intl.message(
      'View Profile',
      name: 'viewProfile',
      desc: '',
      args: [],
    );
  }

  /// `Lesson Calendar`
  String get lessonCalendar {
    return Intl.message(
      'Lesson Calendar',
      name: 'lessonCalendar',
      desc: '',
      args: [],
    );
  }

  /// `Free Lesson Info`
  String get freeLessonInfo {
    return Intl.message(
      'Free Lesson Info',
      name: 'freeLessonInfo',
      desc: '',
      args: [],
    );
  }

  /// `Add points`
  String get addPoints {
    return Intl.message(
      'Add points',
      name: 'addPoints',
      desc: '',
      args: [],
    );
  }

  /// `Account Settings`
  String get settings {
    return Intl.message(
      'Account Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Free Lesson Time Table`
  String get freeLessonTimeTable {
    return Intl.message(
      'Free Lesson Time Table',
      name: 'freeLessonTimeTable',
      desc: '',
      args: [],
    );
  }

  /// `Course Materials`
  String get freeLessonMaterials {
    return Intl.message(
      'Course Materials',
      name: 'freeLessonMaterials',
      desc: '',
      args: [],
    );
  }

  /// `Free Lesson Zoom Info`
  String get freeLessonZoomInfo {
    return Intl.message(
      'Free Lesson Zoom Info',
      name: 'freeLessonZoomInfo',
      desc: '',
      args: [],
    );
  }

  /// `{name}'s Calendar`
  String calendarHeader(Object name) {
    return Intl.message(
      '$name\'s Calendar',
      name: 'calendarHeader',
      desc: '',
      args: [name],
    );
  }

  /// `Timezone: {timeZone}`
  String timeZone(Object timeZone) {
    return Intl.message(
      'Timezone: $timeZone',
      name: 'timeZone',
      desc: '',
      args: [timeZone],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Lesson Filter`
  String get filter {
    return Intl.message(
      'Lesson Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Free lesson`
  String get free {
    return Intl.message(
      'Free lesson',
      name: 'free',
      desc: '',
      args: [],
    );
  }

  /// `Preschool lesson`
  String get preschool {
    return Intl.message(
      'Preschool lesson',
      name: 'preschool',
      desc: '',
      args: [],
    );
  }

  /// `Private lesson`
  String get private {
    return Intl.message(
      'Private lesson',
      name: 'private',
      desc: '',
      args: [],
    );
  }

  /// `Display by lesson type`
  String get filterTitle {
    return Intl.message(
      'Display by lesson type',
      name: 'filterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Free lessons`
  String get freeFilter {
    return Intl.message(
      'Free lessons',
      name: 'freeFilter',
      desc: '',
      args: [],
    );
  }

  /// `Preschool lessons`
  String get preschoolFilter {
    return Intl.message(
      'Preschool lessons',
      name: 'preschoolFilter',
      desc: '',
      args: [],
    );
  }

  /// `Private lessons`
  String get privateFilter {
    return Intl.message(
      'Private lessons',
      name: 'privateFilter',
      desc: '',
      args: [],
    );
  }

  /// `All Lessons`
  String get allEvents {
    return Intl.message(
      'All Lessons',
      name: 'allEvents',
      desc: '',
      args: [],
    );
  }

  /// `My Lessons`
  String get myEvents {
    return Intl.message(
      'My Lessons',
      name: 'myEvents',
      desc: '',
      args: [],
    );
  }

  /// `Add lesson`
  String get createEvent {
    return Intl.message(
      'Add lesson',
      name: 'createEvent',
      desc: '',
      args: [],
    );
  }

  /// `Edit lesson`
  String get editEvent {
    return Intl.message(
      'Edit lesson',
      name: 'editEvent',
      desc: '',
      args: [],
    );
  }

  /// `Sign up for lesson`
  String get signupEvent {
    return Intl.message(
      'Sign up for lesson',
      name: 'signupEvent',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signup {
    return Intl.message(
      'Sign up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `My lesson`
  String get signedUp {
    return Intl.message(
      'My lesson',
      name: 'signedUp',
      desc: '',
      args: [],
    );
  }

  /// `Cancel sign up`
  String get cancelSignup {
    return Intl.message(
      'Cancel sign up',
      name: 'cancelSignup',
      desc: '',
      args: [],
    );
  }

  /// `Sign up successful`
  String get signupSuccess {
    return Intl.message(
      'Sign up successful',
      name: 'signupSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Sign up unsuccessful`
  String get signupFailure {
    return Intl.message(
      'Sign up unsuccessful',
      name: 'signupFailure',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled sign up`
  String get cancelSignupSuccess {
    return Intl.message(
      'Cancelled sign up',
      name: 'cancelSignupSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to cancel sign up`
  String get cancelSignupFailure {
    return Intl.message(
      'Failed to cancel sign up',
      name: 'cancelSignupFailure',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get eventSummaryLabel {
    return Intl.message(
      'Title',
      name: 'eventSummaryLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter lesson title`
  String get eventSummaryValidation {
    return Intl.message(
      'Please enter lesson title',
      name: 'eventSummaryValidation',
      desc: '',
      args: [],
    );
  }

  /// `Number of points`
  String get eventPointsLabel {
    return Intl.message(
      'Number of points',
      name: 'eventPointsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter number of points`
  String get eventPointsValidation {
    return Intl.message(
      'Please enter number of points',
      name: 'eventPointsValidation',
      desc: '',
      args: [],
    );
  }

  /// `{numPoints} Points`
  String eventPointsDisplay(Object numPoints) {
    return Intl.message(
      '$numPoints Points',
      name: 'eventPointsDisplay',
      desc: '',
      args: [numPoints],
    );
  }

  /// `Please add more points`
  String get notEnoughPoints {
    return Intl.message(
      'Please add more points',
      name: 'notEnoughPoints',
      desc: '',
      args: [],
    );
  }

  /// `{cost} of {balance} points will be used`
  String usePoints(Object cost, Object balance) {
    return Intl.message(
      '$cost of $balance points will be used',
      name: 'usePoints',
      desc: '',
      args: [cost, balance],
    );
  }

  /// `{cost} points will be refunded`
  String refundPoints(Object cost) {
    return Intl.message(
      '$cost points will be refunded',
      name: 'refundPoints',
      desc: '',
      args: [cost],
    );
  }

  /// `Description`
  String get eventDescriptionLabel {
    return Intl.message(
      'Description',
      name: 'eventDescriptionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter lesson description`
  String get eventDescriptionValidation {
    return Intl.message(
      'Please enter lesson description',
      name: 'eventDescriptionValidation',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get eventDateLabel {
    return Intl.message(
      'Date',
      name: 'eventDateLabel',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get eventStartLabel {
    return Intl.message(
      'Start',
      name: 'eventStartLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please select a start time`
  String get eventStartValidation {
    return Intl.message(
      'Please select a start time',
      name: 'eventStartValidation',
      desc: '',
      args: [],
    );
  }

  /// `End`
  String get eventEndLabel {
    return Intl.message(
      'End',
      name: 'eventEndLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please select an end time`
  String get eventEndValidation {
    return Intl.message(
      'Please select an end time',
      name: 'eventEndValidation',
      desc: '',
      args: [],
    );
  }

  /// `Start time must be before end time`
  String get eventValidTimeValidation {
    return Intl.message(
      'Start time must be before end time',
      name: 'eventValidTimeValidation',
      desc: '',
      args: [],
    );
  }

  /// `Repeat`
  String get recurTitle {
    return Intl.message(
      'Repeat',
      name: 'recurTitle',
      desc: '',
      args: [],
    );
  }

  /// `Recurring lesson edit/delete not supported yet. Please edit/delete directly in Google Calendar.`
  String get recurEditNotSupported {
    return Intl.message(
      'Recurring lesson edit/delete not supported yet. Please edit/delete directly in Google Calendar.',
      name: 'recurEditNotSupported',
      desc: '',
      args: [],
    );
  }

  /// `No repeat`
  String get recurNone {
    return Intl.message(
      'No repeat',
      name: 'recurNone',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get recurDaily {
    return Intl.message(
      'Daily',
      name: 'recurDaily',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get recurWeekly {
    return Intl.message(
      'Weekly',
      name: 'recurWeekly',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get recurMonthly {
    return Intl.message(
      'Monthly',
      name: 'recurMonthly',
      desc: '',
      args: [],
    );
  }

  /// `End`
  String get recurEnd {
    return Intl.message(
      'End',
      name: 'recurEnd',
      desc: '',
      args: [],
    );
  }

  /// `Account settings updated`
  String get accountUpdated {
    return Intl.message(
      'Account settings updated',
      name: 'accountUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Failed to update account settings`
  String get failedAccountUpdate {
    return Intl.message(
      'Failed to update account settings',
      name: 'failedAccountUpdate',
      desc: '',
      args: [],
    );
  }

  /// `ID`
  String get id {
    return Intl.message(
      'ID',
      name: 'id',
      desc: '',
      args: [],
    );
  }

  /// `Last name`
  String get lastName {
    return Intl.message(
      'Last name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `First name`
  String get firstName {
    return Intl.message(
      'First name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Number of points completed from private lessons`
  String get privateNum {
    return Intl.message(
      'Number of points completed from private lessons',
      name: 'privateNum',
      desc: '',
      args: [],
    );
  }

  /// `Number of preschool lessons completed`
  String get preschoolNum {
    return Intl.message(
      'Number of preschool lessons completed',
      name: 'preschoolNum',
      desc: '',
      args: [],
    );
  }

  /// `Number of free lessons completed`
  String get freeNum {
    return Intl.message(
      'Number of free lessons completed',
      name: 'freeNum',
      desc: '',
      args: [],
    );
  }

  /// `MERCY EDUCATION`
  String get businessName {
    return Intl.message(
      'MERCY EDUCATION',
      name: 'businessName',
      desc: '',
      args: [],
    );
  }

  /// `Terms of use`
  String get termsOfUse {
    return Intl.message(
      'Terms of use',
      name: 'termsOfUse',
      desc: '',
      args: [],
    );
  }

  /// `Agree to terms of use`
  String get agreeToTerms {
    return Intl.message(
      'Agree to terms of use',
      name: 'agreeToTerms',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
