import 'package:auto_size_text/auto_size_text.dart';
import 'package:covid_19/constant.dart';
import 'package:flutter/material.dart';

class Counter extends StatelessWidget {
  final int number;
  final Color color;
  final String title;
  const Counter({
    Key key,
    this.number,
    this.color,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(6),
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(.26),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: color,
                width: 2,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Container(
            child: Center(
              child: AutoSizeText(
                "$number",
                style: TextStyle(
                  fontSize: 40,
                  color: color,
                ),
                maxLines: 1,
                minFontSize: 10,
                maxFontSize: 20,
              ),
            ),
            width: width * 0.25,
          ),
        ),
        Text(title, style: kSubTextStyle),
      ],
    );
  }
}
