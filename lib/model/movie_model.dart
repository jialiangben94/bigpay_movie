import 'package:equatable/equatable.dart';

class MovieModelList {
  final int page;
  final List<MovieModel> results;
  MovieModelList({
    required this.page,
    required this.results,
  });

  factory MovieModelList.fromMap(Map<String, dynamic> map) {
    return MovieModelList(
      page: map['page'] as int,
      results: List<MovieModel>.from(
        (map['results'] as List<dynamic>).map<MovieModel>(
          (x) => MovieModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class MovieModel extends Equatable {
  int id;
  String posterPath;
  String title;

  MovieModel({
    required this.id,
    required this.posterPath,
    required this.title,
  });

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel(
      id: map['id'] as int,
      posterPath: map['poster_path'] as String,
      title: map['title'] as String,
    );
  }

  @override
  List<Object?> get props => [id, posterPath, title];

  @override
  bool get stringify => true;
}
