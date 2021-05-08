import 'package:flutter/material.dart';
import 'package:unoxdue/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Standing extends StatelessWidget {
  const Standing({Key key, this.standings}) : super(key: key);

  final List standings;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Classifica', style: Theme.of(context).textTheme.headline6),
          Expanded(
            child: ListView(children: <Widget>[
              ...standings[0]["table"]
                  .map((e) => 
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
                      child: 
                        Row(
                          children: [
                            Container(
                              child: Text('${e["position"]}', textAlign: TextAlign.center,),
                              width: 25,
                            ),
                            Container(
                              child: SvgPicture.asset(
                                  "assets/crests/${e["team"]["id"]}.svg",
                                  height: 25),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            Text(Constants.TEAMS[e["team"]["id"]]),
                            Expanded(
                              child: Row(children: [
                                Container(child: Text('${e["points"]}', textAlign: TextAlign.center), width: 30, padding: EdgeInsets.only(right: 4),),
                                Container(child: Text('${e["won"]}', textAlign: TextAlign.center), width: 30, padding: EdgeInsets.only(right: 4),),
                                Container(child: Text('${e["draw"]}', textAlign: TextAlign.center), width: 30, padding: EdgeInsets.only(right: 4),),
                                Container(child: Text('${e["lost"]}', textAlign: TextAlign.center), width: 30, padding: EdgeInsets.only(right: 4),),
                                Container(child: Text('${e["goalsFor"]}', textAlign: TextAlign.center), width: 30, padding: EdgeInsets.only(right: 4),),
                                Container(child: Text('${e["goalsAgainst"]}', textAlign: TextAlign.center), width: 30, padding: EdgeInsets.only(right: 4),),
                              ],
                              mainAxisAlignment: MainAxisAlignment.end,
                              )
                            )
                          ],
                        )
                    )
                  ).toList()
            ]),
          )

          /*Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ...standings[0]["table"].map((e) => 
              Text(Constants.TEAMS[e["team"]["id"]])).toList()
          ]
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ...standings[0]["table"].map((e) => 
              Container(
                child: Text(e["points"].toString()),
                padding: EdgeInsets.symmetric(horizontal: 8),
              )).toList(),
                
          ]
        )
      ]
    )*/
        ]);
  }
}
