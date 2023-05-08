import 'package:contact_list/screens/HomeScreen.dart';
import 'package:contact_list/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await MongoDataBase.connect();
  prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SharedPrefsModel(email: ''),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var email = prefs.getString('email') ?? "";
    context.read<SharedPrefsModel>().email = email;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yellow Class',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/home-screen': (context) => HomePage(),
        '/login-screen': (context) => const LoginScreen(),
      },
      initialRoute: email == "" ? '/login-screen' : '/home-screen',
    );
  }
}
