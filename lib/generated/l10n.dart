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

  /// `Please select studen't date of birth`
  String get dateOfBirthValidation {
    return Intl.message(
      'Please select studen\'t date of birth',
      name: 'dateOfBirthValidation',
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

  /// `Minimum Course - $30/month`
  String get minimumCourse {
    return Intl.message(
      'Minimum Course - \$30/month',
      name: 'minimumCourse',
      desc: '',
      args: [],
    );
  }

  /// `Minimum Course + Preschool Class - $40/month`
  String get minimumPreschoolCourse {
    return Intl.message(
      'Minimum Course + Preschool Class - \$40/month',
      name: 'minimumPreschoolCourse',
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

  /// `Continue to subscription purchase`
  String get stripePurchase {
    return Intl.message(
      'Continue to subscription purchase',
      name: 'stripePurchase',
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

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
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
