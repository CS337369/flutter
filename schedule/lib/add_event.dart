import 'package:flutter/material.dart';

class AddEvent extends StatelessWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 150.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {},
            child: Text('test'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: TextField(),
          ),
        ],
      ),
    );
  }
}
