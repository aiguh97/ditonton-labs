import 'package:ditonton/presentation/bloc/movie/movie_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ditonton/presentation/bloc/movie/movie_state.dart';

import 'package:ditonton/presentation/pages/movies/movie_detail_page.dart';
import 'package:ditonton/presentation/widgets/card_list.dart';

class PopularMoviesPage extends StatelessWidget {
  static const ROUTE_NAME = '/popular-movie';

  const PopularMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieHasData) {
              return ListView.builder(
                itemCount: state.result.length,
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return CardList(
                    title: movie.title ?? '-',
                    overview: movie.overview ?? '-',
                    posterPath: movie.posterPath ?? '',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MovieDetailPage.ROUTE_NAME,
                        arguments: movie.id,
                      );
                    },
                  );
                },
              );
            } else if (state is MovieError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
