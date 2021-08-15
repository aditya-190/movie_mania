import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'db/database.dart';
import 'models/model.dart';
import 'movie_list.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key key, this.movies, this.index}) : super(key: key);
  final Movies movies;
  final int index;

  @override
  _EditScreenState createState() => _EditScreenState(index, movies);
}

class _EditScreenState extends State<EditScreen> {
  _EditScreenState(this.index, this.movies);

  Movies movies;
  int index;
  String _name;
  String _director;
  String _imageURL;

  @override
  void initState() {
    super.initState();
    if (movies != null) {
      _name = movies.movieName;
      _director = movies.movieDirector;
      _imageURL = movies.movieImageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Movie Data"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.movie_creation),
            title: TextFormField(
              initialValue: _name,
              decoration: InputDecoration(labelText: 'Movie Name'),
              style: TextStyle(fontSize: 14),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Movie Name is Required';
                }
                return null;
              },
              onChanged: (text) {
                _name = text;
              },
              onSaved: (String value) {
                _name = value;
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.voice_chat_rounded),
            title: TextFormField(
              initialValue: _director,
              decoration: InputDecoration(labelText: 'Director'),
              style: TextStyle(fontSize: 14),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Director Name is Required';
                }
                return null;
              },
              onChanged: (text) {
                _director = text;
              },
              onSaved: (String value) {
                _director = value;
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: TextFormField(
              initialValue: _imageURL,
              decoration: InputDecoration(labelText: 'Image URL'),
              style: TextStyle(fontSize: 14),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Image URL is Required';
                }
                return null;
              },
              onChanged: (text) {
                _imageURL = text;
              },
              onSaved: (String value) {
                _imageURL = value;
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () {
                  movies = Movies(movies.movieID, _name, _director, _imageURL);
                  SQLHelper.db.editMovie(movies).whenComplete(() => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieList(),
                          ),
                        )
                      });
                },
                child: Text("Save Changes"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
