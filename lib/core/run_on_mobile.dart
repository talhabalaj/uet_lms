import 'dart:io';

import 'package:flutter/foundation.dart';

Future<void> runOnlyOnMobile(Function fun) async  {
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await fun();
  }
} 