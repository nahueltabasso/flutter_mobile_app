import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:techconnect_mobile/models/location_dto.dart';
import 'package:techconnect_mobile/services/user_profile_service.dart';

part 'add_location_event.dart';
part 'add_location_state.dart';

class AddLocationBloc extends Bloc<AddLocationEvent, AddLocationState> {
  AddLocationBloc() : super(AddLocationState()) {
    on<AddLocation>((event, emit) => _onAddMarker(event, emit));
    on<RemoveLocation>((event, emit) => _onRemoveMarker(event, emit));
    on<ChangeMapType>((event, emit) => _onChangeMapType(event, emit));
    on<SetShowDialogFlag>((event, emit) => _setShowDialogFlag(event, emit));
    on<OnSubmitNewLocation>((event, emit) => _onSubmitNewLocation(event, emit));
  }


void _onAddMarker(AddLocation event, Emitter<AddLocationState> emit) {
  final newMarker = Marker(
    markerId: MarkerId(event.position.toString()),
    position: event.position,
    icon: state.icon,
    infoWindow: InfoWindow(
      title: DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now()),
    ),
  );

  emit(state.copyWith(
    markers: {...state.markers, newMarker},
  ));
}


  void _onRemoveMarker(RemoveLocation event, Emitter<AddLocationState> emit) {

    final updatedMarkers = state.markers
        .where((marker) => marker.position != event.position)
        .toSet();
    // emit(state.copyWith(showDialog: false));
    emit(state.copyWith(markers: updatedMarkers));
  }

  void _onChangeMapType(ChangeMapType event, Emitter<AddLocationState> emit) {
    emit(state.copyWith(
      mapType: state.mapType == MapType.normal
          ? MapType.satellite
          : MapType.normal,
    ));
  }

  void _setShowDialogFlag(SetShowDialogFlag event, Emitter<AddLocationState> emit) {
    // emit(state.copyWith(showDialog: false));
    print(state);
  }

  Future<void> _onSubmitNewLocation(OnSubmitNewLocation event, Emitter<AddLocationState> emit) async {
    emit(state.copyWith(
      isLoading: true,
      markers: state.markers,
    ));

    final userProfileService = event.context.read<UserProfileService>();

    LatLng position;
    if (state.markers.length == 1) {
      position = state.markers.first.position;
    } else {
      position = state.markers.last.position;
    }
    LocationDto? response = await userProfileService.saveUserLocation(event.context, position);
    if (response != null) {
      emit(state.copyWith(isLoading: false, navigate: true));
    }
  }
}
