import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:videoplayer/bloc/auth/auth_bloc.dart';
import 'package:videoplayer/bloc/profile/profile_cubit.dart';
import 'package:videoplayer/bloc/sign_in/sign_in_cubit.dart';
import 'package:videoplayer/repository/auth_repository.dart';
import 'package:videoplayer/repository/profile_repository.dart';
import 'package:videoplayer/view/screens/home_screen.dart';
import 'package:videoplayer/view/screens/sign_in_screen.dart';
import 'package:videoplayer/view/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(
              firebaseFirestore: FirebaseFirestore.instance,
              firebaseAuth: FirebaseAuth.instance),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<SignInCubit>(
            create: (context) => SignInCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
              profileRepository: context.read<ProfileRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Video Player',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(centerTitle: true),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
          routes: {
            SignInScreen.routeName: (context) => const SignInScreen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
          },
        ),
      ),
    );
  }
}
