import 'dart:async';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

// Model przechowujący obliczone dane, aby uniknąć powtarzania kodu
class TimeData {
      final String title;
        final String data;
          TimeData(this.title, this.data);
}

// Funkcja obliczająca czas - może być używana zarówno w UI, jak i w tle
TimeData calculateTime() {
      final now = DateTime.now();
        final targetTime = DateTime(now.year, now.month, now.day, 6, 15);
          String title;
            String data;

              Duration difference;
                if (now.isBefore(targetTime)) {
                        // Przypadek 1: Przed 6:15 dzisiaj
                            final yesterdayTarget = targetTime.subtract(const Duration(days: 1));
                                final totalMinutes = now.difference(yesterdayTarget).inMinutes;

                                    if (totalMinutes > 1000) {
                                              // Jeśli od 6:15 wczoraj minęło więcej niż 1000 min, to liczymy w dół do 6:15 dzisiaj
                                                    difference = targetTime.difference(now);
                                                          title = "Zostało do 6:15";
                                                                data = "${difference.inMinutes} min";
                                    } else {
                                              // Jeśli nie, to nadal liczymy w górę od 6:15 wczoraj
                                                    title = "Minęło od 6:15";
                                                          data = "$totalMinutes min";
                                    }

                } else {
                        // Przypadek 2: Po 6:15 dzisiaj
                            difference = now.difference(targetTime);
                                if (difference.inMinutes <= 1000) {
                                          // Liczymy w górę do 1000 minut
                                                title = "Minęło od 6:15";
                                                      data = "${difference.inMinutes} min";
                                } else {
                                          // Liczymy w dół do 6:15 jutro
                                                final nextDayTarget = targetTime.add(const Duration(days: 1));
                                                      difference = nextDayTarget.difference(now);
                                                            title = "Zostało do 6:15";
                                                                  data = "${difference.inMinutes} min";
                                }
                }
                  return TimeData(title, data);
}

// Funkcja wywoływana w tle. Musi być na najwyższym poziomie (poza klasą).
@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? uri) async {
      if (uri?.host == 'update_widget') {
            final timeData = calculateTime();
                await HomeWidget.saveWidgetData<String>('widget_title', timeData.title);
                    await HomeWidget.saveWidgetData<String>('widget_data', timeData.data);
                        await HomeWidget.updateWidget(name: 'ClockWidgetProvider', iOSName: 'ClockWidgetProvider');
      }
}

void main() {
      WidgetsFlutterBinding.ensureInitialized();
        HomeWidget.registerBackgroundCallback(backgroundCallback);
          runApp(const MyApp());
}

class MyApp extends StatelessWidget {
      const MyApp({super.key});

        @override
          Widget build(BuildContext context) {
                return MaterialApp(
                          title: 'Clock 1000',
                                theme: ThemeData.dark(useMaterial3: true),
                                      home: const MyHomePage(),
                );
          }
}

class MyHomePage extends StatefulWidget {
      const MyHomePage({super.key});

        @override
          State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
      TimeData _timeData = TimeData("Ładowanie...", "");
        Timer? _timer;

          @override
            void initState() {
                    super.initState();
                        _initForWidget();
                            _startTimer();
            }

              void _initForWidget() {
                    HomeWidget.scheduleBackgroundUpdate(frequency: const Duration(minutes: 15));
                        _updateWidget();
              }

                void _startTimer() {
                        _updateTime(); 
                            _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _updateTime());
                }

                  void _updateTime() {
                        setState(() {
                                  _timeData = calculateTime();
                        });
                  }
                    
                      Future<void> _updateWidget() async {
                            final timeData = calculateTime();
                                await HomeWidget.saveWidgetData<String>('widget_title', timeData.title);
                                    await HomeWidget.saveWidgetData<String>('widget_data', timeData.data);
                                        await HomeWidget.updateWidget(name: 'ClockWidgetProvider', iOSName: 'ClockWidgetProvider');
                      }

                        @override
                          void dispose() {
                                _timer?.cancel();
                                    super.dispose();
                          }

                            @override
                              Widget build(BuildContext context) {
                                    return Scaffold(
                                              appBar: AppBar(
                                                        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                                                                title: const Text("Clock 1000"),
                                              ),
                                                    body: Center(
                                                                child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: <Widget>[
                                                                                                        Text(
                                                                                                                          _timeData.data,
                                                                                                                                        style: Theme.of(context).textTheme.headlineMedium,
                                                                                                        ),
                                                                                                                    Text(
                                                                                                                                      _timeData.title,
                                                                                                                    ),
                                                                                        ],
                                                                ),
                                                    ),
                                                          floatingActionButton: FloatingActionButton(
                                                                    onPressed: _updateWidget,
                                                                            tooltip: 'Odśwież widżet',
                                                                                    child: const Icon(Icons.update),
                                                          ),
                                    );
                              }
}

                                                          )
                                                                                                                    )
                                                                                                        )
                                                                                        ]
                                                                )
                                                    )
                                              )
                                    )
                              }
                          }
                      }
                        })
                  }
                }
              }
            }
}
}
                )
          }
}
}
      }
}
                                }
                                }
                }
                                    }
                                    }
                }
}
}