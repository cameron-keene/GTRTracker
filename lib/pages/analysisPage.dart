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
    final border = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 27, 27, 27),
          title: Text("Analysis",
              style: TextStyle(color: Color.fromARGB(255, 43, 121, 194))),
        ),
        backgroundColor: Color.fromARGB(255, 27, 27, 27),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              Center(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Trends',
                            style: GoogleFonts.roboto(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          )))),
              const Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                  )),
              ListTileTheme(
                  contentPadding: const EdgeInsets.all(8),
                  iconColor: Color.fromARGB(255, 0, 0, 0),
                  textColor: Color.fromARGB(255, 0, 0, 0),
                  tileColor: Color.fromARGB(255, 255, 255, 255),
                  style: ListTileStyle.list,
                  dense: true,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8.0),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Card(
                            child: ListTile(
                          shape: border,
                          trailing: Icon(Icons.more_vert),
                          title: Text(
                            "First",
                            textScaleFactor: 1.5,
                            style: GoogleFonts.roboto(
                                fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ));
                      }))
            ]))));
  }
}
