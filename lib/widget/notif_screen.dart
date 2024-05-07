import 'package:flutter/material.dart';


class NotifScreen extends StatelessWidget {
  const NotifScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Icon(Icons.notifications),
      ),
    );
  }
}
