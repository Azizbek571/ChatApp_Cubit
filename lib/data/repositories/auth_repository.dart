



import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger_app_cubit/data/models/user_model.dart';
import 'package:messenger_app_cubit/data/services/base_repositories.dart';
import 'package:messenger_app_cubit/logic/cubits/auth/auth_state.dart';

class AuthRepository extends BaseRepositories {

  Stream <User?> get AuthStateChanges => auth.authStateChanges();



     Future<UserModel>signUp({ 
      required String fullName,
      required String username,
      required String email,
      required String phoneNumber,
      required String password,
     }) async{
          try {
          final formattedPhoneNumber = phoneNumber.replaceAll(RegExp(r'\s+'), "".trim());

            final UserCredential = await auth.createUserWithEmailAndPassword(
              email: email, 
              password: password);
            if (UserCredential.user==null) {
              throw "Failed to create user";
              
            }
            final user = UserModel(
              uid: UserCredential.user!.uid, 
            username: username, 
            fullName: fullName,
             email: email,
              phoneNumber: formattedPhoneNumber);
  await saveUserData(user);
  return user;
          } catch (e) {
            log(e.toString());
            rethrow;
          }
     }




     Future<UserModel>signIn({ 
   
      required String email,
    
      required String password,
     }) async{
          try {
            final userCredential = await auth.signInWithEmailAndPassword(
              email: email, 
              password: password);
            if (userCredential.user==null) {
              throw "User not found";
              
            }

             
   final userData = await getUserData(userCredential.user!.uid);
   return userData;
          } catch (e) {
            log(e.toString());
            rethrow;
          }
     }



Future<void>  saveUserData(UserModel user)async{
  try {
    firestore.collection("users").doc(user.uid).set(user.toMap());
  } catch (e) {
      throw "Failed to save user data";
  }
}

Future <void> signOut() async { 
  await auth.signOut();
}

Future<UserModel>  getUserData(String uid)async{
  try {
  final doc =  await firestore.collection("users").doc(uid).get();
  if(!doc.exists){
    throw "User data not found";
  }
log(doc.id);
  return  UserModel.fromFirestore(doc);
  } catch (e) {
      throw "Failed to save user data";
  }
}
     
}