import 'package:anypass_movil_main/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Any Password'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(10),
          child: _MainPage(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => const AlertDialog(
                title: Text('Encrypt'),
                content: _EncryptForm(),
              ),
            );
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class _MainPage extends StatefulWidget {
  const _MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Color pickerColor = Colors.blue;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(state.currentName ?? ''),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username: ${state.currentUser ?? ''}'),
                Text('Password: ${state.currentPassword ?? ''}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        ).then((value) => context.read<LoginCubit>().desactivateCurrent());
      },
      listenWhen: (previous, current) =>
          previous.activateCurrent == false && current.activateCurrent == true,
      buildWhen: (previous, current) => previous.appNames != current.appNames,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Credentials',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              if (state.appNames != null) ...{
                ...state.appNames!
                    .asMap()
                    .entries
                    .map<Widget>(
                      (e) => Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              e.value,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () async {
                                await context
                                    .read<LoginCubit>()
                                    .selectAppName(e.value, e.key);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white),
                              child: const Text(
                                'Decrypt',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                    .toList(),
              }
            ],
          ),
        );
      },
    );
  }
}

class _EncryptForm extends StatefulWidget {
  const _EncryptForm({Key? key}) : super(key: key);

  @override
  _EncryptFormState createState() => _EncryptFormState();
}

class _EncryptFormState extends State<_EncryptForm> {
  final appController = TextEditingController();
  final userController = TextEditingController();
  final passController = TextEditingController();
  bool isActive = false;

  @override
  void initState() {
    appController.addListener(() {
      setState(() => isActive = appController.text.isNotEmpty &&
          userController.text.isNotEmpty &&
          passController.text.isNotEmpty);
    });
    userController.addListener(() {
      setState(() => isActive = appController.text.isNotEmpty &&
          userController.text.isNotEmpty &&
          passController.text.isNotEmpty);
    });
    passController.addListener(() {
      setState(() => isActive = appController.text.isNotEmpty &&
          userController.text.isNotEmpty &&
          passController.text.isNotEmpty);
    });
    super.initState();
  }

  @override
  void dispose() {
    appController.dispose();
    userController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: appController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Application',
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: userController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: passController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: (isActive)
                  ? () {
                      context.read<LoginCubit>().registerApp(appController.text,
                          userController.text, passController.text);
                      Navigator.of(context).pop();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                'Encrypt',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
