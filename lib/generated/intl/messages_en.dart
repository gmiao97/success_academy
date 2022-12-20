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

  static String m1(numPoints) => "${numPoints} Points";

  static String m2(cost) => "${cost} points will be refunded";

  static String m3(timeZone) => "Timezone: ${timeZone}";

  static String m4(cost, balance) =>
      "${cost} of ${balance} points will be used";

  static String m5(address) =>
      "A verification link has been sent to your email at ${address}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accountUpdated":
            MessageLookupByLibrary.simpleMessage("Account settings updated"),
        "addPoints": MessageLookupByLibrary.simpleMessage("Add points"),
        "addProfile": MessageLookupByLibrary.simpleMessage("Add profile"),
        "allEvents": MessageLookupByLibrary.simpleMessage("All Lessons"),
        "businessName": MessageLookupByLibrary.simpleMessage("MERCY EDUCATION"),
        "calendarHeader": m0,
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancelSignup": MessageLookupByLibrary.simpleMessage("Cancel sign up"),
        "cancelSignupFailure":
            MessageLookupByLibrary.simpleMessage("Failed to cancel sign up"),
        "cancelSignupSuccess":
            MessageLookupByLibrary.simpleMessage("Cancelled sign up"),
        "changeProfile": MessageLookupByLibrary.simpleMessage("Select Profile"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "copied": MessageLookupByLibrary.simpleMessage("Code Copied!"),
        "copy": MessageLookupByLibrary.simpleMessage("Copy Code"),
        "createEvent": MessageLookupByLibrary.simpleMessage("Add lesson"),
        "createProfile": MessageLookupByLibrary.simpleMessage("Create Profile"),
        "dateOfBirthLabel":
            MessageLookupByLibrary.simpleMessage("Student Date of Birth"),
        "dateOfBirthValidation": MessageLookupByLibrary.simpleMessage(
            "Please select student\'s date of birth"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "editEvent": MessageLookupByLibrary.simpleMessage("Edit lesson"),
        "eventDateLabel": MessageLookupByLibrary.simpleMessage("Date"),
        "eventDescriptionLabel":
            MessageLookupByLibrary.simpleMessage("Description"),
        "eventDescriptionValidation": MessageLookupByLibrary.simpleMessage(
            "Please enter lesson description"),
        "eventEndLabel": MessageLookupByLibrary.simpleMessage("End"),
        "eventEndValidation":
            MessageLookupByLibrary.simpleMessage("Please select an end time"),
        "eventPointsDisplay": m1,
        "eventPointsLabel":
            MessageLookupByLibrary.simpleMessage("Number of points"),
        "eventPointsValidation": MessageLookupByLibrary.simpleMessage(
            "Please enter number of points"),
        "eventStartLabel": MessageLookupByLibrary.simpleMessage("Start"),
        "eventStartValidation":
            MessageLookupByLibrary.simpleMessage("Please select a start time"),
        "eventSummaryLabel": MessageLookupByLibrary.simpleMessage("Title"),
        "eventSummaryValidation":
            MessageLookupByLibrary.simpleMessage("Please enter lesson title"),
        "eventValidTimeValidation": MessageLookupByLibrary.simpleMessage(
            "Start time must be before end time"),
        "failedAccountUpdate": MessageLookupByLibrary.simpleMessage(
            "Failed to update account settings"),
        "filter": MessageLookupByLibrary.simpleMessage("Lesson Filter"),
        "filterTitle":
            MessageLookupByLibrary.simpleMessage("Display by lesson type"),
        "firstName": MessageLookupByLibrary.simpleMessage("First name"),
        "firstNameHint": MessageLookupByLibrary.simpleMessage("John"),
        "firstNameLabel":
            MessageLookupByLibrary.simpleMessage("Student First Name"),
        "firstNameValidation": MessageLookupByLibrary.simpleMessage(
            "Please enter student\'s first name"),
        "free": MessageLookupByLibrary.simpleMessage("Free lesson"),
        "freeFilter": MessageLookupByLibrary.simpleMessage("Free lessons"),
        "freeNum": MessageLookupByLibrary.simpleMessage(
            "Number of free lessons completed"),
        "goBack": MessageLookupByLibrary.simpleMessage("Go back"),
        "id": MessageLookupByLibrary.simpleMessage("ID"),
        "lastName": MessageLookupByLibrary.simpleMessage("Last name"),
        "lastNameHint": MessageLookupByLibrary.simpleMessage("Smith"),
        "lastNameLabel":
            MessageLookupByLibrary.simpleMessage("Student Last Name"),
        "lastNameValidation": MessageLookupByLibrary.simpleMessage(
            "Please enter student\'s last name"),
        "lessonCalendar":
            MessageLookupByLibrary.simpleMessage("Lesson Calendar"),
        "manageProfile": MessageLookupByLibrary.simpleMessage("Manage Users"),
        "manageSubscription":
            MessageLookupByLibrary.simpleMessage("Manage Subscriptions"),
        "minimumCourse":
            MessageLookupByLibrary.simpleMessage("Minimum Course - \$40/month"),
        "minimumPreschoolCourse": MessageLookupByLibrary.simpleMessage(
            "Minimum Course + Preschool Class - \$50/month"),
        "monthlyCourse": MessageLookupByLibrary.simpleMessage(
            "Monthly Payment - \$10/month"),
        "myCode": MessageLookupByLibrary.simpleMessage("Referral Code"),
        "myEvents": MessageLookupByLibrary.simpleMessage("My Lessons"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "noPlan": MessageLookupByLibrary.simpleMessage("No subscription plan"),
        "notEnoughPoints":
            MessageLookupByLibrary.simpleMessage("Please add more points"),
        "pickPlan":
            MessageLookupByLibrary.simpleMessage("Choose a subscription plan"),
        "preschool": MessageLookupByLibrary.simpleMessage("Preschool lesson"),
        "preschoolFilter":
            MessageLookupByLibrary.simpleMessage("Preschool lessons"),
        "preschoolNum": MessageLookupByLibrary.simpleMessage(
            "Number of preschool lessons completed"),
        "private": MessageLookupByLibrary.simpleMessage("Private lesson"),
        "privateFilter":
            MessageLookupByLibrary.simpleMessage("Private lessons"),
        "privateNum": MessageLookupByLibrary.simpleMessage(
            "Number of points completed from private lessons"),
        "recurDaily": MessageLookupByLibrary.simpleMessage("Daily"),
        "recurEditNotSupported": MessageLookupByLibrary.simpleMessage(
            "Recurring lesson edit/delete not supported yet. Please edit/delete directly in Google Calendar."),
        "recurEnd": MessageLookupByLibrary.simpleMessage("End"),
        "recurMonthly": MessageLookupByLibrary.simpleMessage("Monthly"),
        "recurNone": MessageLookupByLibrary.simpleMessage("No repeat"),
        "recurTitle": MessageLookupByLibrary.simpleMessage("Repeat"),
        "recurWeekly": MessageLookupByLibrary.simpleMessage("Weekly"),
        "referralLabel":
            MessageLookupByLibrary.simpleMessage("Enter referral code"),
        "referralValidation":
            MessageLookupByLibrary.simpleMessage("Invalid referral code"),
        "refundPoints": m2,
        "reloadPage": MessageLookupByLibrary.simpleMessage("Reload page"),
        "selectProfile": MessageLookupByLibrary.simpleMessage("Select profile"),
        "settings": MessageLookupByLibrary.simpleMessage("Account Settings"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign in"),
        "signOut": MessageLookupByLibrary.simpleMessage("Sign out"),
        "signedUp": MessageLookupByLibrary.simpleMessage("My lesson"),
        "signup": MessageLookupByLibrary.simpleMessage("Sign up"),
        "signupEvent":
            MessageLookupByLibrary.simpleMessage("Sign up for lesson"),
        "signupFailure":
            MessageLookupByLibrary.simpleMessage("Sign up unsuccessful"),
        "signupSuccess":
            MessageLookupByLibrary.simpleMessage("Sign up successful"),
        "stripePointsPurchase":
            MessageLookupByLibrary.simpleMessage("Continue to points purchase"),
        "stripePurchase": MessageLookupByLibrary.simpleMessage(
            "Continue to subscription purchase"),
        "studentProfile":
            MessageLookupByLibrary.simpleMessage("Student Profile Information"),
        "teacherProfile":
            MessageLookupByLibrary.simpleMessage("Teacher Profile Information"),
        "termsOfUse": MessageLookupByLibrary.simpleMessage("Terms of use"),
        "timeZone": m3,
        "timeZoneLabel": MessageLookupByLibrary.simpleMessage("Time Zone"),
        "timeZoneValidation": MessageLookupByLibrary.simpleMessage(
            "Please select a valid time zone"),
        "today": MessageLookupByLibrary.simpleMessage("Today"),
        "usePoints": m4,
        "verifyEmailAction": MessageLookupByLibrary.simpleMessage(
            "Please click on the link in your email to continue the registration process. If you don\'t see a message in your inbox, please check your spam or junk mail folder."),
        "verifyEmailMessage": m5,
        "viewProfile": MessageLookupByLibrary.simpleMessage("View Profile")
      };
}
