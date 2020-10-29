import 'package:flutter/material.dart';
import 'package:frontendflutter/src/constants/hwsession.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';
import 'package:frontendflutter/src/model_classes/session.dart';

class SessionPage extends StatefulWidget {
  final bool personalPage;

  final String patientShortId;

  final int sessionId;

  SessionPage({this.sessionId, this.patientShortId, this.personalPage = false});

  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  Session session;
  bool _loading;
  bool _sessionNotFound = false;

  void _getSessionDataAsync() async {
    setState(() {
      _loading = true;
    });

    Patient tempPatient = new Patient();

    if (widget.personalPage) {
      tempPatient = await HWSession().getPersonalInfo();
    } else {
      tempPatient = await HWSession().getPatient(widget.patientShortId);
    }

    // if not found
    if (tempPatient == null) {
      setState(() {
        _loading = false;
        _sessionNotFound = true;
        return;
      });
    }

    Session tempSession = new Session();

    tempSession = tempPatient.sessions
        .firstWhere((element) => element.id == widget.sessionId);

    setState(() {
      _loading = false;
      // if not found
      if (tempSession == null) {
        _sessionNotFound = true;
        return;
      }
      session = tempSession;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
