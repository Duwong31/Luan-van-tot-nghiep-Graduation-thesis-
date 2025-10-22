import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.from});
  final String? from;
  @override
  State<HomeScreen> createState() => HomeScreenState();

}

class HomeScreenState extends State<HomeScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text(
          'Home Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}