import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/date_formatter.dart';
import '../../../domain/models/user.dart';
import '../../widgets/user_detail_section.dart';
import '../view_model/details_view_model.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailsViewModel>().initialize();
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
      child: Consumer<DetailsViewModel>(
        builder: (context, viewModel, _) {
          final user = viewModel.user;
          return Scaffold(
            appBar: AppBar(
              title: Text(user.name.fullName),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeaderSection(user: user),
                  UserDetailSection(
                    title: 'Informações pessoais',
                    items: {
                      'Gênero': user.gender,
                      'E-mail': user.email,
                      'Telefone': user.phone,
                      'Celular': user.cell,
                      'Nacionalidade': user.nat,
                      'Documento': user.id.value.isNotEmpty
                          ? '${user.id.name} - ${user.id.value}'
                          : 'Não informado',
                    },
                  ),
                  UserDetailSection(
                    title: 'Localização',
                    items: {
                      'Rua': '${user.location.street.number} ${user.location.street.name}',
                      'Cidade': user.location.city,
                      'Estado': user.location.state,
                      'País': user.location.country,
                      'CEP': user.location.postcode,
                      'Coordenadas':
                          'Lat: ${user.location.coordinates.latitude}, Lng: ${user.location.coordinates.longitude}',
                      'Fuso horário':
                          '${user.location.timezone.offset} - ${user.location.timezone.description}',
                    },
                  ),
                  UserDetailSection(
                    title: 'Acesso',
                    items: {
                      'UUID': user.login.uuid,
                      'Usuário': user.login.username,
                      'Senha': user.login.password,
                      'Salt': user.login.salt,
                      'MD5': user.login.md5,
                      'SHA1': user.login.sha1,
                      'SHA256': user.login.sha256,
                    },
                  ),
                  UserDetailSection(
                    title: 'Datas',
                    items: {
                      'Nascimento':
                          '${DateFormatter.format(user.dob.date)} • ${user.dob.age} anos',
                      'Cadastro':
                          '${DateFormatter.format(user.registered.date)} • ${user.registered.age} anos de conta',
                    },
                  ),
                  if (viewModel.error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        viewModel.error!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton.icon(
                      onPressed:
                          viewModel.isProcessing ? null : () => _toggleUser(viewModel),
                      icon: Icon(
                        viewModel.isPersisted ? Icons.delete_outline : Icons.save_outlined,
                      ),
                      label: Text(
                        viewModel.isPersisted
                            ? 'Remover dos usuários persistidos'
                            : 'Salvar usuário',
                      ),
                    ),
                  ),
                  if (viewModel.isProcessing)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _toggleUser(DetailsViewModel viewModel) async {
    await viewModel.togglePersistence();
    if (viewModel.error == null && !_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ClipOval(
            child: user.picture.large.isNotEmpty
                ? Image.network(
                    user.picture.large,
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 120,
                    width: 120,
                    color: theme.colorScheme.primary,
                    alignment: Alignment.center,
                    child: Text(
                      user.name.first.isNotEmpty
                          ? user.name.first[0].toUpperCase()
                          : '?',
                      style: theme.textTheme.displaySmall?.copyWith(color: Colors.white),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Text(user.name.fullName, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(user.email, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
            '${user.location.city}, ${user.location.country}',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
