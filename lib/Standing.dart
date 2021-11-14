import 'package:flutter/material.dart';
import 'package:unoxdue/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unoxdue/TeamDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StandingItem extends StatelessWidget {
  const StandingItem({Key key, this.team, this.isFavourite, this.onBack})
      : super(key: key);

  final Map team;
  final bool isFavourite;
  final Function onBack;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (team["team"]["id"] < 0) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeamDetails(teamId: team["team"]["id"]),
            ),
          ).then((value) {
            onBack();
          });
        },
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: isFavourite == true
                    ? Colors.orange[100]
                    : Colors.transparent,
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
                    "points",
                    "won",
                    "draw",
                    "lost",
                    "goalsFor",
                    "goalsAgainst"
                  ]
                      .map((stat) => Container(
                            child: Text('${team[stat]}',
                                textAlign: TextAlign.center),
                            width: 30,
                            padding: EdgeInsets.only(right: 4),
                          ))
                      .toList(),
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
  Map _favouriteTeams =
      Constants.TEAMS.map((key, value) => MapEntry(key, false));

  Future<Map> getFavouriteTeams() async {
    final SharedPreferences prefs = await _prefs;
    Map favouriteTeams;

    favouriteTeams = Constants.TEAMS.map(
        (key, value) => MapEntry(key, prefs.getBool(key.toString()) ?? false));

    return favouriteTeams;
  }

  @override
  void initState() {
    super.initState();
    setFavouriteTeams();
  }

  void setFavouriteTeams() {
    getFavouriteTeams().then((value) {
      setState(() {
        _favouriteTeams = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 600),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text('Classifica',
                    style: Theme.of(context).textTheme.headline6),
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
                    return StandingItem(
                      team: widget.standings[0]["table"][index - 1],
                      isFavourite: _favouriteTeams[widget.standings[0]["table"]
                          [index - 1]["team"]["id"]],
                      onBack: () {
                        setFavouriteTeams();
                      },
                    );
                  },
                ),
              )
            ]));
  }
}
