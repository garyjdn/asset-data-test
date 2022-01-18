import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_cubit.dart';
import '../helpers/errors/network_exceptions.dart';
import 'shared/popup/message_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController(text: 'test_flutter@mailinator.com');
  final _passwordCtrl = TextEditingController(
      text: 'VW1Gb1lYTnBZVEl3TWpJaEswSlNibkp2V1VGRWMyc2grWUFEc2shIQ==');
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  void _toggleObscurePassword() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void signIn() {
    if (_formKey.currentState?.validate() ?? false) {
      String _email = _userCtrl.text;
      String _password = _passwordCtrl.text;
      context.read<AuthCubit>().login(
            email: _email,
            password: _password,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 400,
                  minHeight: size.height,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Login',
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _userCtrl,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'email is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _passwordCtrl,
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: GestureDetector(
                            onTap: _toggleObscurePassword,
                            child: Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 12.0),
                              child: Icon(_obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                        obscureText: _obscurePassword,
                        onFieldSubmitted: (string) {
                          final authState = context.read<AuthCubit>().state;
                          if (authState is! Authenticating) {
                            signIn();
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is AuthenticationFailure) {
                              showDialog(
                                  context: context,
                                  builder: (_) => MessageDialog(
                                      title: "Oops..",
                                      message: state.error
                                              is UnauthorisedRequest
                                          ? "Email atau password salah"
                                          : "Telah terjadi kesalahan, coba sekali lagi."));
                            }
                          },
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () {
                                if (state is! Authenticating) {
                                  signIn();
                                }
                              },
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                              ),
                              child: state is Authenticating
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text('Sign In'),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
