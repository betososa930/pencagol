class AppStrings {
  // Autenticación - Errores
  static const String loginCanceled = 'Inicio de sesión cancelado';
  static const String appleSignInNotAvailable =
      'Apple Sign-In solo está disponible en iOS y macOS';
  static const String weakPassword =
      'La contraseña es muy débil. Usa una más fuerte.';
  static const String emailAlreadyInUse = 'Este email ya está registrado.';
  static const String invalidEmail = 'El formato del email no es válido.';
  static const String registerError = 'Error al registrarse';
  static const String unexpectedError = 'Error inesperado';
  static const String userNotFound = 'Usuario no encontrado.';
  static const String wrongPassword = 'Contraseña incorrecta.';
  static const String userDisabled = 'Esta cuenta ha sido deshabilitada.';
  static const String loginError = 'Error al iniciar sesión';
  static const String passwordResetError = 'No existe usuario con este email.';

  // Validación de formularios
  static const String emptyUsername = 'Por favor ingresa tu usuario';
  static const String emptyPassword = 'Por favor ingresa tu contraseña';
  static const String emptyEmail = 'Por favor ingresa tu email';
  static const String emptyFullName = 'Por favor ingresa tu nombre';
  static const String shortName = 'El nombre debe tener al menos 3 caracteres';
  static const String emptyConfirmPassword = 'Por favor confirma tu contraseña';
  static const String passwordMismatch = 'Las contraseñas no coinciden';
  static const String shortPassword =
      'La contraseña debe tener al menos 6 caracteres';

  // Pantalla de Login
  static const String welcome = 'Bienvenido';
  static const String chooseLoginMethod = 'Elige tu forma de iniciar sesión';
  static const String googleButtonLabel = 'Google';
  static const String appleButtonLabel = 'Apple ID';
  static const String loginButton = 'Iniciar Sesión';
  static const String forgotPassword = '¿Olvidaste tu contraseña?';
  static const String noAccount = '¿No tienes cuenta? Regístrate aquí';
  static const String usernameLabel = 'Usuario';
  static const String usernameHint = 'Ingresa tu usuario';
  static const String passwordLabel = 'Contraseña';
  static const String passwordHint = 'Ingresa tu contraseña';
  static const String rememberUser = 'Recordar usuario';

  // Pantalla de Registro
  static const String createAccount = 'Crear Cuenta';
  static const String joinPencaGol = 'Únete a PencaGol';
  static const String completeForm = 'Completa el formulario para registrarte';
  static const String fullNameLabel = 'Nombre Completo';
  static const String fullNameHint = 'Ingresa tu nombre';
  static const String emailLabel = 'Correo Electrónico';
  static const String emailHint = 'ejemplo@email.com';
  static const String passwordConfirmLabel = 'Confirmar Contraseña';
  static const String passwordConfirmHint = 'Repite tu contraseña';
  static const String registerButton = 'Registrarse';
  static const String registerSuccess = 'Registro exitoso. ¡Bienvenido!';
  static const String hasAccount = '¿Ya tienes cuenta? Inicia sesión aquí';

  // Recuperación de contraseña
  static const String resetPassword = 'Recuperar Contraseña';
  static const String resetPasswordMessage =
      'Ingresa tu email y recibirás un enlace para restablecer tu contraseña.';
  static const String emailResetHint = 'Correo Electrónico';
  static const String sendButton = 'Enviar';
  static const String cancelButton = 'Cancelar';
  static const String resetEmailSent =
      'Se envió un enlace de recuperación a tu email. Revisa tu bandeja.';
  static const String forgotPasswordError = 'Error: ';

  // Splash Screen
  static const String appTitle = 'PencaGol';
}
