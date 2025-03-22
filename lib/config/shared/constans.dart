class CommonConstant {
  
  // LOGIN FORM ERRORS MESSAGES:
  static String BAD_CREDENTIALS = "Nombre de usuario o contraseña incorrectas";
  static String USER_LOCKED = "Usuario bloqueado. Para poder iniciar sesion debe primero desbloquear su usuario";
  static String EMPTY_USERNAME_FIELD_ERROR = "El nombre de usuario no puede ser vacio";
  static String EMPTY_PASSWORD_FIELD_ERROR = "La contraseña no puede ser vacia";
  static String LOGIN_SUCCESS_MESSAGE = "Bienvenido a la app";
  static String LOGIN_ERROR_MESSAGE = "Error al iniciar sesion. Por favor intentelo de nuevo";

  // REGISTER FORM ERRORS MESSAGES:
  static String NOT_VALID_PASSWORD = "Contraseña no valida. Establesca una contraseña mas segura";  
  static String REGISTER_SUCCESS_MESSAGE = "Te has registrado con exito!";
  static String EMAIL_FIELD_ERROR = "Email no valido";
  static String EMPTY_FIELD_ERROR = "Este campo no puede estar vacio";

  // FORGOT-PASSWORD FORM ERRORS MESSAGES 
  static String LEGEND_FORGOR_PASSWORD_SCREEN = "Por favor ingrese su email. Recibira un correo electronico con un codigo para poder modificar su contraseña";
  static String FORGOT_PASSWORD_SUCCESS_LEGEND = "El codigo se ha enviado correctamente al email ingresado";
  static String LEGEND_RESET_PASSWORD_SCREEN = "Revise su email e ingrese el codigo de verificacion";
  static String FIELD_CODE_RESET_PASSWORD_ERROR = "El codigo de verificacion no puede ser nulo";
  static String RESET_PASSWORD_SUCCESS_SCEEN = "La contraseña se ha modificado correctamente!";
  static String FORGOT_PASSWORD_ERROR_MESSAGE = "Error: el email es requerido";
  static String RESET_PASSWORD_INVALID_FORM = "Error: revisar los campos del formulario";

  // COMPLETE PROFILE FORM ERRORS MESSAGES:
  static String FIRST_NAME_ERROR = "El nombre no puede estar vacio!";
  static String FIRST_NAME_ERROR_NUMBER = "El nombre no puede contener caracteres numericos";
  static String LAST_NAME_ERROR = "El apellido no puede estar vacio!";
  static String LAST_NAME_ERROR_NUMBER = "El apellido no puede contener caracteres numericos";
  static String TELEPHONE_NUMBER_ERROR_LETTERS = "El numero de telefono no puede contener caracteres alfabeticos";
  static String TELEPHONE_NUMBER_ERROR = "El numero de telefono no puede estar vacio";
  static String LOCATION_NOT_VALID = "La ubicacion seleccionada no es valida! Por favor elige otra";
  static String TO_USER_NOT_FOUND = "El usuario al que le envias la solicitud no existe";
  static String REQUEST_HAS_ALREADY_BEEN_SUBMITTED = "Ya le enviaste una solicitud a este usuario";
  static String ALREADY_FRIENDS = "Ya son amigos!";
  static String NOT_EXISTS_FRIEND_REQUEST = "No existe una solicitud de amistad entre estos dos usuarios";

}