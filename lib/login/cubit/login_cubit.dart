import 'dart:convert';

import 'package:anypass_movil_main/provider/provider.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  final Provider _provider = Provider();

  void goLogin() {
    emit(state.copyWith(status: StatusLogin.login));
  }

  void goRegister() {
    emit(state.copyWith(status: StatusLogin.register));
  }

  Future<void> login(String email, String password, String colorCode) async {
    emit(state.copyWith(status: StatusLogin.loading));
    final response = await _provider.login(email, password, colorCode);
    if (response == 'success') {
      await getApps();
      emit(state.copyWith(status: StatusLogin.success));
    } else {
      emit(
        state.copyWith(
          status: StatusLogin.login,
          isError: true,
          errorName: response,
        ),
      );
    }
  }

  Future<void> register(String email, String password, String colorCode) async {
    emit(state.copyWith(status: StatusLogin.loading));
    final response = await _provider.register(email, password, colorCode);
    if (response == 'success') {
      emit(state.copyWith(status: StatusLogin.login));
    } else {
      emit(
        state.copyWith(
          status: StatusLogin.register,
          isError: true,
          errorName: response,
        ),
      );
    }
  }

  Future<void> getApps() async {
    final alistapp = await _provider.getApplications();
    final listapp = <String>[
      ...alistapp,
    ];
    emit(
      state.copyWith(appNames: listapp),
    );
  }

  void desactivateCurrent() {
    emit(state.copyWith(activateCurrent: false));
  }

  Future<void> selectAppName(String app, int id) async {
    final response = await _provider.decrypt(app, id);
    if (response != '') {
      final data = (jsonDecode(response) as Map<String, dynamic>);
      emit(
        state.copyWith(
          currentName: app,
          currentUser: data['username'],
          currentPassword: data['password'],
          activateCurrent: true,
        ),
      );
    }
  }

  Future<void> registerApp(String appName, String user, String password) async {
    final response = await _provider.encrypt(appName, user, password);
    if (response == 'success') {
      await getApps();
    }
  }
}
