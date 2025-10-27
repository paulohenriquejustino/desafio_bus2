import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/models/user.dart';

class UserLocalDataSource {
  UserLocalDataSource(this._preferences);

  static const _storageKey = 'persisted_users';

  final SharedPreferences _preferences;

  Future<List<User>> loadUsers() async {
    final rawUsers = _preferences.getStringList(_storageKey) ?? <String>[];
    return rawUsers.map(User.fromJsonString).toList();
  }

  Future<void> saveUser(User user) async {
    final users = await loadUsers();
    final filtered = users.where((element) => element.uuid != user.uuid).toList();
    filtered.insert(0, user);
    final encoded = filtered.map((user) => user.toJsonString()).toList();
    await _preferences.setStringList(_storageKey, encoded);
  }

  Future<void> removeUser(String uuid) async {
    final users = await loadUsers();
    final filtered = users.where((user) => user.uuid != uuid).toList();
    final encoded = filtered.map((user) => user.toJsonString()).toList();
    await _preferences.setStringList(_storageKey, encoded);
  }

  Future<bool> exists(String uuid) async {
    final users = await loadUsers();
    return users.any((user) => user.uuid == uuid);
  }
}
