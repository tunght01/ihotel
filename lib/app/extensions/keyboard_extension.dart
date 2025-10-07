import 'package:flutter/services.dart';

void hiddenKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}
