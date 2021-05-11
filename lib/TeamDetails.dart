import 'package:flutter/material.dart';
import 'package:unoxdue/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamDetails extends StatefulWidget {
  TeamDetails({Key key, this.teamId}) : super(key: key);

  final int teamId;

  @override
  TeamDetailsState createState() => TeamDetailsState();
}

class TeamDetailsState extends State<TeamDetails> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> _switchValue;

  Future<void> _changeSwitchValue() async {
    final String teamId = widget.teamId.toString();
    final SharedPreferences prefs = await _prefs;
    final bool switchValue = !(prefs.getBool(teamId) ?? false);

    setState(() {
      _switchValue = prefs.setBool(teamId, switchValue).then((bool success) {
        return switchValue;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _switchValue = _prefs.then((SharedPreferences prefs) {
      return (prefs.getBool(widget.teamId.toString()) ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Constants.TEAMS[widget.teamId]),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset("assets/crests/${widget.teamId}.svg"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Imposta come squadra preferita'),
                    FutureBuilder<bool>(
                        future: _switchValue,
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                              return Switch(
                                value: snapshot.data,
                                onChanged: (value) {
                                  _changeSwitchValue();
                                },
                              );
                            }
                            return CircularProgressIndicator();
                        })
                  ],
                )
              ]),
        ));
  }
}
