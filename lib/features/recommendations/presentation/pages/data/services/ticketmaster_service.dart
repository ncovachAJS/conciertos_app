import 'dart:convert';

import 'package:http/http.dart' as http;

class TicketmasterService {
  static const _apiKey = 'TU_API_KEY';

  Future<Map<String, dynamic>> searchEvents(String artist) async {
    final uri = Uri.https('app.ticketmaster.com', '/discovery/v2/events.json', {
      'apikey': _apiKey,
      'keyword': artist,
      'countryCode': 'ES',
      'size': '20',
      'sort': 'date,asc',
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Error Ticketmaster');
    }

    return jsonDecode(response.body);
  }
}
