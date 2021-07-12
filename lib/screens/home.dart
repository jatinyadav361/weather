import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:weather/weather.dart';
import 'package:weatherapp/help.dart';
import 'package:weatherapp/screens/fiveDaysWeatherForecast.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  WeatherFactory wf;

  Location location = Location();
  LocationData _locationData;
  Weather w;

  bool locationLoading = true;

  _getCurrentLocation() async {
    try {
      var currentLocationData = await location.getLocation();
      if (currentLocationData != null) {
        setState(() {
          _locationData = currentLocationData;
        });
      } else {
        Fluttertoast.showToast(
            msg:
                "can't fetch your location! Make sure you have a healthy internet connection!",
            textColor: Colors.white,
            backgroundColor: Colors.black);
      }
    } catch (eee) {
      Fluttertoast.showToast(
          msg: eee, textColor: Colors.white, backgroundColor: Colors.black);
    }
  }

  _getCurrentWeather() async {
    try {
      var data = await location.getLocation();
      setState(() {
        locationLoading = true;
      });
      if (data != null) {
        setState(() {
          _locationData = data;
        });
        Weather res = await wf.currentWeatherByLocation(
            _locationData.latitude, _locationData.longitude);
        setState(() {
          w = res;
        });
        if (w != null) {
          setState(() {
            currentCity = w.areaName;
          });
        } else {
          Fluttertoast.showToast(
              msg: 'cannot fetch your location right now!, try again!',
              textColor: Colors.white,
              backgroundColor: Colors.black);
        }
        setState(() {
          locationLoading = false;
        });
      } else {
        Fluttertoast.showToast(
            msg:
                "can't fetch your location! Make sure you have a healthy internet connection!",
            textColor: Colors.white,
            backgroundColor: Colors.black);
      }
    } catch (err) {
      Fluttertoast.showToast(
          msg: err, textColor: Colors.white, backgroundColor: Colors.black);
    }
  }

  var currentCity = 'Fetching Your Location';

  choiceAction(String choice) {
    if (choice == Options.secondItem) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Help();
      }));
    }
    if (choice == Options.firstItem) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FiveDaysWeatherForecast();
      }));
    }
  }

  Widget getWidget(String choice) {
    if (choice == Options.secondItem) {
      return ListTile(
        title: Text(choice),
        leading: Icon(Icons.help),
      );
    }
    if (choice == Options.firstItem) {
      return ListTile(
        title: Text(choice),
        leading: Icon(FlutterIcons.wi_forecast_io_clear_day_wea),
      );
    }
    if (choice == Options.thirdItem) {
      return ListTile(
        title: Text(choice),
        leading: Icon(Icons.rate_review),
        onTap: () {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: 'This feature is not available currently!',
              textColor: Colors.white,
              backgroundColor: Colors.black);
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    wf = WeatherFactory('5d862ae56bf1f683b1452ed1444ff86d',
        language: Language.ENGLISH);
    _getCurrentLocation();
    _getCurrentWeather();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Wrap(
          direction: Axis.vertical,
          children: [
            Text(currentCity),
          ],
        ),
        leading: locationLoading
            ? Padding(
                padding: EdgeInsets.all(15),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : IconButton(
                icon: Icon(FlutterIcons.my_location_mdi),
                tooltip: 'Update Location',
                onPressed: () async {
                  try {
                    setState(() {
                      locationLoading = true;
                      currentCity = 'Updating location';
                    });
                    var data = await location.getLocation();
                    setState(() {
                      _locationData = data;
                    });
                    Weather res = await wf.currentWeatherByLocation(
                        _locationData.latitude, _locationData.longitude);
                    setState(() {
                      w = res;
                      currentCity = w.areaName;
                    });
                    setState(() {
                      locationLoading = false;
                    });
                  } catch (e) {
                    setState(() {
                      locationLoading = false;
                    });
                    Fluttertoast.showToast(
                        msg: e,
                        textColor: Colors.white,
                        backgroundColor: Colors.black);
                  }
                },
              ),
        actions: [
          PopupMenuButton<String>(
              icon: Icon(FlutterIcons.more_vertical_fea),
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return Options.choices.map((choice) {
                  return PopupMenuItem<String>(
                      value: choice, child: getWidget(choice));
                }).toList();
              }),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 5, right: 5, top: 5),
              child: w != null
                  ? Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Current Weather',
                            textScaleFactor: 1.2,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          title: Text(
                            '${((((w.temperature).celsius) * 100).toInt() / 100.0).toString()} °C',
                            textScaleFactor: 4,
                          ),
                          subtitle: Wrap(
                            children: <Widget>[
                              Icon(Icons.chevron_right),
                              Text(w.weatherMain),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Text(
                              'Your Location : ${w.areaName} [${w.country}]'),
                        ),
                        ListTile(
                          leading: Image.network(
                              'http://openweathermap.org/img/wn/${w.weatherIcon}@2x.png'),
                          title: Text(
                              '${w.weatherMain} , ${w.weatherDescription}'),
                        ),
                        ListTile(
                          leading: Icon(
                            FlutterIcons.today_mdi,
                            color: Color.fromRGBO(100, 149, 189, 1),
                          ),
                          title: Text(
                              '${DateFormat.EEEE().format(DateTime.now())} , ${DateFormat.yMMMMd().format(DateTime.now())}'),
                        ),
                        ListTile(
                          leading: Icon(FlutterIcons.md_rainy_ion),
                          title: Text(
                              'Rainfall in last 1 hour : ${w.rainLastHour} mm'),
                          subtitle: Text(
                              'Rainfall in last 3 hours : ${w.rainLast3Hours} mm'),
                        ),
                        ListTile(
                          leading: Icon(FlutterIcons.weather_snowy_heavy_mco),
                          title: Text(
                              'Snowfall in last 1 hour : ${w.snowLastHour} mm'),
                          subtitle: Text(
                              'Snowfall in last 3 hours : ${w.snowLast3Hours} mm'),
                        ),
                        FlatButton.icon(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return FiveDaysWeatherForecast();
                              }));
                            },
                            icon: Icon(Icons.chevron_right),
                            label: Text('5 days weather forecast')),
                        Divider(
                          height: 15,
                          thickness: 1,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: ListTile(
                                leading: Icon(
                                  FlutterIcons.sunrise_fea,
                                  color: Color.fromRGBO(222, 111, 64, 1),
                                ),
                                title: Text(
                                    'Sunrise  ${DateFormat.jm().format(w.sunrise)}'),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: ListTile(
                                leading: Icon(
                                  FlutterIcons.sunset_fea,
                                  color: Color.fromRGBO(222, 122, 64, 1),
                                ),
                                title: Text(
                                    'Sunset  ${DateFormat.jm().format(w.sunset)}'),
                              ),
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
                                leading: Icon(
                                  FlutterIcons.md_thermometer_ion,
                                  color: Colors.redAccent,
                                ),
                                title: Text(
                                    'Temperature Felt ${((((w.tempFeelsLike).celsius) * 100).toInt() / 100.0).toString()} °C'),
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
                                      'Humidity ${((((w.humidity)) * 100).toInt() / 100.0).toString()} %')),
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
                                    'Wind Speeed ${((w.windSpeed * 1800).toInt()) / 500.0} Km/h'),
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
                                      'Air Pressure ${((((w.pressure)) * 100).toInt() / 100.0).toString()} Pa')),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    )
                  : Card(
                      child: ListTile(
                        title: Text('Fetching your location!'),
                        subtitle: Text(
                            'If location is not fetched automatically,then click on location icon to fetch your current location!'),
                      ),
                    )),
        ],
      ),
    );
  }
}

class Options {
  static const String firstItem = 'Five Days Weather Forecast';
  static const String secondItem = 'Help';
  static const String thirdItem = 'Rate this app';

  static const List<String> choices = [firstItem, secondItem, thirdItem];
}
