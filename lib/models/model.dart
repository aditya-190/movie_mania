import 'package:movie_mania/db/database.dart';

class Movies {
  final int movieID;
  final String movieName;
  final String movieDirector;
  final String movieImageUrl;

  Movies(this.movieID, this.movieName, this.movieDirector, this.movieImageUrl);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      SQLHelper.COLUMN_ID: movieID,
      SQLHelper.COLUMN_NAME: movieName,
      SQLHelper.COLUMN_DIRECTOR: movieDirector,
      SQLHelper.COLUMN_IMAGE: movieImageUrl,
    };

    if (movieID != null) {
      map[SQLHelper.COLUMN_ID] = movieID;
    }
    return map;
  }

  Movies.fromMap(Map<String, dynamic> map)
      : movieID = map[SQLHelper.COLUMN_ID],
        movieName = map[SQLHelper.COLUMN_NAME],
        movieDirector = map[SQLHelper.COLUMN_DIRECTOR],
        movieImageUrl = map[SQLHelper.COLUMN_IMAGE];
}
