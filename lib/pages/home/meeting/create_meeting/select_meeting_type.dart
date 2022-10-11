import 'package:flutter/material.dart';
import 'package:pepala/core/providers/create_meeting.dart';
import 'package:provider/provider.dart';

class SelectMeetingType extends StatelessWidget {
  const SelectMeetingType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey<String>('bottom-sliver-list');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Consumer<CreateMeetingProvider>(
          builder: (context, data, child) =>
              Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "What do you want?",
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    onChanged: data.onSearchTextChanged,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search),
                      hintText: "Choose profile type",
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 15, 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: CustomScrollView(
                      scrollDirection: Axis.vertical,
                      center: centerKey,
                      slivers: [
                        SliverList(
                          key: centerKey,
                          delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: InkWell(
                                  onTap: () => data.selectType(context, index),
                                  child: data.searchResult[index],
                                ),
                              );
                            },
                            childCount: data.searchResult.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
