import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:videoplayer/bloc/auth/auth_bloc.dart';
import 'package:videoplayer/bloc/profile/profile_cubit.dart';
import 'package:videoplayer/model/custom_error.dart';

import 'package:videoplayer/view/dialog/error_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  void _getProfile() {
    final String uid = context.read<AuthBloc>().state.user!.uid;
    print('uid: $uid');
    context.read<ProfileCubit>().getProfile(uid: uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.profileStatus == ProfileStatus.error) {
            errorDialog(context, state.error);
          }
        },
        builder: (context, state) {
          if (state.profileStatus == ProfileStatus.initial) {
            return Container();
          } else if (state.profileStatus == ProfileStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.profileStatus == ProfileStatus.error) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/app_logo.png',
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 20.0),
                  const Text(
                    'Oops!\nTry again',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(
            alignment: Alignment.center,
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/app_logo.png',
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '-name: ${state.userData.username}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          '- id: ${state.userData.uid}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showmodalsheet,
        child: const Icon(Icons.upload),
      ),
    );
  }

  void _showmodalsheet() {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        builder: (_) {
          return Padding(
            padding: EdgeInsets.only(
                top: size.height * 0.03, bottom: size.width * 0.05),
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  'Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        fixedSize: Size(size.width * .3, size.height * .15),
                        shape: const CircleBorder(),
                      ),
                      onPressed: () async {
                        pickAndUploadVideo();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset('assets/images/gallery.png'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<void> pickAndUploadVideo() async {
    final XFile? pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      final File videoFile = File(pickedVideo.path);
      final String uid = context.read<AuthBloc>().state.user!.uid;

      try {
        final Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child(
                  'user_videos/$uid/${DateTime.now().millisecondsSinceEpoch}.mp4',
                );

        await firebaseStorageRef.putFile(videoFile);
        final String downloadURL = await firebaseStorageRef.getDownloadURL();

        await context
            .read<ProfileCubit>()
            .addVideoUrls(uid: uid, videoUrls: [downloadURL]);

        Navigator.of(context).pop(); // Close the bottom sheet after upload
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[300],
            content: Text('Video uploaded successfully'),
            duration: const Duration(seconds: 2),
          ),
        );
      } catch (e) {
        throw CustomError(
          code: 'Exception',
          message: e.toString(),
          plugin: 'flutter_error/server_error',
        );
        // Handle error as needed
      }
    }
  }
}
