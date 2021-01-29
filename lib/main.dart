import 'package:auto_size_text/auto_size_text.dart';
import 'package:covid_19/controller/api_manager.dart';
import 'package:covid_19/constant.dart';
import 'package:covid_19/models/covid_data_model.dart';
import 'package:covid_19/controller/user_location.dart';
import 'package:covid_19/views/widgets/counter.dart';
import 'package:covid_19/views/widgets/my_header.dart';
import 'package:covid_19/views/widgets/news_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import 'controller/news_api.dart';
import 'models/article.dart';

void main() async {
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            bodyText2: TextStyle(color: kBodyTextColor),
          )),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<bool> dataFuture;
  // ignore: non_constant_identifier_names
  API_Manager api_manager = API_Manager();
  SelectedLocation selectedLocation = SelectedLocation();
  News news = News();
  bool hasNews = true;

  List<String> _countryList = [];
  CovidData _covidData;
  List<Article> _newsList = [];

  String _selectedCountry;
  int selectedIndex;
  final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataFuture = getFuture();
    controller.addListener(onScroll);
  }

  Future<bool> getFuture() async {
    _covidData = await api_manager.getData();
    _selectedCountry = await selectedLocation.getLocation();
    _newsList = await news.getNews();
    if (_newsList == null || _newsList.length == 0) {
      hasNews = false;
    }
    for (int i = 0; i < _covidData.countries.length; i++) {
      _countryList.add(_covidData.countries[i].country);
    }
    if (_selectedCountry != null) {
      selectedIndex = _countryList.indexOf(_selectedCountry);
    }
    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    selectedLocation.dispose();
    api_manager.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    String getDate(DateTime date) {
      String newDate = "";
      List<String> months = [
        "error",
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ];
      newDate =
          "${date.day}-${months[date.month]}-${date.year} ${date.hour}:${date.minute}";
      return newDate;
    }

    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "All you need",
              textBottom: "is to stay at home",
              offset: offset,
            ),
            SizedBox(height: 20),
            FutureBuilder(
              future: dataFuture,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "GLOBAL CASES\n",
                                        style: kTitleTextstyle,
                                      ),
                                      TextSpan(
                                        text:
                                            "Newest update ${getDate(_covidData.date)}",
                                        style: TextStyle(
                                          color: kTextLightColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 4),
                                    blurRadius: 30,
                                    color: kShadowColor,
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Counter(
                                    color: kInfectedColor,
                                    number: _covidData.global.totalConfirmed,
                                    title: "Infected",
                                  ),
                                  Counter(
                                    color: kDeathColor,
                                    number: _covidData.global.totalDeaths,
                                    title: "Deaths",
                                  ),
                                  Counter(
                                    color: kRecovercolor,
                                    number: _covidData.global.totalRecovered,
                                    title: "Recovered",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Color(0xFFE5E5E5),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              "assets/icons/maps-and-flags.svg",
                              width: 25,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: SearchableDropdown.single(
                                isExpanded: true,
                                displayClearIcon: false,
                                value: _selectedCountry,
                                hint: Text(
                                  "Select Country",
                                  style: TextStyle(fontSize: 15),
                                ),
                                items: _countryList
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: AutoSizeText(
                                      value,
                                      maxLines: 1,
                                      minFontSize: 5,
                                      maxFontSize: 25,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String value) async {
                                  await selectedLocation.putData(value);
                                  int index;
                                  index = _countryList.indexOf(value);
                                  setState(() {
                                    _selectedCountry = value;
                                    if (index != null && index >= 0) {
                                      selectedIndex = index;
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      selectedIndex == null
                          ? Text("")
                          : Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 4),
                                      blurRadius: 30,
                                      color: kShadowColor,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Counter(
                                      color: kInfectedColor,
                                      number: _covidData
                                          .countries[selectedIndex]
                                          .totalConfirmed,
                                      title: "Infected",
                                    ),
                                    Counter(
                                      color: kDeathColor,
                                      number: _covidData
                                          .countries[selectedIndex].totalDeaths,
                                      title: "Deaths",
                                    ),
                                    Counter(
                                      color: kRecovercolor,
                                      number: _covidData
                                          .countries[selectedIndex]
                                          .totalRecovered,
                                      title: "Recovered",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      hasNews
                          ? Container(
                              margin: EdgeInsets.only(top: 16),
                              child: ListView.builder(
                                  itemCount: _newsList.length,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return NewsTile(
                                      imgUrl: _newsList[index].urlToImage ?? "",
                                      title: _newsList[index].title ?? "",
                                      desc: _newsList[index].description ?? "",
                                      content: _newsList[index].content ?? "",
                                      posturl:
                                          _newsList[index].articleUrl ?? "",
                                    );
                                  }),
                            )
                          : Text("No internet connection"),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
