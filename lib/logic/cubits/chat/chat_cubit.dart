import 'dart:async';
import 'dart:developer';
import 'package:messenger_app_cubit/config/exports.dart';
import 'package:messenger_app_cubit/data/repositories/chat_repository.dart';
import 'package:messenger_app_cubit/logic/cubits/chat/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  final String currentUserId;

  StreamSubscription ? _messageSubscription;
  

  ChatCubit({
    required ChatRepository chatRepository,
    required this.currentUserId,
  }) : _chatRepository = chatRepository,
       super(const ChatState());

  void enterChat(String recieverId) async {
    emit(state.copyWith(status: ChatStatus.loading));
    try {
      final ChatRoom = await _chatRepository.getOrCreateChatRoom(
        currentUserId,
        recieverId,
      );
      emit(
        state.copyWith(
          chatRoomId: ChatRoom.id,
          receiverId: recieverId,
          status: ChatStatus.loaded,
        ));
        _subscribeToMessages(ChatRoom.id);
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatStatus.error,
          error: "Failed to create chat room $e",
        ),
      );
    }
  }

  Future<void> sendMessage({
    required String content,
    required String recieverId,
  }) async {
    if (state.chatRoomId == null) return;
    try {
      await _chatRepository.sendMessage(
        chatRoomId: state.chatRoomId!,
        senderId: currentUserId,
        recieverId: recieverId,
        content: content,
      );
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(error: "Failed to send message"));
    }
  }


  void _subscribeToMessages(String chatRoomId){
    _messageSubscription?.cancel();
    _messageSubscription=
        _chatRepository.getMessages(chatRoomId).listen((messages){
      emit(state.copyWith( 
        messages: messages,
         error: null
      ),);
    }, onError: (error){ 
      emit(state.copyWith(error: "Failed to load messages", status: ChatStatus.error  ));
    });
  }
}
