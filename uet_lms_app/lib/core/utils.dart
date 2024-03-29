import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

//import 'package:file_chooser/file_chooser.dart';
import 'package:file_chooser/file_chooser.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lms_api/lms_api.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/adapters/ResultAdapter.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/AuthService.dart';
import 'package:uet_lms/ui/dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hive/hive.dart';

import 'adapters/RegisterAdapter.dart';

Future<void> saveFile(Uint8List bytes, String fileName,
    {bool open = true}) async {
  if (kIsWeb) {
    final content = base64Encode(bytes);
    await launch("data:application/pdf;charset=utf-16le;base64,$content");
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

Future<bool> onlyCatchLMSorInternetException(Exception e,
    {StackTrace stackTrace,
    String mainTitleButton,
    String secondaryButtonTitle = "Cancel"}) async {
  String errorMessage, description;

  if (e is LMSException) {
    errorMessage = e.message;
    description = e.description ?? "Please report this issue to developer.";
    if (e is ReportableLMSError)
      FirebaseCrashlytics.instance.recordError(e, stackTrace);
  } else if (e is SocketException || e is HttpException) {
    errorMessage = "No Internet connection.";
    description = "Maybe try again with internet";
  } else {
    throw e;
  }

  final result = await I<DialogService>().showCustomDialog(
    variant: DialogType.basic,
    mainButtonTitle: mainTitleButton ?? "Retry",
    secondaryButtonTitle: secondaryButtonTitle,
    title: errorMessage,
    barrierDismissible: secondaryButtonTitle != null,
    description: description,
  );

  return result.confirmed;
}

bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
bool isDesktop =
    !kIsWeb && ((Platform.isLinux || Platform.isWindows || Platform.isMacOS));

Future<Uint8List> openImage() async {
  if (isMobile) {
  return (await ImagePicker().getImage(source: ImageSource.gallery))
      .readAsBytes();
  } else {
    final openResult = await showOpenPanel(
      allowedFileTypes: [
        FileTypeFilterGroup(
          fileExtensions: ['jpg', 'jpeg', 'png'],
        )
      ],
      allowsMultipleSelection: false,
    );
    if (openResult.canceled) return null;
    return File(openResult.paths[0]).readAsBytes();
  }
}

void registerHiveTypeAdapters() {
  Hive.registerAdapter(ResultAdapter());
  Hive.registerAdapter(RegisterAdapter());
}

String userBox(String boxName) {
  if (!I<AuthService>().loggedIn)
    throw Exception("User is not logged in");
  return "${I<AuthService>().user.uid}_$boxName";
}