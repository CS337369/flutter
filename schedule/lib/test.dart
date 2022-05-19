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

class Test2 extends StatefulWidget {
  const Test2({Key? key}) : super(key: key);

  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  // late final ValueNotifier<List<Event>> _selectedEvents;
  Map<DateTime, List<Event>>? selectedEvents;
  TextEditingController _eventController = TextEditingController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _eventController = TextEditingController();
    selectedEvents = {};
    _selectedDay = _focusedDay;
    prefsData();
  }

  // @override
  // void dispose() {
  //   _selectedEvents.dispose();
  //   super.dispose();
  // }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return selectedEvents?[day] ?? [];
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
            // var formatter = DateFormat.yMMMMd('ko-KR').format(selectDay);
            onDayLongPressed: (selectDay, focusDay) {
              _showAddDialog();
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
          // Expanded(),
        ],
      ),
    );
  }

  _showAddDialog() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white70,
        title: Text("Add Events"),
        content: TextField(
          controller: _eventController,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Save",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              if (_eventController.text.isEmpty) return;
              setState(() {
                if (selectedEvents?[_selectedDay] != null) {
                  selectedEvents![_selectedDay]!
                      .add(Event(_eventController.text));
                }
                pref.setString("title", json.encode(_eventController.text));
                _eventController.clear();
                Navigator.pop(context);
              });
            },
          )
        ],
      ),
    );
  }

  prefsData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      selectedEvents = Map<DateTime, List<Event>>.from(
          json.decode(pref.getString("title") ?? "{}"));
    });
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
        GestureDetector(
          onTap: () {
            // if (_textController.text.isEmpty) {
            //   Navigator.pop(context);
            // } else {
            //   if (selectedEvent?[selectDay] != null) {
            //     selectedEvent?[selectDay]?.add(
            //       Event(title: _textController.text),
            //     );
            //   } else {
            //     selectedEvent?[selectDay!] = [
            //       Event(title: _textController.text),
            //     ];
            //   }
            // }

            // setState(() {
            //   if (_textController.text.isEmpty) {
            //     Navigator.pop(context);
            //   } else {
            //     if (_textController.text.isNotEmpty) {
            //       if (widget.selectDay != null) {
            //         selectedEvents.addAll({
            //           widget.selectDay!: [Event(_textController.text)]
            //         });
            //       }
            //     }
            //   }
            // });

            Navigator.pop(context);
            _textController.clear();

            return;
          },
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ],
    );
  }
}
