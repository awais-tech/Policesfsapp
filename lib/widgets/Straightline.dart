import 'package:flutter/material.dart';

class Straightline extends StatelessWidget {
  const Straightline({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0,
      width: 1.0,
      color: Colors.grey.withOpacity(0.5),
      margin: const EdgeInsets.only(left: 00.0, right: 10.0),
    );
  }
}
