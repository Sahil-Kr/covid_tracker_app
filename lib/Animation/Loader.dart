import 'dart:math';
import 'package:covid_tracker_app/Animation/Dot.dart';
import 'package:flutter/material.dart';

Widget getAnimation(context, animationRotation, radius) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      decoration: BoxDecoration(color: Color.fromARGB(30, 149, 7, 64)),
      child: (Center(
        child: RotationTransition(
          turns: animationRotation,
          child: Stack(
            children: <Widget>[
              /*Dot(
                    radius: 15.0,
                    color: Colors.blueGrey,
                  ),*/
              Transform.translate(
                offset: Offset(radius * cos(pi / 4), radius * sin(pi / 4)),
                child: Dot(
                  radius: 6.0,
                  color: Color.fromARGB(255, 149, 7, 64),
                ),
              ),
              Transform.translate(
                offset:
                Offset(radius * cos(2 * pi / 4), radius * sin(2 * pi / 4)),
                child: Dot(
                  radius: 6.0,
                  color: Color.fromARGB(255, 149, 7, 64),
                ),
              ),
              Transform.translate(
                offset:
                Offset(radius * cos(3 * pi / 4), radius * sin(3 * pi / 4)),
                child: Dot(
                  radius: 6.0,
                  color: Color.fromARGB(255, 149, 7, 64),
                ),
              ),
              Transform.translate(
                offset:
                Offset(radius * cos(4 * pi / 4), radius * sin(4 * pi / 4)),
                child: Dot(
                  radius: 6.0,
                  color: Color.fromARGB(255, 149, 7, 64),
                ),
              ),
              Transform.translate(
                offset:
                Offset(radius * cos(5 * pi / 4), radius * sin(5 * pi / 4)),
                child: Dot(
                  radius: 6.0,
                  color: Color.fromARGB(255, 149, 7, 64),
                ),
              ),
              Transform.translate(
                offset:
                Offset(radius * cos(6 * pi / 4), radius * sin(6 * pi / 4)),
                child: Dot(
                  radius: 6.0,
                  color: Color.fromARGB(255, 149, 7, 64),
                ),
              ),
              Transform.translate(
                offset:
                Offset(radius * cos(7 * pi / 4), radius * sin(7 * pi / 4)),
                child: Dot(
                  radius: 6.0,
                  color: Color.fromARGB(255, 149, 7, 64),
                ),
              ),
              Transform.translate(
                offset:
                Offset(radius * cos(8 * pi / 4), radius * sin(8 * pi / 4)),
                child: Dot(
                  radius: 6.0,
                  color: Color.fromARGB(
                      255, 149, 7, 64) /*Color.fromARGB(255, 149, 7, 64)*/,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

