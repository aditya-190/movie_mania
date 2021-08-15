import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'movie_list.dart';

void main() => runApp(MovieApp());

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          accentColor: Colors.blue,
        ),
        title: 'Movie Mania',
        home: MovieList());
  }
}
