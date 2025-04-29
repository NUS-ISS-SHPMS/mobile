import 'dart:math';

import 'package:flutter_onboarding/networks/restApis.dart';

class Plant {
  final int plantId;
  final int price;
  final String size;
  final double rating;
  final int humidity;
  final String temperature;
  final String category;
  final String plantName;
  final String imageURL;
  bool isFavorated;
  final String decription;
  bool isSelected;

  // 新增字段
  final String button; // 按钮状态
  final double moisture; // 土壤湿度
  final String relay; // 继电器状态

  Plant({
    required this.plantId,
    required this.price,
    required this.category,
    required this.plantName,
    required this.size,
    required this.rating,
    required this.humidity,
    required this.temperature,
    required this.imageURL,
    required this.isFavorated,
    required this.decription,
    required this.isSelected,
    required this.button, // 新增字段
    required this.moisture, // 新增字段
    required this.relay, // 新增字段
  });

  // 获取植物数据列表
  static Future<List<Plant>> fetchPlantList() async {
    final plants = await RestApis.fetchAllPlants();
    if (plants != null) {
      return plants.map((plant) {
        return Plant(
          plantId: plant.plantId,
          price: plant.price,
          category: plant.category,
          plantName: plant.plantName,
          size: plant.size,
          rating: plant.rating,
          humidity: plant.humidity,
          temperature: plant.temperature,
          imageURL: _getRandomImage(), // 随机分配图片
          isFavorated: plant.isFavorated,
          decription: plant.decription,
          isSelected: plant.isSelected,
          button: plant.button,
          moisture: plant.moisture,
          relay: plant.relay,
        );
      }).toList();
    } else {
      return []; // 如果获取失败，返回空列表
    }
  }

  // 随机获取图片路径
  static String _getRandomImage() {
    const List<String> images = [
      'assets/images/plant-one.png',
      'assets/images/plant-two.png',
      'assets/images/plant-three.png',
      'assets/images/plant-four.png',
      'assets/images/plant-five.png',
      'assets/images/plant-six.png',
      'assets/images/plant-seven.png',
      'assets/images/plant-eight.png',
    ];
    final random = Random();
    return images[random.nextInt(images.length)];
  }
}
