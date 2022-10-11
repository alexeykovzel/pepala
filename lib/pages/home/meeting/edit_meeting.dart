import 'package:flutter/material.dart';
import 'package:pepala/core/models/meeting.dart';
import 'package:pepala/core/providers/user_data.dart';
import 'package:pepala/widgets/google_map.dart';
import 'package:pepala/widgets/meeting_type.dart';
import 'package:provider/provider.dart';

class EditMeetingPage extends StatelessWidget {
  const EditMeetingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Consumer<UserData>(
            builder: (context, user, child) {
              MeetingModel? currentMeeting = user.currentMeeting;
              if (currentMeeting == null) return const CircularProgressIndicator();
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Title(text: 'Current Meeting', fontSize: 15),
                  const Title(text: "Type", fontSize: 15),
                  MeetingType(
                    value: currentMeeting.type ?? 'Undefined',
                    icon: const Icon(Icons.coffee),
                  ),
                  const Title(text: "Location", fontSize: 15),
                  Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                    ),
                    child: ChangeNotifierProvider(
                      create: (_) => MapModel(),
                      child: TrackerMap(
                        initialPosition: currentMeeting.location,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await user.leaveMeeting();
                      Navigator.maybePop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class Title extends StatelessWidget {
  final String text;
  final double? fontSize;

  const Title({Key? key, required this.text, required this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize ?? 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
