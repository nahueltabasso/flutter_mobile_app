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
    on<ResetErrorDialog>((event, emit) => _onResetErrorDialog(event, emit));
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

  print("Markers despues de agregar: ${state.markers}");
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
    emit(state.copyWith(navigate: false));
    print("ESTADO DESPUES DE RESETEAR BANDERA $state");
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

    print("Positiong geografica antes del request $position");
    try {
      LocationDto? response = await userProfileService.saveUserLocation(position);
      if (response == null) {
        print("Entra a este if a mostrar el dialog");
        emit(state.copyWith(isLoading: false));
        print("Mostro el dialog correctamente");
        return;
      }
      emit(state.copyWith(isLoading: false, navigate: true));
    } catch (e) {
      print("Error al guardar la ubicacion: $e");
    }
  }

  void _onResetErrorDialog(ResetErrorDialog event, Emitter<AddLocationState> emit) {
    emit(state.copyWith(showError: false));
  }
}
