import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
          Matches(matches: widget.scoresData
            .where((match) => match["matchday"] == _visibleMatchday)
            .toList())       
      ],
    );
  }
}
