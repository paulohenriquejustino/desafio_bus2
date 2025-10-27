import '../../domain/models/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local/user_local_data_source.dart';
import '../datasources/remote/random_user_api_service.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required RandomUserApiService remoteDataSource,
    required UserLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final RandomUserApiService _remoteDataSource;
  final UserLocalDataSource _localDataSource;

  final List<User> _fetchedUsers = <User>[];

  @override
  Future<User> fetchAndPersistRandomUser() async {
    final user = await _remoteDataSource.fetchRandomUser();
    await _localDataSource.saveUser(user);

    if (_fetchedUsers.indexWhere((element) => element.uuid == user.uuid) == -1) {
      _fetchedUsers.insert(0, user);
    }

    return user;
  }

  @override
  List<User> get fetchedUsers => List.unmodifiable(_fetchedUsers);

  @override
  Future<List<User>> loadPersistedUsers() => _localDataSource.loadUsers();

  @override
  Future<void> saveUser(User user) async {
    await _localDataSource.saveUser(user);
  }

  @override
  Future<void> removeUser(String uuid) async {
    await _localDataSource.removeUser(uuid);
    _fetchedUsers.removeWhere((user) => user.uuid == uuid);
  }

  @override
  Future<bool> isPersisted(String uuid) => _localDataSource.exists(uuid);
}
