import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_stepper/stepper.dart';
import 'package:techconnect_mobile/presentation/blocs/profile/complete-profile/complete_profile_bloc.dart';

class CompleteProfileScreen extends StatelessWidget {
  static const String routeName = '/complete-profile';

  const CompleteProfileScreen({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Center(child: Text('Completa tu Perfil')),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.lightBlue,
    ),
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
                    builder: (context, state) {
                      return IconStepper(
                        icons: const [
                          Icon(Icons.person_4_rounded),
                          Icon(Icons.school_outlined),
                          Icon(Icons.photo_camera),
                        ],
                        activeStep: state.activeStep,
                        onStepReached: (index) {
                          context.read<CompleteProfileBloc>().add(StepChanged(index));
                        },
                      );
                    },
                  ),
                  BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
                    builder: (context, state) {
                      return header(state.activeStep);
                    },
                  ),
                  BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Column(
                          children: [
                            SizedBox(height: 50),
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        );
                      }
                      return SizedBox(
                        height: 570,
                        width: 500,
                        child: PageView(
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          controller: state.pageController,
                          children: [
                            // PersonalDataForm(email: state.userEmail),
                            // StudyHobbyForm(),
                            // UploadProfilePhotoForm(),
                            Container(color: Colors.red,),
                            Container(color: Colors.green,),
                            Container(color: Colors.blue,),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  previousButton(context, state),
                  if (state.activeStep < state.upperBound)
                    nextButton(context, state)
                  else if (state.activeStep == state.upperBound)
                    submitButton(context),
                ],
              );
            },
          ),
        ],
      ),
    ),
  );
}

  Widget submitButton(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightBlue),
      ),
      onPressed: () {
        // context.read<CompleteProfileBloc>().add(SaveProfile());
      },
      child: const Text(
        'Guardar',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget nextButton(BuildContext context, CompleteProfileState state) {
    return ElevatedButton(
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.lightBlue),
      ),
      onPressed: () {
        if (state.activeStep < state.upperBound) {
          context.read<CompleteProfileBloc>().add(NextStep());
        }
      },
      child: const Text(
        'Siguiente',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget previousButton(BuildContext context, CompleteProfileState state) {
    return ElevatedButton(
      onPressed: () {
        if (state.activeStep > 0) {
          context.read<CompleteProfileBloc>().add(PreviousStep());
        }
      },
      child: const Text('Atras'),
    );
  }

  Widget header(int activeStep) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              headerText(activeStep),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String headerText(int activeStep) {
    switch (activeStep) {
      case 0:
        return 'Datos Personales';
      case 1:
        return 'Estudios y Hobbies';
      case 2:
        return 'Foto de perfil';
      default:
        return '';
    }
  }
}