import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'SemiFilledCirclePainter.dart';

void main() {
  runApp(
      MaterialApp(
          home: GreedyLeoGame(),
          debugShowCheckedModeBanner: false
      )
  );
}

class GreedyLeoGame extends StatefulWidget {
  @override
  _GreedyLeoGameState createState() => _GreedyLeoGameState();
}

class _GreedyLeoGameState extends State<GreedyLeoGame> {
  int selectedBet = 16;
  int balance = 1000;
  int winAmount = 10000;

  int currentCircleIndex = 0;
  Timer? handTimer;
  bool isHandMoving = false;



  final List<Map<String, String>> foodItems = [
    {'image': 'assets/leg-piece.png', 'label': '25 Times'},
    {'image': 'assets/tuna.png', 'label': '15 Times'},
    {'image': 'assets/hot-dog.png', 'label': '10 Times'},
    {'image': 'assets/tomato.png', 'label': '5 Times'},
    {'image': 'assets/cabbage.png', 'label': '5 Times'},
    {'image': 'assets/corn.png', 'label': '5 Times'},
    {'image': 'assets/carrot.png', 'label': '5 Times'},
    {'image': 'assets/beef.png', 'label': '45 Times'},
  ];

  Set<int> selectedCircles = {};

  // Method to toggle circle selection
  void toggleSelection(int index) {
    setState(() {
      if (selectedCircles.contains(index)) {
        selectedCircles.remove(index);
      } else if (selectedCircles.length < 6) {
        selectedCircles.add(index);
      }
    });
  }

  void startHandMovement() {
    if (isHandMoving) return;
    setState(() {
      isHandMoving = true;
    });

    handTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentCircleIndex = (currentCircleIndex + 1) % foodItems.length;
      });

      // Stop after 30 seconds
      if (timer.tick >= 30) {
        timer.cancel();
        setState(() {
          isHandMoving = false;
        });
      }
    });
  }

  @override
  void dispose() {
    handTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    startHandMovement(); // Trigger hand movement when the app starts
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            alignment: Alignment(0, -0.3),
            fit: BoxFit.cover,
          ),

          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a2635),
              Color(0xFF0d1219)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFoodWheel(),
                    _buildResultRow()
                  ],
                ),
              ),
              _buildBalanceRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildCircularButton(Icons.emoji_events, Colors.cyan),
              const SizedBox(width: 5),
              _buildCircularButton(Icons.music_off_outlined, Colors.cyan),
            ],
          ),

          const Text(
            'GREEDYLEO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          Row(
            children: [
              _buildCircularButton(Icons.menu, Colors.cyan),
              const SizedBox(width: 5),
              _buildCircularButton(Icons.help_outline_rounded, Colors.cyan),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget _buildFoodWheel() {
    return Center(
      child: Stack(
        children: [
          const Image(
              image: AssetImage('assets/stand-without-circles.png'),
              width: 360,
              height: 535,
              fit: BoxFit.contain,
          ),

          for (int i = 0; i < foodItems.length; i++)
            Positioned(
              left: 138 + 150 * cos((i * 45) * (3.14159 / 180)) / 1.15,
              top: 128 - 150 * sin((i * 45) * (3.14159 / 180)) / 1.15,
              child: GestureDetector(
                onTap: () => toggleSelection(i),
                child: _semiFilledCircle(
                  size: 82,
                  image: foodItems[i]['image']!,
                  label: foodItems[i]['label']!,
                  isSelected: selectedCircles.contains(i),
                ),
              ),
            ),

          if (isHandMoving)
            Positioned(
              left: 160 + 150 * cos((currentCircleIndex * 45) * (3.14159 / 180)) / 1.15,
              top: 165 - 150 * sin((currentCircleIndex * 45) * (3.14159 / 180)) / 1.15,
              child: Image.asset(
                'assets/hand.png',
                width: 60,
                height: 60,
              ),
            ),

          Positioned(
              bottom: 55,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBetSelector(),
                ],
              )
          ),

          // Positioned(
          //     top: 500,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         _buildResultRow()
          //       ],
          //     )
          // )
        ],
      ),
    );
  }

  Widget _buildBetSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 38),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [10, 50, 100, 1000].map((amount) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedBet = amount;
                  });
                },
                child: _buildBetButton(amount),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // food circle
  Widget _semiFilledCircle({
    required double size,
    required String image,
    required String label,
    required bool isSelected,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isSelected
              ? [Colors.lightGreenAccent.shade200, Colors.lightGreenAccent.shade400]
              : [Colors.blue.shade600, Colors.blue.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Colors.green.shade500
                : Colors.blue.shade800,
            blurRadius: 0,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: CustomPaint(
        painter: SemiFilledCirclePainter(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 12,
              child: Image.asset(
                image,
                width: 37,
                height: 37,
                fit: BoxFit.contain,
              ),
            ),

            Positioned(
              bottom: 16,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBetButton(int amount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3.5),
      width: 65,
      height: 54,
      decoration: BoxDecoration(
        color: selectedBet == amount ? Colors.red : Colors.blue.shade400,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: selectedBet == amount
                ? Colors.red.shade900
                : Colors.blue.shade500.withOpacity(0.6),
            blurRadius: 0,
            spreadRadius: 1,
            offset: Offset(0, 4),
          )
        ]
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/diamond.png'),
              height: 30,
            ),
            Text(
              '$amount',
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Colors.black38,
              Colors.black26,
              Colors.black,
            ],
          ),
        borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade600.withOpacity(0.6),
              blurRadius: 0,
              spreadRadius: 1,
              offset: Offset(0, 4),
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'RESULTS |',
            style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Row(
            children: List.generate(
              7,
                  (index) => Container(
                width: 35,
                height: 35,
                margin: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: index == 0
                    // ? Center(child: Text('NEW', style: TextStyle(fontSize: 8)))
                    ? Image.asset('assets/hot-dog.png',scale: 20)
                    : Image.asset('assets/hot-dog.png',scale: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceRow() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black,
            Colors.black38,
            Colors.black26,
            Colors.black,
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(0),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBalanceDisplay('BALANCE', balance),
              _buildBalanceDisplay('WIN', winAmount),
            ],
          ),

          // SizedBox(height: 20),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Row(
          //       children: List.generate(
          //         8,
          //             (index) => Container(
          //           width: 35,
          //           height: 35,
          //           margin: const EdgeInsets.symmetric(horizontal: 4),
          //           decoration: const BoxDecoration(
          //             color: Colors.white,
          //             shape: BoxShape.circle,
          //           ),
          //           child: index == 0
          //               ? Center(child: Text('NEW', style: TextStyle(fontSize: 8)))
          //               : Icon(Icons.fastfood, size: 16),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildBalanceDisplay(String label, int amount) {
    return Row(
      children: [
        Text(
          '$label : ',
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
          ),
        ),
        const Image(
            image: AssetImage('assets/coin.png'),
            width: 18,
            height: 18,
        ),
        Text(
          amount.toString(),
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
          ),
        ),
      ],
    );
  }
}
