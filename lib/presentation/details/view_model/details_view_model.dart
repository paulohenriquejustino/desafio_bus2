import 'package:flutter/foundation.dart';

import '../../../domain/models/user.dart';
import '../../../domain/repositories/user_repository.dart';

class DetailsViewModel extends ChangeNotifier {
  DetailsViewModel({
    required UserRepository userRepository,
    required User user,
  })  : _repository = userRepository,
        _user = user;

  final UserRepository _repository;
  User _user;

  bool _isPersisted = false;
  bool _isProcessing = false;
  String? _error;

  User get user => _user;
  bool get isPersisted => _isPersisted;
  bool get isProcessing => _isProcessing;
  String? get error => _error;

  Future<void> initialize() async {
    _isPersisted = await _repository.isPersisted(_user.uuid);
    notifyListeners();
  }

  Future<void> togglePersistence() async {
    if (_isProcessing) {
      return;
    }

    _isProcessing = true;
    _error = null;
    notifyListeners();

    try {
      if (_isPersisted) {
        await _repository.removeUser(_user.uuid);
        _isPersisted = false;
      } else {
        await _repository.saveUser(_user);
        _isPersisted = true;
      }
    } catch (error) {
      _error = error.toString();
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void updateUser(User user) {
    _user = user;
    notifyListeners();
  }
}
