import 'package:flutter/material.dart';
import 'package:pepala/core/models/profile.dart';
import 'package:pepala/core/providers/user_data.dart';
import 'package:pepala/core/routes.dart';
import 'package:pepala/core/providers/auth/google_auth.dart';
import 'package:pepala/widgets/custom_buttons.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserData>(
        builder: (context, data, child) {
          Profile? user = data.profile;
          if (user == null) return Container();

          List<String> infoFields = [
            'Bio: ${user.bio}',
            'Nationality: ${user.nationality}',
            'Gender: ${user.gender}',
            'Age: ${user.age.toString()}',
            'University: ${user.university}',
            'Course: ${user.course}',
            'CourseYear: ${user.courseYear.toString()}',
            'Hobbies: ${user.hobbies!.join(', ')}',
            'Phone: ${user.phone}',
            'Email: ${user.email}',
          ];

          return CustomScrollView(
            shrinkWrap: true,
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 320.0,
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1.3,
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: user.name!,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: '\nonline',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 20),
                  background: Image.network(user.photoUrl!, fit: BoxFit.fitWidth),
                ),
              ),
              SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        infoFields[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  },
                  childCount: infoFields.length,
                ),
                itemExtent: 60,
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 100),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    height: 50,
                    child: OutlinedButton(
                        onPressed: () async {
                          await context.read<GoogleAuthService>().handleSignOut();
                          context.read<Routes>().pushReplacement(AppRoute.auth.get());
                        },
                        child: const Text('Log Out')),
                  ),
                ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
