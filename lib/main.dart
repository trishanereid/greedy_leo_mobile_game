import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'SemiFilledCirclePainter.dart';
import 'api_service.dart';
import 'betting_history_screen.dart';
import 'game_rules_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'leaderboard_screen.dart';


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
  final ApiService _apiService = ApiService();
  int balance = 0;
  int selectedBet = 16;
  int winAmount = 10000;
  int currentCircleIndex = 0;
  Timer? handTimer;
  bool isHandMoving = false;
  int timeRemaining = 0;
  int round = 0;
  late IO.Socket socket;
  bool isScreenTransitionActive = false;
  Timer? screenTransitionTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isMuted = false;
  String connectionStatus = "Disconnected";
  int currentRoundNumber = 0;
  String status = 'Disconnected';
  List<Map<String, dynamic>> gameHistory = [];


  final List<Map<String, String>> foodItems = [
    {'image': 'assets/leg-piece.png', 'label': '25 Times', 'value': '25'},
    {'image': 'assets/tuna.png', 'label': '15 Times', 'value': '15'},
    {'image': 'assets/hot-dog.png', 'label': '10 Times', 'value': '10'},
    {'image': 'assets/tomato.png', 'label': '5 Times', 'value': '5'},
    {'image': 'assets/cabbage.png', 'label': '5 Times', 'value': '5'},
    {'image': 'assets/corn.png', 'label': '5 Times', 'value': '5'},
    {'image': 'assets/carrot.png', 'label': '5 Times', 'value': '5'},
    {'image': 'assets/beef.png', 'label': '45 Times', 'value': '45'},
  ];

  Set<int> selectedCircles = {};


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
      if (timeRemaining <= 0) {
        timer.cancel();
        setState(() {
          isHandMoving = false;
          triggerScreenTransition();
        });
      }
    });
  }

  void triggerScreenTransition() {
    setState(() {
      isScreenTransitionActive = true;
    });

    screenTransitionTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        isScreenTransitionActive = false;
        resetGame();
      });
      _updateBalance();
      print(currentRoundNumber);
    });
  }

  void resetGame() {
    setState(() {
      currentCircleIndex = 0;
      selectedCircles.clear();
      startHandMovement();
    });
  }

  @override
  void dispose() {
    handTimer?.cancel();
    // _webSocketService.close();
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    connectToServer();
    startHandMovement();
    _playBackgroundMusic();
    _fetchBalance();
  }

  void connectToServer() {
    socket = IO.io('http://145.223.21.62:3020', {
      'transports': ['websocket'],
      'autoConnect': false,
    });
    
    socket.connect();

    // Listen for the timeUpdate event
    socket.on('timeUpdate', (data) {
      setState(() {
        timeRemaining = data['timeRemaining'];
        round = data['roundNumber'];
      });
    });


    // Handle connection events
    socket.onConnect((_) {
      print('Connected to WebSocket server');
    });

    socket.onDisconnect((_) {
      print('Disconnected from WebSocket server');
    });

    socket.onError((err) {
      print('Error connecting to WebSocket server: $err');
    });
  }

  Future<void> _fetchBalance() async {
    int walletBalance = await _apiService.fetchWalletBalance();
    setState(() {
      balance = walletBalance;
    });
  }

  Future<void> _updateBalance() async {
    int newBalance = balance;

    bool success = await _apiService.updateWalletBalance(newBalance);

    if (success) {
      setState(() {
        balance = newBalance;
        print(balance);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update wallet balance')),
      );
    }
  }

  Future<void> _playBackgroundMusic() async {
    try {
      await _audioPlayer.play(AssetSource('assets/audio/backgroundmusic.mp3'));
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
    });
    _audioPlayer.setVolume(isMuted ? 0.0 : 1.0);
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
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
                  Color(0xFF0d1219),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0,
                    ),
                    child: _buildTopBar(),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildFoodWheel(context),
                        Transform.translate(
                          offset: Offset(0, screenHeight * 0.015),
                          child: _buildResultRow(context),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: screenHeight * 0,
                    ),
                    child: _buildBalanceRow(),
                  ),
                ],
              ),
            ),
          ),

          // Overlay for Screen Transition
          if (isScreenTransitionActive)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Text(
                  'Please Wait...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // 16,10
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildCircularButton(
                  Icons.emoji_events,
                  Colors.cyan,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LeaderboardScreen()),
                    );
                  }
              ),
              const SizedBox(width: 5),
              _buildCircularButton(
                  isMuted ? Icons.music_off_outlined : Icons.music_note_outlined,
                  Colors.cyan,
                  onTap: () {
                    _toggleMute;
                  }),
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
              _buildCircularButton(
                Icons.menu,
                Colors.cyan,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BettingHistoryScreen()),
                  );
                },
              ),
              const SizedBox(width: 5),
              _buildCircularButton(
                Icons.help_outline_rounded,
                Colors.cyan,
                onTap: () {
                  Navigator.push(
                    context,
                      MaterialPageRoute(builder: (context) => GameRulesScreen())
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, Color color, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildFoodWheel(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image(
            image: const AssetImage('assets/stand-without-circles.png'),
            width: screenWidth * 1.0,
            height: screenHeight * 0.63,
            fit: BoxFit.contain,
          ),

          Positioned(
            left: screenWidth * 0.415,
            top: screenHeight * 0.17,
            child: Container(
              width: screenWidth * 0.17,
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'PLEASE BET\n',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.026,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '$timeRemaining',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          for (int i = 0; i < foodItems.length; i++)
            Positioned(
              left: screenWidth * 0.395 +
                  (screenWidth * 0.4 * cos((i * 45) * (3.14159 / 180)) / 1.15),
              top: screenHeight * 0.129 -
                  (screenWidth * 0.4 * sin((i * 45) * (3.14159 / 180)) / 1.15),
              child: GestureDetector(
                onTap: () => toggleSelection(i),
                child: _semiFilledCircle(
                  size: screenWidth * 0.22,
                  image: foodItems[i]['image']!,
                  label: foodItems[i]['label']!,
                  isSelected: selectedCircles.contains(i),
                ),
              ),
            ),


          if (isHandMoving)
            Positioned(
              left: screenWidth * 0.45 +
                  (screenWidth * 0.4 *
                      cos((currentCircleIndex * 45) * (3.14159 / 180)) /
                      1.15),
              top: screenHeight * 0.18 -
                  (screenWidth * 0.4 *
                      sin((currentCircleIndex * 45) * (3.14159 / 180)) /
                      1.15),
              child: Image.asset(
                'assets/hand.png',
                width: screenWidth * 0.15,
                height: screenWidth * 0.15,
              ),
            ),

          Positioned(
            bottom: screenHeight * 0.09,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            child: _showRoundNumber(context),
          ),

          Positioned(
            bottom: screenHeight * 0.029,
            left: screenWidth * 0,
            right: screenWidth * 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBetSelector(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _showRoundNumber(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        '$round Round',
        style: TextStyle(
          // color: const Color(0xFFFFD700),
          color: Colors.black,
          fontSize: screenWidth * 0.05,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBetSelector(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(

      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
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
                child: _buildBetButton(amount, screenWidth, screenHeight),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBetButton(int amount, double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.009),
      width: screenWidth * 0.18,
      height: screenHeight * 0.07,
      decoration: BoxDecoration(
        color: selectedBet == amount ? Colors.red : Colors.blue.shade400,
        borderRadius: BorderRadius.circular(screenWidth * 0.02), // Adjust radius
        boxShadow: [
          BoxShadow(
            color: selectedBet == amount
                ? Colors.red.shade900
                : Colors.blue.shade500.withOpacity(0.6),
            blurRadius: 0,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/diamond.png'),
              height: 30, // Keep asset height fixed
            ),
            Text(
              '$amount',
              style: TextStyle(
                fontSize: screenWidth * 0.04, // Responsive font size
                color: const Color(0xFFFFD700),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
              ? [Colors.red, Colors.red]
              : [Colors.blue.shade600, Colors.blue.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? Colors.red.shade900
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


  Widget _buildResultRow(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.033),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
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
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade600.withOpacity(0.6),
            blurRadius: 0,
            spreadRadius: 1,
            offset: Offset(0, screenHeight * 0.005),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'RESULTS |',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: screenWidth * 0.02),
          Row(
            children: List.generate(
              7,
                  (index) => Container(
                width: screenWidth * 0.08,
                height: screenWidth * 0.08,
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.005),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: index == 0
                    ? Image.asset(
                  'assets/hot-dog.png',
                  scale: screenWidth * 0.05,
                )
                    : Image.asset(
                  'assets/hot-dog.png',
                  scale: screenWidth * 0.05,
                ),
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
