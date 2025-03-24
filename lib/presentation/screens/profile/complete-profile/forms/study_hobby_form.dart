import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techconnect_mobile/presentation/blocs/profile/complete-profile/complete_profile_bloc.dart';
import 'package:techconnect_mobile/presentation/widgets/custom_form_input.dart';

class StudyHobbyForm extends StatelessWidget {
  const StudyHobbyForm({super.key});

  @override
  Widget build(BuildContext context) {
    final completeProfileState = context.read<CompleteProfileBloc>().state;

    return Container(
      alignment: AlignmentDirectional.topCenter,
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            const SizedBox(height: 10),

            /* Study Field */
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: CustomFormInput(
                hintText: 'Ingeniería en Sistemas',
                labelText: 'Estudios',
                prefixIcon: Icons.school_outlined,
                initialValue: completeProfileState.study,
                errorMessage: null,
                onChanged: (value) => context.read<CompleteProfileBloc>().add(OnChangedInputField(value, 'study')),
              ),
            ),

            const SizedBox(height: 15),

            /* Hobby Field */
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Ejemplo: Leer, Jugar Videojuegos, etc.',
                  labelText: 'Hobbies',
                  prefixIcon: const Icon(Icons.sports_esports, color: Colors.lightBlue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.lightBlue),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue, width: 2),
                  ),
                ),
                initialValue: completeProfileState.hobby,
                onChanged: (value) => context.read<CompleteProfileBloc>().add(OnChangedInputField(value, 'hobby')),
              ),
            )
          ],
        ),
      ),
    );
  }
}