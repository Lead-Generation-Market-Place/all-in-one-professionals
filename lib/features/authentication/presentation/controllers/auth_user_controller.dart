import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/web.dart';
import 'package:yelpax_pro/features/authentication/models/userModel.dart';

import 'package:yelpax_pro/shared/services/api_service.dart';

class AuthUserController extends ChangeNotifier {
  final ApiService apiService;

  AuthUserController(this.apiService);

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Reactive variables
  final ValueNotifier<bool> isAuthenticated = ValueNotifier<bool>(false);
  final ValueNotifier<UserModel?> currentUser = ValueNotifier<UserModel?>(null);
  final authUserId = ValueNotifier<String?>(null);

  /// UI state
  bool isLoading = false;
  String? errorMessage;

  /// Login method
  Future<void> login({
    required String email,
    required String password,
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      Logger().d('Login request initiated');

      final response = await apiService.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        // Remove the 'success' check since your API doesn't return it
        // Just check if we have user data and tokens
        if (responseData['user'] != null && responseData['tokens'] != null) {
          final userJson = responseData['user'];
          final tokens = responseData['tokens'];
          final token = tokens['accessToken'];
          final refreshToken = tokens['refreshToken'];

          // Store token and auth state securely
          await _storage.write(key: 'auth_token', value: token);
          await _storage.write(key: 'refresh_token', value: refreshToken);
          await _storage.write(key: 'isAuthenticated', value: 'true');

          // Set tokens in ApiService
          apiService.setTokens(
            accessToken: token,
            refreshToken: refreshToken,
            // expiresIn: expiresIn, // Remove if not available
          );

          // Parse user
          final user = UserModel.fromJson(userJson);
          currentUser.value = user;
          isAuthenticated.value = true;
          authUserId.value = user.id;
          await getProfessionalIdByUserId();

          Logger().i('User logged in: ${user.email}');
          onSuccess();
          return;
        } else {
          errorMessage = 'Invalid response format from server.';
        }
      } else {
        errorMessage = 'Login failed with status code ${response.statusCode}.';
      }

      onFailure();
    } catch (e) {
      Logger().e('Login error: $e');
      errorMessage = 'An error occurred. Please try again.';
      onFailure();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Check auth status - UPDATED
  Future<void> checkAuthStatus() async {
    final authValue = await _storage.read(key: 'isAuthenticated');
    final token = await _storage.read(key: 'auth_token');
    final refreshToken = await _storage.read(key: 'refresh_token'); // Add this

    Logger().d('Auth stored: $authValue, Token: $token');

    if (authValue == 'true' && token != null) {
      // Set tokens in ApiService - IMPORTANT!
      apiService.setTokens(
        accessToken: token,
        refreshToken: refreshToken,
        // expiresIn might not be available here, you might need to store it too
      );

      isAuthenticated.value = true;

      // Optional: fetch user profile again using token
      try {
        final response = await apiService.get('/auth/me');
        if (response.statusCode == 200) {
          final user = UserModel.fromJson(response.data['user']);
          currentUser.value = user;
          Logger().i('User restored: ${user.email}');
        }
      } catch (e) {
        Logger().e('Failed to restore user: $e');
      }

      // Ensure professional ID is loaded after restoring auth
      await getProfessionalIdByUserId();
    } else {
      isAuthenticated.value = false;
      currentUser.value = null;
      apiService.clearTokens(); // Clear tokens if not authenticated
    }

    notifyListeners();
  }

  /// Logout method - UPDATED
  Future<void> logout() async {
    isAuthenticated.value = false;
    currentUser.value = null;

    // Clear tokens from ApiService
    apiService.clearTokens();

    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'refresh_token'); // Add this
    await _storage.delete(key: 'isAuthenticated');

    Logger().i('User logged out');
    notifyListeners();
  }

  final professionalId = ValueNotifier<String?>(null);

  Future<void> getProfessionalIdByUserId() async {
    try {
      final response = await apiService.get('/professionals/pro');

      if (response.statusCode == 200) {
        final data = response.data;

        // Debug: Print the entire response to see the structure
        Logger().d('Professional API Response: $data');

        // The backend returns the entire professional object with '_id' field
        if (data != null && data['_id'] != null) {
          professionalId.value = data['_id'];
          Logger().i('Professional ID fetched: ${data['_id']}');
        } else {
          professionalId.value = null;
          Logger().w('Professional data exists but no _id found in response.');
        }
      } else if (response.statusCode == 404) {
        professionalId.value = null;
        Logger().w('No professional profile found for this user.');
      } else {
        professionalId.value = null;
        Logger().e(
          'Failed to fetch professional: ${response.statusCode} - ${response.data}',
        );
      }
    } catch (e) {
      professionalId.value = null;
      Logger().e('Failed to get professional ID: $e');
    }
  }
}
