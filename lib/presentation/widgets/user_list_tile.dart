import 'package:flutter/material.dart';

import '../../domain/models/user.dart';

class UserListTile extends StatelessWidget {
  const UserListTile({
    super.key,
    required this.user,
    required this.onTap,
    this.onRemove,
  });

  final User user;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundImage:
              user.picture.thumbnail.isNotEmpty ? NetworkImage(user.picture.thumbnail) : null,
          child: user.picture.thumbnail.isEmpty
              ? Text(
                  user.name.first.isNotEmpty ? user.name.first[0].toUpperCase() : '?',
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                )
              : null,
        ),
        title: Text(user.name.fullName, style: theme.textTheme.titleMedium),
        subtitle: Text('${user.email}\n${user.location.city}, ${user.location.country}'),
        isThreeLine: true,
        trailing: onRemove != null
            ? IconButton(
                tooltip: 'Remover usuário',
                icon: const Icon(Icons.delete_outline),
                onPressed: onRemove,
              )
            : const Icon(Icons.chevron_right),
      ),
    );
  }
}
