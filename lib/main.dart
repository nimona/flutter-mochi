import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/blocs/conversations/conversations_bloc.dart';
import 'package:flutterapp/blocs/conversations/conversations_event.dart';

import 'package:flutterapp/blocs/simple_bloc_observer.dart';

import 'master_detail_layout.dart';

void main() {
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  if (!kIsWeb && (Platform.isLinux || Platform.isWindows)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  runApp(
    BlocProvider(
      create: (context) {
        return ConversationsBloc()..add(LoadConversations());
      },
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Bloc.observer = SimpleBlocObserver();
    return MaterialApp(
      title: 'Mochi',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.light, // HACK
        primarySwatch: Colors.blue,
      ),
      home: MasterDetailLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
