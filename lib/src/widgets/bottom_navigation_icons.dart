import 'package:flutter/material.dart';
import 'package:food_order_app/src/widgets/custom_text.dart';

class BottomNavIcon extends StatelessWidget {

  final String image;
  final String name;
  final Function onTap;

  BottomNavIcon({@required this.image, this.name, this.onTap});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap ?? null,
        child: Column(
          children: <Widget>[
            Image.asset(
              "images/$image",
              width: 20,
              height: 20,
            ),
            SizedBox(height: 2,),
            CustomText(text: name,)
          ],
        ),
      ),
    );
  }
}
