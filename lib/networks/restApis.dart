import 'package:flutter_onboarding/main/network/http_utils.dart';
import 'package:flutter_onboarding/models/EnvironmentModel.dart';
import 'package:flutter_onboarding/models/plants.dart';

class RestApis {
  // API URL
  static const String environmentEndpoint =
      'https://uqmugjssj3.execute-api.ap-southeast-1.amazonaws.com/latest';

  static const String controlEndpoint =
      'https://5mlnpaofi6jnsrltd3bqguvhbu0xrvil.lambda-url.ap-southeast-1.on.aws/';

  // 获取环境数据
  static Future<EnvironmentModel?> fetchEnvironmentData() async {
    try {
      final response = await HttpUtils.get<Map<String, dynamic>>(
        environmentEndpoint,
        loadingDialog: true,
      );

      if (response.code == 0 && response.data != null) {
        final environmentData = response.data!['environment'];
        return EnvironmentModel(
          temperature: environmentData['temperature'],
          light: environmentData['light'],
          humidity: environmentData['humidity'],
        );
      } else {
        print('Failed to fetch environment data: ${response.msg}');
        return null;
      }
    } catch (e) {
      print('Error fetching environment data: $e');
      return null;
    }
  }

  // 获取所有植物数据
  static Future<List<Plant>?> fetchAllPlants() async {
    try {
      final response = await HttpUtils.get<Map<String, dynamic>>(
        environmentEndpoint,
        loadingDialog: true,
      );

      if (response.code == 0 && response.data != null) {
        final plantsData = response.data!['plants'] as List<dynamic>;

        // 解析植物数据
        return plantsData.map((plant) {
          return Plant(
            plantId: plant['index'].toInt(),
            price: 0, // 默认值，API中未提供
            category: 'Unknown', // 默认值，API中未提供
            plantName: 'Plant ${plant['index']}', // 默认值，基于索引生成
            size: 'Unknown', // 默认值，API中未提供
            rating: 0.0, // 默认值，API中未提供
            humidity: 0, // 默认值，API中未提供
            temperature: 'Unknown', // 默认值，API中未提供
            imageURL: '', // 默认值，API中未提供
            isFavorated: false, // 默认值
            decription: '', // 默认值
            isSelected: false, // 默认值
            button: plant['button'],
            moisture: plant['moisture'],
            relay: plant['relay'],
          );
        }).toList();
      } else {
        print('Failed to fetch plants data: ${response.msg}');
        return null;
      }
    } catch (e) {
      print('Error fetching plants data: $e');
      return null;
    }
  }

  // 打开设备
  static Future<bool> turnOnDevice(int plantId) async {
    try {
      final response = await HttpUtils.post<Map<String, dynamic>>(
        controlEndpoint,
        data: {
          "plant_id": plantId,
          "state": "on",
        },
        loadingDialog: true,
      );

      if (response.code == 0) {
        print('Device turned ON successfully: ${response.data}');
        return true;
      } else {
        print('Failed to turn ON device: ${response.msg}');
        return false;
      }
    } catch (e) {
      print('Error turning ON device: $e');
      return false;
    }
  }

  // 关闭设备
  static Future<bool> turnOffDevice(int plantId) async {
    try {
      final response = await HttpUtils.post<Map<String, dynamic>>(
        controlEndpoint,
        data: {
          "plant_id": plantId,
          "state": "off",
        },
        loadingDialog: true,
      );

      if (response.code == 0) {
        print('Device turned OFF successfully: ${response.data}');
        return true;
      } else {
        print('Failed to turn OFF device: ${response.msg}');
        return false;
      }
    } catch (e) {
      print('Error turning OFF device: $e');
      return false;
    }
  }
}
