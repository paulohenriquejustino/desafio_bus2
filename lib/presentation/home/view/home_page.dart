import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/user.dart';
import '../../widgets/user_list_tile.dart';
import '../view_model/home_view_model.dart';
import '../../../app.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<HomeViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.initialize(this);
    });
  }

  @override
  void dispose() {
    _viewModel.stopTicker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Users'),
        actions: [
          IconButton(
            tooltip: 'Usuários persistidos',
            icon: const Icon(Icons.storage),
            onPressed: _openPersisted,
          ),
        ],
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading && viewModel.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null && viewModel.users.isEmpty) {
            return _ErrorState(
              message: viewModel.errorMessage!,
              onRetry: () => viewModel.fetchLatestUser(showLoader: true),
            );
          }

          return Column(
            children: [
              if (viewModel.isFetching) const LinearProgressIndicator(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => viewModel.refreshPersisted(),
                  child: viewModel.users.isEmpty
                      ? ListView(
                          children: const [
                            SizedBox(height: 120),
                            Center(child: Text('Nenhum usuário disponível.')),
                          ],
                        )
                      : ListView.builder(
                          itemCount: viewModel.users.length,
                          itemBuilder: (context, index) {
                            final user = viewModel.users[index];
                            return UserListTile(
                              user: user,
                              onTap: () => _openDetails(user),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Buscar agora',
        onPressed: () => _viewModel.fetchLatestUser(showLoader: true),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Future<void> _openDetails(User user) async {
    final shouldRefresh = await Navigator.pushNamed(
      context,
      AppRoutes.details,
      arguments: user,
    );
    if (shouldRefresh == true && mounted) {
      await _viewModel.refreshPersisted();
    }
  }

  Future<void> _openPersisted() async {
    final shouldRefresh = await Navigator.pushNamed(context, AppRoutes.persistedUsers);
    if (shouldRefresh == true && mounted) {
      await _viewModel.refreshPersisted();
    }
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
