import 'package:desafio_tecnico/presentation/details/view/details_page.dart';
import 'package:desafio_tecnico/presentation/details/view_model/details_view_model.dart';
import 'package:desafio_tecnico/presentation/home/view/home_page.dart';
import 'package:desafio_tecnico/presentation/home/view_model/home_view_model.dart';
import 'package:desafio_tecnico/presentation/persisted/view/persisted_users_page.dart';
import 'package:desafio_tecnico/presentation/persisted/view_model/persisted_users_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'domain/models/user.dart';
import 'domain/repositories/user_repository.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String details = '/details';
  static const String persistedUsers = '/persisted-users';
}

class DesafioApp extends StatelessWidget {
  const DesafioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desafio Técnico Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) => _onGenerateRoute(context, settings),
    );
  }

  Route<dynamic> _onGenerateRoute(BuildContext context, RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (context) => HomeViewModel(
              userRepository: context.read<UserRepository>(),
            ),
            child: const HomePage(),
          ),
        );
      case AppRoutes.details:
        final args = settings.arguments;
        if (args is! User) {
          return _errorRoute('Usuário não informado para detalhes');
        }
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (context) => DetailsViewModel(
              userRepository: context.read<UserRepository>(),
              user: args,
            ),
            child: const DetailsPage(),
          ),
        );
      case AppRoutes.persistedUsers:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (context) => PersistedUsersViewModel(
              userRepository: context.read<UserRepository>(),
            ),
            child: const PersistedUsersPage(),
          ),
        );
      default:
        return _errorRoute('Rota não encontrada.');
    }
  }

  Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
