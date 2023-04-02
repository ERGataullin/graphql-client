import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '/data/services/movie.dart';
import '/presentation/home/home.dart';
import '/presentation/movie_details/movie_details.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      Provider<GraphQLClient>(
        create: (_) => GraphQLClient(
          link: HttpLink('http://localhost:8080/graphql'),
          cache: GraphQLCache(),
        ),
      ),
      Provider<MovieService>(
        create: (context) => GraphQlMovieService(context.read()),
      ),
    ],
    child: const _App(),
  ));
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeView(),
          ),
          GoRoute(
            path: '/movies/:id',
            builder: (context, state) => MovieDetailsView(
              id: int.parse(state.params['id']!),
            ),
          ),
        ],
      ),
    );
  }
}
