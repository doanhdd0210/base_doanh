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

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "allow_permission": MessageLookupByLibrary.simpleMessage(
            "Muốn quyền truy cập vào camera và Ảnh của bạn."),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "continue_with": MessageLookupByLibrary.simpleMessage("Continue with"),
        "continue_with_email":
            MessageLookupByLibrary.simpleMessage("Continue with Email"),
        "email_or_username":
            MessageLookupByLibrary.simpleMessage("Email or username"),
        "error": MessageLookupByLibrary.simpleMessage("Error"),
        "error_network": MessageLookupByLibrary.simpleMessage(
            "Please check the internet connection and try again later."),
        "forgot_password":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "go_to_setting": MessageLookupByLibrary.simpleMessage("Đi tới Cài đặt"),
        "have_an_account_already":
            MessageLookupByLibrary.simpleMessage("Have an account already?"),
        "log_in": MessageLookupByLibrary.simpleMessage("Log in"),
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "out_app":
            MessageLookupByLibrary.simpleMessage("Press back again to exit"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "server_error": MessageLookupByLibrary.simpleMessage(
            "Can’t access to the server, please try again later."),
        "session_time_out":
            MessageLookupByLibrary.simpleMessage("Session time out!"),
        "sign_up": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "sign_up_with": MessageLookupByLibrary.simpleMessage("Sign up with"),
        "something_went_wrong": MessageLookupByLibrary.simpleMessage(
            "Something went wrong. Please try again later."),
        "unauthorized": MessageLookupByLibrary.simpleMessage(
            "Your session has expired. Please sign in.")
      };
}
