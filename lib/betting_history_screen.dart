import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BettingHistoryScreen extends StatefulWidget {

  @override
  State<BettingHistoryScreen> createState() => _BettingHistoryScreenState();
}

class _BettingHistoryScreenState extends State<BettingHistoryScreen> {
  DateTime selectedDate = DateTime.now();

  final List<Map<String, dynamic>> historyData = [
    {
      'round': 1945,
      'playAmount': '500',
      'status': 'Missed',
      'time': 'Nov,18 2024 21:36',
    },
    {
      'round': 1943,
      'playAmount': '150',
      'status': 'Missed',
      'time': 'Nov,18 2024 21:35',
    },
    {
      'round': 1942,
      'playAmount': '1000',
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

  String getFormattedDate(DateTime date) {
    return DateFormat('MMM, dd yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Records',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: StatefulBuilder(
              builder: (context, setState) => GestureDetector(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Row(
                  children: [
                    Text(
                      getFormattedDate(selectedDate),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.white,),
                  ],
                ),
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2B73F4),
                Color(0xFF1A75D1)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade700,
              Colors.indigo.shade600,
              Colors.blueAccent.shade400,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: historyData.length,
          itemBuilder: (context, index) {
            final data = historyData[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                gradient: RadialGradient( colors: [
                  Colors.blue.shade400,
                  Colors.blue.shade800,
                ],
                    radius: 4
                ),
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
                      'Play:💎 ${data['playAmount']}',
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
                        color: data['status'] == 'Missed' ? Colors.deepOrangeAccent : Colors.yellow,
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
      )
    );
  }
}
