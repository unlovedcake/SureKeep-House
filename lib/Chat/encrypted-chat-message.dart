import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randomstring_dart/randomstring_dart.dart';
import 'package:sure_keep/Models/conversation.dart';
import 'package:sure_keep/Provider/chat-provider.dart';

import '../Models/user-model.dart';
import '../Widgets/rectangular_input_field.dart';

class EncryptedChatMessage extends StatefulWidget {
  final DocumentSnapshot messageData;
  final UserModel user;

  const EncryptedChatMessage({required this.messageData,required this.user, Key? key})
      : super(key: key);

  @override
  State<EncryptedChatMessage> createState() => _EncryptedChatMessageState();
}

class _EncryptedChatMessageState extends State<EncryptedChatMessage> {
  User? user = FirebaseAuth.instance.currentUser;
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final availableChars = "💙🖤㋡ヅ✔♍♉⌚⌛❎💯¢✃♛♥♦௹฿₧₯₳₰﷼￥☂☃☈💘ლ☬☻☹☻ӫ⋭aʊABC";
  var random = Random();



  // Define a reusable function
  String generateRandomString() {

    //
    // var  rs = RandomString();
    // String result = rs.getRandomString(
    //   uppersCount: 1,
    //   lowersCount: 1,
    //   numbersCount: 1,
    //   specialsCount: 12,
    //   specials: '\u{1234}💙🖤㋡ヅ✔♍♉⌚⌛❎💯¢✃♛♥௹฿₧₯₳₰﷼￥☂☃☈💘ლ☬☻☹☻ӫ⋭aʊ',
    // );
    //
    //
    //
    // return   result;
    int ranNum = 5 + Random().nextInt(20 - 4);

    var sRunes = availableChars.runes;

    print(String.fromCharCodes(sRunes, 0, sRunes.length-1));

    return String.fromCharCodes(sRunes.toList()..shuffle(), 1, ranNum);

    //
    // return String.fromCharCodes(Iterable.generate(
    //          15, (index) {
    //
    //   return availableChars.codeUnitAt(random.nextInt(sRunes.length));
    // }));

    //
    // final randomStr = List.generate(
    //         ranNum,
    //         (index) =>
    //             availableChars[random.nextInt(availableChars.length - 1)])
    //     .toString();
    //
    // print(randomStr);
    //
    // return randomStr;
  }


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {



    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: (widget.messageData.get('idFrom') == user!.uid
                ? Alignment.topRight
                : Alignment.topLeft),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (widget.messageData.get('idFrom') == user!.uid
                    ? Colors.grey.shade200
                    : Colors.blue[200]),
              ),
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onDoubleTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Enter your password to decrypt"),
                        content: Form(
                          key: _formKey,
                          child: RectangularInputField(
                            controller: passwordController,
                            textInputType: TextInputType.text,
                            hintText: 'Enter Password',
                            icon: const Icon(
                              Icons.lock,
                              color: Colors.black,
                            ),
                            obscureText: true,
                            onChanged: (val) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Password  is required");
                              }
                            },
                          ),
                        ),
                        actions: <Widget>[
                          OutlinedButton(
                            child: Text("OK"),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {

                                context.read<ChatProvider>().signInFakePassword(user!.email.toString(), passwordController.text,widget.user, context );

                              }
                              // Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                  print("EnterPassowrd");
                },
                child: Text(generateRandomString()

                  // generateRandomString().toString() //getRandomStringss(12)
                    // generateRandomStrings(widget.messageData.get('message').toString().length + 10),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
