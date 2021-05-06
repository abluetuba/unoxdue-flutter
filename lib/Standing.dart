import 'package:flutter/material.dart';

class Standing extends StatelessWidget {
  const Standing({Key key, this.standings}) : super(key: key);

  final List standings;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Classifica', style: Theme.of(context).textTheme.headline6),
        Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ...standings[0]["table"].map((e) => 
              Text(e["team"]["name"])).toList()
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
    )
  ]);
  }
}
