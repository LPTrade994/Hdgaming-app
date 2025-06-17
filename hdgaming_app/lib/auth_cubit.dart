import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required String baseUrl,
    FlutterSecureStorage? storage,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _storage = storage ?? const FlutterSecureStorage(),
        _client = httpClient ?? http.Client(),
        super(const AuthState.unknown());

  final String _baseUrl;
  final FlutterSecureStorage _storage;
  final http.Client _client;

  static const _tokenKey = 'jwt_token';

  String? get token => state.token;

  Uri _endpoint(String path) => Uri.parse('$_baseUrl$path');

  Future<void> loadSession() async {
    final token = await _storage.read(key: _tokenKey);
    if (token != null) {
      emit(AuthState.authenticated(token));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(const AuthState.loading());
    try {
      final response = await _client.post(
        _endpoint('/wp-json/jwt-auth/v1/token'),
        body: {'username': email, 'password': password},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final token = data['token'] as String?;
        if (token != null) {
          await _storage.write(key: _tokenKey, value: token);
          emit(AuthState.authenticated(token));
          return;
        }
      }
      emit(const AuthState.unauthenticated());
    } catch (_) {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> register(String email, String password) async {
    emit(const AuthState.loading());
    try {
      final response = await _client.post(
        _endpoint('/wp-json/wp/v2/users/register'),
        body: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        await login(email, password);
        return;
      }
      emit(const AuthState.unauthenticated());
    } catch (_) {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    emit(const AuthState.unauthenticated());
  }
}
