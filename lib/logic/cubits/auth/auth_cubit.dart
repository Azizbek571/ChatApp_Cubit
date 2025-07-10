import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app_cubit/data/repositories/auth_repository.dart';
import 'package:messenger_app_cubit/logic/cubits/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {

  final AuthRepository _authRepository ; 
  StreamSubscription<User?>? _authStateSubscribtion;

  AuthCubit ({ 
    required AuthRepository authrepository,

  }): _authRepository = authrepository, super (AuthState()){
    _init();
  }



  void _init(){
    emit(state.copyWith(status: AuthStatus.initial));

    _authStateSubscribtion=_authRepository.AuthStateChanges.listen((user)async{ 
      if (user!=null) {
        try {
          final userData = await _authRepository.getUserData(user.uid);
          emit(state.copyWith(status: AuthStatus.authenticated, user: userData));
        } catch (e) {
          emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
        }
        
      }

      else{ 
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      }
    });
  }
} 