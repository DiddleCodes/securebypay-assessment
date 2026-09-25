import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/token_storage.dart';
import '../data/auth_repository.dart';
import '../data/user.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, User?>(AuthController.new);

class AuthController extends AsyncNotifier<User?> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);
  TokenStorage get _tokenStorage => ref.read(tokenStorageProvider);

  @override
  Future<User?> build() async {
    final token = await _tokenStorage.read();
    if (token == null) return null;

    try {
      return await _repository.me();
    } on ApiException catch (e) {
      if (e.statusCode == 401) await _tokenStorage.clear();
      return null;
    }
  }

  Future<void> login({required String email, required String password}) async {
    await _startSession(await _repository.login(email: email, password: password));
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneCode,
    required String phoneNumber,
    required String password,
  }) async {
    await _startSession(
      await _repository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneCode: phoneCode,
        phoneNumber: phoneNumber,
        password: password,
      ),
    );
  }

  Future<void> logout() async {
    await _tokenStorage.clear();
    state = const AsyncData(null);
  }

  void sessionExpired() {
    if (state.value != null) logout();
  }

  Future<void> _startSession(AuthSession session) async {
    await _tokenStorage.save(session.token);
    state = AsyncData(session.user);
  }
}
