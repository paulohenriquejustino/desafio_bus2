import 'package:flutter/foundation.dart';

import '../../../domain/models/user.dart';
import '../../../domain/repositories/user_repository.dart';

class PersistedUsersViewModel extends ChangeNotifier {
  PersistedUsersViewModel({required UserRepository userRepository})
      : _repository = userRepository;

  final UserRepository _repository;
  final List<User> _users = <User>[];

  bool _isLoading = false;
  String? _error;

  List<User> get users => List.unmodifiable(_users);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUsers() async {
    _setLoading(true);
    try {
      final persisted = await _repository.loadPersistedUsers();
      _users
        ..clear()
        ..addAll(persisted);
      _error = null;
    } catch (error) {
      _error = error.toString();
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> removeUser(String uuid) async {
    await _repository.removeUser(uuid);
    _users.removeWhere((user) => user.uuid == uuid);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
  }
}
