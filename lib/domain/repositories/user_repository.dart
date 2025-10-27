import '../models/user.dart';

/// Abstraction for fetching and persisting user data.
abstract class UserRepository {
  /// Fetches a new random user from the API and persists it locally.
  Future<User> fetchAndPersistRandomUser();

  /// Returns the in-memory list of fetched users.
  ///
  /// This is primarily used by the home screen.
  List<User> get fetchedUsers;

  /// Loads all persisted users.
  Future<List<User>> loadPersistedUsers();

  /// Persists or updates a user entry.
  Future<void> saveUser(User user);

  /// Removes a persisted user based on UUID (login.uuid).
  Future<void> removeUser(String uuid);

  /// Returns true if the user is already persisted.
  Future<bool> isPersisted(String uuid);
}
