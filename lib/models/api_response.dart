import 'package:awesome_dialog/awesome_dialog.dart';

class APIResponseBrt<T> {
  T? data;
  bool error;
  String? errorMessage;
  int? status;
  APIResponseBrt({
    this.data,
    this.error = false,
    this.errorMessage,
    this.status = 500,
  });
}

class APIResponse<T> {
  T? data;
  bool error;
  String? errorMessage;
  int? status;
  DialogType dialog;
  APIResponse({
    this.data,
    this.errorMessage,
    this.error = false,
    this.status = 500,
    this.dialog = DialogType.SUCCES,
  });
}

class APIResponseC<T> {
  T? data;
  bool error;
  APIResponseC({this.data, this.error = false});
}

class APIResponseMasuk<T> {
  T? data;
  bool error;
  String? errorMessage;
  int? status;
  DialogType dialog;
  APIResponseMasuk({
    this.data,
    this.errorMessage,
    this.error = false,
    this.status = 500,
    this.dialog = DialogType.SUCCES,
  });
}
