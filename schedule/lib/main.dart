import 'package:flutter/material.dart';
import 'package:schedule/add_event.dart';
import 'package:schedule/start_page.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:schedule/test.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TableCalendar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: StartPage(),
      initialRoute: '/',
      routes: {
        '/': (context) => StartPage(),
        '/add_event': (context) => AddEvent(),
        '/test': (context) => Test2(),
      },
    );
  }
}

// class StartPage extends StatefulWidget {
//   @override
//   _StartPageState createState() => _StartPageState();
// }
//
// class _StartPageState extends State<StartPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('TableCalendar Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20.0),
//             ElevatedButton(
//               child: Text('Basics'),
//               onPressed: () {},
//               // onPressed: () => Navigator.push(
//               //   context,
//               //   MaterialPageRoute(builder: (_) => TableBasicsExample()),
//               // ),
//             ),
//             const SizedBox(height: 12.0),
//             ElevatedButton(
//               child: Text('Range Selection'),
//               onPressed: () {},
//               // onPressed: () => Navigator.push(
//               //   context,
//               //   MaterialPageRoute(builder: (_) => TableRangeExample()),
//               // ),
//             ),
//             const SizedBox(height: 12.0),
//             ElevatedButton(
//               child: Text('Events'),
//               onPressed: () {},
//               // onPressed: () => Navigator.push(
//               //   context,
//               //   MaterialPageRoute(builder: (_) => TableEventsExample()),
//               // ),
//             ),
//             const SizedBox(height: 12.0),
//             ElevatedButton(
//               child: Text('Multiple Selection'),
//               onPressed: () {},
//               // onPressed: () => Navigator.push(
//               //   context,
//               //   MaterialPageRoute(builder: (_) => TableMultiExample()),
//               // ),
//             ),
//             const SizedBox(height: 12.0),
//             ElevatedButton(
//               child: Text('Complex'),
//               onPressed: () {},
//               // onPressed: () => Navigator.push(
//               //   context,
//               //   MaterialPageRoute(builder: (_) => TableComplexExample()),
//               // ),
//             ),
//             const SizedBox(height: 20.0),
//           ],
//         ),
//       ),
//     );
//   }
// }
