part of 'complete_profile_bloc.dart';

class CompleteProfileState extends Equatable {

  final int activeStep;
  final int upperBound;
  final bool isLoading;
  final bool isValid;
  final PageController pageController;
  final String userEmail;
  final FirstNameInput firstNameInput;
  final LastNameInput lastNameInput;
  final PhoneNumberInput phoneNumberInput;
  final String personalStatus;
  final DateTime birthDate;
  final String study;
  final String hobby;
  final File? profilePhoto;

  const CompleteProfileState({
    required this.activeStep, 
    required this.upperBound, 
    required this.isLoading,
    required this.isValid, 
    required this.pageController, 
    required this.userEmail,
    required this.firstNameInput,
    required this.lastNameInput,
    required this.phoneNumberInput,
    required this.personalStatus,
    required this.birthDate,
    required this.study,  
    required this.hobby,
    this.profilePhoto
  });

  // Initial state
  factory CompleteProfileState.initial() {
    return CompleteProfileState(
      activeStep: 0,
      upperBound: 2,
      isLoading: false,
      isValid: false,
      pageController: PageController(initialPage: 0),
      userEmail: '',
      firstNameInput: const FirstNameInput.pure(),
      lastNameInput: const LastNameInput.pure(),
      phoneNumberInput: const PhoneNumberInput.pure(),  
      personalStatus: 'Soltero/a',
      birthDate: DateTime.now(),
      study: '',
      hobby: '',
      profilePhoto: null
    );
  }

  CompleteProfileState copyWith({
    int? activeStep,
    int? upperBound,
    bool? isLoading,
    bool? isValid,
    PageController? pageController,
    String? userEmail,
    FirstNameInput? firstNameInput,
    LastNameInput? lastNameInput, 
    PhoneNumberInput? phoneNumberInput,
    String? personalStatus,
    DateTime? birthDate,
    String? study,
    String? hobby,
    File? profilePhoto
  }) {
    return CompleteProfileState(
      activeStep: activeStep ?? this.activeStep,
      upperBound: upperBound ?? this.upperBound,
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid,
      pageController: pageController ?? this.pageController,
      userEmail: userEmail ?? this.userEmail,
      firstNameInput: firstNameInput ?? this.firstNameInput,
      lastNameInput: lastNameInput ?? this.lastNameInput,
      phoneNumberInput: phoneNumberInput ?? this.phoneNumberInput,
      personalStatus: personalStatus ?? this.personalStatus,
      birthDate: birthDate ?? this.birthDate,
      study: study ?? this.study, 
      hobby: hobby ?? this.hobby, 
      profilePhoto: profilePhoto ?? this.profilePhoto 
    );
  }

  @override
  List<Object?> get props => [activeStep, 
                              upperBound, 
                              isLoading, 
                              isValid,
                              pageController, 
                              userEmail,
                              firstNameInput,
                              lastNameInput,
                              phoneNumberInput,
                              personalStatus,
                              birthDate,
                              study,  
                              hobby,
                              profilePhoto];

}

  // const CompleteProfileState({
  //   required this.activeStep = 0, 
  //   required this.upperBound = 2, 
  //   required this.isLoading = false, 
  //   required this.pageController = PageController(initialPage: 0), 
  //   required this.userEmail});