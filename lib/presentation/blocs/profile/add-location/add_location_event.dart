part of 'add_location_bloc.dart';

sealed class AddLocationEvent extends Equatable {
  const AddLocationEvent();

  @override
  List<Object> get props => [];
}

class AddLocation extends AddLocationEvent {
  final LatLng position;

  const AddLocation(this.position);

  @override
  List<Object> get props => [position];
}

class RemoveLocation extends AddLocationEvent {
  final LatLng position;

  const RemoveLocation(this.position);

  @override
  List<Object> get props => [position];
}

class ChangeMapType extends AddLocationEvent {}

class SetShowDialogFlag extends AddLocationEvent {}

class OnSubmitNewLocation extends AddLocationEvent {

  final BuildContext context;

  const OnSubmitNewLocation(this.context);

  @override
  List<Object> get props => [context];  
}