import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videoplayer/bloc/sign_in/sign_in_cubit.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = '/signin';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          FloatingActionButton.extended(
              elevation: 1,
              onPressed: () {
                context.read<SignInCubit>().signInWithGoogle();
              },
              backgroundColor: Colors.white,
              label: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Image(
                          height: 20,
                          image: AssetImage('assets/icons/google.png'),
                        )),
                    Padding(
                      padding: EdgeInsets.only(left: 12.0, top: 12),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 1,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ])),
        ]),
      ),
    );
  }
}
