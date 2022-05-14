import 'package:chama_projet/api/firebase_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewMessageWidget extends StatefulWidget {
  final String idUser;
  final String currentUserMail;
  const NewMessageWidget(
      {required this.idUser, required this.currentUserMail, Key? key})
      : super(key: key);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _controller = TextEditingController();
  String message = '';

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    print("About to send to fb ${widget.idUser} === ${widget.currentUserMail}");
    await FirebaseApi.uploadMessage(widget.idUser, message);

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  labelText: 'Enter votre message',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onChanged: (value) => setState(() {
                  message = value;
                }),
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: message.trim().isEmpty ? null : sendMessage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange,
                ),
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      );
}
