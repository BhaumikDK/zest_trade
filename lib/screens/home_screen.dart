import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zest_trade/models/base_model.dart';
import 'package:zest_trade/models/trade_list_model.dart';
import 'package:zest_trade/utils/app_constant.dart';
import 'package:zest_trade/utils/base_colors.dart';
import 'package:zest_trade/utils/base_images.dart';
import 'package:zest_trade/utils/extensions.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final nameOneController = TextEditingController();
  final nameTwoController = TextEditingController();
  int selectedIndex = 0;
  PageController pageController = PageController(
    initialPage: 0,
  );
  List<TradeModel> tradeListData = [];
  List<TradeModel> tempTradeListData = [];
  bool isLoading = true;
  int pageCount = 1;
  final ScrollController _scrollController = ScrollController();

  TextStyle get tabStyle => const TextStyle(
      color: BaseColors.BLACK,
      fontFamily: BaseFonts.popins_bold,
      fontSize: 14,
      fontWeight: FontWeight.w600);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!isLoading) {
          isLoading = !isLoading;
          pageCount++;
          getTradeListData(page: pageCount);
        }
      }
    });
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          shape: OutlineInputBorder(
              borderSide: const BorderSide(
                color: BaseColors.transparent,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: 15.0.toRadius,
                bottomRight: 15.0.toRadius,
              )),
          title: const Text(BaseStrings.tradeList,
              style: TextStyle(
                color: BaseColors.WHITE,
                fontSize: 18.0,
                fontFamily: BaseFonts.popins_bold,
              )),
          actions: [
            IconButton(
                onPressed: () {}, icon: Image.asset(BaseImages.IC_FILTER))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: tabWidget(),
        ),
      ),
    );
  }

  Widget tabWidget() {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.zero,
          shape: const StadiumBorder(),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      pageCount = 1;
                      isLoading = true;
                      getTradeListData(page: pageCount, type: 'expired');
                      if (selectedIndex == 1) {
                        pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      }
                    });
                  },
                  borderRadius: 90.0.toAllBorderRadius,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: 90.0.toAllBorderRadius,
                        color: selectedIndex == 0
                            ? BaseColors.SKY_BLUE
                            : BaseColors.WHITE),
                    child: Text('Ongoing Trades',
                        style: tabStyle.copyWith(
                            color: selectedIndex == 0
                                ? BaseColors.WHITE
                                : BaseColors.BLACK)),
                  ),
                ).toExpanded,
                10.0.toHSB,
                InkWell(
                  onTap: () {
                    setState(() {
                      if (selectedIndex == 0) {
                        pageCount = 1;
                        isLoading = true;
                        getTradeListData(
                          page: pageCount,
                        );
                        pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      }
                    });
                  },
                  borderRadius: 90.0.toAllBorderRadius,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: 90.0.toAllBorderRadius,
                        color: selectedIndex == 1
                            ? BaseColors.SKY_BLUE
                            : BaseColors.WHITE),
                    child: Text('Expired Trades',
                        style: tabStyle.copyWith(
                            color: selectedIndex == 1
                                ? BaseColors.WHITE
                                : BaseColors.BLACK)),
                  ),
                ).toExpanded
              ],
            ),
          ),
        ),
        14.0.toVSB,
        PageView(
          controller: pageController,
          onPageChanged: (er) {
            setState(() {
              selectedIndex = er;
            });
          },
          children: [
            pageOne(),
            pageTwo(),
          ],
        ).toExpanded,
      ],
    );
  }

  Widget pageOne() {
    return Column(
      children: [
        TextFormField(
          controller: nameOneController,
          onChanged: (value) {
            filterSearchResults(value);
          },
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          cursorColor: BaseColors.SKY_BLUE,
          decoration: InputDecoration(
            constraints: const BoxConstraints(maxHeight: 50),
            contentPadding: const EdgeInsets.all(8),
            suffixIcon: const Icon(Icons.search, color: Color(0xFF000000)),
            focusedBorder: OutlineInputBorder(
                borderRadius: 10.0.toAllBorderRadius,
                borderSide: const BorderSide(
                    color: Color.fromRGBO(0, 0, 0, 0.1), width: 1)),
            enabledBorder: OutlineInputBorder(
              borderRadius: 10.0.toAllBorderRadius,
              borderSide: const BorderSide(color: Color.fromRGBO(0, 0, 0, 0.1)),
            ),
            hintText: BaseStrings.searchHint,
            hintStyle: const TextStyle(
                color: Color.fromARGB(255, 158, 156, 156), fontSize: 16),
          ),
        ),
        const SizedBox(height: 20),
        FutureBuilder(
            future: getTradeListData(page: 1),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return tempTradeListData.isEmpty
                    ? const Text('No data found').toCenter
                    : ListView.separated(
                        controller: _scrollController,
                        itemCount: tempTradeListData.length,
                        separatorBuilder: (_, index) => 12.0.toVSB,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (_, index) {
                          var data = tempTradeListData[index];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: 8.0.toAllBorderRadius,
                              color: BaseColors.WHITE,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.10),
                                  blurRadius: 8,
                                  offset: Offset(4, 4),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: 8.0.toRadius,
                                        topLeft: 8.0.toRadius),
                                    color: BaseColors.SKY_BLUE,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${data.stock}",
                                        style: const TextStyle(
                                            color: BaseColors.WHITE,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            fontFamily: BaseFonts.popins_bold),
                                      ).toExpanded,
                                      Row(
                                        children: [
                                          Text(
                                              DateFormat("dd-MM-yyyy")
                                                  .format(DateTime.now()),
                                              style: const TextStyle(
                                                  color: BaseColors.WHITE,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  fontFamily:
                                                      BaseFonts.popins_bold)),
                                          14.0.toHSB,
                                          Image.asset(
                                            BaseImages.ic_arrow,
                                            color: BaseColors.WHITE,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          textDetailer(
                                                  header: 'Type:',
                                                  ans: '${data.type}')
                                              .toExpanded,
                                          textDetailer(
                                                  header: 'Entry:',
                                                  ans: '${data.entryPrice}',
                                                  isMoneyActive: true)
                                              .toExpanded,
                                          textDetailer(
                                                  header: 'Exit:',
                                                  ans: '${data.exitPrice}',
                                                  isMoneyActive: true)
                                              .toExpanded,
                                        ],
                                      ),
                                      10.0.toVSB,
                                      Row(
                                        children: [
                                          textDetailer(
                                                  header: 'Stop Loss:',
                                                  ans: '${data.stopLossPrice}',
                                                  isMoneyActive: true)
                                              .toExpanded,
                                          textDetailer(
                                            header: 'Stock Name:',
                                            ans: '${data.name}',
                                          ).toExpanded,
                                          textDetailer(
                                            header: 'Action',
                                            ans: '${data.action}',
                                          ).toExpanded,
                                        ],
                                      ),
                                      10.0.toVSB,
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Status:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: BaseColors.GRAY_3,
                                                    fontSize: 12),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6.0,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      90.0.toAllBorderRadius,
                                                  color: const Color.fromRGBO(
                                                      0, 189, 177, 0.10),
                                                ),
                                                child: Text('${data.status}',
                                                    style: TextStyle(
                                                        color: BaseColors
                                                            .SKY_BLUE)),
                                              ),
                                            ],
                                          ).toExpanded,
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Posted by:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: BaseColors.GRAY_3,
                                                    fontSize: 12),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6.0,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      90.0.toAllBorderRadius,
                                                  color: const Color.fromRGBO(
                                                      0, 189, 177, 0.10),
                                                ),
                                                child: Text(
                                                    '${data.user != null ? data.user!.name : ''}',
                                                    style: const TextStyle(
                                                        color: BaseColors
                                                            .SKY_BLUE)),
                                              ),
                                            ],
                                          ).toExpanded,
                                          // SizedBox().toExpanded,
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
              } else {
                return const CircularProgressIndicator().toCenter;
              }
            }).toExpanded
      ],
    );
  }

  Widget pageTwo() {
    return Column(
      children: [
        TextFormField(
          controller: nameTwoController,
          onChanged: (value) {
            filterSearchResults(value);
          },
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          cursorColor: BaseColors.SKY_BLUE,
          decoration: InputDecoration(
            constraints: const BoxConstraints(maxHeight: 50),
            contentPadding: const EdgeInsets.all(8),
            suffixIcon: const Icon(Icons.search, color: Color(0xFF000000)),
            focusedBorder: OutlineInputBorder(
                borderRadius: 10.0.toAllBorderRadius,
                borderSide: const BorderSide(
                    color: Color.fromRGBO(0, 0, 0, 0.1), width: 1)),
            enabledBorder: OutlineInputBorder(
              borderRadius: 10.0.toAllBorderRadius,
              borderSide: const BorderSide(color: Color.fromRGBO(0, 0, 0, 0.1)),
            ),
            hintText: BaseStrings.searchHint,
            hintStyle: const TextStyle(
                color: Color.fromARGB(255, 158, 156, 156), fontSize: 16),
          ),
        ),
        const SizedBox(height: 20),
        FutureBuilder(
            future: getTradeListData(page: 1),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return tempTradeListData.isEmpty
                    ? const Text('No data found').toCenter
                    : ListView.separated(
                        controller: _scrollController,
                        itemCount: tempTradeListData.length,
                        separatorBuilder: (_, index) => 12.0.toVSB,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (_, index) {
                          var data = tempTradeListData[index];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: 8.0.toAllBorderRadius,
                              color: BaseColors.WHITE,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.10),
                                  blurRadius: 8,
                                  offset: Offset(4, 4),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: 8.0.toRadius,
                                        topLeft: 8.0.toRadius),
                                    color: BaseColors.SKY_BLUE,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${data.stock}",
                                        style: const TextStyle(
                                            color: BaseColors.WHITE,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                            fontFamily: BaseFonts.popins_bold),
                                      ).toExpanded,
                                      Row(
                                        children: [
                                          Text(
                                              DateFormat("dd-MM-yyyy")
                                                  .format(DateTime.now()),
                                              style: const TextStyle(
                                                  color: BaseColors.WHITE,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  fontFamily:
                                                      BaseFonts.popins_bold)),
                                          14.0.toHSB,
                                          Image.asset(
                                            BaseImages.ic_arrow,
                                            color: BaseColors.WHITE,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          textDetailer(
                                                  header: 'Type:',
                                                  ans: '${data.type}')
                                              .toExpanded,
                                          textDetailer(
                                                  header: 'Entry:',
                                                  ans: '${data.entryPrice}',
                                                  isMoneyActive: true)
                                              .toExpanded,
                                          textDetailer(
                                                  header: 'Exit:',
                                                  ans: '${data.exitPrice}',
                                                  isMoneyActive: true)
                                              .toExpanded,
                                        ],
                                      ),
                                      10.0.toVSB,
                                      Row(
                                        children: [
                                          textDetailer(
                                                  header: 'Stop Loss:',
                                                  ans: '${data.stopLossPrice}',
                                                  isMoneyActive: true)
                                              .toExpanded,
                                          textDetailer(
                                            header: 'Stock Name:',
                                            ans: '${data.name}',
                                          ).toExpanded,
                                          textDetailer(
                                            header: 'Action',
                                            ans: '${data.action}',
                                          ).toExpanded,
                                        ],
                                      ),
                                      10.0.toVSB,
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Status:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: BaseColors.GRAY_3,
                                                    fontSize: 12),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6.0,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      90.0.toAllBorderRadius,
                                                  color: const Color.fromRGBO(
                                                      0, 189, 177, 0.10),
                                                ),
                                                child: Text('${data.status}',
                                                    style: TextStyle(
                                                        color: BaseColors
                                                            .SKY_BLUE)),
                                              ),
                                            ],
                                          ).toExpanded,
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Posted by:',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: BaseColors.GRAY_3,
                                                    fontSize: 12),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6.0,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      90.0.toAllBorderRadius,
                                                  color: const Color.fromRGBO(
                                                      0, 189, 177, 0.10),
                                                ),
                                                child: Text(
                                                    '${data.user != null ? data.user!.name : ''}',
                                                    style: const TextStyle(
                                                        color: BaseColors
                                                            .SKY_BLUE)),
                                              ),
                                            ],
                                          ).toExpanded,
                                          // SizedBox().toExpanded,
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
              } else {
                return const CircularProgressIndicator().toCenter;
              }
            }).toExpanded
      ],
    );
  }

  Widget textDetailer(
      {String? header, String? ans, bool isMoneyActive = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header!,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: BaseColors.GRAY_3,
              fontSize: 12),
        ),
        3.0.toVSB,
        Row(
          children: [
            Visibility(
                visible: isMoneyActive,
                child: Image.asset(BaseImages.bx_rupee)),
            Text(
              ans!,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: BaseColors.BLACK,
                  fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  void filterSearchResults(String query) {
    setState(() {
      tempTradeListData = tradeListData
          .where((e) =>
              e.stock!.toLowerCase().contains(query.toLowerCase()) ||
              e.user!.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<bool> getTradeListData(
      {int page = 1,
      String type = 'ongoing',
      bool isLimitApply = false}) async {
    var url = Uri.parse(RequestURL.BASE_URL + RequestURL.TRADE_LIST);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var body = {
      'filters': type,
      'limit': type == 'ongoing' ? '$page' : '10',
      'offset': type == 'ongoing' ? '' : '$page',
    };

    var header = {
      'vAuthorization': 'Bearer ${prefs.getString(SharedPrefConst.USER_TOKEN)}'
    };

    try {
      var response = await http.post(url, body: body, headers: header);
      if (response.statusCode == 200) {
        if (page == 1) {
          tradeListData.clear();
          tempTradeListData.clear();
        }
        CommonListModel dataModel =
            CommonListModel.fromJson(json.decode(response.body));
        if (dataModel.status == 200) {
          if (dataModel.data != null && dataModel.data!.isNotEmpty) {
            for (var element in dataModel.data!) {
              tradeListData.add(TradeModel.fromJson(element));
              tempTradeListData.addAll(tradeListData);
            }
          } else {}
          return true;
        } else {
          return false;
        }
      } else if (response.statusCode == 400) {
        print('Page not found');
        return false;
      } else if (response.statusCode == 404) {
        print('Page not found');
        return false;
      } else if (response.statusCode == 500) {
        print('Something went wrong');
        return false;
      } else {
        print(response.reasonPhrase);
        return false;
      }
    } catch (error) {
      print('[Error]::$error');
      return false;
    }
  }
}
