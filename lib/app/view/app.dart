import 'package:anypass_movil_main/login/cubit/login_cubit.dart';
import 'package:anypass_movil_main/login/view/login_page.dart';
import 'package:anypass_movil_main/login/view/main_page.dart';
import 'package:anypass_movil_main/login/view/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Colors.teal),
        ),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: 0,
            shadowColor: Colors.transparent,
            title: const Text('Any Password'),
          ),
          body: BlocBuilder<LoginCubit, LoginState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              if (state.status == StatusLogin.login) {
                return const LoginPage();
              }
              if (state.status == StatusLogin.register) {
                return const RegisterPage();
              }
              if (state.status == StatusLogin.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == StatusLogin.success) {
                return const MainPage();
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
