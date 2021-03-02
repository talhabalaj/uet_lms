// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_analytics/firebase_analytics.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:stacked_services/stacked_services.dart' as _i5;

import 'locator.dart' as _i12;
import 'services/AuthService.dart' as _i3;
import 'services/BackgroundService.dart' as _i4;
import 'services/DataService.dart' as _i11;
import 'services/NestedNavigationService.dart' as _i7;
import 'services/NotificationService.dart' as _i8;
import 'services/PreferencesService.dart' as _i9;
import 'services/ThemeService.dart'
    as _i10; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.lazySingleton<_i3.AuthService>(() => _i3.AuthService());
  gh.lazySingleton<_i4.BackgroundService>(() => _i4.BackgroundService());
  gh.factory<_i5.BottomSheetService>(
      () => thirdPartyServicesModule.bottomSheetService);
  gh.factory<_i5.DialogService>(() => thirdPartyServicesModule.dialogService);
  gh.factory<_i6.FirebaseAnalytics>(
      () => thirdPartyServicesModule.firebaseAnalytics);
  gh.factory<_i5.NavigationService>(
      () => thirdPartyServicesModule.navigationService);
  gh.lazySingleton<_i7.NestedNavigationService>(
      () => _i7.NestedNavigationService());
  gh.lazySingleton<_i8.NotificationService>(() => _i8.NotificationService());
  gh.lazySingleton<_i9.PreferencesService>(() => _i9.PreferencesService());
  gh.factory<_i5.SnackbarService>(
      () => thirdPartyServicesModule.snackBarService);
  gh.lazySingleton<_i10.ThemeService>(() => _i10.ThemeService());
  gh.singleton<_i11.DataService>(_i11.DataService());
  return get;
}

class _$ThirdPartyServicesModule extends _i12.ThirdPartyServicesModule {
  @override
  _i5.BottomSheetService get bottomSheetService => _i5.BottomSheetService();
  @override
  _i5.DialogService get dialogService => _i5.DialogService();
  @override
  _i6.FirebaseAnalytics get firebaseAnalytics => _i6.FirebaseAnalytics();
  @override
  _i5.NavigationService get navigationService => _i5.NavigationService();
  @override
  _i5.SnackbarService get snackBarService => _i5.SnackbarService();
}
