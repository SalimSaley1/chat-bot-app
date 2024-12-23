import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//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
class ChatBotPage extends StatefulWidget {
  ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  List messages = [
    {"message": "Hello", "type": "user"},
    {"message": "How can i help you", "type": "assistant"},
  ];

  TextEditingController queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat Bot",
          style: TextStyle(
            color: Theme.of(context).indicatorColor,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool isUser = messages[index]['type'] == 'user';
                  return Column(
                    children: [
                      ListTile(
                        trailing: isUser ? Icon(Icons.person) : null,
                        leading: !isUser ? Icon(Icons.support_agent) : null,
                        title: Row(
                          children: [
                            SizedBox(
                              width: isUser ? 100 : 0,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  messages[index]['message'],
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                color: isUser
                                    ? Color.fromARGB(100, 0, 200, 0)
                                    : Colors.white,
                                padding: EdgeInsets.all(10),
                              ),
                            ),
                            SizedBox(
                              width: isUser ? 0 : 100,
                            )
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: queryController,
                    decoration: InputDecoration(
                      //icon: Icon(Icons.lock),
                      suffixIcon: Icon(Icons.visibility),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    String query = queryController.text;
                    var openAiLLMUri =
                        Uri.https("api.openai.com", "/v1/chat/completions");
                    Map<String, String> headers = {
                      "Content-Type": "application/json",
                      "Authorization":
                          "Bearer open_api_key",
                    };
                    var prompt = {
                      "model": "gpt-4o-mini",
                      "messages": [
                        {"role": "user", "content": query}
                      ],
                      "temperature": 0.7
                    };
                    http
                        .post(openAiLLMUri,
                            headers: headers, body: json.encode(prompt))
                        .then((resp) {
                      var responseBody = resp.body;
                      var llmResponse = json.decode(responseBody);
                      String responseContent =
                          llmResponse['choices'][0]['message']['content'];
                      setState(() {
                        messages.add({"message": query, "type": "user"});
                        messages.add(
                            {"message": responseContent, "type": "assistant"});
                      });
                    }, onError: (err) {
                      print("++++++++++++++ ERROR ++++++++++++++++");
                      print(err);
                    });
                  },
                  icon: Icon(Icons.send),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
