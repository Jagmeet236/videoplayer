import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:videoplayer/bloc/auth/auth_bloc.dart';
import 'package:videoplayer/bloc/profile/profile_cubit.dart';
import 'package:videoplayer/model/user_data.dart';
import 'package:videoplayer/view/screens/profile_screen.dart';

import 'package:videoplayer/view/screens/video_play_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<String> _videoUrls = []; // List to store fetched video URLs

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    try {
      final String uid = context.read<AuthBloc>().state.user!.uid;
      final UserData userData =
          await context.read<ProfileCubit>().getProfile(uid: uid);
      setState(() {
        _videoUrls = userData
            .videoUrls; // Assuming videoUrls is a list of video URLs in the UserData model
      });
    } catch (e) {
      print('Error fetching videos: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignOutRequestedEvent());
              },
              icon: const Icon(Icons.logout),
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ProfileScreen();
                  }));
                },
                icon: const Icon(Icons.person)),
          ],
          title: Text(
            'HomeScreen',
            style:
                tt.bodyLarge?.copyWith(color: Colors.black, letterSpacing: 0.2),
          ),
        ),
        body: Center(
          child: _videoUrls.isEmpty
              ? const Text('No videos available')
              : ProfileVideoCarousel(videoUrls: _videoUrls),
        ),
      ),
    );
  }
}
