import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app.dart';
import '../../../domain/models/user.dart';
import '../../widgets/user_list_tile.dart';
import '../view_model/persisted_users_view_model.dart';

class PersistedUsersPage extends StatefulWidget {
  const PersistedUsersPage({super.key});

  @override
  State<PersistedUsersPage> createState() => _PersistedUsersPageState();
}

class _PersistedUsersPageState extends State<PersistedUsersPage> {
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PersistedUsersViewModel>().loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, _hasChanges);
      },
      child: Consumer<PersistedUsersViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Usuários persistidos'),
            ),
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.users.isEmpty
                    ? const _EmptyState()
                    : ListView.builder(
                        itemCount: viewModel.users.length,
                        itemBuilder: (context, index) {
                          final user = viewModel.users[index];
                          return UserListTile(
                            user: user,
                            onTap: () => _openDetails(user),
                            onRemove: () => _removeUser(viewModel, user),
                          );
                        },
                      ),
          );
        },
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
      _triggerChange();
      await context.read<PersistedUsersViewModel>().loadUsers();
    }
  }

  Future<void> _removeUser(
    PersistedUsersViewModel viewModel,
    User user,
  ) async {
    await viewModel.removeUser(user.uuid);
    _triggerChange();
  }

  void _triggerChange() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.storage, size: 48),
            const SizedBox(height: 12),
            Text(
              'Nenhum usuário foi persistido ainda.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
