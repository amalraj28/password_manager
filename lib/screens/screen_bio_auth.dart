import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

class BiometricAuthScreen {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  static authenticate() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuth.authenticate(
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Use fingerprint to authenticate',
            biometricSuccess: 'Authentication Successful',
            cancelButton: 'No thanks',
            goToSettingsButton: 'Settings',
            goToSettingsDescription: 'Get Lost'
          )
        ],
        localizedReason: 'Authenticate to access the app',
        options: const AuthenticationOptions(
          sensitiveTransaction: false,
          useErrorDialogs: true,
          stickyAuth: true, // Prevents biometric prompt from closing on Android
          biometricOnly: true,
        ),
      );
    } catch (e) {
      // if (e.code == '' )
    }

    return isAuthenticated;
  }
}
