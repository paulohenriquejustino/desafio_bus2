

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'data/datasources/local/user_local_data_source.dart';
import 'data/datasources/remote/random_user_api_service.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  final userRepository = UserRepositoryImpl(
    remoteDataSource: RandomUserApiService(),
    localDataSource: UserLocalDataSource(sharedPreferences),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<UserRepository>.value(value: userRepository),
      ],
      child: const DesafioApp(),
    ),
  );
}
