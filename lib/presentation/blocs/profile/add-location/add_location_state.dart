part of 'add_location_bloc.dart';

class AddLocationState extends Equatable {
  final Set<Marker> markers;
  final MapType mapType;
  final BitmapDescriptor icon;
  final bool isLoading;
  final bool navigate;

  const AddLocationState({
    this.markers = const {}, // Valor predeterminado
    this.mapType = MapType.normal,
    this.icon = BitmapDescriptor.defaultMarker,
    this.isLoading = false,
    this.navigate = false,
  });

  AddLocationState copyWith({
    Set<Marker>? markers,
    MapType? mapType,
    BitmapDescriptor? icon,
    bool? isLoading,
    bool? navigate, 
  }) {
    return AddLocationState(
      markers: markers ?? this.markers,
      mapType: mapType ?? this.mapType,
      icon: icon ?? this.icon,
      isLoading: isLoading ?? this.isLoading,
      navigate: navigate ?? this.navigate,  
    );
  }

  @override
  List<Object> get props => [markers, mapType, icon, isLoading, navigate];
}