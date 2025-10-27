
import 'package:desafio_tecnico/app.dart';
import 'package:desafio_tecnico/domain/models/user.dart';
import 'package:desafio_tecnico/domain/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class FakeUserRepository implements UserRepository {
  final List<User> _users = <User>[];

  @override
  Future<User> fetchAndPersistRandomUser() async {
    final user = _createUser();
    _users.insert(0, user);
    return user;
  }

  @override
  List<User> get fetchedUsers => List.unmodifiable(_users);

  @override
  Future<bool> isPersisted(String uuid) async {
    return _users.any((user) => user.uuid == uuid);
  }

  @override
  Future<List<User>> loadPersistedUsers() async {
    return List.unmodifiable(_users);
  }

  @override
  Future<void> removeUser(String uuid) async {
    _users.removeWhere((user) => user.uuid == uuid);
  }

  @override
  Future<void> saveUser(User user) async {
    final index = _users.indexWhere((element) => element.uuid == user.uuid);
    if (index >= 0) {
      _users[index] = user;
    } else {
      _users.insert(0, user);
    }
  }

  User _createUser() {
    return User(
      gender: 'male',
      name: const Name(title: 'Mr', first: 'John', last: 'Doe'),
      location: Location(
        street: const Street(number: 123, name: 'Main Street'),
        city: 'Testville',
        state: 'Test State',
        country: 'Test Country',
        postcode: '12345',
        coordinates: const Coordinates(latitude: '0.0', longitude: '0.0'),
        timezone: const Timezone(offset: '+0:00', description: 'UTC'),
      ),
      email: 'john.doe@example.com',
      login: const Login(
        uuid: 'uuid-123',
        username: 'johndoe',
        password: 'password',
        salt: 'salt',
        md5: 'md5',
        sha1: 'sha1',
        sha256: 'sha256',
      ),
      dob: DateInfo(date: DateTime(1990, 1, 1), age: 34),
      registered: DateInfo(date: DateTime(2010, 1, 1), age: 14),
      phone: '+1 123456789',
      cell: '+1 987654321',
      id: const Id(name: 'ID', value: '123456789'),
      picture: const Picture(
        large: '',
        medium: '',
        thumbnail: '',
      ),
      nat: 'US',
    );
  }
}

void main() {
  testWidgets('Home screen renders with fake repository', (WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<UserRepository>.value(
        value: FakeUserRepository(),
        child: const DesafioApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 6));

    expect(find.text('Random Users'), findsOneWidget);
    expect(find.text('Mr John Doe'), findsWidgets);
  });
}
