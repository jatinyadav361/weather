import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 15, right: 15),
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
              "If some of you are facing some problems with this app, we recommend you the following steps: ",
              textScaleFactor: 1.25),
          SizedBox(
            height: 10.0,
          ),
          Text(
              "1. Make sure you are connected to a healthy internet connection."),
          SizedBox(
            height: 5.0,
          ),
          Text(
              "2. Make sure that this app has access to your location. If the app does not have access to your location"
              ", then change the permissions of the app."),
          SizedBox(
            height: 5.0,
          ),
          Text(
              "3. If you are still facing some issues, then you are advised to reinstall or update the app at:"),
          SizedBox(
            height: 2.0,
          ),
          InkWell(
            child: Text(
              'https://drive.google.com/drive/folders/1b2d47e6yWmlcZFk2QefleNxQ2hf7Jtrg?usp=sharing',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: () async {
              await launchUrlApp(
                  'https://drive.google.com/drive/folders/1b2d47e6yWmlcZFk2QefleNxQ2hf7Jtrg?usp=sharing');
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
          ),
          Center(
              child: Text(
            'from',
            textScaleFactor: 1.0,
          )),
          Center(
            child: Text(
              'Jatin Yadav',
              textScaleFactor: 1.75,
            ),
          )
        ],
      ),
    );
  }

  launchUrlApp(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e);
    }
  }
}
