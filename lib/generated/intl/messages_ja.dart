// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  String get localeName => 'ja';

  static String m0(name) => "${name}のカレンダー";

  static String m1(numPoints) => "${numPoints} ポイント";

  static String m2(cost) => "${cost}ポイントが還元されます";

  static String m3(timeZone) => "時間帯： ${timeZone}";

  static String m4(cost, balance) => "${balance}ポイントから${cost}ポイントを使う";

  static String m5(address) => "確認リンクがメールアドレス（${address}）に送信されました";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accountUpdated":
            MessageLookupByLibrary.simpleMessage("アカウント設定を更新しました"),
        "addPoints": MessageLookupByLibrary.simpleMessage("ポイントを追加する"),
        "addProfile": MessageLookupByLibrary.simpleMessage("プロフィール追加"),
        "allEvents": MessageLookupByLibrary.simpleMessage("すべてのレッスン"),
        "calendarHeader": m0,
        "cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
        "cancelSignup": MessageLookupByLibrary.simpleMessage("登録解除"),
        "cancelSignupFailure":
            MessageLookupByLibrary.simpleMessage("登録解除できませんでした"),
        "cancelSignupSuccess":
            MessageLookupByLibrary.simpleMessage("登録を解除しました"),
        "changeProfile": MessageLookupByLibrary.simpleMessage("プロフィール選択"),
        "confirm": MessageLookupByLibrary.simpleMessage("決定"),
        "copied": MessageLookupByLibrary.simpleMessage("コードをコピーしました"),
        "copy": MessageLookupByLibrary.simpleMessage("コードをコピー"),
        "createEvent": MessageLookupByLibrary.simpleMessage("レッスン作成"),
        "createProfile": MessageLookupByLibrary.simpleMessage("プロフィール作成"),
        "dateOfBirthLabel": MessageLookupByLibrary.simpleMessage("生徒生年月日"),
        "dateOfBirthValidation":
            MessageLookupByLibrary.simpleMessage("生徒の生年月日を選択してください"),
        "delete": MessageLookupByLibrary.simpleMessage("削除"),
        "editEvent": MessageLookupByLibrary.simpleMessage("レッスン編集"),
        "eventDateLabel": MessageLookupByLibrary.simpleMessage("日付"),
        "eventDescriptionLabel": MessageLookupByLibrary.simpleMessage("説明"),
        "eventDescriptionValidation":
            MessageLookupByLibrary.simpleMessage("レッスンの説明を入力してください"),
        "eventEndLabel": MessageLookupByLibrary.simpleMessage("終了"),
        "eventEndValidation":
            MessageLookupByLibrary.simpleMessage("終了時間を選択してください"),
        "eventPointsDisplay": m1,
        "eventPointsLabel": MessageLookupByLibrary.simpleMessage("ポイント数"),
        "eventPointsValidation":
            MessageLookupByLibrary.simpleMessage("ポイント数を入力してください"),
        "eventStartLabel": MessageLookupByLibrary.simpleMessage("開始"),
        "eventStartValidation":
            MessageLookupByLibrary.simpleMessage("開始時間を選択してください"),
        "eventSummaryLabel": MessageLookupByLibrary.simpleMessage("タイトル"),
        "eventSummaryValidation":
            MessageLookupByLibrary.simpleMessage("レッスンのタイトルを入力してください"),
        "eventValidTimeValidation":
            MessageLookupByLibrary.simpleMessage("開始時間は終了時間より前である必要があります"),
        "failedAccountUpdate":
            MessageLookupByLibrary.simpleMessage("アカウント設定更新に失敗しました"),
        "filter": MessageLookupByLibrary.simpleMessage("レッスンのフィルター"),
        "filterTitle": MessageLookupByLibrary.simpleMessage("レッスンの種類で表示する"),
        "firstNameHint": MessageLookupByLibrary.simpleMessage("太郎"),
        "firstNameLabel": MessageLookupByLibrary.simpleMessage("生徒名"),
        "firstNameValidation":
            MessageLookupByLibrary.simpleMessage("生徒の名前を入力してください"),
        "free": MessageLookupByLibrary.simpleMessage("フリーレッスン"),
        "freeFilter": MessageLookupByLibrary.simpleMessage("フリーレッスン"),
        "goBack": MessageLookupByLibrary.simpleMessage("戻る"),
        "lastNameHint": MessageLookupByLibrary.simpleMessage("山田"),
        "lastNameLabel": MessageLookupByLibrary.simpleMessage("生徒性"),
        "lastNameValidation":
            MessageLookupByLibrary.simpleMessage("生徒の名字を入力してください"),
        "lessonCalendar": MessageLookupByLibrary.simpleMessage("レッスンカレンダー"),
        "manageSubscription":
            MessageLookupByLibrary.simpleMessage("サブスクリプション管理"),
        "minimumCourse": MessageLookupByLibrary.simpleMessage("ミニマムコース・月＄4０"),
        "minimumPreschoolCourse":
            MessageLookupByLibrary.simpleMessage("ミニマムコース＋未就学児クラス・月＄5０"),
        "myCode": MessageLookupByLibrary.simpleMessage("紹介コード"),
        "myEvents": MessageLookupByLibrary.simpleMessage("マイレッスン"),
        "name": MessageLookupByLibrary.simpleMessage("名前"),
        "next": MessageLookupByLibrary.simpleMessage("次へ"),
        "noPlan": MessageLookupByLibrary.simpleMessage("サブスクリプションがありません"),
        "notEnoughPoints":
            MessageLookupByLibrary.simpleMessage("ポイントを追加してください"),
        "pickPlan":
            MessageLookupByLibrary.simpleMessage("サブスクリプションのコースを選択してください"),
        "preschool": MessageLookupByLibrary.simpleMessage("未就学児レッスン"),
        "preschoolFilter": MessageLookupByLibrary.simpleMessage("未就学児レッスン"),
        "private": MessageLookupByLibrary.simpleMessage("個別レッスン"),
        "privateFilter": MessageLookupByLibrary.simpleMessage("個別レッスン"),
        "recurDaily": MessageLookupByLibrary.simpleMessage("毎日"),
        "recurEditNotSupported": MessageLookupByLibrary.simpleMessage(
            "繰り返しレッスンの編集や削除は現在サポートされていません。直接Google Calendarで編集や削除をしてください。"),
        "recurEnd": MessageLookupByLibrary.simpleMessage("最終日"),
        "recurMonthly": MessageLookupByLibrary.simpleMessage("毎月"),
        "recurNone": MessageLookupByLibrary.simpleMessage("繰り返さない"),
        "recurTitle": MessageLookupByLibrary.simpleMessage("繰り返し"),
        "recurWeekly": MessageLookupByLibrary.simpleMessage("毎週"),
        "referralLabel": MessageLookupByLibrary.simpleMessage("紹介コードを入力してください"),
        "referralValidation":
            MessageLookupByLibrary.simpleMessage("入力された紹介コードは無効です"),
        "refundPoints": m2,
        "reloadPage": MessageLookupByLibrary.simpleMessage("再読み込み"),
        "selectProfile":
            MessageLookupByLibrary.simpleMessage("プロフィールを選択してください"),
        "settings": MessageLookupByLibrary.simpleMessage("アカウント設定"),
        "signIn": MessageLookupByLibrary.simpleMessage("サインイン"),
        "signOut": MessageLookupByLibrary.simpleMessage("サインアウト"),
        "signedUp": MessageLookupByLibrary.simpleMessage("マイレッスン"),
        "signup": MessageLookupByLibrary.simpleMessage("登録"),
        "signupEvent": MessageLookupByLibrary.simpleMessage("レッスン登録"),
        "signupFailure": MessageLookupByLibrary.simpleMessage("登録できませんでした"),
        "signupSuccess": MessageLookupByLibrary.simpleMessage("登録できました"),
        "stripePointsPurchase": MessageLookupByLibrary.simpleMessage("ポイント購入へ"),
        "stripePurchase": MessageLookupByLibrary.simpleMessage("サブスクリプション購入へ"),
        "studentProfile": MessageLookupByLibrary.simpleMessage("生徒プロフィール"),
        "teacherProfile": MessageLookupByLibrary.simpleMessage("講師プロフィール"),
        "timeZone": m3,
        "timeZoneLabel": MessageLookupByLibrary.simpleMessage("時間帯"),
        "timeZoneValidation":
            MessageLookupByLibrary.simpleMessage("有効の時間帯を選択してください"),
        "today": MessageLookupByLibrary.simpleMessage("今日"),
        "usePoints": m4,
        "verifyEmailAction": MessageLookupByLibrary.simpleMessage(
            "登録を続けるには確認リンクをクリックしてください。受信トレイにメールがない場合は迷惑メールかゴミ箱に入ってる可能性があるのでご確認ください。"),
        "verifyEmailMessage": m5,
        "viewProfile": MessageLookupByLibrary.simpleMessage("プロフィールを見る")
      };
}
