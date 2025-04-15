import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:techconnect_mobile/models/http_error_dto.dart';
import 'package:techconnect_mobile/models/user_profile_dto.dart';
import 'package:techconnect_mobile/presentation/screens/profile/complete-profile/forms/location_form.dart';
import 'package:techconnect_mobile/presentation/widgets/profiles/inputs/first_name_input.dart';
import 'package:techconnect_mobile/presentation/widgets/profiles/inputs/last_name_input.dart';
import 'package:techconnect_mobile/presentation/widgets/profiles/inputs/phone_number_input.dart';
import 'package:techconnect_mobile/services/auth_service.dart';
import 'package:techconnect_mobile/services/dialog_service.dart';
import 'package:techconnect_mobile/services/user_profile_service.dart';

part 'complete_profile_event.dart';
part 'complete_profile_state.dart';

class CompleteProfileBloc extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  CompleteProfileBloc() : super(CompleteProfileState.initial()) {
    on<StepChanged>((event, emit) => _onStepChanged(event, emit));
    on<NextStep>((event, emit) => _onNextStep(event, emit));
    on<PreviousStep>((event, emit) => _onPreviousStep(event, emit));
    on<SaveProfile>((event, emit) => _onSaveProfile(event, emit));
    on<OnChangedInputField>((event, emit) => _onChangetInputField(event, emit));
    on<SetUserEmail>((event, emit) => _setUserEmail(event, emit));  
    on<OnChangedBirthDate>((event, emit) => _onChangedBirthDate(event, emit));
    on<SetProfilePhoto>((event, emit) => _setProfilePhoto(event, emit));
  }

  void _onStepChanged(StepChanged event, Emitter<CompleteProfileState> emit) {
    emit(state.copyWith(activeStep: event.step));
    state.pageController.jumpToPage(event.step);
  }

  void _onNextStep(NextStep event, Emitter<CompleteProfileState> emit) async {
    if (state.activeStep < state.upperBound) {
      emit(state.copyWith(activeStep: state.activeStep + 1));
      state.pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPreviousStep(PreviousStep event, Emitter<CompleteProfileState> emit) {
    if (state.activeStep > 0) {
      emit(state.copyWith(activeStep: state.activeStep - 1));
      state.pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _onSaveProfile(SaveProfile event, Emitter<CompleteProfileState> emit) async {
    emit(state.copyWith(isLoading: true));

    final formValid = Formz.validate([state.firstNameInput, state.lastNameInput, state.phoneNumberInput]);
    if (!formValid || state.profilePhoto == null || state.personalStatus.isEmpty || state.birthDate == null) {
      DialogService.showErrorDialogAlert(event.context, 'Por favor, complete todos los campos');
      emit(state.copyWith(isLoading: false));
      return;
    }

    try {
      final userDto = event.context.read<AuthService>().userDto;

      Map<String, dynamic> userProfileFormData = {
        'firstName': state.firstNameInput.value,
        'lastName': state.lastNameInput.value,
        'phoneNumber': state.phoneNumberInput.value,
        'personalStatus': state.personalStatus,
        'birthDate': state.birthDate.toString(),
        'email': state.userEmail,
        'study': state.study,
        'hobby': state.hobby,
        'userId': userDto!.id,
        'activeProfile': true,
        'verifiedProfile': false,
      };

      final userProfileService = event.context.read<UserProfileService>();

      final response = await userProfileService.saveProfile(userProfileFormData, state.profilePhoto!, event.context);
      if (response != null) {
        if (response is UserProfileDto) {
          emit(state.copyWith(isLoading: false));
          Navigator.push(event.context, MaterialPageRoute(builder: (context) => const LocationForm()));
          DialogService.showSuccessDialogAlert(event.context, 'Perfil creado correctamente', '', null);
        } 

        if (response is HttpErrorDto) {
          emit(state.copyWith(isLoading: false));
          DialogService.showErrorDialogAlert(event.context, response.message);
        }
      } 
    } catch (e) {
      print('Error: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  void _setUserEmail(SetUserEmail event, Emitter<CompleteProfileState> emit) {
    final authService = event.context.read<AuthService>();
    emit(state.copyWith(userEmail: authService.userDto!.email));
  }

  void _onChangetInputField(OnChangedInputField event, Emitter<CompleteProfileState> emit) {
    switch (event.field) {
      case 'firstName':
        final firstName = FirstNameInput.dirty(value: event.value);
        emit(state.copyWith(
          firstNameInput: firstName,
        ));
        break;

      case 'lastName':
        final lastName = LastNameInput.dirty(value: event.value);
        emit(state.copyWith(
          lastNameInput: lastName,
        ));
        break;

      case 'phoneNumber':
        final phoneNumber = PhoneNumberInput.dirty(value: event.value);
        emit(state.copyWith(
          phoneNumberInput: phoneNumber,
        ));
        break;

      case 'personalStatus':
        emit(state.copyWith(
          personalStatus: event.value,
        ));
        break;

      case 'email':
        emit(state.copyWith(
          userEmail: event.value,
        ));
        break;

      case 'study':
        emit(state.copyWith(
          study: event.value,
        ));
        break;

      case 'hobby':
        emit(state.copyWith(
          hobby: event.value,
        ));
        break;

      default:
        break;
    }
  }

  void _onChangedBirthDate(OnChangedBirthDate event, Emitter<CompleteProfileState> emit) {
    emit(state.copyWith(birthDate: event.date));
  }

  void _setProfilePhoto(SetProfilePhoto event, Emitter<CompleteProfileState> emit) {
    emit(state.copyWith(profilePhoto: event.photo));
  }
}
