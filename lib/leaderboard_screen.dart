import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboardData = [
    {'name': 'Johnny Rios', 'score': 23131, 'rank': 1, 'avatar': 'assets/avatar1.png'},
    {'name': 'Hodges', 'score': 12323, 'rank': 2, 'avatar': 'assets/avatar2.png'},
    {'name': 'Hammond', 'score': 6878, 'rank': 3, 'avatar': 'assets/avatar3.png'},
    {'name': 'Dora Hines', 'score': 6432, 'rank': 4, 'avatar': 'assets/avatar4.png'},
    {'name': 'Carolyn Francis', 'score': 5232, 'rank': 5, 'avatar': 'assets/avatar5.png'},
    {'name': 'Isaiah McGee', 'score': 5200, 'rank': 6, 'avatar': 'assets/avatar6.png'},
    {'name': 'Mark Holmes', 'score': 4987, 'rank': 7, 'avatar': 'assets/avatar7.png'},
    {'name': 'Georgie Clayton', 'score': 4632, 'rank': 8, 'avatar': 'assets/avatar8.png'},
    {'name': 'Alta Koch', 'score': 6878, 'rank': 9, 'avatar': 'assets/avatar9.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Colors.blue,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  const Text(
                    'Leaderboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTopPlayer(leaderboardData[1], 2),
                      _buildTopPlayer(leaderboardData[0], 1, isCenter: true),
                      _buildTopPlayer(leaderboardData[2], 3),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView.builder(
                  itemCount: leaderboardData.length - 3,
                  itemBuilder: (context, index) {
                    final data = leaderboardData[index + 3];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(data['avatar']),
                      ),
                      title: Text(
                        data['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Score: ${data['score']}',
                        style: TextStyle(
                          color: Colors.orange,
                        ),
                      ),
                      trailing: Text(
                        '${data['rank']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildTopPlayer(Map<String, dynamic> player, int rank, {bool isCenter = false}) {
    return Column(
      children: [
        CircleAvatar(
          radius: isCenter ? 55 : 40,
          backgroundImage: AssetImage(player['avatar']),
        ),
        const SizedBox(height: 8),
        Text(
          player['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('assets/coin.png'),
              width: 18,
              height: 18,
            ),
            const SizedBox(width: 4),
            Text(
              '${player['score']}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        // if (isCenter)
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$rank',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
