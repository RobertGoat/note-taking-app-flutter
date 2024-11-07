import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_but_better/firebase_options.dart';
import 'package:notes_but_better/pages/loginpage.dart';
import 'package:notes_but_better/pages/registerpage.dart';
import 'package:provider/provider.dart';
import 'package:notes_but_better/change_notifiers/notes_provider.dart';
import 'package:notes_but_better/change_notifiers/new_note_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase and log success
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase successfully initialized.');
  } catch (e) {
    // Log the error if Firebase initialization fails
    print('Error initializing Firebase: $e');
  }

  // Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => NewNoteController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes But Better',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        home: RegisterPage(),
      ),
    );
  }
}
