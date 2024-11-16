import 'package:flutter/material.dart';
import 'FoodItem.dart';

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

  final List<FoodItem> foodItems = [
    FoodItem('Meat', 45),
    FoodItem('Tomato', 5),
    FoodItem('Pepper', 5),
    FoodItem('Ham', 25),
    FoodItem('Carrot', 5),
    FoodItem('Hot Dog', 15),
    FoodItem('Fish', 10),
    FoodItem('Cabbage', 5),
  ];

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
            colors: [Color(0xFF1a2635), Color(0xFF0d1219)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFoodWheel(),

                    //_buildResultRow(),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
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
            'GREEDY LEO',
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
              width: 350,
              height: 450,
              fit: BoxFit.contain,
          ),

          Positioned(
              bottom: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBetSelector()
                ],
              )
          )
        ],
      ),
    );
  }

  Widget _buildFoodItem(FoodItem item) {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fastfood, color: Colors.white),
          SizedBox(height: 4),
          Text(
            '${item.multiplier}X',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
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
            children: [100, 1000, 5000, 10000].map((amount) {
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

  Widget _buildBetButton(int amount) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3.5),
      width: 62,
      height: 53,
      decoration: BoxDecoration(
        color: selectedBet == amount ? Colors.red : Colors.blue.shade400,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: selectedBet == amount ? Colors.red.shade900 : Colors.blue.shade500.withOpacity(0.6),
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
              style: TextStyle(
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
      padding: const EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade500.withOpacity(0.6),
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
                color: Colors.white,
                fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Row(
            children: List.generate(
              7,
                  (index) => Container(
                width: 34,
                height: 34,
                margin: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: index == 0
                    ? Center(child: Text('NEW', style: TextStyle(fontSize: 8)))
                    : Icon(Icons.fastfood, size: 16),
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
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.only(
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

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: List.generate(
                  8,
                      (index) => Container(
                    width: 35,
                    height: 35,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: index == 0
                        ? Center(child: Text('NEW', style: TextStyle(fontSize: 8)))
                        : Icon(Icons.fastfood, size: 16),
                  ),
                ),
              ),
            ],
          ),
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
