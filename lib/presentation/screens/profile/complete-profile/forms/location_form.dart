import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:techconnect_mobile/presentation/blocs/profile/add-location/add_location_bloc.dart';
import 'package:techconnect_mobile/presentation/screens/profile/complete-profile/forms/invite_friends_form.dart';
import 'package:techconnect_mobile/services/dialog_service.dart';

class LocationForm extends StatelessWidget {
  static const String routeName = '/location';

  const LocationForm({Key? key}) : super(key: key);

  void _closeDialog(BuildContext context) {
    context.read<AddLocationBloc>().add(SetShowDialogFlag());
    Navigator.of(context).pop();
  }

  Widget getWidgetToDialog(BuildContext context) {
    final state = context.read<AddLocationBloc>().state;
    if (state.markers.isEmpty) return const Text('No se selecciono ninguna ubicación');
    if (state.markers.length == 1) return const Text('¿Desea guardar esta ubicación?');
    if (state.markers.length > 1) return const Text('¿Desea guardar la ultima ubicacion seleccionada?');
    if (state.isLoading) return const Center(child: CircularProgressIndicator());
    return const Text('');
  }

  void _saveLocation(BuildContext context) async {
    final state = context.read<AddLocationBloc>().state;
    print(state);
    // Muestra el AlertDialog usando showDialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: state.markers.isEmpty
              ? const Icon(Icons.error, color: Colors.red, size: 50)
              : const Icon(Icons.question_answer, color: Colors.lightBlue, size: 50),
          title: state.markers.isEmpty
              ? const Text('Error')
              : const Center(child: Text('Guardar Ubicación')),
          content: getWidgetToDialog(context),
          actions: [
            TextButton(
              onPressed: () => _closeDialog(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: state.markers.isEmpty 
              ? null 
              : () {
                context.read<AddLocationBloc>().add(OnSubmitNewLocation(context));
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddLocationBloc, AddLocationState>(
      listener: (context, state) {
        if (state.navigate) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const InviteFriendsForm()),
          );
          DialogService.showSuccessDialogAlert(
            context,
            'Bienvenido',
            'Hola, ahora puedes agregar algunos amigos!',
            null,
          );

          // Restablecer el estado de navegación
          context.read<AddLocationBloc>().add(SetShowDialogFlag());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Selecciona tu ubicación'),
        ),
        body: BlocBuilder<AddLocationBloc, AddLocationState>(
          builder: (context, state) {
            return GoogleMap(
              initialCameraPosition: const CameraPosition(
                zoom: 11,
                target: LatLng(37.4234, -122.6848),
              ),
              mapType: state.mapType,
              markers: state.markers,
              onTap: (position) {
                context.read<AddLocationBloc>().add(AddLocation(position));
              },
              onLongPress: (position) {
                context.read<AddLocationBloc>().add(RemoveLocation(position));
              },
            );
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              onPressed: () => _saveLocation(context),
              backgroundColor: Colors.lightBlue,
              child: const Icon(Icons.save, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
