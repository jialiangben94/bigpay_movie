import 'package:bigpay_movie/model/movie_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/movie_repository.dart';
import '../../repository/service/exceptions.dart';

part 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  MovieCubit(this._movieRepository) : super(const MovieState());

  final MovieRepository _movieRepository;

  Future<void> getPopularMovie(int page) async {
    emit(const MovieState(status: MovieStatus.loading));

    try {
      final list = await _movieRepository.getPoularMovie(page);
      emit(MovieState(status: MovieStatus.loaded, movies: list));
    } on RequestException catch (e) {
      emit(MovieState(status: MovieStatus.error, error: e.errorMessage));
    } catch (e) {
      emit(MovieState(status: MovieStatus.error, error: e.toString()));
    }
  }
}
