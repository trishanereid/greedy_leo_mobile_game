import 'package:flutter/material.dart';

class GameResultScreen extends StatefulWidget {
  final int roundNumber;
  final int spending;
  final int earnings;
  final List<SpendingDetail> spendingDetails;
  final String topFoodImage;

  const GameResultScreen({
    Key? key,
    required this.roundNumber,
    required this.spending,
    required this.earnings,
    required this.spendingDetails,
    required this.topFoodImage,
  }) : super(key: key);

  @override
  State<GameResultScreen> createState() => _GameResultScreenState();
}

class _GameResultScreenState extends State<GameResultScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, size.height * _slideAnimation.value / 2),
          child: child,
        );
      },
      child: Container(
        height: size.height * 0.75,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1976D2),
              Color(0xFF2979FF)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // Top Food Image
            Positioned(
              top: -size.width * 0.15, // Position above the container
              child: Container(
                width: size.width * 0.3,
                height: size.width * 0.3,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Image.asset(
                  widget.topFoodImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Main Content
            Padding(
              padding: EdgeInsets.only(
                top: size.width * 0.2,
                left: size.width * 0.04,
                right: size.width * 0.04,
              ),
              child: Column(
                children: [
                  Text(
                    'Result of Round ${widget.roundNumber}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  // Info Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoCard('My Spending', widget.spending, size),
                      _buildInfoCard('My Earnings', widget.earnings, size),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
                  Text(
                    'Spending Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.06,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  // Spending Details List
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                        vertical: size.height * 0.01,
                      ),
                      itemCount: widget.spendingDetails.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.white24,
                        height: size.height * 0.01,
                      ),
                      itemBuilder: (context, index) {
                        final detail = widget.spendingDetails[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.012,
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                detail.imagePath,
                                width: size.width * 0.1,
                                height: size.width * 0.1,
                              ),
                              SizedBox(width: size.width * 0.04),
                              const Expanded(child: SizedBox()),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/coin.png',
                                    width: size.width * 0.06,
                                    height: size.width * 0.06,
                                  ),
                                  SizedBox(width: size.width * 0.02),
                                  Text(
                                    detail.amount.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isSmallScreen
                                          ? size.width * 0.045
                                          : size.width * 0.05,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, int amount, Size size) {
    final isSmallScreen = size.width < 360;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.06,
        vertical: size.height * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? size.width * 0.04 : size.width * 0.045,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            children: [
              Image.asset(
                'assets/coin.png',
                width: size.width * 0.06,
                height: size.width * 0.06,
              ),
              SizedBox(width: size.width * 0.02),
              Text(
                amount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isSmallScreen ? size.width * 0.055 : size.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SpendingDetail {
  final String imagePath;
  final int amount;

  SpendingDetail({
    required this.imagePath,
    required this.amount,
  });
}

void showGameResult(BuildContext context, int round) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => GameResultScreen(
      roundNumber: round,
      spending: 0,
      earnings: 0,
      topFoodImage: 'assets/cabbage.png',
      spendingDetails: [
        SpendingDetail(imagePath: 'assets/carrot.png', amount: 150),
        SpendingDetail(imagePath: 'assets/corn.png', amount: 400),
        SpendingDetail(imagePath: 'assets/cabbage.png', amount: 400),
        SpendingDetail(imagePath: 'assets/beef.png', amount: 50),
      ],
    ),
  );
}
