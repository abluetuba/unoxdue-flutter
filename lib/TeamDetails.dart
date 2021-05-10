import 'package:flutter/material.dart';
//import 'package:unoxdue/constants.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class TeamDetails extends StatelessWidget {
  TeamDetails({Key key, this.teamId}) : super(key: key);

  final int teamId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Details'),
      ),
      body: Text(teamId.toString()),
    );
  }
}
