import 'package:equatable/equatable.dart';
import 'package:messenger_app_cubit/config/exports.dart';
enum ChatStatus{ 
  inital,
  loading,
  loaded,
  error
}
class ChatState extends Equatable{ 
  final ChatStatus status;
  final String? error;
  final String? recieverId;
  final String? chatRoomId; 
  final List<ChatMessage> messages;

  const ChatState({ 
    this.status = ChatStatus.inital,
    this.recieverId,
    this.messages = const [],
    this.error,
    this.chatRoomId
  });
    ChatState copyWith({ 
      ChatStatus? status,
      String? error,
      List<ChatMessage>?messages,
      String? receiverId,
      String? chatRoomId,
    }){ 
      return ChatState(
        status: status ?? this.status, 
        error: error ?? this.error,
        recieverId: recieverId ?? this.recieverId,
        chatRoomId: chatRoomId ?? this.chatRoomId,
        );
    }
    @override 
    List<Object?>get props { 
      return [ 
        status,
        error, 
        recieverId,
        chatRoomId,
        messages
    ];
  }
}