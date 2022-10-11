import 'package:flutter/material.dart';

class UserOverview extends StatelessWidget {
  const UserOverview({Key? key}) : super(key: key);

  //TODO: a better way of creating the app (using maps and arrays)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 15),
            const Text(
              "John Doe",
              style: TextStyle(fontSize: 24),
            ),
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black54),
              ),
            ),
            const Divider(color: Colors.black87),
            const Text(
              "Bio",
              style: TextStyle(fontSize: 24),
            ),
            const Text("Lorem ipsum dolor sit amet amin"),
            const Divider(color: Colors.black87),
            const Text(
              "Hobbies",
              style: TextStyle(fontSize: 24),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ["music", "beer", "chess"]
                  .map((e) => Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Text(e),
                      ))
                  .toList(),
            ),
            const Divider(color: Colors.black87),
            const Text(
              "University",
              style: TextStyle(fontSize: 24),
            ),
            const Text("Twente"),
            const Divider(color: Colors.black87),
            const Text(
              "Other",
              style: TextStyle(fontSize: 24),
            ),
            const Text("data"),
            const Divider(color: Colors.black87),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                FilledIconButton(
                  icon: Icon(Icons.done),
                  color: Colors.green,
                ),
                FilledIconButton(
                  icon: Icon(Icons.close),
                  color: Colors.redAccent,
                ),
              ],
            )
          ],
        )),
      ),
    );
  }
}

class FilledIconButton extends StatelessWidget {
  const FilledIconButton({
    Key? key,
    required this.icon,
    required this.color,
  }) : super(key: key);
  final Icon icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
        color: color,
        shape: const CircleBorder(),
      ),
      child: IconButton(
        icon: icon,
        color: Colors.white,
        onPressed: () {},
      ),
    );
  }
}
