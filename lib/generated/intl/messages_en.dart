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

  static String m0(numPoints) => "${numPoints} Points";

  static String m1(numPoints, cost) => "${numPoints} Points - \$${cost}";

  static String m2(until) => " until ${until}";

  static String m3(cost) => "${cost} points will be refunded";

  static String m4(cost, balance) =>
      "${cost} of ${balance} points will be used";

  static String m5(address) =>
      "A verification link has been sent to your email at ${address}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accountUpdated":
            MessageLookupByLibrary.simpleMessage("Account settings updated"),
        "addPlan": MessageLookupByLibrary.simpleMessage("Add subscription"),
        "addPoints": MessageLookupByLibrary.simpleMessage("Add points"),
        "admin": MessageLookupByLibrary.simpleMessage("ADMIN"),
        "agreeToTerms":
            MessageLookupByLibrary.simpleMessage("Agree to terms of use"),
        "allEvents": MessageLookupByLibrary.simpleMessage("All Lessons"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancelSignup": MessageLookupByLibrary.simpleMessage("Cancel sign-up"),
        "cancelSignupFailure":
            MessageLookupByLibrary.simpleMessage("Failed to cancel sign-up"),
        "cancelSignupPastEvent": MessageLookupByLibrary.simpleMessage(
            "Cannot cancel sign-up for past lesson"),
        "cancelSignupSuccess":
            MessageLookupByLibrary.simpleMessage("Cancelled sign-up"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "copied": MessageLookupByLibrary.simpleMessage("Code Copied!"),
        "copy": MessageLookupByLibrary.simpleMessage("Copy Code"),
        "createEvent": MessageLookupByLibrary.simpleMessage("Create lesson"),
        "createEventFailure":
            MessageLookupByLibrary.simpleMessage("Failed to create lesson"),
        "createEventSuccess":
            MessageLookupByLibrary.simpleMessage("Created lesson"),
        "createProfile": MessageLookupByLibrary.simpleMessage("Create Profile"),
        "dateOfBirthLabel":
            MessageLookupByLibrary.simpleMessage("Student Date of Birth"),
        "dateOfBirthValidation": MessageLookupByLibrary.simpleMessage(
            "Please select student\'s date of birth"),
        "deleteAll": MessageLookupByLibrary.simpleMessage("All lessons"),
        "deleteEvent": MessageLookupByLibrary.simpleMessage("Delete lesson"),
        "deleteEventFailure":
            MessageLookupByLibrary.simpleMessage("Failed to delete lesson"),
        "deleteEventSuccess":
            MessageLookupByLibrary.simpleMessage("Deleted lesson"),
        "deleteFuture":
            MessageLookupByLibrary.simpleMessage("This and following lessons"),
        "deleteSingle": MessageLookupByLibrary.simpleMessage("This lesson"),
        "editEvent": MessageLookupByLibrary.simpleMessage("Edit lesson"),
        "editEventFailure":
            MessageLookupByLibrary.simpleMessage("Failed to edit lesson"),
        "editEventSuccess":
            MessageLookupByLibrary.simpleMessage("Edited lesson"),
        "eventDescriptionLabel":
            MessageLookupByLibrary.simpleMessage("Description"),
        "eventDescriptionValidation": MessageLookupByLibrary.simpleMessage(
            "Please enter lesson description"),
        "eventEndLabel": MessageLookupByLibrary.simpleMessage("End"),
        "eventEndValidation":
            MessageLookupByLibrary.simpleMessage("Please select an end time"),
        "eventPointsDisplay": m0,
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
        "eventTooLongValidation": MessageLookupByLibrary.simpleMessage(
            "Duration must be less than 24 hours"),
        "eventType": MessageLookupByLibrary.simpleMessage("Lesson type"),
        "eventValidTimeValidation": MessageLookupByLibrary.simpleMessage(
            "Start time must be before end time"),
        "failedAccountUpdate": MessageLookupByLibrary.simpleMessage(
            "Failed to update account settings"),
        "failedGetRecurrenceEvent":
            MessageLookupByLibrary.simpleMessage("Failed to load lesson"),
        "filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "firstName": MessageLookupByLibrary.simpleMessage("First name"),
        "firstNameHint": MessageLookupByLibrary.simpleMessage("John"),
        "firstNameLabel":
            MessageLookupByLibrary.simpleMessage("Student First Name"),
        "firstNameValidation": MessageLookupByLibrary.simpleMessage(
            "Please enter student\'s first name"),
        "free": MessageLookupByLibrary.simpleMessage("Free lesson"),
        "freeLessonMaterials":
            MessageLookupByLibrary.simpleMessage("Course Materials"),
        "freeLessonTimeTable":
            MessageLookupByLibrary.simpleMessage("Free Lesson Time Table"),
        "freeLessonZoomInfo":
            MessageLookupByLibrary.simpleMessage("Free Lesson Zoom Info"),
        "freeNum": MessageLookupByLibrary.simpleMessage(
            "Number of free lessons completed"),
        "freeTrial": MessageLookupByLibrary.simpleMessage("14 days free trial"),
        "goBack": MessageLookupByLibrary.simpleMessage("Go back"),
        "id": MessageLookupByLibrary.simpleMessage("ID"),
        "lastName": MessageLookupByLibrary.simpleMessage("Last name"),
        "lastNameHint": MessageLookupByLibrary.simpleMessage("Smith"),
        "lastNameLabel":
            MessageLookupByLibrary.simpleMessage("Student Last Name"),
        "lastNameValidation": MessageLookupByLibrary.simpleMessage(
            "Please enter student\'s last name"),
        "lesson": MessageLookupByLibrary.simpleMessage("Lesson"),
        "lessonCalendar":
            MessageLookupByLibrary.simpleMessage("Lesson Calendar"),
        "lessonInfo": MessageLookupByLibrary.simpleMessage("Lesson Info"),
        "lessonInfoUpdateFailed":
            MessageLookupByLibrary.simpleMessage("Update failed"),
        "lessonInfoUpdated": MessageLookupByLibrary.simpleMessage("Updated"),
        "link": MessageLookupByLibrary.simpleMessage("Link"),
        "manageProfile": MessageLookupByLibrary.simpleMessage("Manage Users"),
        "manageSubscription":
            MessageLookupByLibrary.simpleMessage("Manage Subscriptions"),
        "meetingId": MessageLookupByLibrary.simpleMessage("Meeting ID"),
        "minimumCourse": MessageLookupByLibrary.simpleMessage(
            "Free Lesson - \$40 USD/month"),
        "minimumPreschoolCourse": MessageLookupByLibrary.simpleMessage(
            "Free Lesson + Preschool Class - \$50 USD/month"),
        "monthlyCourse": MessageLookupByLibrary.simpleMessage(
            "Monthly Payment - \$10 USD/month (Private Lesson Only)"),
        "myCode": MessageLookupByLibrary.simpleMessage("Referral Code"),
        "myEvents": MessageLookupByLibrary.simpleMessage("My Lessons"),
        "noPlan": MessageLookupByLibrary.simpleMessage("No subscription plan"),
        "notEnoughPoints":
            MessageLookupByLibrary.simpleMessage("Please add more points"),
        "openLinkFailure":
            MessageLookupByLibrary.simpleMessage("Failed to open link"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "pickPlan":
            MessageLookupByLibrary.simpleMessage("Choose a subscription plan"),
        "pointsPurchase": m1,
        "preschool": MessageLookupByLibrary.simpleMessage("Preschool lesson"),
        "preschoolNum": MessageLookupByLibrary.simpleMessage(
            "Number of preschool lessons completed"),
        "private": MessageLookupByLibrary.simpleMessage("Private lesson"),
        "privateNum": MessageLookupByLibrary.simpleMessage(
            "Number of points completed from private lessons"),
        "profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "promptSave": MessageLookupByLibrary.simpleMessage(
            "Please press the save button"),
        "recurDaily": MessageLookupByLibrary.simpleMessage("Daily"),
        "recurEnd": MessageLookupByLibrary.simpleMessage("End"),
        "recurMonthly": MessageLookupByLibrary.simpleMessage("Monthly"),
        "recurNone": MessageLookupByLibrary.simpleMessage("No repeat"),
        "recurTitle": MessageLookupByLibrary.simpleMessage("Repeat"),
        "recurUntil": m2,
        "recurUntilLabel": MessageLookupByLibrary.simpleMessage("Until"),
        "recurWeekly": MessageLookupByLibrary.simpleMessage("Weekly"),
        "referralLabel":
            MessageLookupByLibrary.simpleMessage("Enter referral code"),
        "referralValidation":
            MessageLookupByLibrary.simpleMessage("Invalid referral code"),
        "referrerHint": MessageLookupByLibrary.simpleMessage("John Smith"),
        "referrerLabel":
            MessageLookupByLibrary.simpleMessage("Name of referrer"),
        "refundPoints": m3,
        "reloadPage": MessageLookupByLibrary.simpleMessage("Reload page"),
        "selectProfile": MessageLookupByLibrary.simpleMessage("Select profile"),
        "settings": MessageLookupByLibrary.simpleMessage("Account Settings"),
        "signIn": MessageLookupByLibrary.simpleMessage("Sign in"),
        "signOut": MessageLookupByLibrary.simpleMessage("Sign out"),
        "signUpFee": MessageLookupByLibrary.simpleMessage(
            "\$50 USD sign-up fee due after trial"),
        "signUpFeeDiscount":
            MessageLookupByLibrary.simpleMessage("20% off - \$40 USD"),
        "signedUp": MessageLookupByLibrary.simpleMessage("Signed-up"),
        "signup": MessageLookupByLibrary.simpleMessage("Sign up"),
        "signupFailure":
            MessageLookupByLibrary.simpleMessage("Sign-up unsuccessful"),
        "signupPastEvent": MessageLookupByLibrary.simpleMessage(
            "Cannot sign up for past lesson"),
        "signupSuccess":
            MessageLookupByLibrary.simpleMessage("Sign-up successful"),
        "stripePointsPurchase":
            MessageLookupByLibrary.simpleMessage("Continue to points purchase"),
        "stripePurchase": MessageLookupByLibrary.simpleMessage(
            "Continue to subscription purchase"),
        "stripeRedirectFailure": MessageLookupByLibrary.simpleMessage(
            "Failed to redirect to Stripe"),
        "student": MessageLookupByLibrary.simpleMessage("STUDENT"),
        "studentListTitle":
            MessageLookupByLibrary.simpleMessage("Registered students"),
        "switchProfile": MessageLookupByLibrary.simpleMessage("Switch Profile"),
        "teacher": MessageLookupByLibrary.simpleMessage("TEACHER"),
        "teacherTitle": MessageLookupByLibrary.simpleMessage("Teacher"),
        "termsOfUse": MessageLookupByLibrary.simpleMessage("Terms of use"),
        "timeZoneLabel": MessageLookupByLibrary.simpleMessage("Time Zone"),
        "timeZoneValidation": MessageLookupByLibrary.simpleMessage(
            "Please select a valid time zone"),
        "today": MessageLookupByLibrary.simpleMessage("Today"),
        "unspecified": MessageLookupByLibrary.simpleMessage("Unspecified"),
        "usePoints": m4,
        "verifyEmailAction": MessageLookupByLibrary.simpleMessage(
            "Please click on the link in your email to continue the registration process. If you don\'t see a message in your inbox, please check your spam or junk mail folder."),
        "verifyEmailMessage": m5,
        "viewProfile": MessageLookupByLibrary.simpleMessage("View Profile")
      };
}
