import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pepala/core/db/user_repository.dart';
import 'package:pepala/core/models/meeting.dart';
import 'package:pepala/core/models/profile.dart';
import 'package:pepala/core/providers/user_data.dart';
import 'package:pepala/core/routes.dart';
import 'package:pepala/widgets/custom_buttons.dart';
import 'package:provider/provider.dart';

class CurrentMeetingPage extends StatelessWidget {
  const CurrentMeetingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<UserData>(
        builder: (context, data, child) {
          MeetingModel? meeting = data.currentMeeting;
          return meeting == null
              ? const _CreateMeetingButton()
              : Column(
                  children: [
                    _MeetingNavigationBar(type: meeting.type.toString()),
                    StreamBuilder(
                      stream: meeting.requests,
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text("Loading");
                        }

                        return ListView(
                          shrinkWrap: true,
                          children: snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                            String userUid = data['user_uid'];
                            Timestamp sentTime = data['sent_time'];
                            int duration = (Timestamp.now().seconds - sentTime.seconds) ~/ 60;

                            return FutureBuilder(
                              future: UserRepository().get(userUid),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                  case ConnectionState.active:
                                    return const RequestContainer(
                                      child: CircularProgressIndicator(),
                                    );

                                  case ConnectionState.done:
                                    Profile? user = snapshot.data as Profile?;
                                    if (user != null) {
                                      return _RequestOverview(
                                        name: user.name,
                                        bio: user.bio,
                                        age: user.age,
                                        photoUrl: user.photoUrl,
                                        duration: duration,
                                      );
                                    }
                                }
                                return Container();
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                );
        },
      ),
    );
  }
}

/// Button to start a profile creating.
class _CreateMeetingButton extends StatelessWidget {
  const _CreateMeetingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Spacer(),
          const Text(
            "There are no current meetings\nyou have created.\nMay be try to create one?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () => context.read<Routes>().push(AppRoute.createMeeting.get()),
            child: const BasicButtonContainer(
              text: 'Create Meeting',
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class RequestContainer extends StatelessWidget {
  final Widget child;

  const RequestContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.black38),
      ),
      height: 150,
      child: child,
    );
  }
}

/// Overview of the join request for the user's current meeting.
class _RequestOverview extends StatelessWidget {
  final String? photoUrl;
  final String? name;
  final String? bio;
  final int duration;
  final int? age;

  const _RequestOverview({
    Key? key,
    required this.name,
    required this.age,
    required this.duration,
    required this.bio,
    this.photoUrl = '', // TODO: Set incognito image.
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RequestContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                ),
                height: 40,
                width: 40,
              ),
              Column(
                children: [
                  SizedBox(
                    width: 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 20),
                        Text(
                          name ?? 'Incognito',
                          style: const TextStyle(fontSize: 24),
                        ),
                        const Spacer(),
                        Text(
                          duration.toString() + ' min',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 20),
                        Text(bio ?? ''),
                        const Spacer(),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => context.read<Routes>().pushReplacement(AppRoute.userOverview.get()),
                icon: const Icon(Icons.person_search),
              ),
              IconButton(
                onPressed: () => 1,
                icon: const Icon(Icons.done),
              ),
              IconButton(
                onPressed: () => 1,
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Meeting navigation bar for the user's current meeting.
class _MeetingNavigationBar extends StatelessWidget {
  final String type;

  const _MeetingNavigationBar({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: context.read<UserData>().currentMeeting != null
          ? Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    type + ' meeting',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                      onPressed: () => context.read<Routes>().push(AppRoute.editMeeting.get()),
                      icon: const Icon(Icons.edit))
                ],
              ),
            )
          : Container(),
    );
  }
}
