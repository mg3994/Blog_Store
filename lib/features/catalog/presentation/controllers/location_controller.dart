import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import '../../domain/entities/location_model.dart';

class LocationController extends SignalCubit<LocationModel?> {
  LocationController([LocationModel? initial]) : super(initial);

  void setLocation(LocationModel location) {
    emit(location);
  }

  void clearLocation() {
    emit(null);
  }
}
