import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videoplayer/bloc/auth/auth_bloc.dart';
import 'package:videoplayer/view/screens/home_screen.dart';
import 'package:videoplayer/view/screens/sign_in_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.unauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            SignInScreen.routeName,
            (route) {
              print('route.settings.name: ${route.settings.name}');
              print('ModalRoute: ${ModalRoute.of(context)!.settings.name}');

              return route.settings.name ==
                      ModalRoute.of(context)!.settings.name
                  ? true
                  : false;
            },
          );
        } else if (state.authStatus == AuthStatus.authenticated) {
          Navigator.pushNamed(context, HomeScreen.routeName);
        }
      },
      builder: (context, state) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
