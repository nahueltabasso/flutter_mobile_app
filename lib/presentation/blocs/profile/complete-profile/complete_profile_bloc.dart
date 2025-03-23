import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'complete_profile_event.dart';
part 'complete_profile_state.dart';
class CompleteProfileBloc extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  CompleteProfileBloc(String userEmail)
      : super(CompleteProfileState.initial(userEmail)) {
    on<StepChanged>((event, emit) {
      emit(state.copyWith(activeStep: event.step));
      state.pageController.jumpToPage(event.step);
    });

    on<NextStep>((event, emit) {
      if (state.activeStep < state.upperBound) {
        emit(state.copyWith(activeStep: state.activeStep + 1));
        state.pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    on<PreviousStep>((event, emit) {
      if (state.activeStep > 0) {
        emit(state.copyWith(activeStep: state.activeStep - 1));
        state.pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    on<SaveProfile>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      // Simula una operación de guardado
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(isLoading: false));
    });
  }
}
