import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_mania/sql.dart';

void main() => runApp(MovieApp());

class Movies {
  final String movieID;
  final String movieName;
  final String movieDirector;
  final String movieImageUrl;

  Movies(this.movieID, this.movieName, this.movieDirector, this.movieImageUrl);

  Movies.fromDbMap(Map<String, dynamic> map)
      : movieID = map['movieID'],
        movieName = map['movieName'],
        movieDirector = map['movieDirector'],
        movieImageUrl = map['movieImageUrl'];

  Map<String, dynamic> toDbMap() {
    var map = Map<String, dynamic>();
    map['movieID'] = movieID;
    map['movieName'] = movieName;
    map['movieDirector'] = movieDirector;
    map['movieImageUrl'] = movieImageUrl;
    return map;
  }
}

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

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  List<Movies> _moviesList = [];

  @override
  void initState() {
    super.initState();
    SQLHelper.instance.fetchAllMovies();
  }

  void _addMovieToList() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddScreen(),
        ),
      );
    });
  }

  void _removeMovieFromList(int index, String id) {
    setState(() {
      SQLHelper.instance.deleteMovie(id);
      _moviesList.removeAt(index);
    });
  }

  void _editButtonClicked(int index) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditScreen(movies: _moviesList[index]),
        ),
      );
    });
  }

  Widget _buildMovieList() {
    return ListView.builder(
      itemCount: _moviesList.length,
      itemBuilder: (context, index) {
        return _buildMovieItem(_moviesList[index], index);
      },
    );
  }

  Widget _buildMovieItem(Movies movieItem, int index) {
    return Card(
      child: ListTile(
          title: Row(
            children: [
              SizedBox(
                width: 100,
                child: ClipRRect(
                  child: Image.network(movieItem.movieImageUrl),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movieItem.movieName,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      Text(movieItem.movieDirector,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                              fontWeight: FontWeight.normal))
                    ],
                  ),
                ),
              )
            ],
          ),
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
      body: _buildMovieList(),
      floatingActionButton: FloatingActionButton(
          onPressed: _addMovieToList, child: Icon(Icons.add)),
    );
  }
}

class EditScreen extends StatefulWidget {
  const EditScreen({Key key, this.movies}) : super(key: key);

  final Movies movies;

  @override
  _EditScreenState createState() => _EditScreenState(movies);
}

class _EditScreenState extends State<EditScreen> {
  _EditScreenState(this.movies);

  final Movies movies;
  var textFieldName = TextEditingController();
  var textFieldDirector = TextEditingController();
  var textFieldURL = TextEditingController();

  @override
  void initState() {
    super.initState();
    textFieldName = TextEditingController(text: movies.movieName);
    textFieldDirector = TextEditingController(text: movies.movieDirector);
    textFieldURL = TextEditingController(text: movies.movieImageUrl);
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
            title: TextField(
              controller: textFieldName,
              decoration: InputDecoration(
                hintText: "Movie Name",
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.voice_chat_rounded),
            title: TextField(
              controller: textFieldDirector,
              decoration: InputDecoration(
                hintText: "Movie Director",
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: TextField(
              controller: textFieldURL,
              decoration: InputDecoration(
                hintText: "Image URL",
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () {
                  SQLHelper.instance.updateMovie(movies).whenComplete(() => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieApp(),
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

class AddScreen extends StatefulWidget {
  const AddScreen({Key key, this.movies}) : super(key: key);
  final Movies movies;

  @override
  _AddScreenState createState() => _AddScreenState(movies);
}

class _AddScreenState extends State<AddScreen> {
  _AddScreenState(this.movies);

  final Movies movies;
  var textFieldName = TextEditingController();
  var textFieldDirector = TextEditingController();
  var textFieldURL = TextEditingController();

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
            title: TextField(
              controller: textFieldName,
              decoration: InputDecoration(
                hintText: "Movie Name",
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.voice_chat_rounded),
            title: TextField(
              controller: textFieldDirector,
              decoration: InputDecoration(
                hintText: "Movie Director",
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: TextField(
              controller: textFieldURL,
              decoration: InputDecoration(
                hintText: "Image URL",
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: () {
                  SQLHelper.instance.addMovies(movies).whenComplete(() => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieApp(),
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
