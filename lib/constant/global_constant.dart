import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

final userRef = FirebaseFirestore.instance.collection('users');

//global object for accessing device screen size
late Size size;
