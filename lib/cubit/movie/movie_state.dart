part of 'movie_cubit.dart';

enum MovieStatus { initial, loading, loaded, error }

class MovieState extends Equatable {
  final MovieStatus status;
  final List<MovieModel> movies;
  final String error;
  const MovieState({
    this.status = MovieStatus.initial,
    this.movies = const <MovieModel>[],
    this.error = '',
  });

  @override
  List<Object> get props => [status, movies, error];

  MovieState copyWith({
    MovieStatus? status,
    List<MovieModel>? movies,
    String? error,
  }) {
    return MovieState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      error: error ?? this.error,
    );
  }
}
