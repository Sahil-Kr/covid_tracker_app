import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:covid_tracker_app/Animation/Loader.dart';
import 'package:covid_tracker_app/Api/CallApi.dart';
import 'package:covid_tracker_app/Commons/ApiFailedDialog.dart';
import 'package:covid_tracker_app/Commons/FontStyle.dart';
import 'package:covid_tracker_app/Commons/RefreshDialog.dart';
import 'package:covid_tracker_app/mapper/LineChartDataMapper.dart';
import 'package:covid_tracker_app/models/CountryChartData.dart';
import 'package:covid_tracker_app/models/CountryModel.dart';
import 'package:covid_tracker_app/models/LineChartDataModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartsScreen extends StatefulWidget {
  List<CountryModel> countries = new List();

  ChartsScreen(this.countries);

  @override
  _ChartsScreenState createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> with SingleTickerProviderStateMixin {
  LineChartDataModel chartData = new LineChartDataModel();
  List<CountryChartData> countryChartData = new List();
  List<CountryChartData> _filteredList = new List();
  CountryChartData _selectedChartData = new CountryChartData();
  Map<String, dynamic> chartData1 = new Map();
  bool apiHitSuccess = false;
  bool isConnectedToInternet = false;
  Random random = new Random();
  List<charts.Series<TimeSeriesData, DateTime>> listCR;
  final DateFormat displayFormater = DateFormat('dd-MMM-yyyy');
  bool onSearch = false;
  List<TimeSeriesData> confirmedMapped = new List();
  List<TimeSeriesData> recoveredMapped = new List();
  List<TimeSeriesData> fatalMapped = new List();
  NumberFormat _formattedNumber = NumberFormat.compact();
  final formatter = new NumberFormat("#,##,###", "en_US");
  String _selectedDate = '';
  String _selectedCnf = '';
  String _selectedRecv = '';
  String _selectedFatal = '';
  bool showSelectedData = false;
  FocusNode _focusNode = new FocusNode();
  bool isAnimationEnable = true;
  AnimationController _controller;
  Animation<double> animationRotation ;
  Animation<double> animationRadiusIn;
  Animation<double> animationRadiusOut;
  final double initialRadius = 20.0;
  var _duration = new Duration(seconds: 10);
  double radius = 0.0;
  String url, token;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    startAnimation();
    _checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            centerTitle: false,
            backgroundColor: Color.fromARGB(255, 249, 125, 161),
            title: !onSearch
                ? Text('COVID-19 Charts', style: fontStyle(null, null, true))
            :TextField(
                style: fontStyle(null, null, false),
                onChanged: _showFilteredList,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  icon: Icon(Icons.search,color: Colors.black54,),
                  hintText: 'Search country here...',
                  hintStyle: fontStyle(null, null, false)
                ),
            ),
            leading: !onSearch?BackButton(
                onPressed: () => Navigator.of(context).pop(true),
            ):null,
            actions: <Widget>[
              onSearch?IconButton(
                icon: Icon(Icons.cancel),
                onPressed: (){
                  setState(() {
                    onSearch = false;
                  });
                },
              ):
              apiHitSuccess?IconButton(
                icon: Icon(Icons.search,),
                  onPressed: (){
                  setState(() {
                    onSearch = true;
                  });
                },
        ):Container(),
      ],
    ),
        body: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  (apiHitSuccess == true && onSearch == false)?_topChartCard(): Container(),
                  Expanded(
                    child: ListView(
                      children: apiHitSuccess ? _getList() : [Container()],
                        scrollDirection: Axis.vertical,
                        ),
                  ),
                ],
              ),
            ),
            isAnimationEnable ? getAnimation(context, animationRotation, radius): Container(),
          ],
        ),
      ),
    );
  }

  Widget _topChartCard() {
    confirmedMapped = _selectedChartData.chartData.map((item) {
      return TimeSeriesData(
          date: DateTime.parse(item['date']), number: item['confirmed']);
    }).toList();

    recoveredMapped = _selectedChartData.chartData.map((item) {
      return TimeSeriesData(
          date: DateTime.parse(item['date']), number: item['recovered']);
    }).toList();

    fatalMapped = _selectedChartData.chartData.map((item) {
      return TimeSeriesData(
          date: DateTime.parse(item['date']), number: item['fatal']);
    }).toList();

    listCR = [
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Fatal\nCases',
        colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.date,
        measureFn: (TimeSeriesData data, _) => data.number,
        strokeWidthPxFn: (_, __) => 1.5,
        //labelAccessorFn: (TimeSeriesData sales, _) => sales.date.toString(),
        data: fatalMapped,
      ),
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Recovered\nCases',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.date,
        measureFn: (TimeSeriesData data, _) => data.number,
        strokeWidthPxFn: (_, __) => 2,
        //labelAccessorFn: (TimeSeriesData sales, _) => sales.date.toString(),
        data: recoveredMapped,
      ),
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Confirmed\nCases',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.date,
        measureFn: (TimeSeriesData data, _) => data.number,
        strokeWidthPxFn: (_, __) => 3,
        //labelAccessorFn: (TimeSeriesData sales, _) => sales.date.toString(),
        data: confirmedMapped,
      )
    ];

    /*List<charts.Series<TimeSeriesData, DateTime>> recoveredList = [
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Recovered Cases',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (TimeSeriesData sales, _) => sales.date,
        measureFn: (TimeSeriesData sales, _) => sales.number,
        //labelAccessorFn: (TimeSeriesData sales, _) => sales.date.toString(),
        data: confirmedMapped,
      )
    ];*/

    return Card(
        margin: EdgeInsets.all(5),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical ,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: SizedBox(
                      height: 210,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          height: 210,
                          width:MediaQuery
                              .of(context)
                              .size
                              .width*0.95 ,
                          child: charts.TimeSeriesChart(
                            listCR,
                            animationDuration: Duration(milliseconds: 2),
                            dateTimeFactory: const charts.LocalDateTimeFactory(),
                            animate: true,
                            domainAxis: charts.DateTimeAxisSpec(
                              renderSpec: charts.SmallTickRendererSpec(labelRotation: 60),
                              tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                                  month: new charts.TimeFormatterSpec(
                                      format: 'dd/MMM', transitionFormat: 'dd/MMM/yy'),
                                  day: new charts.TimeFormatterSpec(
                                      format: 'dd', transitionFormat: 'dd/MMM')),
                              tickProviderSpec: charts.DayTickProviderSpec(increments: [5]),
                            ),
                            primaryMeasureAxis: new charts.NumericAxisSpec(
                                showAxisLine: true,
                                tickProviderSpec: new charts.BasicNumericTickProviderSpec(
                                    desiredMinTickCount: 7, desiredMaxTickCount: 10)),
                            behaviors: [
                              new charts.SlidingViewport(),
                              new charts.SeriesLegend(),
                              //new charts.PanAndZoomBehavior(panningCompletedCallback: (){}),

                            ],
                            selectionModels: [
                              charts.SelectionModelConfig(
                                  type: charts.SelectionModelType.info,
                                  changedListener: _onSelectionChanged)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom:8.0),
                    child: Text('${_selectedChartData.displayName.toUpperCase()}', style: fontStyle(null, null, true),),
                  ),
                ],
              ),
              showSelectedData?Align(
                  alignment: Alignment.center,
                  child: Card(
                    color: Color.fromARGB(130, 255, 255, 255),
                    margin: EdgeInsets.only(top: 50),
                    child: Container(
                      padding: EdgeInsets.all(3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('${_selectedDate}', style: fontStyle(null, 12, false),),
                          Text('Confirmed:${_selectedCnf}', style: fontStyle(null, 12, false),),
                          Text('Recovered:${_selectedRecv}', style: fontStyle(null, 12, false),),
                          Text('Fatal:${_selectedFatal}', style: fontStyle(null, 12, false),),
                        ],
                      ),
                    ),
                  ),
              ):Container(),
            ],
          ),
        ));
  }

  _onSelectionChanged(charts.SelectionModel<DateTime> model) {

    Future.delayed(Duration(milliseconds: 130), (){
      setState(() {
        showSelectedData = true;
        _selectedDate = displayFormater.format(model.selectedDatum.elementAt(0).datum.date);
        _selectedCnf = formatter.format(model.selectedDatum.elementAt(0).datum.number);
        _selectedRecv = formatter.format(model.selectedDatum.elementAt(1).datum.number);
        _selectedFatal = formatter.format(model.selectedDatum.elementAt(2).datum.number);
      });
    });

   /* Future.delayed(Duration(milliseconds: 10000),(){
      setState(() {
        showSelectedData = false;
      });
    })*/;
  }

  void _showFilteredList(String inputText) {
    setState(() {
      _filteredList = countryChartData
          .where((data) =>
      (data.displayName.toLowerCase().contains(inputText.toLowerCase())))
          .toList();
    });
  }

  Future<void> _refreshPage() async {
    print('refreshing data.....');
    _controller.repeat();
    setState(() {
      isAnimationEnable = true;
    });
    startTime();
    await _checkInternet();
  }

  startTime() async {
    return new Timer(_duration, _autoRefreshPage);
  }

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

  List<Widget> _getList() {
    return (_filteredList.map((data) {
      return Card(
        color:Color.fromARGB(255, 251, 211, 223),
        child: ListTile(
          title: Text(data.displayName,
              style: fontStyle(Colors.black87, null, true)),
          trailing: Icon(Icons.insert_chart),
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            Future.delayed(Duration(milliseconds: 100),(){
            setState(() {
            showSelectedData = false;
            onSearch = false;
            _filteredList = countryChartData;
            _getSelectedChart(data.displayName);
            });
            });

          },
        ),
      );
    }).toList());
  }
  Future<void> hitChartUrlApi() async {
    var response = CallApi().hitChartUrlApi();
    try {
      response.then((value) {
        Map<String, dynamic> jsonMap = json.decode(value.body);
        setState(() {
          url = jsonMap['url'];
          token = jsonMap['token'];
        });
        hitChartApi();
//        _controller.stop();
      });
    } catch (e) {
      //_controller.repeat();
      print(e.toString());
    }
  }

  Future<void> hitChartApi() async {
    try {
      var response = CallApi().hitChartApi(url, token);
      response.then((value) {
        setState(() {
          apiHitSuccess = true;
          chartData1 = LineChartDataMapper().dataMapper(value.body);
          isAnimationEnable = false;
//          isAnimationEnable = false;
//          apiHitSuccess = true;
        });
        _controller.stop();
        _manageData();
//        _controller.stop();
      });
    } catch (e) {
      //_controller.repeat();
      print(e.toString());
    }
  }

  void _getSelectedChart(String id){
    var tempChartData;
    setState(() {
      tempChartData =  countryChartData.where((data) =>
      (data.displayName.toLowerCase().contains(id.toLowerCase()))).toList();
      _selectedChartData = tempChartData[0];
    });
  }

  void _manageData() {
    for (int i = 0; i < widget.countries.length; i++) {
      CountryChartData model = new CountryChartData();
      setState(() {
        model.id = widget.countries[i].id;
        model.displayName = widget.countries[i].displayName;
        model.chartData = chartData1[widget.countries[i].id];
        if (model.chartData != null) {
          countryChartData.add(model);
          if (model.id == 'india')
            setState(() {
              _selectedChartData = model;
            });
        }
        _filteredList = countryChartData;
      });
    }
  }

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
  Future<void> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hitChartUrlApi();
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

}



class TimeSeriesData {
  final DateTime date;
  final int number;
  TimeSeriesData({this.date, this.number});
}
