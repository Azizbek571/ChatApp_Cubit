import 'package:messenger_app_cubit/logic/cubits/chat/chat_cubit.dart';
import 'package:messenger_app_cubit/logic/cubits/chat/chat_state.dart';

import '../../config/exports.dart';

class ChatMessageScreen extends StatefulWidget {
  final String recieverId;
  final String recieverName;
  const ChatMessageScreen({
    super.key,
    required this.recieverId,
    required this.recieverName,
  });
  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  final TextEditingController messageController = TextEditingController();
  late final ChatCubit _chatCubit;

  @override
  void initState() {
    _chatCubit = getIt<ChatCubit>();
    _chatCubit.enterChat(widget.recieverId);
    super.initState();
  }

  Future<void> handleSendMessage() async {
    final messageText = messageController.text.trim();
    messageController.clear();

    await _chatCubit.sendMessage(
      content: messageText,
      recieverId: widget.recieverId,
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Text(widget.recieverName[0].toUpperCase()),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Online",
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        bloc: _chatCubit,
        builder: (context, state) {
          if (state.status == ChatStatus.loading){ 
            return Center(child: const CircularProgressIndicator());
          }
          if (state.status == ChatStatus.error) {
              Center(child: Text(state.error ?? "Something went wrong"),);
            
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      message: ChatMessage(
                        id: "5414164541",
                        chatRoomId: "4848494894",
                        senderId: "646541654",
                        recieverId: "4198419849",
                        content: "Hi, This is my first message",
                        timestamp: Timestamp.now(),
                        status: MessageStatus.sent,
                        readBy: [],
                      ),
                      isMe: false,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.emoji_emotions),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onTap: () {},
                            controller: messageController,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: "Type a message",
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),

                              fillColor: Theme.of(context).cardColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          onPressed: handleSendMessage,
                          icon: Icon(Icons.send),
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  // final bool showTime;
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    // this.showTime=true
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? 64 : 8,
          right: isMe ? 8 : 64,
          bottom: 4,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isMe
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,

          children: [
            Text(
              message.content,
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "4:54 PM",
                  style: TextStyle(color: isMe ? Colors.white : Colors.black),
                ),
                Icon(
                  Icons.done_all,
                  color:
                      message.status == MessageStatus.read
                          ? Colors.red
                          : Colors.white70,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
