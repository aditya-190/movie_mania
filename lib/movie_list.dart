import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_mania/db/database.dart';

import 'add.dart';
import 'edit.dart';
import 'models/model.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  List<Movies> _moviesList = [];

  @override
  void initState() {
    super.initState();
    SQLHelper.db.fetchAllMovies().then((movies) {
      setState(() {
        movies.forEach((note) {
          _moviesList.add(Movies.fromMap(note));
        });
      });
    });
  }

  void _addMovieToList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddScreen(),
      ),
    );
  }

  void _removeMovieFromList(int index, int id) {
    setState(() {
      SQLHelper.db.deleteMovie(id);
      _moviesList.removeAt(index);
    });
  }

  void _editButtonClicked(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditScreen(index: index, movies: _moviesList[index]),
      ),
    );
  }

  Widget _buildMovieItem(Movies movieItem, int index) {
    return Card(
      child: ListTile(
          leading: SizedBox(
            child: ClipRRect(
              child: Image.network(movieItem.movieImageUrl),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          subtitle: Text(movieItem.movieDirector,
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  fontWeight: FontWeight.normal)),
          title: Text(movieItem.movieName,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          trailing: Wrap(
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                  size: 24,
                ),
                onPressed: () {
                  _editButtonClicked(index);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.blue,
                  size: 24,
                ),
                onPressed: () {
                  _removeMovieFromList(index, _moviesList[index].movieID);
                },
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movies List')),
      body: ListView.builder(
        itemCount: _moviesList.length,
        itemBuilder: (context, index) {
          return _buildMovieItem(_moviesList[index], index);
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _addMovieToList, child: Icon(Icons.add)),
    );
  }
}
