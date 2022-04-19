import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:tell_me_a_joke/models/joke_model.dart';
import 'package:loading_animations/loading_animations.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Make me laugh',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Make me laugh'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    fetchJoke();
  }

  static const API_KEY = 'QUtFhHPnlQ5f13LDVpQL3a54XgQzTlCJa1PMSB3o';
  static String joke_url = 'https://joke.api.gkamelo.xyz/random';
  String _jokePunchLine = '';
  String _jokeText = '';
  bool _isPunchLineVisible = false;
  bool _isJokeTextVisible = false;
  bool _isLoaderVisible = true;
  Joke random_joke = Joke(id: 0, type: '', setup: '', punchline: '');

  static Map<String, String> get headers => {
    'x-api-key': API_KEY
  };

  void _getPunchLine() {
    setState(() {
      _isPunchLineVisible = true;
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      // Here you can write your code
      setState(() {
        _isPunchLineVisible = false;
        fetchJoke();
      });
    });
  }

  fetchJoke() async {
    _isJokeTextVisible = false;
    _isLoaderVisible = true;
    final response = await http.get(Uri.parse(joke_url), headers: headers);
    if (response.statusCode == 200) {
      random_joke = Joke.fromJson(json.decode(response.body));
      setState(() {
        _jokeText = random_joke.setup;
        _jokePunchLine = random_joke.punchline;
        _isJokeTextVisible = true;
        _isLoaderVisible = false;
      });
    } else {
      throw Exception('Failed to load Joke');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                child: LoadingFadingLine.square(
                  borderColor: Colors.black,
                  borderSize: 3.0,
                  size: 30.0,
                  backgroundColor: Colors.grey,
                  duration: Duration(milliseconds: 300),
                ),
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: _isLoaderVisible,
              ),
              Visibility(
                child: GestureDetector(
                  onTap: _getPunchLine,
                  child: Text(
                    _jokeText,
                    style: TextStyle(color: Colors.black, fontSize: 22),
                  ),
                ),
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: _isJokeTextVisible,
              ),
              Visibility(
                child: Text(
                  _jokePunchLine,
                  style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic, height: 5, fontSize: 20),
                ),
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: _isPunchLineVisible,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
