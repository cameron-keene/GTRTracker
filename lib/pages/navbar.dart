// flutter and ui libraries
import 'package:flutter/material.dart';

// amplify configuration and models that should have been generated for you

import 'analysisPage.dart';
import 'homePage.dart';
import 'goalPage.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int pageIndex = 0;

  //array to connect pages to navbar
  final pages = [const HomePage(), const GoalsPage(), const AnalysisPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //styling
      backgroundColor: const Color(0xffC4DFCB),
      body: pages[pageIndex],
      bottomNavigationBar: Container(
        height: 60,
        decoration:
            BoxDecoration(color: Color.fromARGB(255, 27, 27, 27), boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(2, -2),
          ),
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              //home page
              icon: pageIndex == 0
                  ? const Icon(
                      Icons.home_filled,
                      color: Color.fromARGB(255, 43, 121, 194),
                      size: 35,
                    )
                  : const Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              //goal page
              icon: pageIndex == 1
                  ? const Icon(
                      Icons.task_alt_rounded,
                      color: Color.fromARGB(255, 43, 121, 194),
                      size: 35,
                    )
                  : const Icon(
                      Icons.task_alt_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
            IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              //analysis page
              icon: pageIndex == 2
                  ? const Icon(
                      Icons.timeline_rounded,
                      color: Color.fromARGB(255, 43, 121, 194),
                      size: 35,
                    )
                  : const Icon(
                      Icons.timeline_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
