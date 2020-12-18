import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/lms_service.dart';

class DMCViewModel extends BaseViewModel {
  final LMSService lmsService = locator<LMSService>();

  Future<void> loadData() async {

  }
}