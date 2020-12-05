import 'package:flutter/material.dart';
import 'package:lms_app/core/locator.dart';
import 'package:lms_app/ui/shared/BasicDialog.dart';
import 'package:stacked_services/stacked_services.dart';

enum DialogType { basic, form }

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final builders = {
    DialogType.basic: (context, sheetRequest, completer) 
    => BasicDialog(request: sheetRequest, completer: completer,),
  };

  dialogService.registerCustomDialogBuilders(builders);
}