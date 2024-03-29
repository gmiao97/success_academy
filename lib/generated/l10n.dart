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

  /// `Account Settings`
  String get settings {
    return Intl.message(
      'Account Settings',
      name: 'settings',
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

  /// `Go back`
  String get goBack {
    return Intl.message(
      'Go back',
      name: 'goBack',
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

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
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

  /// `Create Profile`
  String get createProfile {
    return Intl.message(
      'Create Profile',
      name: 'createProfile',
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

  /// `{numPoints} Points - ${cost}`
  String pointsPurchase(Object numPoints, Object cost) {
    return Intl.message(
      '$numPoints Points - \$$cost',
      name: 'pointsPurchase',
      desc: '',
      args: [numPoints, cost],
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

  /// `Name of referrer`
  String get referrerLabel {
    return Intl.message(
      'Name of referrer',
      name: 'referrerLabel',
      desc: '',
      args: [],
    );
  }

  /// `John Smith`
  String get referrerHint {
    return Intl.message(
      'John Smith',
      name: 'referrerHint',
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

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
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

  /// `Manage Users`
  String get manageProfile {
    return Intl.message(
      'Manage Users',
      name: 'manageProfile',
      desc: '',
      args: [],
    );
  }

  /// `Switch Profile`
  String get switchProfile {
    return Intl.message(
      'Switch Profile',
      name: 'switchProfile',
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

  /// `{numPoints} Points`
  String eventPointsDisplay(Object numPoints) {
    return Intl.message(
      '$numPoints Points',
      name: 'eventPointsDisplay',
      desc: '',
      args: [numPoints],
    );
  }

  /// `ADMIN`
  String get admin {
    return Intl.message(
      'ADMIN',
      name: 'admin',
      desc: '',
      args: [],
    );
  }

  /// `TEACHER`
  String get teacher {
    return Intl.message(
      'TEACHER',
      name: 'teacher',
      desc: '',
      args: [],
    );
  }

  /// `STUDENT`
  String get student {
    return Intl.message(
      'STUDENT',
      name: 'student',
      desc: '',
      args: [],
    );
  }

  /// `Free Lesson - $40 USD/month`
  String get minimumCourse {
    return Intl.message(
      'Free Lesson - \$40 USD/month',
      name: 'minimumCourse',
      desc: '',
      args: [],
    );
  }

  /// `Free Lesson + Preschool Class - $50 USD/month`
  String get minimumPreschoolCourse {
    return Intl.message(
      'Free Lesson + Preschool Class - \$50 USD/month',
      name: 'minimumPreschoolCourse',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Payment - $10 USD/month (Private Lesson Only)`
  String get monthlyCourse {
    return Intl.message(
      'Monthly Payment - \$10 USD/month (Private Lesson Only)',
      name: 'monthlyCourse',
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

  /// `14 days free trial`
  String get freeTrial {
    return Intl.message(
      '14 days free trial',
      name: 'freeTrial',
      desc: '',
      args: [],
    );
  }

  /// `$50 USD sign-up fee due after trial`
  String get signUpFee {
    return Intl.message(
      '\$50 USD sign-up fee due after trial',
      name: 'signUpFee',
      desc: '',
      args: [],
    );
  }

  /// `20% off - $40 USD`
  String get signUpFeeDiscount {
    return Intl.message(
      '20% off - \$40 USD',
      name: 'signUpFeeDiscount',
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

  /// `Add subscription`
  String get addPlan {
    return Intl.message(
      'Add subscription',
      name: 'addPlan',
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

  /// `Failed to redirect to Stripe`
  String get stripeRedirectFailure {
    return Intl.message(
      'Failed to redirect to Stripe',
      name: 'stripeRedirectFailure',
      desc: '',
      args: [],
    );
  }

  /// `Lesson Info`
  String get lessonInfo {
    return Intl.message(
      'Lesson Info',
      name: 'lessonInfo',
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

  /// `Lesson`
  String get lesson {
    return Intl.message(
      'Lesson',
      name: 'lesson',
      desc: '',
      args: [],
    );
  }

  /// `Link`
  String get link {
    return Intl.message(
      'Link',
      name: 'link',
      desc: '',
      args: [],
    );
  }

  /// `Meeting ID`
  String get meetingId {
    return Intl.message(
      'Meeting ID',
      name: 'meetingId',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Failed to open link`
  String get openLinkFailure {
    return Intl.message(
      'Failed to open link',
      name: 'openLinkFailure',
      desc: '',
      args: [],
    );
  }

  /// `Updated`
  String get lessonInfoUpdated {
    return Intl.message(
      'Updated',
      name: 'lessonInfoUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Update failed`
  String get lessonInfoUpdateFailed {
    return Intl.message(
      'Update failed',
      name: 'lessonInfoUpdateFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please press the save button`
  String get promptSave {
    return Intl.message(
      'Please press the save button',
      name: 'promptSave',
      desc: '',
      args: [],
    );
  }

  /// `Lesson type`
  String get eventType {
    return Intl.message(
      'Lesson type',
      name: 'eventType',
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

  /// ` until {until}`
  String recurUntil(Object until) {
    return Intl.message(
      ' until $until',
      name: 'recurUntil',
      desc: '',
      args: [until],
    );
  }

  /// `Unspecified`
  String get unspecified {
    return Intl.message(
      'Unspecified',
      name: 'unspecified',
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

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
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

  /// `Signed-up`
  String get signedUp {
    return Intl.message(
      'Signed-up',
      name: 'signedUp',
      desc: '',
      args: [],
    );
  }

  /// `Cancel sign-up`
  String get cancelSignup {
    return Intl.message(
      'Cancel sign-up',
      name: 'cancelSignup',
      desc: '',
      args: [],
    );
  }

  /// `Cannot sign up for past lesson`
  String get signupPastEvent {
    return Intl.message(
      'Cannot sign up for past lesson',
      name: 'signupPastEvent',
      desc: '',
      args: [],
    );
  }

  /// `Cannot cancel sign-up for past lesson`
  String get cancelSignupPastEvent {
    return Intl.message(
      'Cannot cancel sign-up for past lesson',
      name: 'cancelSignupPastEvent',
      desc: '',
      args: [],
    );
  }

  /// `Sign-up successful`
  String get signupSuccess {
    return Intl.message(
      'Sign-up successful',
      name: 'signupSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Sign-up unsuccessful`
  String get signupFailure {
    return Intl.message(
      'Sign-up unsuccessful',
      name: 'signupFailure',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled sign-up`
  String get cancelSignupSuccess {
    return Intl.message(
      'Cancelled sign-up',
      name: 'cancelSignupSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to cancel sign-up`
  String get cancelSignupFailure {
    return Intl.message(
      'Failed to cancel sign-up',
      name: 'cancelSignupFailure',
      desc: '',
      args: [],
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

  /// `Delete lesson`
  String get deleteEvent {
    return Intl.message(
      'Delete lesson',
      name: 'deleteEvent',
      desc: '',
      args: [],
    );
  }

  /// `Deleted lesson`
  String get deleteEventSuccess {
    return Intl.message(
      'Deleted lesson',
      name: 'deleteEventSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete lesson`
  String get deleteEventFailure {
    return Intl.message(
      'Failed to delete lesson',
      name: 'deleteEventFailure',
      desc: '',
      args: [],
    );
  }

  /// `This lesson`
  String get deleteSingle {
    return Intl.message(
      'This lesson',
      name: 'deleteSingle',
      desc: '',
      args: [],
    );
  }

  /// `This and following lessons`
  String get deleteFuture {
    return Intl.message(
      'This and following lessons',
      name: 'deleteFuture',
      desc: '',
      args: [],
    );
  }

  /// `All lessons`
  String get deleteAll {
    return Intl.message(
      'All lessons',
      name: 'deleteAll',
      desc: '',
      args: [],
    );
  }

  /// `Create lesson`
  String get createEvent {
    return Intl.message(
      'Create lesson',
      name: 'createEvent',
      desc: '',
      args: [],
    );
  }

  /// `Created lesson`
  String get createEventSuccess {
    return Intl.message(
      'Created lesson',
      name: 'createEventSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to create lesson`
  String get createEventFailure {
    return Intl.message(
      'Failed to create lesson',
      name: 'createEventFailure',
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

  /// `Edited lesson`
  String get editEventSuccess {
    return Intl.message(
      'Edited lesson',
      name: 'editEventSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Failed to edit lesson`
  String get editEventFailure {
    return Intl.message(
      'Failed to edit lesson',
      name: 'editEventFailure',
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

  /// `Until`
  String get recurUntilLabel {
    return Intl.message(
      'Until',
      name: 'recurUntilLabel',
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

  /// `Duration must be less than 24 hours`
  String get eventTooLongValidation {
    return Intl.message(
      'Duration must be less than 24 hours',
      name: 'eventTooLongValidation',
      desc: '',
      args: [],
    );
  }

  /// `Teacher`
  String get teacherTitle {
    return Intl.message(
      'Teacher',
      name: 'teacherTitle',
      desc: '',
      args: [],
    );
  }

  /// `Registered students`
  String get studentListTitle {
    return Intl.message(
      'Registered students',
      name: 'studentListTitle',
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

  /// `End`
  String get recurEnd {
    return Intl.message(
      'End',
      name: 'recurEnd',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load lesson`
  String get failedGetRecurrenceEvent {
    return Intl.message(
      'Failed to load lesson',
      name: 'failedGetRecurrenceEvent',
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
