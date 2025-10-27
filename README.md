# Desafio Técnico Flutter

Aplicativo criado por **Paulo Henrique de Paiva Barbosa Justino** como solução para o desafio técnico de Desenvolvedor(a) Flutter. O objetivo é consumir a API pública [Random User](https://randomuser.me/) para apresentar pessoas em tempo real, organizar os dados com arquitetura MVVM e realizar persistência local.

## Visão Geral
- Busca uma nova pessoa a cada 5 segundos usando `Ticker`.
- Lista usuários em memória e permite navegar até detalhes completos.
- Persiste usuários localmente com `SharedPreferences`.
- Sincroniza a lista principal e a lista de persistidos (adicionar/remover).
- Arquitetura MVVM com Repository Pattern, camada de domínio rica em objetos de valor.

## Stack Técnica
- Flutter 3.35.5 • Dart 3.9.2
- Gerenciamento de estado: `provider`
- HTTP client: `dio`
- Persistência local: `shared_preferences`
- Formatação de datas: `intl`

## Estrutura das Pastas
```
lib/
 ├─ core/            # Constantes, utilitários e exceções
 ├─ data/            # DataSources remoto/local e implementação do repositório
 ├─ domain/          # Modelos ricos em OO e contratos de repositório
 ├─ presentation/    # MVVM (ViewModels) + Views + Widgets reutilizáveis
 ├─ app.dart         # Configuração de rotas e tema
 └─ main.dart        # Inicialização, injeção de dependências e providers
```

## Pré-Requisitos
- Flutter SDK 3.35.5 ou superior
- Dart SDK 3.9.2 (incluso no Flutter)
- Dispositivo/emulador Android ou iOS configurado

## Configuração do Projeto
```bash
git clone <url-do-repositorio>
cd desafio_tecnico
flutter pub get
```

## Executando
```bash
flutter run
```

## Testes
```bash
flutter test
```

O projeto inclui um teste widget com um repositório fake para garantir renderização básica da Home.

## Considerações de Git
- A pasta `build/` está ignorada em `.gitignore`. Se gerar artefatos pesados, limpe-os com:
  ```bash
  git rm -r --cached build/
  ```
- Crie commits pequenos e descritivos.

## Próximas Melhorias Sugeridas
1. Adicionar testes unitários para ViewModels e Repository.
2. Introduzir um cache mais robusto (ex.: `hive`) caso haja requisito offline mais amplo.
3. Implementar temas claro/escuro configuráveis pelo usuário.

---
Projeto desenvolvido por **Paulo Henrique de Paiva Barbosa Justino**. Sinta-se à vontade para abrir _issues_ ou contribuir via _pull requests_. Obrigado por conferir!***
