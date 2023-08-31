import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

//Screens
import 'screens/login_screen.dart';
import './screens/home_screen.dart';

//Providers
import './provider/appwrite_provider.dart';

final GetStorage getStorage = GetStorage();

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AppWriteProvider(),
        ),
      ],
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: getStorage.read('userId') != null ? HomePage() : LoginPage(),
        routes: {
          HomePage.pageRoute: (ctx) => HomePage(),
          LoginPage.pageRoute: (ctx) => LoginPage(),
        },
      ),
    );
  }
}
