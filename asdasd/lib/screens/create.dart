import 'package:flutter/material.dart';
import 'dart:math';

class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // color: Colors.white60,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NumberRow(),
            NumberRow(),
            NumberRow(),
            NumberRow(),
            NumberRow(),
          ],
        ),
      ),
    );
  }
}

class NumberRow extends StatelessWidget {
  const NumberRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NumberText(),
        NumberText(),
        NumberText(),
        NumberText(),
        NumberText(),
        NumberText(),
      ],
    );
  }
}

class NumberText extends StatelessWidget {
  const NumberText({
    Key? key,
  }) : super(key: key);

  int nextNumber({required int min, required int max}) =>
      min + Random().nextInt(max - min + 1);

  List<int> nextNumbers(int length, {required int min, required int max}) {
    final numbers = Set<int>();

    while (numbers.length < length) {
      final number = nextNumber(min: min, max: max);
      numbers.add(number);
    }
    return List.of(numbers);
  }

  @override
  Widget build(BuildContext context) {
    final list = nextNumbers(6, min: 1, max: 42);
    return Text(
      '11',
      style: TextStyle(
        color: Colors.white,
        fontSize: 30.0,
        backgroundColor: Colors.blueGrey, // 랜덤컬러 넣기
      ),
    );
  }
}
