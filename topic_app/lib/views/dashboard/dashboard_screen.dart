import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topic_app'),
      ),
      body: Center(
        child: Text('Dashboard'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          Navigator.of(context).pushNamed(
              AppRoutes.design);
        },
        child: const Icon(Icons.add), // Add icon for the floating action button
      ),
    );
  }
}
