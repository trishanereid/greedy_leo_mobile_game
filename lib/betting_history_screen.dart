import 'package:flutter/material.dart';

class BettingHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> historyData = [
    {
      'round': 1945,
      'playAmount': '500',
      'currency': 'silver',
      'status': 'Missed',
      'time': 'Nov,18 2024 21:36',
    },
    {
      'round': 1943,
      'playAmount': '150',
      'currency': 'gold',
      'status': 'Missed',
      'time': 'Nov,18 2024 21:35',
    },
    {
      'round': 1942,
      'playAmount': '1000',
      'currency': 'silver',
      'status': 'Missed',
      'time': 'Nov,18 2024 21:34',
    },
    {
      'round': 1891,
      'playAmount': '100',
      'currency': 'silver',
      'status': 'Missed',
      'time': 'Nov,18 2024 21:00',
    },
    {
      'round': 1890,
      'playAmount': '160',
      'currency': 'silver',
      'status': 'Won',
      'time': 'Nov,18 2024 20:59',
      'reward': '100',
    },
    {
      'round': 1890,
      'playAmount': '160',
      'currency': 'silver',
      'status': 'Won',
      'time': 'Nov,18 2024 20:59',
      'reward': '100',
    },
    {
      'round': 1890,
      'playAmount': '160',
      'currency': 'silver',
      'status': 'Won',
      'time': 'Nov,18 2024 20:59',
      'reward': '100',
    },
    {
      'round': 1890,
      'playAmount': '160',
      'currency': 'silver',
      'status': 'Won',
      'time': 'Nov,18 2024 20:59',
      'reward': '100',
    },
    {
      'round': 1890,
      'playAmount': '160',
      'currency': 'silver',
      'status': 'Won',
      'time': 'Nov,18 2024 20:59',
      'reward': '100',
    },
    {
      'round': 1890,
      'playAmount': '160',
      'currency': 'silver',
      'status': 'Won',
      'time': 'Nov,18 2024 20:59',
      'reward': '100',
    },
    {
      'round': 1890,
      'playAmount': '160',
      'currency': 'silver',
      'status': 'Won',
      'time': 'Nov,18 2024 20:59',
      'reward': '100',
    },
    {
      'round': 1890,
      'playAmount': '160',
      'currency': 'silver',
      'status': 'Won',
      'time': 'Nov,18 2024 20:59',
      'reward': '100',
    },
    {
      'round': 1890,
      'playAmount': '160',
      'currency': 'silver',
      'status': 'Won',
      'time': 'Nov,18 2024 20:59',
      'reward': '100',
    },
    {
      'round': 1890,
      'playAmount': '160',
      'currency': 'silver',
      'status': 'Won',
      'time': 'Nov,18 2024 20:59',
      'reward': '100',
    },
    {
      'round': 1890,
      'playAmount': '160',
      'currency': 'silver',
      'status': 'Won',
      'time': 'Nov,18 2024 20:59',
      'reward': '100',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        title: const Text('My Record'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Nov,18 2024',
                  style: TextStyle(fontSize: 16),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: historyData.length,
        itemBuilder: (context, index) {
          final data = historyData[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.red.shade800,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                'Round: ${data['round']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Play: ${data['currency'] == 'gold' ? '🪙' : '💎'} ${data['playAmount']}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    data['time'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data['status'],
                    style: TextStyle(
                      color: data['status'] == 'Missed' ? Colors.white : Colors.yellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (data['reward'] != null)
                    Text(
                      data['reward'],
                      style: const TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
