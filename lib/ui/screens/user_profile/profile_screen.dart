import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.from});
  final String? from;
  @override
  State<ProfileScreen> createState() => HomeScreenState();

}

class HomeScreenState extends State<ProfileScreen>{
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}