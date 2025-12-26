import 'package:emojihub/api/api.dart';
import 'package:emojihub/core/client_factory.dart';
import 'package:emojihub/modules/search/bloc/search_bloc.dart';
import 'package:emojihub/modules/search/pages/search_page.dart';
import 'package:emojihub/modules/suggestion/bloc/suggestion_bloc.dart';
import 'package:emojihub/modules/suggestion/pages/suggestion_page.dart';
import 'package:emojihub/repo/emoji_repository.dart';
import 'package:emojihub/repo/suggestion_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = createDio();
    final api = ApiClient(dio);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => EmojiRepository(api)),
        RepositoryProvider(create: (_) => SuggestionRepository(api)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) => SearchBloc(ctx.read<EmojiRepository>()),
          ),
          BlocProvider(
            create: (ctx) => SuggestBloc(ctx.read<SuggestionRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'EmojiHub',
          theme: ThemeData(useMaterial3: true),
          routes: {
            '/': (_) => const SearchPage(),
            '/suggest': (_) => const SuggestPage(),
          },
        ),
      ),
    );
  }
}
