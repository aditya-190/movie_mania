import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_mania/db/database.dart';
import 'package:movie_mania/movie_list.dart';

import 'models/model.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key key, this.movies}) : super(key: key);
  final Movies movies;

  @override
  _AddScreenState createState() => _AddScreenState(movies);
}

class _AddScreenState extends State<AddScreen> {
  _AddScreenState(this.movies);

  Movies movies;
  String _name;
  String _director;
  String _imageURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Movie Data"),
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
                  movies = Movies(
                      Random().nextInt(100000), _name, _director, _imageURL);
                  SQLHelper.db.addMovies(movies).whenComplete(() => {
                        Navigator.pop(context)
                      });
                },
                child: Text("Add Movie"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
