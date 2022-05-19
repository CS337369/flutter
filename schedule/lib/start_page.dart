import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:collection';

import 'even.dart';

/// todo: 다 뜯어 고쳐야 할 것 같다 첨부터
/// todo:0 이벤트 위로 올리면 달력 줄어들고 이벤트 창 커지게
/// todo:1 273line DateTime selectedDay로 바꾸기 & 껏다켜도 저장되게 바꾸기 (stf?)
/// todo:2 event가 있는 날짜 아래에 event.length 표시

////////////////////////////////////////////////////////////////////

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  late final ValueNotifier<List<Event>> _selectedEvents;
  Map<DateTime, List<Event>>? events;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  Future<void> prefsData() async {
    final SharedPreferences prefs = await _pref;
    setState(() {
      events = Map<DateTime, List<Event>>.from(
          decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  // @override
  // void dispose() {
  //   _selectedEvents.dispose();
  //   super.dispose();
  // }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        // _rangeStart = null; // Important to clean those
        // _rangeEnd = null;
        // _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: DateTime(1950),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },

            // day changed
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },

            onDaySelected: _onDaySelected,
            onDayLongPressed: (selectDay, focusDay) {
              var formatter = DateFormat.yMMMMd('ko-KR').format(selectDay);
              showStickyFlexibleBottomSheet<void>(
                minHeight: 0,
                initHeight: 0.5,
                maxHeight: .8,
                headerHeight: 200,
                context: context,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                headerBuilder: (context, offset) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(offset == 0.8 ? 0 : 40),
                        topRight: Radius.circular(offset == 0.8 ? 0 : 40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Center(
                              child: Center(
                                child: Text(
                                  formatter,
                                  style: TextStyle(
                                    fontSize: 30,
                                    // fontWeight: FontWeight.w400,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(5, 5),
                                        blurRadius: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // _TextField(),
                      ],
                    ),
                  );
                },
                bodyBuilder: (context, selectedDay) {
                  return SliverChildListDelegate(
                    // _children,
                    [
                      _TextField(
                        selectDay: _selectedDay,
                        // selectedEvent: _selectedEvents,
                      )
                    ],
                  );
                },
                anchors: [.2, 0.5, .8],
              );
            },
            eventLoader: _getEventsForDay,

            // to style calendar
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: Colors.white,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              todayTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
            ),
            locale: 'ko-KR',
          ),
          // ..._getEventsForDay(_selectedDay!).map(
          //   (Event event) => Text(event.title),
          // ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _children = [_TextField()];

class _TextField extends StatefulWidget {
  _TextField({this.selectDay, this.selectedEvent});

  final Map<DateTime, List<Event>>? selectedEvent;
  final DateTime? selectDay;

  @override
  State<_TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField> {
  final TextEditingController _textController = TextEditingController();

  List<String> todoList = [];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            controller: _textController,
            // onChanged: (msg) {
            //   toDo = msg;
            // },
            decoration: InputDecoration(
              // border: InputBorder.none,
              hintText: '일정을 추가하세요',
              hintStyle: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                // fontWeight: FontWeight.w400,
                shadows: [
                  Shadow(
                    color: Colors.grey,
                    offset: Offset(5, 5),
                    blurRadius: 60,
                  ),
                ],
              ),
            ),
          ),
        ),
        _gestureDetector(),
        // GestureDetector(
        //   onTap: () {
        //     // if (_textController.text.isEmpty) {
        //     //   Navigator.pop(context);
        //     // } else {
        //     //   if (selectedEvent?[selectDay] != null) {
        //     //     selectedEvent?[selectDay]?.add(
        //     //       Event(title: _textController.text),
        //     //     );
        //     //   } else {
        //     //     selectedEvent?[selectDay!] = [
        //     //       Event(title: _textController.text),
        //     //     ];
        //     //   }
        //     // }
        //     setState(() {
        //       if (_textController.text.isEmpty) {
        //         Navigator.pop(context);
        //       } else {
        //         if (_textController.text.isNotEmpty) {
        //           if (widget.selectDay != null) {
        //             kEvents.addAll({
        //               widget.selectDay!: [Event(_textController.text)]
        //             });
        //           }
        //         }
        //       }
        //     });
        //
        //     Navigator.pop(context);
        //     _textController.clear();
        //
        //     return;
        //   },
        //   child: Icon(
        //     Icons.add,
        //     size: 30,
        //   ),
        // ),
      ],
    );
  }

  _gestureDetector() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    GestureDetector(
      onTap: () {
        setState(() {
          if (_textController.text.isEmpty) {
            Navigator.pop(context);
          } else {
            if (_textController.text.isNotEmpty) {
              if (widget.selectDay != null) {
                kEvents.addAll({
                  widget.selectDay!: [Event(_textController.text)]
                });
              }
            }
          }
          pref.setString('title', json.encode(Event(_textController.text)));
        });

        Navigator.pop(context);
        _textController.clear();

        return;
      },
      child: Icon(
        Icons.add,
        size: 30,
      ),
    );
  }
}

// class _TestContainer extends State<StartPage> {
//   DateTime selectedDay = DateTime.now();
//   DateTime focusedDay = DateTime.now();
//
//   void todoList(selectedDay) {}
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         height: 50,
//         color: Colors.black12,
//       ),
//     );
//   }
// }
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
);
// )..addAll(_kEventSource);
//
// final _kEventSource = Map.fromIterable(
//   List.generate(kEvents[key], (index) => null),
// )..addAll({
//   kToday: [
//     Event('Today\'s Event 1'),
//     Event('Today\'s Event 2'),
//   ],
// });
