import 'package:flutter/material.dart';
import 'package:unoxdue/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unoxdue/TeamDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StandingItem extends StatelessWidget {
  const StandingItem({Key key, this.team, this.isFavourite}) : super(key: key);

  final Map team;
  final bool isFavourite;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (team["team"]["id"] < 0) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeamDetails(teamId: team["team"]["id"]),
            ),
          );
        },
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: isFavourite == true ? Colors.orange[100] : Colors.transparent,
                border: Border(
                    bottom: BorderSide(
                        width: 1,
                        color: team["position"] >= 18
                            ? Colors.red
                            : team["position"] == 5 || team["position"] == 6
                                ? Colors.orange
                                : team["position"] > 0 && team["position"] <= 4
                                    ? Colors.blue
                                    : Colors.grey))),
            child: Row(
              children: [
                Container(
                  child: Text(
                    team["position"] == -1 ? '#' : '${team["position"]}',
                    textAlign: TextAlign.center,
                  ),
                  width: 25,
                ),
                Container(
                  width: 41,
                  height: 25,
                  child: team["team"]["id"] != -1
                      ? SvgPicture.asset(
                          "assets/crests/${team["team"]["id"]}.svg",
                          height: 25,
                        )
                      : SizedBox(),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                ),
                Text(team["team"]["id"] != -1
                    ? Constants.TEAMS[team["team"]["id"]]
                    : 'Squadra'),
                Expanded(
                    child: Row(
                  children: [
                    Container(
                      child: Text('${team["points"]}',
                          textAlign: TextAlign.center),
                      width: 30,
                      padding: EdgeInsets.only(right: 4),
                    ),
                    Container(
                      child:
                          Text('${team["won"]}', textAlign: TextAlign.center),
                      width: 30,
                      padding: EdgeInsets.only(right: 4),
                    ),
                    Container(
                      child:
                          Text('${team["draw"]}', textAlign: TextAlign.center),
                      width: 30,
                      padding: EdgeInsets.only(right: 4),
                    ),
                    Container(
                      child:
                          Text('${team["lost"]}', textAlign: TextAlign.center),
                      width: 30,
                      padding: EdgeInsets.only(right: 4),
                    ),
                    Container(
                      child: Text('${team["goalsFor"]}',
                          textAlign: TextAlign.center),
                      width: 30,
                      padding: EdgeInsets.only(right: 4),
                    ),
                    Container(
                      child: Text('${team["goalsAgainst"]}',
                          textAlign: TextAlign.center),
                      width: 30,
                      padding: EdgeInsets.only(right: 4),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                ))
              ],
            )));
  }
}

class Standing extends StatefulWidget {
  const Standing({Key key, this.standings}) : super(key: key);

  final List standings;

  StandingState createState() => StandingState();
}

class StandingState extends State<Standing> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List> _favouriteTeams;

  Future<List> getFavouriteTeams() async {
    final SharedPreferences prefs = await _prefs;
    return widget.standings[0]["table"]
        .map((e) => prefs.getBool(e["team"]["id"].toString()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _favouriteTeams = getFavouriteTeams();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: <
        Widget>[
      Container(
        child: Text('Classifica', style: Theme.of(context).textTheme.headline6),
        padding: EdgeInsets.symmetric(vertical: 10),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: widget.standings[0]["table"].length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0)
              return StandingItem(team: {
                "position": -1,
                "points": "Pt",
                "won": "V",
                "draw": "N",
                "lost": "P",
                "goalsFor": "GF",
                "goalsAgainst": "GS",
                "team": {"id": -1}
              });
            return FutureBuilder<List>(
                future: _favouriteTeams,
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return StandingItem(
                      team: widget.standings[0]["table"][index - 1],
                      isFavourite: snapshot.data[index - 1],
                    );
                  }
                  return CircularProgressIndicator();
                });
            //StandingItem(team: widget.standings[0]["table"][index - 1]);
          },
        ),
      )
    ]);
  }
}
