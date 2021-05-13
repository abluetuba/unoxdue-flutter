import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:unoxdue/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:unoxdue/keys.dart';

class MatchDetails extends StatefulWidget {
  MatchDetails({Key key, this.matchId}) : super(key: key);

  final int matchId;

  @override
  MatchDetailsState createState() => MatchDetailsState();
}

class MatchDetailsState extends State<MatchDetails> {
  Future<Map> matchData;

  Future<Map> fetchMatch(int matchId) async {
    final resMatch =
        await http.get(
            Uri.https(Constants.API, "/v2/matches/$matchId"),
            //Uri.http(Constants.API, "$matchId.json"));
            headers: {"X-Auth-Token": Keys.key});

    if (resMatch.statusCode == 200) {
      Map<String, dynamic> matchData = jsonDecode(resMatch.body);
      return matchData;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    matchData = fetchMatch(widget.matchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Match Details'),
        ),
        body: FutureBuilder(
          future: matchData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Match(matchData: snapshot.data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        )

        /*Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${widget.matchId}'),
                  ],
                )
              ]),*/
        );
  }
}

class Match extends StatelessWidget {
  const Match({Key key, this.matchData}) : super(key: key);

  final Map matchData;

  @override
  Widget build(BuildContext context) {
    final Map match = matchData["match"];

    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7), BlendMode.darken)),
        ),
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              Text(
                '${match["venue"]}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Container(
                  constraints: BoxConstraints(maxWidth: 800),
                  padding: EdgeInsets.all(20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset(
                          "assets/crests/${match["homeTeam"]["id"]}.svg",
                          width: 100,
                        ),
                        Text(
                          '${match["score"]["fullTime"]["homeTeam"] ?? ""}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 50),
                        ),
                        Text(
                          '-',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 50),
                        ),
                        Text(
                          '${match["score"]["fullTime"]["awayTeam"] ?? ""}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 50),
                        ),
                        SvgPicture.asset(
                          "assets/crests/${match["awayTeam"]["id"]}.svg",
                          width: 100,
                        ),
                      ])),
              match["status"] == "FINISHED"
                  ? Text("Risultato finale", style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )
                  : Text(DateFormat('d.M.y').format(
                      DateTime.parse(match["utcDate"])),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )
            ])));
  }
}
