import 'package:anypass_movil_main/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Map<Color, String> colorsList = <Color, String>{
  const Color.fromARGB(255, 244, 67, 54): '#F44336',
  const Color.fromARGB(255, 233, 30, 99): '#E91E63',
  const Color.fromARGB(255, 156, 39, 176): '#9C27B0',
  const Color.fromARGB(255, 103, 58, 183): '#673AB7',
  const Color.fromARGB(255, 63, 81, 181): '#3F51B5',
  const Color.fromARGB(255, 33, 150, 243): '#2196F3',
  const Color.fromARGB(255, 3, 169, 244): '#03A9F4',
  const Color.fromARGB(255, 0, 188, 212): '#00BCD4',
  const Color.fromARGB(255, 0, 150, 136): '#009688',
  const Color.fromARGB(255, 76, 175, 80): '#4CAF50',
  const Color.fromARGB(255, 139, 195, 74): '#8BC34A',
  const Color.fromARGB(255, 205, 220, 57): '#CDDC39',
  const Color.fromARGB(255, 255, 235, 59): '#FFEB3B',
  const Color.fromARGB(255, 255, 193, 7): '#FFC107',
  const Color.fromARGB(255, 255, 152, 0): '#FF9800',
  const Color.fromARGB(255, 255, 87, 34): '#FF5722',
  const Color.fromARGB(255, 121, 85, 72): '#795548',
  const Color.fromARGB(255, 96, 125, 139): '#607D8B',
};

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Any Password'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(10),
          child: _RegisterForm(),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Color pickerColor = const Color.fromARGB(255, 244, 67, 54);

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
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.teal,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 65,
                ),
              )),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Register',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email address',
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: Expanded(
              child: BlockPicker(
                useInShowDialog: false,
                pickerColor: pickerColor,
                onColorChanged: changeColor,
                layoutBuilder: _layoutBuilder,
                availableColors: colorsList.keys.toList(),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                context.read<LoginCubit>().register(
                      emailController.text,
                      passwordController.text,
                      colorsList[pickerColor] ?? '#F44336',
                    );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                'Register',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Already have an account?'),
              TextButton(
                child: const Text(
                  'Log In',
                  style: TextStyle(color: Colors.teal),
                ),
                onPressed: () {
                  context.read<LoginCubit>().goLogin();
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

Widget _layoutBuilder(
    BuildContext context, List<Color> colors, PickerItem child) {
  return GridView.count(
    shrinkWrap: true,
    crossAxisCount: 6,
    crossAxisSpacing: 5,
    mainAxisSpacing: 5,
    children: [for (Color color in colors) child(color)],
  );
}
