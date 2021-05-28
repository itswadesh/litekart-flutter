import 'package:flutter/material.dart';

nextCardButton() {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25),
            topRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            topLeft: Radius.circular(25))),
    child: Container(
        margin: EdgeInsets.all(3),
        child: Icon(
          Icons.arrow_forward,
          color: Colors.deepPurple,
        )),
  );
}
