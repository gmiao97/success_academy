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

  static String m0(numPoints) => "${numPoints} ポイント";

  static String m1(numPoints, cost) => "${numPoints} ポイント - ${cost}米ドル";

  static String m2(until) => "${until}まで";

  static String m3(cost) => "${cost} ポイントが還元されます";

  static String m4(cost, balance) => "${balance} ポイントから ${cost} ポイントを使う";

  static String m5(address) => "確認リンクがメールアドレス（${address}）に送信されました";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accountUpdated":
            MessageLookupByLibrary.simpleMessage("アカウント設定を更新しました"),
        "addPlan": MessageLookupByLibrary.simpleMessage("サブスクリプションを追加"),
        "addPoints": MessageLookupByLibrary.simpleMessage("ポイントを追加する"),
        "admin": MessageLookupByLibrary.simpleMessage("アドミン"),
        "agreeToTerms": MessageLookupByLibrary.simpleMessage("利用規約に同意"),
        "allEvents": MessageLookupByLibrary.simpleMessage("すべてのレッスン"),
        "cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
        "cancelSignup": MessageLookupByLibrary.simpleMessage("予約キャンセル"),
        "cancelSignupFailure":
            MessageLookupByLibrary.simpleMessage("予約キャンセルに失敗しました"),
        "cancelSignupSuccess":
            MessageLookupByLibrary.simpleMessage("予約をキャンセルしました"),
        "cancelSignupWindowPassed": MessageLookupByLibrary.simpleMessage(
            "予約キャンセル期間が過ぎました。24時間までに予約キャンセルしてください"),
        "close": MessageLookupByLibrary.simpleMessage("閉じる"),
        "confirm": MessageLookupByLibrary.simpleMessage("決定"),
        "copied": MessageLookupByLibrary.simpleMessage("コードをコピーしました"),
        "copy": MessageLookupByLibrary.simpleMessage("コードをコピー"),
        "createEvent": MessageLookupByLibrary.simpleMessage("レッスン作成"),
        "createEventFailure":
            MessageLookupByLibrary.simpleMessage("レッスンの作成ができませんでした"),
        "createEventSuccess":
            MessageLookupByLibrary.simpleMessage("レッスンを作成しました"),
        "createProfile": MessageLookupByLibrary.simpleMessage("プロフィール作成"),
        "dateOfBirthLabel": MessageLookupByLibrary.simpleMessage("生徒生年月日"),
        "dateOfBirthValidation":
            MessageLookupByLibrary.simpleMessage("生徒の生年月日を選択してください"),
        "deleteAll": MessageLookupByLibrary.simpleMessage("すべてのレッスン"),
        "deleteEvent": MessageLookupByLibrary.simpleMessage("レッスン削除"),
        "deleteEventFailure":
            MessageLookupByLibrary.simpleMessage("レッスンの削除ができませんでした"),
        "deleteEventSuccess":
            MessageLookupByLibrary.simpleMessage("レッスンを削除しました"),
        "deleteFuture": MessageLookupByLibrary.simpleMessage("これ以降のすべてのレッスン"),
        "deleteSingle": MessageLookupByLibrary.simpleMessage("このレッスン"),
        "editEvent": MessageLookupByLibrary.simpleMessage("レッスン編集"),
        "editEventFailure":
            MessageLookupByLibrary.simpleMessage("レッスンの編集ができませんでした"),
        "editEventSuccess": MessageLookupByLibrary.simpleMessage("レッスンを編集しました"),
        "email": MessageLookupByLibrary.simpleMessage("メアド"),
        "eventDescriptionLabel": MessageLookupByLibrary.simpleMessage("説明"),
        "eventDescriptionValidation":
            MessageLookupByLibrary.simpleMessage("レッスンの説明を入力してください"),
        "eventEndLabel": MessageLookupByLibrary.simpleMessage("終了"),
        "eventEndValidation":
            MessageLookupByLibrary.simpleMessage("終了時間を選択してください"),
        "eventPointsDisplay": m0,
        "eventPointsLabel": MessageLookupByLibrary.simpleMessage("ポイント数"),
        "eventPointsValidation":
            MessageLookupByLibrary.simpleMessage("ポイント数を入力してください"),
        "eventStartLabel": MessageLookupByLibrary.simpleMessage("開始"),
        "eventStartValidation":
            MessageLookupByLibrary.simpleMessage("開始時間を選択してください"),
        "eventSummaryLabel": MessageLookupByLibrary.simpleMessage("タイトル"),
        "eventSummaryValidation":
            MessageLookupByLibrary.simpleMessage("レッスンのタイトルを入力してください"),
        "eventTooLongValidation":
            MessageLookupByLibrary.simpleMessage("期間は24時間以下である必要があります"),
        "eventType": MessageLookupByLibrary.simpleMessage("レッスンの種類"),
        "eventValidTimeValidation":
            MessageLookupByLibrary.simpleMessage("開始時間は終了時間より前である必要があります"),
        "failedAccountUpdate":
            MessageLookupByLibrary.simpleMessage("アカウント設定更新に失敗しました"),
        "failedGetRecurrenceEvent":
            MessageLookupByLibrary.simpleMessage("レッスンの読み込みができませんでした"),
        "filter": MessageLookupByLibrary.simpleMessage("フィルター"),
        "firstName": MessageLookupByLibrary.simpleMessage("名"),
        "firstNameHint": MessageLookupByLibrary.simpleMessage("太郎"),
        "firstNameLabel": MessageLookupByLibrary.simpleMessage("生徒（名）"),
        "firstNameValidation":
            MessageLookupByLibrary.simpleMessage("生徒の名前を入力してください"),
        "free": MessageLookupByLibrary.simpleMessage("フリーレッスン"),
        "freeLessonMaterials": MessageLookupByLibrary.simpleMessage("教材"),
        "freeLessonTimeTable":
            MessageLookupByLibrary.simpleMessage("フリーレッスン時間割"),
        "freeLessonZoomInfo":
            MessageLookupByLibrary.simpleMessage("フリーレッスンZOOM情報"),
        "freeNum": MessageLookupByLibrary.simpleMessage("フリーレッスン完了数"),
        "freeTrial": MessageLookupByLibrary.simpleMessage("14日間無料トライアル"),
        "goBack": MessageLookupByLibrary.simpleMessage("戻る"),
        "id": MessageLookupByLibrary.simpleMessage("ID"),
        "lastName": MessageLookupByLibrary.simpleMessage("姓"),
        "lastNameHint": MessageLookupByLibrary.simpleMessage("山田"),
        "lastNameLabel": MessageLookupByLibrary.simpleMessage("生徒（姓）"),
        "lastNameValidation":
            MessageLookupByLibrary.simpleMessage("生徒の名字を入力してください"),
        "lesson": MessageLookupByLibrary.simpleMessage("レッスン"),
        "lessonCalendar": MessageLookupByLibrary.simpleMessage("レッスンカレンダー"),
        "lessonInfo": MessageLookupByLibrary.simpleMessage("レッスン情報"),
        "lessonInfoUpdateFailed":
            MessageLookupByLibrary.simpleMessage("更新に失敗しました"),
        "lessonInfoUpdated": MessageLookupByLibrary.simpleMessage("更新しました"),
        "link": MessageLookupByLibrary.simpleMessage("リンク"),
        "manageProfile": MessageLookupByLibrary.simpleMessage("ユーザー管理"),
        "manageSubscription":
            MessageLookupByLibrary.simpleMessage("サブスクリプション管理"),
        "meetingId": MessageLookupByLibrary.simpleMessage("ミーテイングID"),
        "minimumCourse": MessageLookupByLibrary.simpleMessage("フリーレッスン・月40米ドル"),
        "minimumPreschoolCourse":
            MessageLookupByLibrary.simpleMessage("フリーレッスン+未就学児クラス・月50米ドル"),
        "monthlyCourse":
            MessageLookupByLibrary.simpleMessage("月会費のみ・月10米ドル (個別レッスンのみ)"),
        "myCode": MessageLookupByLibrary.simpleMessage("紹介コード"),
        "myEvents": MessageLookupByLibrary.simpleMessage("マイレッスン"),
        "noPlan": MessageLookupByLibrary.simpleMessage("サブスクリプションがありません"),
        "notEnoughPoints":
            MessageLookupByLibrary.simpleMessage("ポイントが足りません。ポイントを追加してください"),
        "openLinkFailure": MessageLookupByLibrary.simpleMessage("リンクを開けませんでした"),
        "password": MessageLookupByLibrary.simpleMessage("パスワード"),
        "pickPlan":
            MessageLookupByLibrary.simpleMessage("サブスクリプションのコースを選択してください"),
        "pointsPurchase": m1,
        "preschool": MessageLookupByLibrary.simpleMessage("未就学児レッスン"),
        "preschoolNum": MessageLookupByLibrary.simpleMessage("未就学児レッスン完了数"),
        "private": MessageLookupByLibrary.simpleMessage("個別レッスン"),
        "privateNum": MessageLookupByLibrary.simpleMessage("完了個別レッスンポイント数"),
        "profile": MessageLookupByLibrary.simpleMessage("プロフィール"),
        "promptSave": MessageLookupByLibrary.simpleMessage("保存ボタンを押してください"),
        "recurDaily": MessageLookupByLibrary.simpleMessage("毎日"),
        "recurEnd": MessageLookupByLibrary.simpleMessage("終了日"),
        "recurMonthly": MessageLookupByLibrary.simpleMessage("毎月"),
        "recurNone": MessageLookupByLibrary.simpleMessage("繰り返さない"),
        "recurTitle": MessageLookupByLibrary.simpleMessage("繰り返し"),
        "recurUntil": m2,
        "recurUntilLabel": MessageLookupByLibrary.simpleMessage("最終日"),
        "recurWeekly": MessageLookupByLibrary.simpleMessage("毎週"),
        "referralLabel": MessageLookupByLibrary.simpleMessage("紹介コードを入力してください"),
        "referralValidation":
            MessageLookupByLibrary.simpleMessage("入力された紹介コードは無効です"),
        "referrerHint": MessageLookupByLibrary.simpleMessage("山田太郎"),
        "referrerLabel": MessageLookupByLibrary.simpleMessage("紹介者"),
        "refundPoints": m3,
        "reloadPage": MessageLookupByLibrary.simpleMessage("再読み込み"),
        "selectProfile":
            MessageLookupByLibrary.simpleMessage("プロフィールを選択してください"),
        "settings": MessageLookupByLibrary.simpleMessage("アカウント設定"),
        "signIn": MessageLookupByLibrary.simpleMessage("サインイン"),
        "signOut": MessageLookupByLibrary.simpleMessage("サインアウト"),
        "signUpFee":
            MessageLookupByLibrary.simpleMessage("トライアル後に入会費50米ドルが請求されます"),
        "signUpFeeDiscount":
            MessageLookupByLibrary.simpleMessage("20%割引ー40米ドル"),
        "signedUp": MessageLookupByLibrary.simpleMessage("予約済み"),
        "signup": MessageLookupByLibrary.simpleMessage("予約する"),
        "signupFailure": MessageLookupByLibrary.simpleMessage("予約に失敗しました"),
        "signupSuccess": MessageLookupByLibrary.simpleMessage("予約できました"),
        "signupWindowPassed":
            MessageLookupByLibrary.simpleMessage("予約期間が過ぎました。24時間前までに予約してください"),
        "stripePointsPurchase": MessageLookupByLibrary.simpleMessage("ポイント購入へ"),
        "stripePurchase": MessageLookupByLibrary.simpleMessage("サブスクリプション購入へ"),
        "stripeRedirectFailure":
            MessageLookupByLibrary.simpleMessage("Stripeへのリダイレクトができませんでした"),
        "student": MessageLookupByLibrary.simpleMessage("生徒"),
        "studentListTitle": MessageLookupByLibrary.simpleMessage("予約されている生徒"),
        "switchProfile": MessageLookupByLibrary.simpleMessage("プロフィールを切り替える"),
        "teacher": MessageLookupByLibrary.simpleMessage("先生"),
        "teacherTitle": MessageLookupByLibrary.simpleMessage("先生"),
        "termsOfUse": MessageLookupByLibrary.simpleMessage("利用規約"),
        "timeZoneLabel": MessageLookupByLibrary.simpleMessage("タイムゾーン"),
        "timeZoneValidation":
            MessageLookupByLibrary.simpleMessage("有効の時間帯を選択してください"),
        "today": MessageLookupByLibrary.simpleMessage("今日"),
        "unspecified": MessageLookupByLibrary.simpleMessage("未定"),
        "usePoints": m4,
        "verifyEmailAction": MessageLookupByLibrary.simpleMessage(
            "登録を続けるには確認リンクをクリックしてください。受信トレイにメールがない場合は迷惑メールかゴミ箱に入ってる可能性があるのでご確認ください。"),
        "verifyEmailMessage": m5,
        "viewProfile": MessageLookupByLibrary.simpleMessage("プロフィールを見る")
      };
}
