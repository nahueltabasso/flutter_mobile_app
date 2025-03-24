import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:techconnect_mobile/presentation/blocs/profile/complete-profile/complete_profile_bloc.dart';
import 'package:techconnect_mobile/presentation/widgets/custom_form_input.dart';

class PersonalDataForm extends StatelessWidget {
  const PersonalDataForm({super.key});

  Future<void> _selectBirthDate(BuildContext context, TextEditingController dateController) async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
                primary: Colors.lightBlue,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
                ),
            dialogBackgroundColor:Colors.blue[900],
          ),
          child: child!,
        );
      },
    );

    if (_picked != null) {
      DateTime today = DateTime.now();
      DateTime minDate = DateTime(today.year -16, today.month, today.day);

      if (_picked.isBefore(minDate)) {
        // ignore: use_build_context_synchronously
        // final completeProfileState = context.read<CompleteProfileBloc>().state;
        String formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(_picked);
        formattedDate = formattedDate.replaceFirst('T', ' ');
        DateTime dateTime = DateTime.parse(formattedDate);
        print("CUMPLE -- ${_picked.toString().split(" ")[0].toString()}");
        dateController.text = _picked.toString().split(" ")[0].toString();
        context.read<CompleteProfileBloc>().add(OnChangedBirthDate(dateTime));
        return;
      }
      // Error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes ser mayor a 16 años'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final completeProfileState = context.read<CompleteProfileBloc>().state;
    final emailController = TextEditingController(text: completeProfileState.userEmail);
    final dateController = TextEditingController(); 
    return Container(
      alignment: AlignmentDirectional.topCenter,
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            const SizedBox(height: 10),

            /* First Name Field */
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: CustomFormInput(
                hintText: 'Joe',
                labelText: 'Nombre',
                prefixIcon: Icons.person_add_alt_1,
                initialValue: completeProfileState.firstNameInput.value,
                errorMessage: completeProfileState.firstNameInput.errorMessage,
                onChanged: (value) => context.read<CompleteProfileBloc>().add(OnChangedInputField(value, 'firstName')),
              ),
            ),

            const SizedBox(height: 15),

            /* Last Name Field */
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: CustomFormInput(
                hintText: 'Doe',
                labelText: 'Apellido',
                prefixIcon: Icons.person_add_alt_1,
                initialValue: completeProfileState.lastNameInput.value,
                errorMessage: completeProfileState.lastNameInput.errorMessage,
                onChanged: (value) => context.read<CompleteProfileBloc>().add(OnChangedInputField(value, 'lastName')),  
              ),
            ),

            const SizedBox(height: 15),

            /* Email Field */
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: CustomFormInput(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'joe@example.com',
                labelText: 'Email',
                prefixIcon: Icons.email_rounded,
                errorMessage: null,
                onChanged: (value) => context.read<CompleteProfileBloc>().add(OnChangedInputField(value, 'email')),
                enabled: false,
              ),
            ),

            const SizedBox(height: 15),

            /* Phone Field */
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: CustomFormInput(
                keyboardType: TextInputType.phone,
                labelText: 'Telefono',
                hintText: '+54 444444',
                prefixIcon: Icons.phone,
                initialValue: completeProfileState.phoneNumberInput.value,
                errorMessage: completeProfileState.phoneNumberInput.errorMessage,
                onChanged: (value) => context.read<CompleteProfileBloc>().add(OnChangedInputField(value, 'phoneNumber')),
              ),
            ),

            const SizedBox(height: 15),

            /* Date of Birth Field */
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: TextFormField(
                autocorrect: false,
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  hintText: '01/01/2000',
                  prefixIcon: const Icon(Icons.calendar_month_rounded, color: Colors.lightBlue),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue, width: 2),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  _selectBirthDate(context, dateController);
                },
              ),
            ),

            const SizedBox(height: 15),

            /* Personal status Field */
            Padding(
              padding:  const EdgeInsets.only(left: 20.0, right: 20.0),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: 'Estado Sentimental',
                  hintText: 'Estado Sentimental',
                  prefixIcon: const Icon(Icons.sentiment_satisfied_alt_outlined, color: Colors.lightBlue),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlue, width: 2),
                  ),
                ),
                value: completeProfileState.personalStatus,
                items: const [
                  DropdownMenuItem(value: "Soltero/a", child: Text("Soltero/a")),
                  DropdownMenuItem(value: "Casado/a", child: Text("Casado/a")),
                  DropdownMenuItem(value: "Novio/a", child: Text("Novio/a")),
                  DropdownMenuItem(value: "En una relacion", child: Text("En una relacion")),
                ],
                onChanged: (value) => context.read<CompleteProfileBloc>().add(OnChangedInputField(value!, 'personalStatus')),
              ),
            )

          ],
        ),
      ),
    );
  }
}