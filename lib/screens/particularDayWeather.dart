import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:weather/weather.dart';

class ParticularDayWeather extends StatefulWidget {
  final int index;
  ParticularDayWeather(this.index);
  @override
  _ParticularDayWeatherState createState() => _ParticularDayWeatherState();
}

class _ParticularDayWeatherState extends State<ParticularDayWeather> {
  String currentLocationName = 'Fetching your location';

  WeatherFactory wf;
  Location location = Location();
  LocationData currentLocationData;
  List<Weather> fiveDaysWeatherForecast = [];

  bool loading = true;
  List<Weather> list;

  _getCurrentLocation() async {
    try {
      setState(() {
        loading = true;
      });
      var data = await location.getLocation();
      if (data != null) {
        setState(() {
          currentLocationData = data;
        });
      } else {
        Fluttertoast.showToast(
            msg: 'Error fetching your location!,try again!',
            textColor: Colors.white,
            backgroundColor: Colors.black);
      }
    } catch (err) {
      Fluttertoast.showToast(
          msg: err, textColor: Colors.white, backgroundColor: Colors.black);
    }
  }

  _getFiveDaysWeatherForecast() async {
    try {
      setState(() {
        loading = true;
      });
      var data = await location.getLocation();
      setState(() {
        currentLocationData = data;
      });
      if (currentLocationData != null) {
        var res = await wf.fiveDayForecastByLocation(
            currentLocationData.latitude, currentLocationData.longitude);
        setState(() {
          fiveDaysWeatherForecast = res;
        });
        if (fiveDaysWeatherForecast != null) {
          setState(() {
            currentLocationName = fiveDaysWeatherForecast[0].areaName;
            loading = false;
          });
        } else {
          setState(() {
            loading = false;
          });
          Fluttertoast.showToast(
              msg: 'Error fetching your location!',
              textColor: Colors.white,
              backgroundColor: Colors.black);
        }
      } else {
        setState(() {
          loading = false;
        });
        Fluttertoast.showToast(
            msg: 'Error fetching your location!',
            textColor: Colors.white,
            backgroundColor: Colors.black);
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
          msg: e, textColor: Colors.white, backgroundColor: Colors.black);
    }
  }

  @override
  void initState() {
    super.initState();
    wf = WeatherFactory('5d862ae56bf1f683b1452ed1444ff86d',
        language: Language.ENGLISH);
    _getCurrentLocation();
    _getFiveDaysWeatherForecast();
  }

  @override
  Widget build(BuildContext context) {
    list = fiveDaysWeatherForecast
        .where((weather) =>
            weather.date.toString().substring(0, 10) ==
            DateTime.now()
                .add(Duration(days: widget.index))
                .toString()
                .substring(0, 10))
        .toList() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(currentLocationName),
        leading: loading
            ? Padding(
                padding: EdgeInsets.all(15),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : IconButton(
                tooltip: 'Fetch latest data',
                icon: Icon(FlutterIcons.my_location_mdi),
                onPressed: () async {
                  _getCurrentLocation();
                  _getFiveDaysWeatherForecast();
                }),
      ),
      body: loading
          ? Center(
              child: Text(
                'Fetching current data!\nPlease wait for the process to complete!',
                textScaleFactor: 1.3,
              ),
            )
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: Text(
                        '${((((list[index].temperature).celsius) * 100).toInt() / 100.0).toString()} °C',
                        textScaleFactor: 4,
                      ),
                      subtitle: Wrap(
                        children: <Widget>[
                          Icon(Icons.chevron_right),
                          Text(list[index].weatherMain),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text(
                          'Time : ${DateFormat.jm().format(list[index].date)}'),
                    ),
                    ListTile(
                      leading: Image.network(
                          'http://openweathermap.org/img/wn/${list[index].weatherIcon}@2x.png'),
                      title: Text(
                          '${list[index].weatherMain} , ${list[index].weatherDescription}'),
                    ),
                    ListTile(
                      leading: Icon(FlutterIcons.md_rainy_ion),
                      title: Text(
                          'Rainfall in last 1 hour : ${list[index].rainLastHour} mm'),
                      subtitle: Text(
                          'Rainfall in last 3 hours : ${list[index].rainLast3Hours} mm'),
                    ),
                    ListTile(
                      leading: Icon(FlutterIcons.weather_snowy_heavy_mco),
                      title: Text(
                          'Snowfall in last 1 hour : ${list[index].snowLastHour} mm'),
                      subtitle: Text(
                          'Snowfall in last 3 hours : ${list[index].snowLast3Hours} mm'),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: ListTile(
                            leading: Icon(
                              FlutterIcons.md_thermometer_ion,
                              color: Colors.redAccent,
                            ),
                            title: Text(
                                'Temperature Felt ${((((list[index].tempFeelsLike).celsius) * 100).toInt() / 100.0).toString()} °C'),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ListTile(
                              leading: Icon(
                                FlutterIcons.wi_humidity_wea,
                                color: Colors.blueAccent,
                              ),
                              title: Text(
                                  'Humidity ${((((list[index].humidity)) * 100).toInt() / 100.0).toString()} %')),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: ListTile(
                            title: Text(
                                'Wind Speeed ${((list[index].windSpeed * 1800).toInt()) / 500.0} Km/h'),
                            leading: Icon(
                              FlutterIcons.wind_fea,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ListTile(
                              leading: Icon(
                                FlutterIcons.gauge_ent,
                                color: Colors.blue,
                              ),
                              title: Text(
                                  'Air Pressure ${((((list[index].pressure)) * 100).toInt() / 100.0).toString()} Pa')),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              }),
    );
  }
}
