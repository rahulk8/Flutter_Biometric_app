import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key});

  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isSpoofed = false;
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    _detectEmulatorOrSpoofing();
  }

  Future<void> _detectEmulatorOrSpoofing() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (!androidInfo.isPhysicalDevice) {
      setState(() => _isSpoofed = true);
      _showSnackbar('Security Alert: Emulator detected');
    }
  }

  Future<void> _handlePinLogin() async {
    if (_isSpoofed) {
      _showSnackbar('Login blocked on emulator or rooted device');
      return;
    }

    final pin = _pinController.text;
    if (pin == '1234') {
      _attempts = 0;
      await _storage.write(key: 'auth_token', value: 'pin_token');
      _showSnackbar('PIN Login successful!');
    } else {
      _attempts++;
      if (_attempts >= 3) {
        _showSnackbar('Too many failed attempts for PIN. Try again later.');
      } else {
        _showSnackbar('Incorrect PIN. Try again.');
      }
    }
  }

  void _showSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PIN Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter your secure PIN', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'PIN',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handlePinLogin,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
