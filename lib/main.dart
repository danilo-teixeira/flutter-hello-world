import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp( new MyApp() );

class MyApp extends StatelessWidget {

  @override
  Widget build( BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      theme: new ThemeData(
        primaryColor: Colors.white,
        dividerColor: Colors.green
      ),
      home: new RandomWords()
    );
  }
}

class RandomWords extends StatefulWidget {

  @override
  createState() => new RandomWordsState();

}

class RandomWordsState extends State<RandomWords> {

  final _sugestions = <WordPair>[];
  final _biggerFont = new TextStyle(fontSize: 18.0);
  final _saved = new Set<WordPair>();

  @override
  Widget build( BuildContext context ) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon( Icons.list ),
            onPressed: _savedPush,
          )
        ],
      ),
      body: _buildSugestions(),
    );
  }

  Widget _buildSugestions() {

    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if( i.isOdd ) return new Divider();

        final index = i ~/ 2;

        if(index >= _sugestions.length ) {
          _sugestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_sugestions[index]);

      },
    );
  }

  Widget _buildRow( WordPair pair ) {
    final alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState((){
          if(alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _savedPush() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont
                )
              );
            }
          );
          final divider = ListTile
            .divideTiles(
              context: context,
              tiles: tiles            
            )
            .toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text("Saved Sugetions"),
            ),
            body: new ListView(
              children: divider
            ),
          );
        }
      )
    );
  }
}