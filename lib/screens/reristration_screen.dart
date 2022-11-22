import 'package:flutter/material.dart';
import 'package:flutter_lesson_13/screens/user_profile.dart';
import 'package:flutter_lesson_13/shared_preferens.dart';
import 'package:flutter_lesson_13/widget/input_decoration.dart';
import 'package:flutter_lesson_13/widget/text_button_class.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKeyKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  String eMail = '';
  String pHone = '';

  //записываем данные в память при регистрации
  Future<void> register(
      String name, String pass, String email, String phone) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    storage.setString(UserPreferens().nameKey, name);
    storage.setString(UserPreferens().passwordKey, pass);
    storage.setString(UserPreferens().emailKey, email);
    storage.setString(UserPreferens().phoneKey, phone);
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKeyKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              _buildSpacer(20),
              _buildAvatar(),
              _buildSpacer(10),
              SizedBox(
                width: currentWidth < 600 ? 100.w : 120.w,
                child: Column(
                  children: [
                    _buildTextFiledName(),
                    _buildSpacer(10),
                    _buildPhone(),
                    _buildSpacer(10),
                    _buildTextFiledEmail(),
                    _buildSpacer(10),
                    _buildTextFiledPassword(),
                  ],
                ),
              ),
              SizedBox(
                  width: currentWidth < 600 ? 50.w : 80.w,
                  child: _buildTextButton()),
              _buildSpacer(20),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return const Center(
      child: CircleAvatar(
        radius: 55,
        child: Icon(
          Icons.person_outline,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildTextFiledName() {
    return TextFormField(
      decoration: inputDecorationForm(
        const Text('Your name'),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Enter your name';
        return null;
      },
      onChanged: (value) {
        username = value;
      },
    );
  }

  Widget _buildPhone() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: inputDecorationForm(
        const Text('Phone'),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Enter your phone';
        return null;
      },
      onChanged: (value) {
        pHone = value;
      },
    );
  }

  Widget _buildTextFiledEmail() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: inputDecorationForm(
        const Text('E-mail'),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Enter your E-mail';
        if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) return 'Enter a valid E-mail';
        return null;
      },
      onChanged: (value) {
        eMail = value;
      },
    );
  }

  Widget _buildTextFiledPassword() {
    final passwordFieldKey = GlobalKey<FormFieldState<String>>();
    return Column(
      children: [
        TextFormField(
          obscureText: true,
          key: passwordFieldKey,
          decoration: inputDecorationForm(
            const Text('Password'),
          ),
          validator: (value) {
            if (value!.isEmpty) return 'Enter your password';
            if (value.length < 2) return 'The password is too short';
            return null;
          },
          onChanged: (value) {
            password = value;
          },
        ),
        _buildSpacer(10),
        TextFormField(
          obscureText: true,
          decoration: inputDecorationForm(
            const Text('Repeat password'),
          ),
          validator: (value) {
            if (value != passwordFieldKey.currentState!.value) {
              return 'Password does not match';
            }
            return null;
          },
        ),
        _buildSpacer(20),
      ],
    );
  }

  Widget _buildTextButton() {
    return TextButtonClass(
        title: 'Register',
        function: () {
          if (_formKeyKey.currentState!.validate()) {
            setState(() {
              register(username, password, eMail, pHone);
              Get.offAll(
                () => const UserProfile(),
              );
            });
          }
        });
  }
}

Widget _buildSpacer(double space) {
  return SizedBox(
    height: space,
  );
}
