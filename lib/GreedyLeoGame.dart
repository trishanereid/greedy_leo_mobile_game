import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';



class GreedyLeoGame extends StatefulWidget {
  const GreedyLeoGame({super.key});

  @override
  State<GreedyLeoGame> createState() => _GreedyLeoGameState();
}

class _GreedyLeoGameState extends State<GreedyLeoGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.red,
        ),
      ),
    );
  }
}
