import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//const String _API = "api.football-data.org";
const String _API = "localhost:8080";

const String _API_KEY = "d4a62e8fd0e74363a70ad3bd67646d19";

Future<Map> fetchData() async {
  final response = await http.get(
      Uri.https(_API, "/v2/competitions/SA/matches"),
      headers: {"X-Auth-Token": _API_KEY});
  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Failed to fetch data');
  }
}

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
              "$homeScore - $awayScore",
              textAlign: TextAlign.center,
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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'unoXdue'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Map> futureData;
  int _visibleMatchday;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  //int _counter = 0;
  //String _data = "Fetch something first";

  Future<Map> fetchData() async {
    final response = await http.get(
        //Uri.https(_API, "/v2/competitions/SA/matches"),
        Uri.http(_API, "matches.json"));
    //headers: {"X-Auth-Token": _API_KEY});
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      setVisibleMatchday(data["matches"][0]["season"]["currentMatchday"]);
      return data;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  void setVisibleMatchday(int visibleMatchday) {
    setState(() {
      _visibleMatchday = visibleMatchday;
    });
  }

  void previousMatchday() {
    setState(() {
      _visibleMatchday--;
    });
  }

  void nextMatchday() {
    setState(() {
      _visibleMatchday++;
    });
  }

  void _onItemTapped(int index) {
    print(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  /*void _incrementCounter() async {
    var data = await fetchData();
    //print("id: ${data['id']}, title: ${data['title']}");

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      _data = data['matches'][0]['season']['currentMatchday'].toString();
    });
  }*/
 
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _selectedIndex == 0 ?  Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /*Text(
              'unoXdue',
              style: Theme.of(context).textTheme.headline4,
            ),*/
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              GestureDetector(child: Text("<<"), onTap: previousMatchday),
              Text('Giornata $_visibleMatchday'),
              GestureDetector(child: Text(">>"), onTap: nextMatchday),
            ]),
            FutureBuilder<Map>(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //return Text("${snapshot.data['matches'][0]['homeTeam']['name']} ${snapshot.data['matches'][0]['score']['fullTime']['homeTeam']} -  ${snapshot.data['matches'][0]['score']['fullTime']['awayTeam']} ${snapshot.data['matches'][0]['awayTeam']['name']}");
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
        : Text('Classifica')
        
      ),
      bottomNavigationBar:
          BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.sports_soccer), label: 'Risultati'),
        BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Classifica')
      ], currentIndex: _selectedIndex, onTap: _onItemTapped),
      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
