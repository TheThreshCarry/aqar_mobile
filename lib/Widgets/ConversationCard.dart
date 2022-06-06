import 'dart:math';
import 'package:intl/intl.dart';

import 'package:aqar_mobile/Pages/ConversationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConversationCard extends ConsumerWidget {
  const ConversationCard({Key? key, required this.conversation})
      : super(key: key);
  final dynamic conversation;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ConversationPage(conversation: conversation);
        }));
      },
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: size.width,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Color.fromRGBO(Random().nextInt(254),
                    Random().nextInt(254), Random().nextInt(254), 1),
                child: conversation["friend"]["imageUrl"] == null
                    ? Text(conversation["friend"]["name"][0],
                        style: const TextStyle(color: Colors.white))
                    : const Text(""),
                backgroundImage:
                    NetworkImage(conversation["friend"]["imageUrl"] ?? ""),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(conversation["friend"]["name"],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900)),
                    conversation["lastMessage"] != null
                        ? Text(
                            conversation["lastMessage"]["text"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : const Text(""),
                  ],
                ),
              ),
              conversation["lastMessage"] != null
                  ? Text(getDateString(conversation["lastMessage"]["sent_at"]))
                  : const Text(""),
            ]),
      ),
    );
  }
}

String getDateString(String dateString) {
  DateTime date = DateTime.parse(dateString);
  if (DateTime.now().day == date.day &&
      DateTime.now().month == date.month &&
      DateTime.now().year == date.year) {
    return DateFormat('kk:mm').format(date);
  } else {
    if (date.year != DateTime.now().year) {
      return DateFormat('yyyy-MM-dd').format(date);
    }
    return DateFormat('MM-dd').format(date);
  }
}
