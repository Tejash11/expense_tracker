import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = []; // List to store Q&A

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AIxpense Chatbot', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.white, // Change back arrow color to white
        ),
      ),
      body: Column(
        children: [
          // Expanded widget to display user and bot messages in Q&A format
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    'Q: ${messages[index]['question'] ?? ''}',
                    style: TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    'A: ${messages[index]['answer'] ?? ''}',
                    style: TextStyle(color: Colors.blue),
                  ),
                );
              },
            ),
          ),
          // Bottom text field and send button row
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white, // White background for the input area
            child: Row(
              children: [
                // Text Field
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                // Send Button
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () async {
                    String input = _controller.text.trim();
                    if (input.isNotEmpty) {
                      // Add user's question to the list
                      setState(() {
                        messages.add({'question': input, 'answer': ''});
                      });
                      _controller.clear();

                      // Call the prediction URL to get the bot's response
                      String botResponse = await sendMessageToPredictionUrl(
                          input);

                      // Update the bot's response in the list
                      setState(() {
                        messages[messages.length - 1]['answer'] = botResponse;
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white, // White background
    );
  }

  Future<String> sendMessageToPredictionUrl(String message) async {
    String predictionUrl = 'https://chatbotinstance.cognitiveservices.azure.com/language/:query-knowledgebases?projectName=qna&api-version=2021-10-01&deploymentName=test';

    try {
      final response = await http.post(
        Uri.parse(predictionUrl),
        headers: {
          'Ocp-Apim-Subscription-Key': '117f956fff5941d8bb9a8f9e1fe35978',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'question': message, // Adjust according to the API's expected payload
          'user_id': '12345', // Example user data
        }),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print(
            'Response Data: $responseData'); // Print the response for debugging
        // Adjust the key according to the actual response format
        if (responseData.containsKey('answers') &&
            responseData['answers'].isNotEmpty) {
          return responseData['answers'][0]['answer']; // Adjust based on actual response structure
        } else {
          return 'No answer found in response';
        }
      } else {
        return 'Failed to get response: ${response.statusCode} - ${response
            .body}';
      }
    } catch (e) {
      return 'Error occurred: $e';
    }
  }
}

