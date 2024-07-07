import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geocode/geocode.dart';
import 'package:injectable/injectable.dart';
import 'package:we_work/application/permission/permission_cubit.dart';
import 'package:we_work/core/config/shared_preference_constants.dart';
import 'package:we_work/core/services/service_locator.dart';
import 'package:we_work/domain/location/i_location_service.dart';
import 'package:we_work/domain/location/location_model.dart';
import 'package:we_work/domain/location_data_model.dart';

import '../application_life_cycle/application_life_cycle_cubit.dart';
part 'location_cubit.freezed.dart';
part 'location_state.dart';

@injectable
class LocationCubit extends Cubit<LocationState> {
  final ILocationService _locationService;
  final PermissionCubit _permissionCubit;
  final ApplicationLifeCycleCubit _applicationLifeCycleCubit;
  StreamSubscription<LocationModel>? _userPositionSubscription;
  StreamSubscription<List<PermissionState>>? _permissionStatePairSubscription;
  StreamSubscription<List<ApplicationLifeCycleState>>?
      _appLifeCycleStatePairSubscription;
  LocationCubit(this._locationService, this._permissionCubit,
      this._applicationLifeCycleCubit)
      : super(LocationState.initial());

  @override
  Future<void> close() {
    _userPositionSubscription?.cancel();
    _permissionStatePairSubscription?.cancel();
    _appLifeCycleStatePairSubscription?.cancel();

    return super.close();
  }

  void _userPositionListener(LocationModel location) {
    emit(state.copyWith(userLocation: location));
  }

  Future<LocationDataModel> getLocation() async {
    var result = LocationDataModel.fromJson(
        {'statusCode': 500, 'mainAddress': '', 'secondaryAddress': ''});
    LocationModel locationModel;
    if (_permissionCubit.state.isLocationPermissionGrantedAndServicesEnabled) {
      locationModel = await _locationService.getCurrentPosition();
      _userPositionListener(locationModel);
      result = await processAndSave(locationModel);
    } else {
      locationModel = const LocationModel(latitude: 0, longitude: 0);
    }

    return result;
  }

  Future<LocationDataModel> processAndSave(LocationModel locationModel) async {
    final result = LocationDataModel.fromJson(
        {'statusCode': 500, 'mainAddress': '', 'secondaryAddress': ''});
    Address? currentAddress;
    try {
      double lat = locationModel.latitude;
      double long = locationModel.longitude;
      try {
        //TOD0: this is a paid library used for reverseGeocoding
        // as there were couple of issues with free ones, i have to do more  more research on this
        currentAddress =
            await GeoCode().reverseGeocoding(latitude: lat, longitude: long);
      } catch (e) {
        // Show a message to the user or take appropriate action
      }
      var address =
          '${currentAddress!.city} ,${currentAddress.streetAddress}, ${currentAddress.streetAddress}, ${currentAddress.countryName}';

      result.mainAddress = currentAddress.postal;
      result.secondaryAddress = address;
    } catch (err) {
      debugPrint(err.toString());
    }
    cacheLocation(result);

    return result;
  }

  cacheLocation(LocationDataModel result) async {
    await sharedPreferencesService.setString(
        SharedPrefrenceConstants.mainAddress, result.mainAddress!);
    await sharedPreferencesService.setString(
        SharedPrefrenceConstants.secondaryAddress, result.secondaryAddress!);
  }
}
