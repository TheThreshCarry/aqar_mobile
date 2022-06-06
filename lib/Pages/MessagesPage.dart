import 'package:aqar_mobile/Controllers/AuthController.dart';
import 'package:aqar_mobile/Pages/NeedToSignUp.dart';
import 'package:aqar_mobile/Widgets/ConversationCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagePage extends ConsumerStatefulWidget {
  MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends ConsumerState<MessagePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ref.read(authProvider).isLoggedIn
        ? Scaffold(
            appBar: AppBar(title: const Text("Conversations")),
            body: Container(
              height: size.height,
              width: size.width,
              child: FutureBuilder(
                  future: ref.read(authProvider).getConversations(),
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      ref.read(authProvider).usersConversations = ref
                          .read(authProvider)
                          .usersConversations
                          .reversed
                          .toList();
                      return ListView.builder(
                          itemCount:
                              ref.read(authProvider).usersConversations.length,
                          itemBuilder: (context, index) {
                            return ConversationCard(
                                conversation: ref
                                    .read(authProvider)
                                    .usersConversations[index]);
                          });
                    }
                    return const Center(child: CircularProgressIndicator());
                  })),
            ),
          )
        : NeedToSignUp();
  }
}
