import 'package:flutter/material.dart';
import 'package:unoxdue/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unoxdue/MatchDetails.dart';

class Scores extends StatefulWidget {
  Scores({Key key, this.scoresData}) : super(key: key);

  final List scoresData;

  @override
  _ScoresState createState() => _ScoresState();
}

class Match extends StatelessWidget {
  const Match(
      {Key key, this.homeTeam, this.awayTeam, this.homeScore, this.awayScore})
      : super(key: key);

  final int homeTeam;
  final int awayTeam;
  final int homeScore;
  final int awayScore;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
        ),
        child: Column(children: [
          Row(
            children: [
              Container(
                child: SvgPicture.asset("assets/crests/$homeTeam.svg",
                    height: 50),
                padding: EdgeInsets.symmetric(horizontal: 32),
              ),
              Text(Constants.TEAMS[homeTeam]),
              Expanded(
                  child: Container(
                child: Text(
                  homeScore != null ? "$homeScore" : "-",
                  textAlign: TextAlign.end,
                ),
                padding: EdgeInsets.symmetric(horizontal: 64),
              ))
            ],
          ),
          Divider(),
          Row(
            children: [
              Container(
                child: SvgPicture.asset("assets/crests/$awayTeam.svg",
                    height: 50),
                padding: EdgeInsets.symmetric(horizontal: 32),
              ),
              Text(Constants.TEAMS[awayTeam]),
              Expanded(
                  child: Container(
                child: Text(
                  homeScore != null ? "$awayScore" : "-",
                  textAlign: TextAlign.end,
                ),
                padding: EdgeInsets.symmetric(horizontal: 64),
              ))
            ],
          ),         
        ]));
  }
}

class Matches extends StatelessWidget {
  const Matches({Key key, this.matches}) : super(key: key);

  final List matches;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: matches
          .map((e) => InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchDetails(matchId: e["id"]),
                ),
              );
            },
            child: Match(
              homeTeam: e["homeTeam"]["id"],
              awayTeam: e["awayTeam"]["id"],
              awayScore: e["score"]["fullTime"]["awayTeam"],
              homeScore: e["score"]["fullTime"]["homeTeam"]))
          )
          .toList(),
    );
  }
}

class _ScoresState extends State<Scores> {
  int _visibleMatchday;

  @override
  void initState() {
    super.initState();
    _visibleMatchday = widget.scoresData[0]["season"]["currentMatchday"];
  }

  void setVisibleMatchday(int visibleMatchday) {
    setState(() {
      _visibleMatchday = visibleMatchday;
    });
  }

  void _incrementVisibleMatchday() {
    setState(() {
      _visibleMatchday++;
    });
  }

  void _decrementVisibleMatchday() {
    setState(() {
      _visibleMatchday--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              IconButton(
                  icon: const Icon(Icons.navigate_before),
                  onPressed: _decrementVisibleMatchday),
              Text('Giornata $_visibleMatchday',
                  style: Theme.of(context).textTheme.headline6),
              IconButton(
                  icon: const Icon(Icons.navigate_next),
                  onPressed: _incrementVisibleMatchday),
            ]),
            Expanded(
              child: Matches(
                  matches: widget.scoresData
                      .where((match) => match["matchday"] == _visibleMatchday)
                      .toList()),
            )
          ],
        ));
  }
}
