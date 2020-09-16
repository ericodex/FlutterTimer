// Por Ericod3

import 'package:ericFocusTimer/settings.dart';
import 'package:ericFocusTimer/timermodel.dart';
import 'package:ericFocusTimer/widgets.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'timer.dart';
import 'settings.dart';

void main() {
  runApp(MaterialApp(
    title: 'Tempo Útil',
    theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.deepOrange,
        splashColor: Colors.deepOrangeAccent,
        primaryIconTheme: IconThemeData(color: Colors.tealAccent[900])),
    home: Ertimer(),
  ));
}

class Ertimer extends StatefulWidget {
  @override
  _ErtimerState createState() => _ErtimerState();
}

class _ErtimerState extends State<Ertimer> {
  // Váriavel da class CountDownTimer do arquivo timer.dart
  final CountDownTimer timer = CountDownTimer();

  @override
  Widget build(BuildContext context) {
    //
    final List<PopupMenuItem<String>> menuItems = List<PopupMenuItem<String>>();
    menuItems.add(PopupMenuItem(
      value: 'Settings',
      child: Text('Settings'),
    ));

    // buid method
    double sizeX = MediaQuery.of(context).size.width;
    double sizeY = MediaQuery.of(context).size.height;

    // Chamando a função iniciar trabalho.
    timer.startTrabalho();

    //TextStyle txtBarra = TextStyle();

    return Scaffold(
      appBar: AppBar(
        title: Text('T E M P O'),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return menuItems.toList();
            },
            onSelected: (s) {
              gotoSettings(context);
            },
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth;
          return Center(
            child: Column(
              children: [
                Spacer(
                  flex: 1,
                ),
                Row(
                  children: [
                    Spacer(),
                    ProductivityButton(
                        icone: Icons.work,
                        text: 'Trabalho',
                        onPressed: () => timer.startTrabalho(),
                        size: 100),
                    Spacer(),
                    ProductivityButton(
                        text: 'Pausa',
                        icone: Icons.free_breakfast,
                        onPressed: () => timer.startPausa(true),
                        size: 100),
                    Spacer(),
                    ProductivityButton(
                        text: 'Descanço',
                        icone: Icons.local_hotel,
                        onPressed: () => timer.startPausa(false),
                        size: 100),
                    Spacer(),
                  ],
                ),
                Spacer(
                  flex: 3,
                ),
                Container(
                    width: sizeX / 1.5,
                    height: sizeY / 2.5,
                    padding: EdgeInsets.all(10),
                    child: StreamBuilder<Object>(
                        stream: timer.stream(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          TimerModel timer = (snapshot.data == '00:00')
                              ? TimerModel('00:00', 1)
                              : snapshot.data;
                          return Expanded(
                            child: CircularPercentIndicator(
                              progressColor: Colors.tealAccent,
                              backgroundColor: Colors.deepOrangeAccent,
                              radius: availableWidth / 2,
                              lineWidth: 15,
                              percent: timer.percent,
                              center: Text(
                                timer.time,
                                // ignore: deprecated_member_use
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          );
                        })),
                Spacer(
                  flex: 4,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ProductivityButton(
                            text: 'Iniciar',
                            icone: Icons.play_arrow,
                            onPressed: () => timer.startTimer(),
                            size: 140),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ProductivityButton(
                            text: 'Parar',
                            icone: Icons.stop,
                            onPressed: () => timer.stopTimer(),
                            size: 140),
                      ),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CircularPercentIndicatorModel {
  Text text;
  double percent;
}

void gotoSettings(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => SettingsPage()));
}
