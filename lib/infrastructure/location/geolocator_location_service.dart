import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:we_work/domain/location/i_location_service.dart';
import 'package:we_work/domain/location/location_model.dart';

@Injectable(as: ILocationService)
class GeolocatorLocationService implements ILocationService {
  @override
  Stream<LocationModel> get positionStream => Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      )).map((Position position) => LocationModel(
          latitude: position.latitude, longitude: position.longitude));

  @override
  Future<LocationModel> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;
    return LocationModel(latitude: lat, longitude: long);
  }
}
