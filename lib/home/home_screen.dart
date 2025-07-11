import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app_cubit/data/services/service_locator.dart';
import 'package:messenger_app_cubit/logic/cubits/auth/auth_cubit.dart';
import 'package:messenger_app_cubit/presentation/screens/auth/login_screen.dart';
import 'package:messenger_app_cubit/router/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar( 
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
        body: Center(child: Text("User is AUTHENTICATED"),),
    );
  }
}