import 'package:flutter/cupertino.dart';
import 'package:pepala/widgets/google_map.dart';
import 'package:provider/provider.dart';

class TrackerPage extends StatelessWidget {
  const TrackerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapModel(),
      child: const TrackerMap(),
    );
  }
}
