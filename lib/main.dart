import 'package:flutter/material.dart';
import 'package:flutter_onboarding/main/network/http_utils.dart';
import 'package:flutter_onboarding/main/utils/logutil.dart';
import 'package:flutter_onboarding/ui/onboarding_screen.dart';
import 'package:flutter_onboarding/ui/screens/signin_page.dart';
import 'package:get_storage/get_storage.dart';
import 'networks/restApis.dart';
import 'models/EnvironmentModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LogUtil.init();
  await GetStorage.init();
  // 重要
  await HttpUtils.init(unAuthHandle: () {
    // 退出登录
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Environment Data Test',
      // home: EnvironmentTestScreen(),
      // home: OnboardingScreen(),
      home: SignIn(), // 直接跳转到 SignIn 页面
      debugShowCheckedModeBanner: false,
    );
  }
}

class EnvironmentTestScreen extends StatefulWidget {
  const EnvironmentTestScreen({Key? key}) : super(key: key);

  @override
  State<EnvironmentTestScreen> createState() => _EnvironmentTestScreenState();
}

class _EnvironmentTestScreenState extends State<EnvironmentTestScreen> {
  EnvironmentModel? environment;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final data = await RestApis.fetchEnvironmentData();
    setState(() {
      environment = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Environment Data Test'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : environment == null
              ? const Center(child: Text('Failed to load data'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Temperature: ${environment!.temperature}°C'),
                      Text('Light: ${environment!.light} lx'),
                      Text('Humidity: ${environment!.humidity}%'),
                    ],
                  ),
                ),
    );
  }
}
