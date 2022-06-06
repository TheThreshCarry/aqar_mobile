// ignore_for_file: prefer_const_constructors, use_function_type_syntax_for_parameters

import 'dart:convert';

import 'package:aqar_mobile/Controllers/AuthController.dart';
import 'package:aqar_mobile/Widgets/ConversationCard.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ConversationPage extends ConsumerStatefulWidget {
  ConversationPage({Key? key, required this.conversation}) : super(key: key);
  final dynamic conversation;

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends ConsumerState<ConversationPage> {
  String message = "";
  bool isSendingMessage = false;
  IO.Socket? socket;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connect();
  }

  void connect() {
    socket = IO.io("https://aqar-server.herokuapp.com", {
      "transports": ["websocket"],
      "autoConnect": false
    });
    socket!.connect();
    socket!.onConnect((data) {
      print(data);
      socket!.emit("addUser", ref.read(authProvider).userData["id"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    dynamic conversation = widget.conversation;
    socket!.on("getMessage", (data) {
      setState(() {
        print("data:$data");
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Color.fromRGBO(Random().nextInt(254),
                    Random().nextInt(254), Random().nextInt(254), 1),
                child: conversation["friend"]["imageUrl"] == null
                    ? Text(conversation["friend"]["name"][0],
                        style: const TextStyle(color: Colors.white))
                    : Text(""),
                backgroundImage:
                    NetworkImage(conversation["friend"]["imageUrl"] ?? ""),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(conversation["friend"]["name"],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w900)),
            ]),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(children: [
          Expanded(
            flex: 7,
            child: Container(
              width: size.width,
              child: FutureBuilder(
                  future: ref
                      .read(authProvider)
                      .getMessagesOfConversation(conversation["id"]),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      List<dynamic> data = snapshot.data as List<dynamic>;
                      data = data.reversed.toList();

                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          reverse: true,
                          itemCount: data.length,
                          itemBuilder: ((context, index) {
                            return Container(
                                constraints: BoxConstraints(minHeight: 100),
                                width: size.width,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  textDirection: data[index]["sender"] ==
                                          ref.read(authProvider).userData["id"]
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  children: [
                                    CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Color.fromRGBO(
                                            Random().nextInt(254),
                                            Random().nextInt(254),
                                            Random().nextInt(254),
                                            1),
                                        backgroundImage: ref
                                                    .read(authProvider)
                                                    .userData["id"] ==
                                                data[index]["sender"]
                                            ? NetworkImage(ref
                                                    .read(authProvider)
                                                    .userData["image"] ??
                                                "https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png")
                                            : NetworkImage(conversation[
                                                    "friend"]["imageUrl"] ??
                                                "https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png")),
                                    Flexible(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Color(0xFF282828)),
                                        child: Text(
                                          data[index]["text"],
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      getDateString(data[index]["sent_at"]),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    )
                                  ],
                                ));
                          }));
                    }
                    return Center(child: CircularProgressIndicator());
                  })),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: size.width,
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                    flex: 7,
                    child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          onChanged: (msg) {
                            message = msg;
                          },
                          decoration:
                              InputDecoration(hintText: 'Ecrivez un Message'),
                        ))),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2000),
                        color: const Color(0xFF282828),
                      ),
                      child: IconButton(
                          onPressed: () async {
                            if (message.isEmpty) {
                              return;
                            }
                            setState(() {
                              isSendingMessage = true;
                            });
                            var send = await Dio().post(
                                "https://aqar-server.herokuapp.com/messages/message",
                                data: {
                                  "conversationId": conversation["id"],
                                  "sender":
                                      ref.read(authProvider).userData["id"],
                                  "text": message
                                });

                            setState(() {
                              socket!.emit("sendMessage", {
                                "senderId":
                                    ref.read(authProvider).userData["id"],
                                "receiverId": conversation["friend"]["id"],
                                "text": message,
                                "sent_at": send.data["sent_at"]
                              });
                              isSendingMessage = false;
                              message = "";
                            });
                            /*
                            message.conversationId,
                            message.sender,
                            message.text,
                            */
                          },
                          icon: isSendingMessage == true
                              ? CircularProgressIndicator()
                              : Icon(Icons.send)),
                    )),
                const SizedBox(
                  width: 10,
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
