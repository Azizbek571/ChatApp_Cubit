import 'package:flutter/material.dart';
import 'package:messenger_app_cubit/data/repositories/contact_repository.dart';
import 'package:messenger_app_cubit/data/services/service_locator.dart';
import 'package:messenger_app_cubit/logic/cubits/auth/auth_cubit.dart';
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
  Widget build(BuildContext context) {
    return Scaffold( 


      appBar: AppBar( 


        title: const Text("Chats"),
        actions: [ 
          InkWell( 
            onTap: () async{
               await  getIt<AuthCubit>().signOut();
               getIt<AppRouter>().pushAndRemoveuntil(LoginScreen());
            },
            child: Icon( 
                    Icons.logout
            ),
          )
        ],
      ),
        body: Center(child: Text("User is AUTHENTICATED"),
        ),

        floatingActionButton: FloatingActionButton(onPressed: (){ 

        },
         backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
         child: Icon(Icons.chat, color: Colors.white,),
        )  ,
    );
  }
}