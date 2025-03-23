part of 'complete_profile_bloc.dart';

class CompleteProfileState extends Equatable {

  final int activeStep;
  final int upperBound;
  final bool isLoading;
  final PageController pageController;
  final String userEmail;

  const CompleteProfileState({
    required this.activeStep, 
    required this.upperBound, 
    required this.isLoading, 
    required this.pageController, 
    required this.userEmail});

  // Estado inicial
  factory CompleteProfileState.initial(String email) {
    return CompleteProfileState(
      activeStep: 0,
      upperBound: 2, // Número máximo de pasos (0, 1, 2)
      isLoading: false,
      pageController: PageController(initialPage: 0),
      userEmail: email,
    );
  }

  // Copia el estado actual con cambios
  CompleteProfileState copyWith({
    int? activeStep,
    int? upperBound,
    bool? isLoading,
    PageController? pageController,
    String? userEmail,
  }) {
    return CompleteProfileState(
      activeStep: activeStep ?? this.activeStep,
      upperBound: upperBound ?? this.upperBound,
      isLoading: isLoading ?? this.isLoading,
      pageController: pageController ?? this.pageController,
      userEmail: userEmail ?? this.userEmail,
    );
  }

  @override
  List<Object?> get props => [activeStep, upperBound, isLoading, pageController, userEmail];

}

