// flutter and ui libraries
import 'package:flutter/material.dart';

// amplify packages we will need to use
import 'package:google_fonts/google_fonts.dart';
import 'locationWidget.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 27, 27, 27),
          title: Text("Analysis",
              style: TextStyle(color: Color.fromARGB(255, 43, 121, 194))),
        ),
        backgroundColor: Color.fromARGB(255, 27, 27, 27),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Center(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Goal Progress Map',
                          style: GoogleFonts.roboto(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )))),
            locationWidget(27.000, 27.000),
            Divider(color: Color.fromARGB(255, 255, 255, 255)),
            Center(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Goal Progress',
                          style: GoogleFonts.roboto(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )))),
            SizedBox(
                height: 75.0,
                width: 75.0,
                child: CircularProgressIndicator(
                  value: 0.25,
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  valueColor:
                      AlwaysStoppedAnimation(Color.fromARGB(255, 43, 121, 194)),
                  strokeWidth: 12,
                  semanticsLabel: 'Circular progress indicator',
                )),
            Divider(color: Color.fromARGB(255, 255, 255, 255)),
          ],
        )));
  }
}
