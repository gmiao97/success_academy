// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(name) => "${name}\'s Calendar";

  static String m1(timeZone) => "Timezone: ${timeZone}";

  static String m2(address) =>
      "A verification link has been sent to your email at ${address}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addProfile": MessageLookupByLibrary.simpleMessage("Add profile"),
        "calendarHeader": m0,
        "changeProfile": MessageLookupByLibrary.simpleMessage("Select Profile"),
        "copied": MessageLookupByLibrary.simpleMessage("Code Copied!"),
        "copy": MessageLookupByLibrary.simpleMessage("Copy Code"),
        "createProfile": MessageLookupByLibrary.simpleMessage("Create Profile"),
        "dateOfBirthLabel":
            MessageLookupByLibrary.simpleMessage("Student Date of Birth"),
        "dateOfBirthValidation": MessageLookupByLibrary.simpleMessage(
            "Please select studen\'t date of birth"),
        "firstNameHint": MessageLookupByLibrary.simpleMessage("John"),
        "firstNameLabel":
            MessageLookupByLibrary.simpleMessage("Student First Name"),
        "firstNameValidation": MessageLookupByLibrary.simpleMessage(
            "Please enter student\'s first name"),
        "goBack": MessageLookupByLibrary.simpleMessage("Go back"),
        "lastNameHint": MessageLookupByLibrary.simpleMessage("Smith"),
        "lastNameLabel":
            MessageLookupByLibrary.simpleMessage("Student Last Name"),
        "lastNameValidation": MessageLookupByLibrary.simpleMessage(
            "Please enter student\'s last name"),
        "lessonCalendar":
            MessageLookupByLibrary.simpleMessage("Lesson Calendar"),
        "manageSubscription":
            MessageLookupByLibrary.simpleMessage("Manage Subscriptions"),
        "minimumCourse":
            MessageLookupByLibrary.simpleMessage("Minimum Course - \$30/month"),
        "minimumPreschoolCourse": MessageLookupByLibrary.simpleMessage(
            "Minimum Course + Preschool Class - \$40/month"),
        "myCode": MessageLookupByLibrary.simpleMessage("Referral Code"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "pickPlan":
            MessageLookupByLibrary.simpleMessage("Choose a subscription plan"),
        "reloadPage": MessageLookupByLibrary.simpleMessage("Reload page"),
        "selectProfile": MessageLookupByLibrary.simpleMessage("Select profile"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign in"),
        "signOut": MessageLookupByLibrary.simpleMessage("Sign out"),
        "stripePurchase": MessageLookupByLibrary.simpleMessage(
            "Continue to subscription purchase"),
        "studentProfile":
            MessageLookupByLibrary.simpleMessage("Student Profile Information"),
        "teacherProfile":
            MessageLookupByLibrary.simpleMessage("Teacher Profile Information"),
        "timeZone": m1,
        "timeZoneLabel": MessageLookupByLibrary.simpleMessage("Time Zone"),
        "timeZoneValidation": MessageLookupByLibrary.simpleMessage(
            "Please select a valid time zone"),
        "today": MessageLookupByLibrary.simpleMessage("Today"),
        "verifyEmailAction": MessageLookupByLibrary.simpleMessage(
            "Please click on the link in your email to continue the registration process. If you don\'t see a message in your inbox, please check your spam or junk mail folder."),
        "verifyEmailMessage": m2,
        "viewProfile": MessageLookupByLibrary.simpleMessage("View Profile")
      };
}
