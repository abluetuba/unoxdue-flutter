import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Teams extends StatelessWidget {
  const Teams({Key key, this.teams}) : super(key: key);

  final Future<Map> teams;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
        future: teams,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 10),
              itemCount: snapshot.data["teams"].length,
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: SvgPicture.asset('assets/crests/${snapshot.data["teams"][index]["id"].toString()}.svg', height: 50)),
                        Expanded(child: Text(snapshot.data["teams"][index]["shortName"], style: TextStyle(fontSize: 18),))
                      ]
                    )
                  );
              }
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        });
  }
}
