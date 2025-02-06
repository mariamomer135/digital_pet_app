import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(DigitalPetApp());
}

class DigitalPetApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PetHomePage(),
    );
  }
}

class PetHomePage extends StatefulWidget {
  @override
  _PetHomePageState createState() => _PetHomePageState();
}

class _PetHomePageState extends State<PetHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int happiness = 50;
  int hunger = 50;
  late Timer _statusTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    
    _statusTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          happiness = (happiness - 5).clamp(0, 100);
          hunger = (hunger + 5).clamp(0, 100);
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _statusTimer.cancel(); 
    super.dispose();
  }

  void feedPet() {
    setState(() {
      hunger = (hunger - 10).clamp(0, 100);
      happiness = (happiness + 5).clamp(0, 100);
    });
  }

  void playWithPet() {
    setState(() {
      happiness = (happiness + 10).clamp(0, 100);
      hunger = (hunger + 5).clamp(0, 100);
    });
  }

  String getMood() {
    return happiness > 40 ? 'Happy' : 'Sad';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Digital Pet"),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "Dog 🐶"),
              Tab(text: "Cat 🐱"),
              Tab(text: "Bunny 🐰"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            buildPetPage("Dog 🐶", Colors.blue),
            buildPetPage("Cat 🐱", Colors.orange),
            buildPetPage("Bunny 🐰", Colors.pink),
          ],
        ),
      ),
    );
  }

  Widget buildPetPage(String pet, Color color) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            pet,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(getMood() == 'Happy' ? '😃' : '😢', style: TextStyle(fontSize: 100)),
          SizedBox(height: 20),
          Text("Hunger: $hunger", style: TextStyle(fontSize: 20)),
          Text("Happiness: $happiness", style: TextStyle(fontSize: 20)),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: feedPet,
                child: Text("Feed 🍖"),
              ),
              ElevatedButton(
                onPressed: playWithPet,
                child: Text("Play 🎾"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
