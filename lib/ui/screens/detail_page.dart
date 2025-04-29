import 'package:flutter/material.dart';
import 'package:flutter_onboarding/constants.dart';
import 'package:flutter_onboarding/models/plants.dart';
import 'package:flutter_onboarding/networks/restApis.dart';

class DetailPage extends StatefulWidget {
  final Plant plant; // 修改为接收 Plant 对象

  const DetailPage({Key? key, required this.plant}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isWaterOn = false; // 用于控制水滴开关状态

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Constants.primaryColor.withOpacity(.15),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    debugPrint('favorite');
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Constants.primaryColor.withOpacity(.15),
                    ),
                    child: Center(
                      child: Text(
                        widget.plant.plantId.toString(), // 显示编号
                        style: TextStyle(
                          color: Constants.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 78,
            left: 20,
            right: 20,
            child: Container(
              width: size.width * .8,
              height: size.height * .8,
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: -12,
                    child: SizedBox(
                      height: 250, // 调整图片高度为 250
                      width: 150, // 设置图片宽度为 150
                      child: Image.asset(
                        widget.plant.imageURL,
                        fit: BoxFit.contain, // 确保图片按比例缩放
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 0,
                    child: SizedBox(
                      height: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 30), // 添加间距
                          Text(
                            'Button: Not Pressed',
                            style: TextStyle(
                              color: Constants.primaryColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Moisture: 0.0%',
                            style: TextStyle(
                              color: Constants.primaryColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Relay: off',
                            style: TextStyle(
                              color: Constants.primaryColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 按钮部分
          Positioned(
            bottom: 150, // 将按钮从底部向上移动
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final success = await RestApis.turnOnDevice(
                            widget.plant.plantId); // 调用打开设备的 API
                        if (success) {
                          setState(() {
                            isWaterOn = true; // 更新水滴状态为打开
                            debugPrint('Device turned ON');
                          });
                        } else {
                          debugPrint('Failed to turn ON device');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(120, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'ON',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final success = await RestApis.turnOffDevice(
                            widget.plant.plantId); // 调用关闭设备的 API
                        if (success) {
                          setState(() {
                            isWaterOn = false; // 更新水滴状态为关闭
                            debugPrint('Device turned OFF');
                          });
                        } else {
                          debugPrint('Failed to turn OFF device');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(120, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'OFF',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // 按钮和水滴之间的间距
                IconButton(
                  icon: Icon(
                    isWaterOn
                        ? Icons.water_drop // 水滴填充
                        : Icons.water_drop_outlined, // 水滴空心
                    color: isWaterOn ? Colors.blue : Colors.grey,
                    size: 200,
                  ),
                  onPressed: () {
                    debugPrint('Water drop button pressed');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
