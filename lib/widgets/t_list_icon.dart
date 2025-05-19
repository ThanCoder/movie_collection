import 'package:flutter/cupertino.dart';

class TListIcon extends StatelessWidget {
  Widget icon;
  Widget title;
  TListIcon({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        icon,
        Expanded(child: title),
      ],
    );
  }
}
