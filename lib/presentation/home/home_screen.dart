import 'package:flutter/material.dart';
import 'package:messenger_app_cubit/data/repositories/contact_repository.dart';
import 'package:messenger_app_cubit/data/services/service_locator.dart';
import 'package:messenger_app_cubit/logic/cubits/auth/auth_cubit.dart';
import 'package:messenger_app_cubit/presentation/chat/chat_message_screen.dart';
import 'package:messenger_app_cubit/presentation/screens/auth/login_screen.dart';
import 'package:messenger_app_cubit/router/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ContactRepository _contactRepository;
  @override
  void initState() {
    _contactRepository = getIt<ContactRepository>();
    super.initState();
  }

  void _showContactList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "Contacts",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _contactRepository.getRegisteredContacts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: $snapshot.error"));
                    }
                    if (!snapshot.hasData) {
                      return Center(child: const CircularProgressIndicator());
                    }
                    final contacts = snapshot.data!;
                    if (contacts.isEmpty) {
                      return Center(child: const Text("No contacts found"));
                    }
                    return ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            child: Text(contact["name"][0].toUpperCase()),
                          ),
                          title: Text(contact["name"]),
                          onTap: () {
                            getIt<AppRouter>().push(ChatMessageScreen(
                              recieverId: contact ['id'], 
                              recieverName: contact['name'][0],),);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          InkWell(
            onTap: () async {
              await getIt<AuthCubit>().signOut();
              getIt<AppRouter>().pushAndRemoveuntil(LoginScreen());
            },
            child: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: Text("User is AUTHENTICATED")),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showContactList(context),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
        child: Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}
