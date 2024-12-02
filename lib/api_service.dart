import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  String userId = "95r1xjwi3wr8kiz";

  Future<int> fetchWalletBalance() async {
    // Define the API URL
    final String apiUrl =
        "http://145.223.21.62:8090/api/collections/users/records/$userId";

    try {
      // Make the GET request
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        int walletBalance = data['wallet'];
        return walletBalance;
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return 0;
    }
  }

  Future<bool> updateWalletBalance(int newBalance) async {
    final String apiUrl =
        "http://145.223.21.62:8090/api/collections/users/records/$userId";

    try {
      Map<String, dynamic> body = {'wallet': newBalance};

      // Make the PATCH request
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Wallet updated successfully');
        return true;
      } else {
        print('Failed to update wallet. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating wallet: $e');
      return false;
    }
  }

  fetchBettingHistory() async {
    final String apiUrl =
        "http://145.223.21.62:8090/api/collections/user_betting_history/records";
    //TODO
  }
}