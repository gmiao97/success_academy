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

  static String m1(timeZone) => "時間帯： ${timeZone}";

  static String m2(address) => "確認リンクがメールアドレス（${address}）に送信されました";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accountUpdated":
            MessageLookupByLibrary.simpleMessage("アカウント設定を更新しました"),
        "addProfile": MessageLookupByLibrary.simpleMessage("プロフィール追加"),
        "calendarHeader": m0,
        "cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
        "changeProfile": MessageLookupByLibrary.simpleMessage("プロフィール選択"),
        "confirm": MessageLookupByLibrary.simpleMessage("決定"),
        "copied": MessageLookupByLibrary.simpleMessage("コードをコピーしました"),
        "copy": MessageLookupByLibrary.simpleMessage("コードをコピー"),
        "createProfile": MessageLookupByLibrary.simpleMessage("プロフィール作成"),
        "dateOfBirthLabel": MessageLookupByLibrary.simpleMessage("生徒生年月日"),
        "dateOfBirthValidation":
            MessageLookupByLibrary.simpleMessage("生徒の生年月日を選択してください"),
        "eventDateLabel": MessageLookupByLibrary.simpleMessage("日付"),
        "eventDescriptionLabel": MessageLookupByLibrary.simpleMessage("説明"),
        "eventDescriptionValidation":
            MessageLookupByLibrary.simpleMessage("レッスンの説明を入力してください"),
        "eventEndLabel": MessageLookupByLibrary.simpleMessage("終了"),
        "eventEndValidation":
            MessageLookupByLibrary.simpleMessage("終了時間を選択してください"),
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
        "minimumCourse": MessageLookupByLibrary.simpleMessage("ミニマムコース・月＄３０"),
        "minimumPreschoolCourse":
            MessageLookupByLibrary.simpleMessage("ミニマムコース＋未就学児クラス・月＄４０"),
        "myCode": MessageLookupByLibrary.simpleMessage("紹介コード"),
        "name": MessageLookupByLibrary.simpleMessage("名前"),
        "next": MessageLookupByLibrary.simpleMessage("次へ"),
        "pickPlan":
            MessageLookupByLibrary.simpleMessage("サブスクリプションのコースを選択してください"),
        "preschool": MessageLookupByLibrary.simpleMessage("未就学児レッスン"),
        "preschoolFilter": MessageLookupByLibrary.simpleMessage("未就学児レッスン"),
        "private": MessageLookupByLibrary.simpleMessage("個別レッスン"),
        "privateFilter": MessageLookupByLibrary.simpleMessage("個別レッスン"),
        "referralLabel": MessageLookupByLibrary.simpleMessage("紹介コードを入力してください"),
        "referralValidation":
            MessageLookupByLibrary.simpleMessage("入力された紹介コードは無効です"),
        "reloadPage": MessageLookupByLibrary.simpleMessage("再読み込み"),
        "selectProfile":
            MessageLookupByLibrary.simpleMessage("プロフィールを選択してください"),
        "settings": MessageLookupByLibrary.simpleMessage("アカウント設定"),
        "signIn": MessageLookupByLibrary.simpleMessage("サインイン"),
        "signOut": MessageLookupByLibrary.simpleMessage("サインアウト"),
        "stripePurchase": MessageLookupByLibrary.simpleMessage("サブスクリプション購入へ"),
        "studentProfile": MessageLookupByLibrary.simpleMessage("生徒プロフィール"),
        "teacherProfile": MessageLookupByLibrary.simpleMessage("講師プロフィール"),
        "timeZone": m1,
        "timeZoneLabel": MessageLookupByLibrary.simpleMessage("時間帯"),
        "timeZoneValidation":
            MessageLookupByLibrary.simpleMessage("有効の時間帯を選択してください"),
        "today": MessageLookupByLibrary.simpleMessage("今日"),
        "verifyEmailAction": MessageLookupByLibrary.simpleMessage(
            "登録を続けるには確認リンクをクリックしてください。受信トレイにメールがない場合は迷惑メールかゴミ箱に入ってる可能性があるのでご確認ください。"),
        "verifyEmailMessage": m2,
        "viewProfile": MessageLookupByLibrary.simpleMessage("プロフィールを見る")
      };
}
