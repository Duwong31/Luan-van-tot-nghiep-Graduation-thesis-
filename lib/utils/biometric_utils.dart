import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// Utility class for biometric authentication (Fingerprint/Face ID)
class BiometricUtils {
  static final LocalAuthentication _auth = LocalAuthentication();
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // Storage keys
  static const String _keyRefreshToken = 'refresh_token_secure';
  static const String _keyBiometricEnabled = 'biometric_enabled';

  /// Check if device supports biometric authentication
  static Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      print('Error checking biometric support: $e');
      return false;
    }
  }

  /// Get available biometric types (fingerprint, face, etc.)
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Check if device is enrolled with biometrics
  static Future<bool> isDeviceSupported() async {
    try {
      final canCheck = await canCheckBiometrics();
      if (!canCheck) return false;

      final availableBiometrics = await getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (e) {
      print('Error checking device support: $e');
      return false;
    }
  }

  /// Authenticate user with biometrics
  static Future<bool> authenticate({
    required String reason,
  }) async {
    try {
      final canCheck = await canCheckBiometrics();
      if (!canCheck) {
        print('Device does not support biometric authentication');
        return false;
      }

      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );
    } catch (e) {
      print('Error during biometric authentication: $e');
      return false;
    }
  }

  /// Enable biometric login and save refresh token securely
  static Future<void> enableBiometricLogin(String refreshToken) async {
    try {
      await _secureStorage.write(
        key: _keyRefreshToken,
        value: refreshToken,
      );
      await _secureStorage.write(
        key: _keyBiometricEnabled,
        value: 'true',
      );
    } catch (e) {
      throw Exception('Failed to enable biometric login');
    }
  }

  /// Disable biometric login and remove stored data
  static Future<void> disableBiometricLogin() async {
    try {
      await _secureStorage.delete(key: _keyRefreshToken);
      await _secureStorage.delete(key: _keyBiometricEnabled);
    } catch (e) {
      throw Exception('Failed to disable biometric login');
    }
  }

  /// Check if biometric login is enabled
  static Future<bool> isBiometricEnabled() async {
    try {
      final enabled = await _secureStorage.read(key: _keyBiometricEnabled);
      return enabled == 'true';
    } catch (e) {
      return false;
    }
  }

  /// Get securely stored refresh token
  static Future<String?> getSecureRefreshToken() async {
    try {
      return await _secureStorage.read(key: _keyRefreshToken);
    } catch (e) {
      return null;
    }
  }

  /// Update refresh token in secure storage (when refreshed)
  static Future<void> updateSecureRefreshToken(String newRefreshToken) async {
    final isEnabled = await isBiometricEnabled();
    if (isEnabled) {
      await _secureStorage.write(
        key: _keyRefreshToken,
        value: newRefreshToken,
      );
    }
  }

  /// Get human-readable biometric type name
  static String getBiometricTypeName(List<BiometricType> types) {
    if (types.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (types.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    } else if (types.contains(BiometricType.iris)) {
      return 'Iris';
    } else if (types.contains(BiometricType.strong) ||
        types.contains(BiometricType.weak)) {
      return 'Biometric';
    }
    return 'Biometric';
  }

  /// Clear all biometric data (for logout)
  static Future<void> clearAll() async {
    await disableBiometricLogin();
  }
}
