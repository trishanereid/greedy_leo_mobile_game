import 'package:flutter/material.dart';

class GameRulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'How To Play',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            _buildRuleSection('Step 1: Place Your Bets', _placeYourBetsText()),
            _buildRuleSection('Step 2: Wait for the Results', _waitForResultsText()),
            _buildImportantRules(),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Colors.blue.shade400,
            Colors.blue.shade800,
          ],
          radius: 4,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImportantRules() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Colors.orange.shade400,
            Colors.orange.shade700,
          ],
          radius: 4,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: const Text(
          'Important Rules',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            _importantRulesText(),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  String _placeYourBetsText() {
    return '''
Use Gold Diamonds: 
Bets require Gold Diamonds, with 4 different betting amounts available to choose from.

Bet Options:
In each round, you can bet on up to 6 different food items.

You can place multiple bets on the same food item.

Betting Limit: 
The total betting amount for a single round must not exceed 1,000,000 Diamonds.

Bet Indicator: 
After placing a bet, a bubble will appear on the food item, showing the number of Diamonds bet.

The higher your bet, the greater your potential winnings.
    ''';
  }

  String _waitForResultsText() {
    return '''
Prize Selection: 
The character Greedy Leo will randomly select 1 or more winning food items from a list of 8 options.

Winning Condition: 
If you bet on a food item that gets selected, you'll win Gold Diamonds based on the odds.
    ''';
  }

  String _importantRulesText() {
    return '''
1. Gold Diamonds Usage:
Gold Diamonds can only be used within the Leo App to purchase virtual gifts for social activities and entertainment.

2. Restrictions:
Gold Diamonds cannot be used for profit-making activities of any kind.

Misuse of Gold Diamonds will be at your own risk.
    ''';
  }
}
