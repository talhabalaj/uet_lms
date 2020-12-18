import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_chooser/file_chooser.dart';
import 'package:flutter/foundation.dart';
import 'package:lms_api/lms_api.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/ui/dialog.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> saveFile(Uint8List bytes, String fileName,
    {bool open = true}) async {
  if (kIsWeb) {
    final content = base64Encode(bytes);
    await launch(
        "data:application/octet-stream;charset=utf-16le;base64,$content");
  } else {
    if (Platform.isAndroid || Platform.isIOS) {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File tempFile = File("$tempPath/$fileName");

      await tempFile.writeAsBytes(bytes);
      await OpenFile.open(tempFile.path);
    } else {
      final result = await showSavePanel(
        allowedFileTypes: [
          FileTypeFilterGroup(
            fileExtensions: [fileName.split('.')[1]],
          ),
        ],
        confirmButtonText: "Save",
        suggestedFileName: fileName,
      );

      if (!result.canceled) {
        final path = result.paths[0];
        final file = File(path);
        await file.writeAsBytes(bytes);
        if (open) {
          await OpenFile.open("\"${file.path}\"");
        }
      }
    }
  }
}

Future<bool> catchLMSorInternetException(Exception e) async {
  String errorMessage, description;

  if (e is LMSException) {
    errorMessage = e.message;
    description = e.description ?? "Please report this issue to developer.";
  } else if (e is SocketException) {
    errorMessage = "No Internet connection.";
    description = "Maybe try again with internet";
  } else {
    throw e;
  }

  final result = await locator<DialogService>().showCustomDialog(
    variant: DialogType.basic,
    mainButtonTitle: "Retry",
    secondaryButtonTitle: "Cancel",
    title: errorMessage,
    description: description,
  );

  return result.confirmed;
}
