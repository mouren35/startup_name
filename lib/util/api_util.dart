import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String clientId = dotenv.env['BAIDU_QIANFAN_CLINE_AK']!;
  final String clientSecret = dotenv.env['BAIDU_QIANFAN_CLINE_SK']!;

  Future<String> getAccessToken() async {
    final url = Uri.parse(
      'https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=$clientId&client_secret=$clientSecret',
    );

    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }

  Future<String> getWenxinResponse(String message) async {
    final accessToken = await getAccessToken();
    final url = Uri.parse(
      'https://aip.baidubce.com/rpc/2.0/ai_custom/v1/wenxinworkshop/chat/completions?access_token=$accessToken',
    );

    final payload = jsonEncode({
      'messages': [
        {
          'role': 'user',
          'content': message,
        }
      ],
    });

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: payload);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['result'] != null) {
        return data['result'];
      } else {
        return 'No response from Wenxin';
      }
    } else {
      throw Exception('Failed to get response from Wenxin');
    }
  }
}
