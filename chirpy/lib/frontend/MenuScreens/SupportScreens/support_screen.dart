import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'mail_content_maker.dart';

//import 'package:chirpy/FrontEnd/MenuScreen/Support/mail_content_maker.dart';

class SupportMenuMaker extends StatefulWidget {
  const SupportMenuMaker({Key? key}) : super(key: key);

  @override
  _SupportMenuMakerState createState() => _SupportMenuMakerState();
}

class _SupportMenuMakerState extends State<SupportMenuMaker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 46, 38, 78),
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Color.fromARGB(239, 46, 38, 78),
        elevation: 10.0,
        shadowColor: Colors.white70,
        title: Text(
          'Support',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            _getListOption(
                icon: Icon(
                  Icons.report_gmailerrorred_outlined,
                  size: 30.0,
                  color: Colors.red,
                ),
                title: 'Report a Problem',
                extraText: 'About App Crashing, Bugs Report'),
            _getListOption(
              icon: Icon(
                Icons.request_page_outlined,
                size: 30.0,
                color: Colors.green,
              ),
              title: 'Request a Feature',
              extraText: 'Any New Feature in your Mind',
            ),
            _getListOption(
              icon: Icon(
                Icons.featured_play_list_outlined,
                size: 30.0,
                color: Colors.amber,
              ),
              title: 'Send Feedback',
              extraText: 'Your Experience of that App',
            ),
          ],
        ),
      ),
    );
  }

  Widget _getListOption(
      {required Icon icon, required String title, required String extraText}) {
    return OpenContainer(
      closedColor: const Color.fromARGB(239, 46, 38, 78),
      middleColor: const Color.fromARGB(239, 46, 38, 78),
      openColor: const Color.fromARGB(239, 46, 38, 78),
      closedElevation: 0.0,
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: Duration(
        milliseconds: 500,
      ),
      openBuilder: (_, __) {
        print(title);
        if (title == 'Report a Problem')
          return SupportInputTaker(
            subject: 'Problem',
            appbarTitle: 'Describe Your Problem',
          );
        else if (title == 'Request a Feature')
          return SupportInputTaker(
            subject: 'Feature',
            appbarTitle: 'Describe the Feature',
          );
        else if (title == 'Send Feedback')
          return SupportInputTaker(
            subject: 'Feedback',
            appbarTitle: 'Write Your Feedback',
          );
        return Center();
      },
      closedBuilder: (_, __) {
        return Container(
          height: 80.0,
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                ),
                child: icon,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        extraText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
