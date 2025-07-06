import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'pin_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  int? _storedBiometricCount;

  Future<void> _authenticateWithBiometrics() async {
    try {
      final bool isSupported = await _auth.isDeviceSupported();
      final bool canCheck = await _auth.canCheckBiometrics;

      if (!isSupported || !canCheck) {
        _navigateToPin('Biometric not available. Try PIN instead.');
        return;
      }

      // Revalidate biometric setup
      final List<BiometricType> currentBiometrics = await _auth.getAvailableBiometrics();
      final int currentCount = currentBiometrics.length;

      final storedCountStr = await _storage.read(key: 'biometric_count');
      _storedBiometricCount = storedCountStr != null ? int.tryParse(storedCountStr) : null;

      if (_storedBiometricCount != null && _storedBiometricCount != currentCount) {
        await _storage.delete(key: 'auth_token');
        await _storage.write(key: 'biometric_count', value: currentCount.toString());
        _navigateToPin('Biometric setup changed. Please reauthenticate.');
        return;
      }

      if (_storedBiometricCount == null) {
        await _storage.write(key: 'biometric_count', value: currentCount.toString());
      }

      final bool authenticated = await _auth.authenticate(
        localizedReason: 'Authenticate to proceed',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (!mounted) return;

      if (authenticated) {
        await _storage.write(key: 'auth_token', value: 'biometric_token');
        _showSnackbar('Login successful via fingerprint!');
      } else {
        _navigateToPin('Biometric failed. Try PIN.');
      }
    } on PlatformException catch (e) {
      debugPrint('Biometric error: ${e.code} - ${e.message}');
      final errorMsg = e.code == 'LockedOut'
          ? 'Too many failed attempts for fingerprint. Try again after 30 seconds.'
          : 'Biometric error: ${e.message}';
      _navigateToPin(errorMsg);
    } catch (e) {
      debugPrint('Unexpected error: $e');
      _navigateToPin('An unexpected error occurred. Try PIN instead.');
    }
  }

  void _navigateToPin(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PinLoginScreen()),
    );
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biometric Login')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.fingerprint),
          label: const Text('Use your fingerprint to login in'),
          onPressed: _authenticateWithBiometrics,
        ),
      ),
    );
  }
}
