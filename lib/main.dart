import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mochi/app_localizations.dart';
import 'package:mochi/blocs/conversations/conversations_bloc.dart';
import 'package:mochi/blocs/conversations/conversations_event.dart';
import 'package:mochi/blocs/messages/messages_bloc.dart';

import 'package:mochi/blocs/simple_bloc_observer.dart';

import 'master_detail_layout.dart';

void main() {
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  if (!kIsWeb && (Platform.isLinux || Platform.isWindows)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ConversationsBloc>(
          create: (BuildContext context) {
            return ConversationsBloc()..add(LoadConversations());
          },
        ),
        BlocProvider<MessagesBloc>(
          create: (BuildContext context) {
            return MessagesBloc();
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      home: new GestureDetector(
        onTap: () {
          // this allows the TextFields to lose focus when the user clicks
          // anywhere else.
          // from: https://stackoverflow.com/a/54454654
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: MasterDetailLayout(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
