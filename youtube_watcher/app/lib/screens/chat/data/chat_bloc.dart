import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'data.dart';

part 'chat_bloc.freezed.dart';

typedef _Emit = Emitter<ChatState>;

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(super.initialState) {
    on<ChatEvent>(
      (ChatEvent event, _Emit emit) {
        switch (event) {
          case SelectChatMessage():
            _onSelectChatMessage(event, emit);
          case DeselectChatMessage():
            _onDeselectChatMessage(event, emit);
          case AddNewMessage():
            _onAddNewMessage(event, emit);
        }
      },
    );
    youTubeCommentStream = YouTubeCommentStream();
    youTubeCommentStream.initialize();
    _sub = youTubeCommentStream.stream.listen(
      (ChatMessage msg) => add(AddNewMessage(msg)),
    );
  }

  late final YouTubeCommentStream youTubeCommentStream;
  late StreamSubscription<ChatMessage> _sub;

  void _onSelectChatMessage(SelectChatMessage event, _Emit emit) {
    emit(state.copyWith(selectedChatMessageId: event.id));
  }

  void _onDeselectChatMessage(DeselectChatMessage event, _Emit emit) {
    emit(state.copyWith(selectedChatMessageId: null));
  }

  void _onAddNewMessage(AddNewMessage event, _Emit emit) {
    emit(
      state.copyWith(
        messages: List<ChatMessage>.from(state.messages)..add(event.message),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    youTubeCommentStream.close();
    return super.close();
  }
}

@Freezed()
sealed class ChatEvent with _$ChatEvent {
  const factory ChatEvent.select(String id) = SelectChatMessage;
  const factory ChatEvent.deselect() = DeselectChatMessage;
  const factory ChatEvent.addNewMessage(ChatMessage message) = AddNewMessage;
}

@Freezed()
abstract class ChatState with _$ChatState {
  const factory ChatState({
    String? selectedChatMessageId,

    @Default([]) List<ChatMessage> messages,
  }) = _ChatState;
  const ChatState._();

  factory ChatState.initial() => ChatState();
}
