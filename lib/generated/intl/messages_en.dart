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

  static String m0(address) =>
      "A verification link has been sent to your email at ${address}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addProfile": MessageLookupByLibrary.simpleMessage("Add profile"),
        "dateOfBirthLabel":
            MessageLookupByLibrary.simpleMessage("Date of Birth"),
        "dateOfBirthValidation":
            MessageLookupByLibrary.simpleMessage("Please select a date"),
        "firstNameHint": MessageLookupByLibrary.simpleMessage("John"),
        "firstNameLabel": MessageLookupByLibrary.simpleMessage("First Name"),
        "firstNameValidation": MessageLookupByLibrary.simpleMessage(
            "Please enter student\'s first name"),
        "goBack": MessageLookupByLibrary.simpleMessage("Go back"),
        "lastNameHint": MessageLookupByLibrary.simpleMessage("Smith"),
        "lastNameLabel": MessageLookupByLibrary.simpleMessage("Last Name"),
        "lastNameValidation": MessageLookupByLibrary.simpleMessage(
            "Please enter student\'s last name"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "reloadPage": MessageLookupByLibrary.simpleMessage("Reload page"),
        "selectProfile": MessageLookupByLibrary.simpleMessage("Select profile"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign in"),
        "signOut": MessageLookupByLibrary.simpleMessage("Sign out"),
        "timeZoneLabel": MessageLookupByLibrary.simpleMessage("Time Zone"),
        "timeZoneValidation": MessageLookupByLibrary.simpleMessage(
            "Please select a valid time zone"),
        "verifyEmailAction": MessageLookupByLibrary.simpleMessage(
            "Please click on the link in your email to continue the registration process. If you don\'t see a message in your inbox, please check your spam or junk mail folder."),
        "verifyEmailMessage": m0
      };
}