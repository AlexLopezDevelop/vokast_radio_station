import 'package:flutter/material.dart';
import 'feed.dart';

const maxHeight = 350.0;
const minHeight = 70.0;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Feed());
  }
}
