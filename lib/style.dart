import 'package:flutter/material.dart';


class Avatar extends StatelessWidget {
  final String avatarUrl;
  final double width;
  final double height;

  const Avatar({
    required this.avatarUrl,
    this.width = 60,
    this.height = 60,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(50),
          image:
              DecorationImage(image: AssetImage(avatarUrl), fit: BoxFit.cover)),
    );
  }
}
