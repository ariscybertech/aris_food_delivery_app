import 'package:flutter/cupertino.dart';
import 'package:food_order_app/src/helpers/style.dart';

class SmallButton extends StatelessWidget {
  final IconData icon;

  SmallButton(this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: red,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(
            icon,
            size: 16.0,
            color: white,
          ),
        ),
      ),
    );
  }
}
