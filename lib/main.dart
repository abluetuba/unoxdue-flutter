import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import 'package:unoxdue/Standing.dart';
import 'package:unoxdue/Teams.dart';
//import 'package:unoxdue/keys.dart';

//const String _API = "api.football-data.org";
const String _API = "localhost:8080";

//const String _API_KEY = Keys.key;

class Match extends StatelessWidget {
  const Match(
      {Key key, this.homeTeam, this.awayTeam, this.homeScore, this.awayScore})
      : super(key: key);

  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text("$homeTeam", textAlign: TextAlign.end)),
        Container(
            padding: EdgeInsets.all(8.0),
            child: Text(
              homeScore != null ? "$homeScore - $awayScore" : "   -   ",
              //textAlign: TextAlign.center,
            )),
        Expanded(child: Text("$awayTeam", textAlign: TextAlign.start)),
      ],
    );
  }
}

class Matches extends StatelessWidget {
  const Matches({Key key, this.matches}) : super(key: key);

  final List matches;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: matches
          .map((e) => Match(
              homeTeam: e["homeTeam"]["name"],
              awayTeam: e["awayTeam"]["name"],
              awayScore: e["score"]["fullTime"]["awayTeam"],
              homeScore: e["score"]["fullTime"]["homeTeam"]))
          .toList(),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  int _visibleMatchday;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
    futureTeams = fetchTeams();
  }

  Future<Map> fetchData() async {
    final resMatches = await http.get(
        //Uri.https(_API, "/v2/competitions/SA/matches"),
        Uri.http(_API, "matches.json"));
    //headers: {"X-Auth-Token": _API_KEY});
    final resStandings = await http.get(
        //Uri.https(_API, "/v2/competitions/SA/matches"),
        Uri.http(_API, "standings.json"));
    //headers: {"X-Auth-Token": _API_KEY});
    if (resMatches.statusCode == 200 && resStandings.statusCode == 200) {
      Map<String, dynamic> matchesData = jsonDecode(resMatches.body);
      Map<String, dynamic> standingsData = jsonDecode(resStandings.body);
      setVisibleMatchday(
          matchesData["matches"][0]["season"]["currentMatchday"]);
      return {...matchesData, ...standingsData};
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<Map> fetchTeams() async {
    final data = await rootBundle.loadString('assets/teams.json');
    return jsonDecode(data);
  }

  void setVisibleMatchday(int visibleMatchday) {
    setState(() {
      _visibleMatchday = visibleMatchday;
    });
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
      ),
      body: Center(
          child: _selectedIndex == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                              icon: const Icon(Icons.navigate_before),
                              onPressed: () {
                                setState(() {
                                  _visibleMatchday--;
                                });
                              }),
                          Text('Giornata $_visibleMatchday',
                              style: Theme.of(context).textTheme.headline6),
                          IconButton(
                              icon: const Icon(Icons.navigate_next),
                              onPressed: () {
                                setState(() {
                                  _visibleMatchday++;
                                });
                              }),
                        ]),
                    FutureBuilder<Map>(
                        future: futureData,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Matches(
                                matches: snapshot.data["matches"]
                                    .where((match) =>
                                        match["matchday"] == _visibleMatchday)
                                    .toList());
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          return CircularProgressIndicator();
                        }),
                  ],
                )
              : _selectedIndex == 1
                  ? FutureBuilder<Map>(
                      future: futureData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Standing(
                              standings: snapshot.data["standings"]);
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      })
                  : Teams(teams: futureTeams)),
      bottomNavigationBar:
          BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer), label: 'Risultati'),
        BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard), label: 'Classifica'),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Squadre'),
      ], currentIndex: _selectedIndex, onTap: _onItemTapped),
    );
  }
}
