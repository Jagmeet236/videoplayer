import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:videoplayer/model/custom_error.dart';

void errorDialog(BuildContext context, CustomError e) {
  print('code: ${e.code}\nmessage: ${e.message}\nplugin: ${e.plugin}\n');

  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(e.code),
          content: Text('${e.plugin}\n${e.message}'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text(e.code)),
          content: Text(
            '${e.plugin}\n${e.message}',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
