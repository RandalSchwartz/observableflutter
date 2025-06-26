import 'package:app/screens/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatBloc bloc;

  @override
  void initState() {
    bloc = ChatBloc(ChatState.initial());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BlocBuilder<ChatBloc, ChatState>(
            bloc: bloc,
            builder: (context, state) {
              return Row(
                children: [
                  // SizedBox(
                  //   height: constraints.maxHeight,
                  //   width: constraints.maxWidth / 2,
                  //   child: Center(
                  //     child: Padding(
                  //       padding: EdgeInsets.all(20),
                  //       child: ImageSaver(
                  //         child: (selectedMessageIndex != null)
                  //             ? ChatMessageWidget(
                  //                 _chatMessages[selectedMessageIndex!],
                  //               )
                  //             : Container(),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: ListView.builder(
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.all(16),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (state.selectedChatMessageId != null) {
                                // Re-clicked the selected message; ergo, deselect
                                if (state.messages[index].id ==
                                    state.selectedChatMessageId) {
                                  bloc.add(const DeselectChatMessage());
                                } else {
                                  bloc.add(
                                    SelectChatMessage(state.messages[index].id),
                                  );
                                }
                              } else {
                                bloc.add(
                                  SelectChatMessage(state.messages[index].id),
                                );
                              }
                            });
                          },
                          child: ChatMessageWidget(
                            state.messages[index],
                            isSelected:
                                state.selectedChatMessageId ==
                                state.messages[index].id,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
