import 'package:flutter/material.dart';
import 'package:iwill/pallete.dart';

class FeatureBox extends StatelessWidget {
    final Color color;
    final String headerText;
    final String descText;
    const FeatureBox({super.key,required this.color,required this.headerText,required this.descText});

    @override
    Widget build(BuildContext context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 35,vertical: 10),
        decoration: BoxDecoration(
          color:color,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            Text(headerText,
            style: TextStyle(
              fontFamily: 'Cera Pro',
              fontWeight: FontWeight.bold,
              color: Pallete.blackColor,
              fontSize: 18,
            ),
            ),
            Text(
              descText,
              style: TextStyle(
                fontFamily: 'Cera Pro',
                color: Pallete.blackColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }
  }
