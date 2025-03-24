import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:techconnect_mobile/presentation/blocs/profile/complete-profile/complete_profile_bloc.dart';

class UploadProfilePhotoForm extends StatelessWidget {

  const UploadProfilePhotoForm({super.key});

  Future<void> _initPicker(BuildContext context, ImageSource source) async {
    final selectedFile = await ImagePicker().pickImage(source: source);
    if (selectedFile != null) {
      final image = File(selectedFile.path);
      context.read<CompleteProfileBloc>().add(SetProfilePhoto(image));
    }
  }

  @override
  Widget build(BuildContext context) {
    final completeProfileState = context.read<CompleteProfileBloc>().state;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (completeProfileState.profilePhoto != null)
          CircleAvatar(
            radius: 100,
            backgroundImage: FileImage(completeProfileState.profilePhoto!),
            backgroundColor: Colors.grey,
          )
        else
          const CircleAvatar(
            radius: 100,
            child: Icon(Icons.person),
          ),
        
        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: () => _initPicker(context, ImageSource.gallery),
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightBlue),
          ),
          child: const Text('Abrir galería', style: TextStyle(color: Colors.black)),
        ),

        ElevatedButton(
          onPressed: () => _initPicker(context, ImageSource.camera),
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightBlue)
          ),
          child: const Text('Abrir Camara',style: TextStyle(color: Colors.black)),
        ),

        const SizedBox(height: 20),

        if (completeProfileState.isLoading) 
          const CircularProgressIndicator(color: Colors.lightBlue)
      ],
    );
  }
}