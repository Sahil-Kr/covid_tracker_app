import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:covid_tracker_app/Api/CallApi.dart';
import 'package:covid_tracker_app/Commons/ApiFailedDialog.dart';
import 'package:covid_tracker_app/Commons/FontStyle.dart';
import 'package:covid_tracker_app/Commons/RefreshDialog.dart';
import 'package:covid_tracker_app/models/CountryModel.dart';
import 'package:covid_tracker_app/screens/ChartsScreen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:covid_tracker_app/Commons/TopCard.dart';
import 'package:covid_tracker_app/mapper/CoronaDataMapper.dart';
import 'package:covid_tracker_app/models/CoronaAreaListModel.dart';
import 'package:covid_tracker_app/models/CoronaAreaModel.dart';
import 'package:covid_tracker_app/models/CoronaDataListModel.dart';
import 'package:covid_tracker_app/screens/CountryDetails.dart';
import 'package:covid_tracker_app/screens/HelplineScreen.dart';
import 'package:covid_tracker_app/screens/SymptomsPreventionSplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:covid_tracker_app/Animation/Loader.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  CoronaDataListModel coronaData = new CoronaDataListModel();
  CoronaAreaModel areaModel = new CoronaAreaModel();
  CoronaAreaListModel areasList = new CoronaAreaListModel();
  CoronaAreaModel indiaData = new CoronaAreaModel();
  bool apiHitSuccess = false;
  bool isConnectedToInternet = false;
  bool isAnimationEnable = true;
  bool autoRefresh = true;

  //LoadAnimation loadAnimation = new LoadAnimation();

  AnimationController _controller;
  Animation<double> animationRotation ;
  Animation<double> animationRadiusIn;
  Animation<double> animationRadiusOut;
  String url, token;
  final double initialRadius = 20.0;
  List<CountryModel> countries;
  double radius = 0.0;
  bool firstStartup = true;
  int _index;
  final formatter = new NumberFormat("#,##,###", "en_US");
  final String email = "trackingcorona@gmail.com";
  var _duration = new Duration(seconds: 10);
  var _updateDuration = new Duration(seconds: 30);
  PageController _pageController = new PageController();
  final DateFormat displayFormater = DateFormat('dd HH:mm');
  DateTime lastUpdated ;
  var lastUpdate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("COVID-19 Tracker",
              style: fontStyle(null, null, true)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.insert_chart),
              tooltip: 'Show Charts',
              enableFeedback: true,
              onPressed: ()=> Navigator.of(context).push(MaterialPageRoute( builder: (BuildContext context){
                return ChartsScreen(countries);
              })),
            ),
            //show refereh button only after api hit success
            apiHitSuccess?IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Refresh Data',
              enableFeedback: true,
              onPressed: _refreshPage,
            ):Container(),
          ],
        ),
        body: Container(
          color: Color.fromARGB(255, 26, 26, 29),
          child: Stack(
            children: <Widget>[
              Center(
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(10.0),
                        children:  /*[_getChartCard()] +*/[apiHitSuccess?_lastUpdateCard():Container()]+[_getTopCard()]+ _getListView() ,
                      ),
                    ),
                  ],
                ),
              ),
              isAnimationEnable ? getAnimation(context, animationRotation, radius): Container(),
            ],
          ),
        ),
        drawer: Drawer(
          child: Container(
            color: Color.fromARGB(255, 225, 46, 98),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.25,
                  //padding: EdgeInsets.only(top: 25, left: 16),
                  color: Colors.white70 /* Color.fromARGB(255, 251, 211, 223 )*/,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Image.asset('assets/images/coronavirus.png')
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                          child: Text('COVID-19 Tracker', style:fontStyle(Colors.black, 25, true), )
                      ),
                    ],
                  ),

                ),
                InkWell(
                  onTap: () {
                    Future.delayed(new Duration(milliseconds: 200), () {
                      Navigator.of(context).pop();
                    });
                    Future.delayed(new Duration(milliseconds: 300), () {
                      _launchURL();
                    });
                  },
                  splashColor: Color.fromARGB(255, 249, 125, 161),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 15, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.info, color: Colors.white,)),
                        Text('About Corona (Covid-19) Virus',
                          style: fontStyle(Colors.white, 15, true)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Future.delayed(new Duration(milliseconds: 200), () {
                      Navigator.of(context).pop();
                    });
                    Future.delayed(new Duration(milliseconds: 300), () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (
                          BuildContext context) {
                        return SymptomsPreventionSplashScreen();
                      }));
                    });
                  },
                  splashColor: Color.fromARGB(255, 249, 125, 161),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 15, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.local_hospital,
                              color: Colors.white,)),
                        Text('Corona Symptoms & Prevention',
                          style: fontStyle(Colors.white, 15, true)),
                      ],
                    ),
                  ),
                ),
                /*Divider(
                    thickness: 1,
                    color: Colors.white,
                  ),*/
                InkWell(
                  onTap: () {
                    Future.delayed(new Duration(milliseconds: 200), () {
                      Navigator.of(context).pop();
                    });
                    Future.delayed(new Duration(milliseconds: 300), () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (
                          BuildContext context) {
                        return HelplineScreen();
                      }));
                    });
                  },
                  enableFeedback: true,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 12, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.phone, color: Colors.white,)),
                        Text('Corona Helpline No.', style:fontStyle(Colors.white, 15, true)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: ()async {

                    Future.delayed(new Duration(milliseconds: 200), () {
                      Navigator.of(context).pop();
                    });
                    Future.delayed(new Duration(milliseconds: 300), () async{
                      if (await canLaunch('https://www.pmcares.gov.in/en/web/contribution/donate_india')) {
                      await launch('https://www.pmcares.gov.in/en/web/contribution/donate_india');
                      } else {
                      showFailedDialog(context);
                      //throw 'Could not launch https://www.pmcares.gov.in/en/web/contribution/donate_india';
                      }
                    });

                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, top: 12,bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding( padding:EdgeInsets.only(right: 10),child: Icon(Icons.attach_money, color: Colors.white,)),
                        Text('Donate - Help the needy', style: fontStyle(Colors.white, 15, true),),
                      ],
                    ),
                  ),
                ),
                InkWell(
                    onTap: (){
                      Future.delayed(new Duration(milliseconds: 200), () {
                        Navigator.of(context).pop();
                      });
                      Future.delayed(new Duration(milliseconds: 450), () {
                        launch('mailto:$email');
                      });

                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, top: 12,bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding( padding:EdgeInsets.only(right: 10),child: Icon(Icons.feedback, color: Colors.white,)),
                          Text('Give Feedback', style: fontStyle(Colors.white, 15, true),),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),

    );
  }
  //card for last update time
  Widget _lastUpdateCard(){
    lastUpdate = timeago.format(DateTime.now().subtract(DateTime.now().difference(lastUpdated)));
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Color.fromARGB(255, 225, 46, 98),
      child: Container(
        padding: EdgeInsets.all(3),
          child: Text('Last Updated: $lastUpdate', style: fontStyle(Colors.white, 14, false),textAlign: TextAlign.center,)
      ),
    );
  }

  //url launcher
  _launchURL() async {
    const url = 'https://www.who.int/emergencies/diseases/novel-coronavirus-2019';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showFailedDialog(context);
//      throw 'Could not launch $url';
    }
  }

  //top card
  Widget _getTopCard() {
    return Padding(
      padding: EdgeInsets.only(top: 0, bottom: 0),
      child: SizedBox(
        height: 190, // card height
        child: PageView.builder(
          itemCount: 2,
          controller: _pageController,
          onPageChanged: (int index) => setState(() => _index = index),
          itemBuilder: (_, i) {
            return Transform.scale(
                scale: i == _index ? 1 : 1,
                child: i == 0 ? apiHitSuccess==true ?_getIndiaCard():Container() : apiHitSuccess==true?_getGlobalCard():Container());
          },
        ),
      ),

    );
  }

  // for india detail card
  Widget _getIndiaCard() {
    indiaData = _getIndiaData();
    return InkWell(
      onTap: () {
        _controller.repeat();
        isAnimationEnable = true;
        Future.delayed(const Duration(milliseconds: 1500), () {
          _controller.stop();
          isAnimationEnable= false;
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) {
                return CountryDetails(indiaData);
              }));
        });

      },
      child: TopCard().card(indiaData, context),
    );
  }

  //get global detail card
  Widget _getGlobalCard() {
    double screenWidth = MediaQuery.of(context).size.width*0.81;
    return Card(
      color: Color.fromARGB(255, 251, 211, 223),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      //margin: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          //width: MediaQuery.of(context).size.width*0.91,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                'GLOBAL',
                style: fontStyle(Colors.black, 20, true),
              ),
              Text(
                'Total Cases:'
                    '${apiHitSuccess
                    ? formatter.format(coronaData.dataList[0].totalConfirmed??0)
                    : 0}',
                style: fontStyle(Colors.black45, 12, true),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '⬤ ',
                              style:
                              TextStyle(color: Colors.amber),
                            ),
                            Text(
                              'Active Cases',
                              style: fontStyle(Colors.black54, 15, true)
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              '${apiHitSuccess ? (formatter.format(coronaData.dataList[0]
                                  .totalConfirmed -
                                  coronaData.dataList[0].totalRecovered -
                                  coronaData.dataList[0].totalDeaths)??0) : 0}',
                              style: fontStyle(Colors.black, 15, true)
                            ),
                            Text(_activeDelta(),
                              style: fontStyle(Colors.black45, 15, false),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '⬤ ',
                              style:
                              TextStyle(color: Colors.green),
                            ),
                            Text(
                              'Recovered Cases',
                              style: fontStyle(Colors.black54, 15, true),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              '${apiHitSuccess
                                  ? formatter.format(coronaData.dataList[0].totalRecovered??0)
                                  : 0}',
                              style:fontStyle(Colors.black, 15, true)
                            ),
                            Text(' +'
                                '${formatter.format(coronaData.dataList[0].recoveredDelta ?? 0)}',
                              style: fontStyle(Colors.black45, 15, false),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              '⬤ ',
                              style:
                              TextStyle(color: Colors.redAccent),
                            ),
                            Text(
                              'Fatal Cases',
                              style: fontStyle(Colors.black54, 15, true)
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              '${apiHitSuccess
                                  ? formatter.format(coronaData.dataList[0].totalDeaths??0)
                                  : 0}',
                              style: fontStyle(Colors.black, 15, true)
                            ),
                            Text(' +'
                                '${formatter.format(coronaData.dataList[0].deathDelta ?? 0)}',
                              style: fontStyle(Colors.black45, 15, false),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Container(
                          height: 8,
                          width: screenWidth*((coronaData.dataList[0].totalConfirmed - coronaData.dataList[0].totalRecovered - coronaData.dataList[0].totalDeaths)/coronaData.dataList[0].totalConfirmed),
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5)
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Container(
                          height: 8,
                          width: screenWidth*(coronaData.dataList[0].totalRecovered/coronaData.dataList[0].totalConfirmed),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5)
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Container(
                          height: 8,
                          width: screenWidth*(coronaData.dataList[0].totalDeaths/coronaData.dataList[0].totalConfirmed),
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5)
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _activeDelta(){
    int activeDelta = (coronaData.dataList[0].confirmedDelta??0)-(coronaData.dataList[0].recoveredDelta??0);
    if (activeDelta<0)
      return ' +0';
    else
      return ' +'+formatter.format(activeDelta);
  }

  //get the list of countries
  List<Widget> _getListView() {
    countries = new List();
    return (areasList.areaList
        .map((data) {
      CountryModel model = new CountryModel();
        model.id = data.id;
        model.displayName = data.displayName;
        countries.add(model);
        return Card(
          child: ListTile(
              title: Text(
                data.displayName,
                style: fontStyle(Colors.black87, null, true)
              ),
              subtitle:
              Text('Total Cases: ' + formatter.format(data.totalConfirmed??0),
                style: fontStyle(null, null, false),),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                _controller.repeat();
                isAnimationEnable = true;
                Future.delayed(const Duration(milliseconds: 1500), () {
                  _controller.stop();
                  isAnimationEnable= false;
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return CountryDetails(data);
                      }));
                });
              }),
        );}
      )
        .toList());
  }

  //mapper for country wise data
  void _setAreaData() {
    List<dynamic> areaList = coronaData.dataList[0].areas;
    areasList = new CoronaAreaListModel();
    for (var areas in areaList) {
      CoronaAreaModel model = new CoronaAreaModel();
      model.id = areas['id'];
      model.displayName = areas['displayName'];
      model.totalConfirmed = areas['totalConfirmed'];
      model.totalRecovered = areas['totalRecovered'];
      model.totalDeaths = areas['totalDeaths'];
      model.areas = areas['areas'];
      model.parentId = areas['parentId'];
      model.confirmedDelta = areas['totalConfirmedDelta'];
      model.recoveredDelta = areas['totalRecoveredDelta'];
      model.deathDelta = areas['totalDeathsDelta'];
      model.dateTime = areas['lastUpdated'];
      areasList.areaList.add(model);
    }
  }

  CoronaAreaModel _getIndiaData() {
    for (var indiaData in areasList.areaList) {
      if (indiaData.id == "india") {
        return indiaData;
      }
    }
    return CoronaAreaModel();
  }

  //method to hit api
  Future<void> hitApi() async {
    try {
      var response = CallApi().hitCoronaApi(url);
      response.then((value) {
        setState(() {
          coronaData = CoronaDataMapper().dataMapper(value.body);
          isAnimationEnable = false;
          apiHitSuccess = true;
          lastUpdated = DateTime.parse(coronaData.dataList[0].dateTime).toLocal();
        });
        _controller.stop();
        _setAreaData();
        coronaData.dataList[0].dateTime != '' && coronaData.dataList[0].dateTime != null ?changeTopCardTimer():null;
        coronaData.dataList[0].dateTime != '' && coronaData.dataList[0].dateTime != null ?updateLastUpdateTime():null;
      } );

    } catch (e) {
    print('In hit api catch part');
      _refreshPage();
      setState(() {
        apiHitSuccess = false;
      });
      print(e.toString()+'*************');
    }

  }

  Future<void> hitUrlApi() async {
    try {
      var response = CallApi().hitUrlApi();
      response.then((value) {
        Map<String, dynamic> jsonMap = json.decode(value.body);
        setState(() {
          url = jsonMap['url'];
        });
        hitApi();
      } );

    } catch (e) {
      print('In hit api catch part');
      _refreshPage();
      setState(() {
        apiHitSuccess = false;
      });
      print(e.toString()+'*************');
    }

  }

  //timer to auto refresh data
  startTime() async {
    return new Timer(_duration, _autoRefreshPage);
  }

  //auto scroll between top card pages
  changeTopCardTimer() async {
    return new Timer(_duration, changeTopCard);
  }

  //code to change top card page
  changeTopCard(){
    try{
      if(_pageController.page == 0.0 ){
        _pageController.animateToPage(1, duration: Duration(seconds: 1), curve: Curves.decelerate);
        //_duration1 = new Duration(seconds: 10);
        changeTopCardTimer();
      }
      else{
        _pageController.animateToPage(0, duration: Duration(seconds: 1), curve: Curves.decelerate);
        //changeTopCardTimer();
      }
    }catch(e){
      //changeTopCardTimer();
      print('Page controller Exception caught');

    }

  }

  //code to auto refresh data
  void _autoRefreshPage(){
    if(apiHitSuccess==false && isConnectedToInternet == true) {

      setState(() {
        _duration = new Duration(seconds: 3);
      });
      showFailedDialog(context);
      Future.delayed(Duration(milliseconds: 3500),(){
        _refreshPage();
        startTime();
      });
    }
    else{
      setState(() {
        isAnimationEnable = false;
      });
    }
  }

  //get last update time
  updateLastUpdateTime() async{
    return new Timer(_updateDuration, (){
      var temp = timeago.format(DateTime.now().subtract(DateTime.now().difference(lastUpdated)));
      setState(() {
        lastUpdate = temp;
      });
      updateLastUpdateTime();
    });
  }

  //method for auto refresh
  Future<void> _refreshPage() async {
    print('refreshing data.....');
    _controller.repeat();
    setState(() {
      isAnimationEnable = true;
    });
    startTime();
    await _checkInternet();
  }

  @override
  void initState() {
    super.initState();
    _checkInternet();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    startAnimation();
    startTime();
  }

  // method to start animation
  void startAnimation() {
    animationRotation = Tween<double>(
      begin: 0.25,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _controller, curve: Interval(0.0, 1.0, curve: Curves.linear)));
    animationRadiusIn = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(0.75, 1.0, curve: Curves.elasticIn)));

    animationRadiusOut = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 0.25, curve: Curves.elasticOut)));

    _controller.addListener(() {
      setState(() {
        if (_controller.value >= 0.75 && _controller.value <= 1.0) {
          radius = animationRadiusIn.value * initialRadius;
        } else if (_controller.value >= 0.0 && _controller.value <= 0.25) {
          radius = animationRadiusOut.value * initialRadius;
        }
      });}
    );

    _controller.repeat();
  }

  //method to check internet connection
  Future<void> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hitUrlApi();
        setState(() {
          isConnectedToInternet = true;
          isAnimationEnable = true;
          //apiHitSuccess = false;
          //isFirstStart = false;
        });
        _controller.repeat();
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
      setState(() {
        isConnectedToInternet = false;
        isAnimationEnable = false;
        //isFirstStart = false;
      });
      _controller.stop();
      showRefreshDialog(context, (){
        Navigator.of(context).pop(true);
        setState(() {
          isAnimationEnable = true;
          _controller.repeat();
          //startAnimation();
        });
        Future.delayed(Duration(seconds: 2),(){
          _refreshPage();
        });


      } );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

}

