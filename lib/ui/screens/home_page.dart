import 'package:flutter/material.dart';
import 'package:flutter_onboarding/constants.dart';
import 'package:flutter_onboarding/models/plants.dart';
import 'package:flutter_onboarding/ui/screens/detail_page.dart';
import 'package:flutter_onboarding/ui/screens/widgets/info_card.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Plant> _plantList = []; // 用于存储从 API 获取的植物数据
  bool isLoading = true; // 加载状态

  @override
  void initState() {
    super.initState();
    fetchPlants(); // 调用方法获取植物数据
  }

  Future<void> fetchPlants() async {
    final plants = await Plant.fetchPlantList(); // 调用 API 获取植物数据
    setState(() {
      _plantList = plants; // 更新植物列表
      isLoading = false; // 加载完成
    });
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    Size size = MediaQuery.of(context).size;

    // 植物分类
    List<String> _plantTypes = [
      'My Plants',
    ];

    // 切换收藏状态
    bool toggleIsFavorated(bool isFavorited) {
      return !isFavorited;
    }

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // 显示加载动画
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 50.0,
                    width: size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _plantTypes.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Text(
                                _plantTypes[index],
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: selectedIndex == index
                                      ? FontWeight.bold
                                      : FontWeight.w300,
                                  color: selectedIndex == index
                                      ? Constants.primaryColor
                                      : Constants.blackColor,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: size.height * .3,
                    child: ListView.builder(
                        itemCount: _plantList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: DetailPage(
                                    plant: _plantList[index], // 传递整个 Plant 对象
                                  ),
                                  type: PageTransitionType.bottomToTop,
                                ),
                              );
                            },
                            child: Container(
                              width: 200,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 10,
                                    right: 20,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      alignment: Alignment.center,
                                      child: Text(
                                        _plantList[index]
                                            .plantId
                                            .toString(), // 显示植物编号
                                        style: TextStyle(
                                          color: Constants.primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(50), // 保持圆形背景
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 5,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 50,
                                    right: 50,
                                    top: 50,
                                    bottom: 60,
                                    child:
                                        Image.asset(_plantList[index].imageURL),
                                  ),
                                  Positioned(
                                    bottom: 15,
                                    left: 20,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 5), // 添加间距
                                        Text(
                                          'Moisture: ${_plantList[index].moisture}%', // 显示土壤湿度
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 227, 249, 247),
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Relay: ${_plantList[index].relay}', // 显示继电器状态
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 227, 249, 247),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                color: Constants.primaryColor.withOpacity(.8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          );
                        }),
                  ),
                  const SizedBox(height: 10), // 添加间距
                  // 包裹 InfoCard 的容器
                  Center(
                    child: SizedBox(
                      width: size.width * 1, // 设置宽度为屏幕宽度
                      child: const InfoCard(), // InfoCard 保持原样
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
