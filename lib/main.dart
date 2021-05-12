import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import 'package:unoxdue/Standing.dart';
import 'package:unoxdue/Scores.dart';
import 'package:unoxdue/constants.dart';
//import 'package:unoxdue/keys.dart';

//const String _API = "api.football-data.org";
//const String _API = "localhost:8080";

//const String _API_KEY = Keys.key;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'unoXdue',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'unoXdue'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Map> futureData;
  Future<Map> futureTeams;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
    futureTeams = fetchTeams();
  }

  Future<Map> fetchData() async {
    final resMatches = await http.get(
        //Uri.https(Constants.API, "/v2/competitions/SA/matches"),
        Uri.http(Constants.API, "matches.json"));
    //headers: {"X-Auth-Token": _API_KEY});
    final resStandings = await http.get(
        //Uri.https(ConstantsAPI, "/v2/competitions/SA/matches"),
        Uri.http(Constants.API, "standings.json"));
    //headers: {"X-Auth-Token": _API_KEY});
    if (resMatches.statusCode == 200 && resStandings.statusCode == 200) {
      Map<String, dynamic> matchesData = jsonDecode(resMatches.body);
      Map<String, dynamic> standingsData = jsonDecode(resStandings.body);

      return {...matchesData, ...standingsData};
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<Map> fetchTeams() async {
    final data = await rootBundle.loadString('assets/teams.json');
    return jsonDecode(data);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
          child: _selectedIndex == 0
              ? FutureBuilder<Map>(
                  future: futureData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Scores(scoresData: snapshot.data["matches"]);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  })
              : FutureBuilder<Map>(
                  future: futureData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Standing(standings: snapshot.data["standings"]);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  })),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_soccer), label: 'Risultati'),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: 'Classifica'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
