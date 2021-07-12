import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/screens/particularDayWeather.dart';

class FiveDaysWeatherForecast extends StatefulWidget {
  @override
  _FiveDaysWeatherForecastState createState() =>
      _FiveDaysWeatherForecastState();
}

class _FiveDaysWeatherForecastState extends State<FiveDaysWeatherForecast> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
                '${DateFormat.EEEE().format(DateTime.now())} , ${DateFormat.yMMMMd().format(DateTime.now())}'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ParticularDayWeather(0);
              }));
            },
          ),
          ListTile(
            title: Text(
                '${DateFormat.EEEE().format(DateTime.now().add(Duration(days: 1)))} , ${DateFormat.yMMMMd().format(DateTime.now().add(Duration(days: 1)))}'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ParticularDayWeather(1);
              }));
            },
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ParticularDayWeather(2);
              }));
            },
            title: Text(
                '${DateFormat.EEEE().format(DateTime.now().add(Duration(days: 2)))} , ${DateFormat.yMMMMd().format(DateTime.now().add(Duration(days: 2)))}'),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ParticularDayWeather(3);
              }));
            },
            title: Text(
                '${DateFormat.EEEE().format(DateTime.now().add(Duration(days: 3)))} , ${DateFormat.yMMMMd().format(DateTime.now().add(Duration(days: 3)))}'),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ParticularDayWeather(4);
              }));
            },
            title: Text(
                '${DateFormat.EEEE().format(DateTime.now().add(Duration(days: 4)))} , ${DateFormat.yMMMMd().format(DateTime.now().add(Duration(days: 4)))}'),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ParticularDayWeather(5);
              }));
            },
            title: Text(
                '${DateFormat.EEEE().format(DateTime.now().add(Duration(days: 5)))} , ${DateFormat.yMMMMd().format(DateTime.now().add(Duration(days: 5)))}'),
          ),
        ],
      ),
    );
  }
}
