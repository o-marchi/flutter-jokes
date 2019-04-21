import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/foundation.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Jokes',
      theme: ThemeData(
        primaryColor: Colors.yellow[100],
        scaffoldBackgroundColor: Colors.yellow[50]
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Jokes'),
        ),
        body: SingleJoke(),
      )
    );
  }
}

class Joke {
  String setup;
  String punchline;
  bool showpunchline = false;

  Joke({
    this.setup,
    this.punchline,
  });

  factory Joke.fromJson(Map<String, dynamic> json) => new Joke(
      setup: json['setup'],
      punchline: json['punchline']
  );
}

Future<Joke> fetchJoke() async {
  final response =
    await http.get('https://official-joke-api.appspot.com/random_joke');

  return response.statusCode == 200 ?
    Joke.fromJson(json.decode(response.body)) :
    throw Exception('Failed to load joke');
}

class SingleJoke extends StatefulWidget {
  @override
  SingleJokeState createState() => new SingleJokeState();
}

class SingleJokeState extends State<SingleJoke> {

  Joke _joke;

  void anotherOne() async {
    setState(() {
      _joke = null;
    });

    Joke joke = await fetchJoke();

    setState(() {
      _joke = joke;
    });
  }

  @override
  void initState() {
    super.initState();
    anotherOne();
  }

  Widget jokeWidget(Joke joke) {
    return Padding(
      padding:
      const EdgeInsets.only(top: 46, left: 16, right: 16, bottom: 20),
      child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
              Text(
                joke.setup,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Color(0xff6c3c64)
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Text(
                  joke.punchline,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.black
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 46.0),
                child: RaisedButton(
                  onPressed: () {
                    anotherOne();
                  },
                  color: Color(0xff6c3c64),
                  textColor: Colors.white,
                  splashColor: Color(0xff3c2738),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: const Text(
                      'Another one',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

  Widget loading() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 150.0),
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation(Color(0xff6c3c64)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return
      Column(
        children: <Widget>[
          _joke != null ? jokeWidget(_joke) : loading(),
        ],
      );
  }
}
