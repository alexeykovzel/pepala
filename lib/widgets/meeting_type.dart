import 'package:flutter/material.dart';

class MeetingType extends StatelessWidget {
  final Icon icon;
  final String value;

  const MeetingType({
    Key? key,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black45),
      ),
      child: Row (
        children: [
          icon,
          const SizedBox(width: 10),
          Text(value),
        ],
      ),
    );
  }
}
