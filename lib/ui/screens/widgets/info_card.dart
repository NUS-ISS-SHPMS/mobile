import 'package:flutter/material.dart';
import 'package:flutter_onboarding/models/EnvironmentModel.dart';
import 'package:flutter_onboarding/networks/restApis.dart';

class InfoCard extends StatefulWidget {
  const InfoCard({Key? key}) : super(key: key);

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  EnvironmentModel? environment;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEnvironmentData();
  }

  Future<void> fetchEnvironmentData() async {
    final data = await RestApis.fetchEnvironmentData();
    setState(() {
      environment = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30), // 增加内边距
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.deepPurple, // 背景颜色
        borderRadius: BorderRadius.circular(20), // 圆角
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator()) // 加载中状态
          : environment == null
              ? const Center(child: Text('Failed to load data')) // 加载失败
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Environment',
                      style: TextStyle(
                        fontSize: 28, // 增大标题字体
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20), // 间距
                    const Icon(
                      Icons.wb_sunny, // 图标
                      color: Colors.yellow,
                      size: 85, // 增大图标大小
                    ),
                    const SizedBox(height: 20), // 间距
                    Text(
                      '${environment!.temperature}°C',
                      style: const TextStyle(
                        fontSize: 50, // 增大温度字体
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20), // 间距
                    Text(
                      'Light: ${environment!.light} lx',
                      style: const TextStyle(
                        fontSize: 25, // 增大光照字体
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 10), // 间距
                    Text(
                      'Humidity: ${environment!.humidity}%',
                      style: const TextStyle(
                        fontSize: 25, // 增大湿度字体
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
    );
  }
}
