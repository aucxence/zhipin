part of 'firestore.dart';

String _$parseAuthError(error) {
  String errorMessage = '';
  switch (error.code) {
    case "auth/claims-too-large":
      errorMessage =
          "The claims payload provided to setCustomUserClaims() exceeds the maximum allowed size of 1000 bytes.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/email-already-exists":
      errorMessage =
          "The provided email is already in use by an existing user. Each user must have a unique email.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/id-token-expired":
      errorMessage = "The provided Firebase ID token is expired.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/id-token-revoked":
      errorMessage = "The Firebase ID token has been revoked.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/insufficient-permission":
      errorMessage =
          "The credential used to initialize the Admin SDK has insufficient permission to access the requested Authentication resource. Refer to Set up a Firebase project for documentation on how to generate a credential with appropriate permissions and use it to authenticate the Admin SDKs.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/internal-error":
      errorMessage =
          "The Authentication server encountered an unexpected error while trying to process the request. The error message should contain the response from the Authentication server containing additional information. If the error persists, please report the problem to our Bug Report support channel.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/invalid-argument":
      errorMessage =
          "An invalid argument was provided to an Authentication method. The error message should contain additional information.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/invalid-claims":
      errorMessage =
          "The custom claim attributes provided to setCustomUserClaims() are invalid.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/invalid-continue-uri":
      errorMessage = "The continue URL must be a valid URL string.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/invalid-creation-time":
      errorMessage = "The creation time must be a valid UTC date string.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/invalid-credential":
      errorMessage =
          "The credential used to authenticate the Admin SDKs cannot be used to perform the desired action.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/invalid-disabled-field":
      errorMessage =
          "The provided value for the disabled user property is invalid. It must be a boolean.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/invalid-display-name":
      errorMessage =
          "The provided value for the displayName user property is invalid. It must be a non-empty string.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/invalid-dynamic-link-domain":
      errorMessage =
          "The provided dynamic link domain is not configured or authorized for the current project.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/invalid-email":
      errorMessage =
          "The provided value for the email user property is invalid. It must be a string email address.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/invalid-email-verified":
      errorMessage =
          "The provided value for the emailVerified user property is invalid. It must be a boolean.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/invalid-hash-algorithm":
      errorMessage =
          "The hash algorithm must match one of the strings in the list of supported algorithms.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/invalid-hash-block-size":
      errorMessage = "The hash block size must be a valid number.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/invalid-credential":
      errorMessage =
          "The credential used to authenticate the Admin SDKs cannot be used to perform the desired action.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "auth/invalid-credential":
      errorMessage =
          "The credential used to authenticate the Admin SDKs cannot be used to perform the desired action.";
      // errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "ERROR_INVALID_EMAIL":
      errorMessage = "Your email address appears to be malformed.";
      errorMessage = "L'adresse mail saisie est incorrecte.";
      break;
    case "ERROR_WRONG_PASSWORD":
      errorMessage = "Your password is wrong.";
      errorMessage = "Paramètres de connexion erronés";
      break;
    case "ERROR_USER_NOT_FOUND":
      errorMessage = "User with this email doesn't exist.";
      errorMessage = "Paramètres de connexion erronés";
      break;
    case "ERROR_USER_DISABLED":
      errorMessage = "User with this email has been disabled.";
      errorMessage = "Utilisateur bloqué";
      break;
    case "ERROR_TOO_MANY_REQUESTS":
      errorMessage = "Too many requests. Try again later.";
      errorMessage = "Réessayez plus tard";
      break;
    case "ERROR_OPERATION_NOT_ALLOWED":
      errorMessage = "Signing in with Email and Password is not enabled.";
      errorMessage = "Ce mode de connexion n'est pas autorisé";
      break;
    default:
      errorMessage = "An undefined Error happened.";
      errorMessage = "Une erreur inconnue s'est manifestée";
  }

  return errorMessage;
}
