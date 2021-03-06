import 'package:corona_app/src/constants/colors.dart';
import 'package:corona_app/src/models/CoronaLastInfo.dart';
import 'package:corona_app/src/models/news.dart';
import 'package:corona_app/src/providers/corona_last_info_provider.dart';
import 'package:corona_app/src/providers/news_api.dart';
import 'package:corona_app/src/screens/news_screen.dart';
import 'package:corona_app/src/widgets/menu_screen/botton_navigation_bar.dart';
import 'package:corona_app/src/widgets/menu_screen/custom_item.dart';
import 'package:corona_app/src/widgets/menu_screen/requirement_item.dart';
import 'package:corona_app/src/widgets/spacer/spacer.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  static const routeName = '/menu-screen';

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Future<CoronaLastInfo> coronaLastInfo;
  List<double> data;
  final _pageController = PageController(initialPage: 0);
  var _currentPage = 0;

  final dateFormat = DateFormat('hh:MM:ss');
  Future<CoronaLastInfo> refresh() async {
    setState(() {
      coronaLastInfo =
          Provider.of<CoronaLastInfoProvider>(context, listen: false)
              .fetchCoronaLastInfo();
    });
    return coronaLastInfo;
  }

  @override
  void initState() {
    super.initState();
    coronaLastInfo = Provider.of<CoronaLastInfoProvider>(context, listen: false)
        .fetchCoronaLastInfo();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        // backgroundColor: Theme.of(context).primaryColor,
        drawer: Drawer(),
        bottomNavigationBar: MyBottomNavigationBar(
          currentIndex: _currentPage,
          onPositionChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
        ),
        appBar: AppBar(
          elevation: 0,
          title: Text('Covid - 19 Tracker'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(NewsScreen.routeName);
              },
              icon: Icon(Icons.search),
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder<CoronaLastInfo>(
                future: coronaLastInfo,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    return RefreshIndicator(
                      onRefresh: refresh,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Last update: ${snapshot.data.updated_at.substring(11, 19)}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          CustomItem(
                            color: kRed,
                            title: 'Deaths',
                            value: snapshot.data.deaths,
                            imagePath: 'assets/images/death.png',
                            isInProgress: true,
                          ),
                          SpaceH10(),
                          CustomItem(
                            color: Colors.green,
                            title: 'Recovered',
                            value: snapshot.data.recovered,
                            imagePath: 'assets/images/recovery.png',
                            isInProgress: true,
                          ),
                          SpaceH10(),
                          CustomItem(
                            color: Color(0xFFB7A12E),
                            title: 'Active',
                            value: snapshot.data.active,
                            imagePath: 'assets/images/active.png',
                            isInProgress: true,
                          ),
                          SpaceH10(),
                          SpaceH20(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'New cases',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                child: Text(
                                  'More >',
                                  style: TextStyle(
                                    color: Color(0xFF707070),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SpaceH20(),
                          Container(
                            height: 80,
                            width: screenWidth,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              children: <Widget>[
                                RequirementItem(
                                  label: 'Deaths',
                                  value: snapshot.data.new_deaths,
                                ),
                                RequirementItem(
                                  label: 'Confirmed',
                                  value: snapshot.data.new_confirmed,
                                ),
                                RequirementItem(
                                  label: 'Recovery',
                                  value: snapshot.data.new_recovered,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Erreur lors du changement des données.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        SpaceH10(),
                        OutlineButton(
                          onPressed: refresh,
                          child: Text(
                            'Réessayer',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            Text('2'),
            Text('3'),
          ],
        ));
  }
}
