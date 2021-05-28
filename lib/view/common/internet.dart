import 'package:flutter/material.dart';

class Internet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/no-internet.png',
                scale: 2.5,
              ),
              SizedBox(
                height: 50.0,
              ),
              Text(
                'Ooooooooooooops!',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Color(0xFFED1164)),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'No internet Connection \nCheck your setting and try again.',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18.0, color: Color(0xFFED1164)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
