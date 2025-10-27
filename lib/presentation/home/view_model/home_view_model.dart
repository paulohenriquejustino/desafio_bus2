import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../../domain/models/user.dart';
import '../../../domain/repositories/user_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required UserRepository userRepository})
      : _userRepository = userRepository;

  final UserRepository _userRepository;

  final Duration _fetchInterval = const Duration(seconds: 5);
  final List<User> _users = <User>[];

  bool _isLoading = false;
  bool _isFetching = false;
  bool _initialized = false;
  String? _errorMessage;
  Ticker? _ticker;
  Duration _lastFetchElapsed = Duration.zero;

  List<User> get users => List.unmodifiable(_users);
  bool get isLoading => _isLoading;
  bool get isFetching => _isFetching;
  String? get errorMessage => _errorMessage;

  Future<void> initialize(TickerProvider tickerProvider) async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    await _loadPersistedUsers();
    await fetchLatestUser(showLoader: _users.isEmpty);
    _startTicker(tickerProvider);
  }

  Future<void> _loadPersistedUsers() async {
    _setLoading(true);
    try {
      final persisted = await _userRepository.loadPersistedUsers();
      _users
        ..clear()
        ..addAll(persisted);
      _errorMessage = null;
    } catch (error) {
      _errorMessage = _mapError(error);
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> fetchLatestUser({bool showLoader = false}) async {
    if (_isFetching) {
      return;
    }

    _isFetching = true;
    if (showLoader) {
      _setLoading(true);
    }
    notifyListeners();

    try {
      final user = await _userRepository.fetchAndPersistRandomUser();
      _upsertUser(user);
      _errorMessage = null;
    } catch (error) {
      _errorMessage = _mapError(error);
    } finally {
      _isFetching = false;
      if (showLoader) {
        _setLoading(false);
      }
      notifyListeners();
    }
  }

  Future<void> refreshPersisted() async {
    await _loadPersistedUsers();
  }

  Future<void> removeUser(String uuid) async {
    await _userRepository.removeUser(uuid);
    _users.removeWhere((user) => user.uuid == uuid);
    notifyListeners();
  }

  void _upsertUser(User user) {
    final index = _users.indexWhere((element) => element.uuid == user.uuid);
    if (index >= 0) {
      _users[index] = user;
      if (index != 0) {
        _users
          ..removeAt(index)
          ..insert(0, user);
      }
    } else {
      _users.insert(0, user);
    }
  }

  void _startTicker(TickerProvider tickerProvider) {
    _ticker ??= tickerProvider.createTicker(_onTick)..start();
  }

  void stopTicker() {
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;
  }

  void _onTick(Duration elapsed) {
    if (elapsed - _lastFetchElapsed >= _fetchInterval) {
      _lastFetchElapsed = elapsed;
      fetchLatestUser();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
  }

  String _mapError(Object error) {
    return error.toString();
  }

  @override
  void dispose() {
    stopTicker();
    super.dispose();
  }
}
