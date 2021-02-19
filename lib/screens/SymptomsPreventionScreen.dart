import 'dart:io';
import 'dart:ui';
import 'package:covid_tracker_app/Commons/FontStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SymptomsPreventionScreen extends StatefulWidget {
  @override
  _SymptomsPreventionScreenState createState() => _SymptomsPreventionScreenState();
}

class _SymptomsPreventionScreenState extends State<SymptomsPreventionScreen> {

  bool onSymptoms = true;
  bool onPrevention = false;
  bool onTreatment = false;
  int index = 0;
  String currentLang = 'eng';
  String appBarTitle = 'Coronavirus Disease';
  String drawerSym = 'SYMPTOMS';
  String drawerPrevn = 'PREVENTION';
  String drawerTreat = 'TREATMENT';
  String floatingButtonTooltip = 'Change language';
  String backButtonTooltip = 'Back';
  String drawerTooltip = 'Open Navigation Menu';

  Color symBackColor = Color.fromARGB(255, 225, 46, 98);
  Color prevBackColor = Color.fromARGB(255, 225, 46, 98);
  Color treatBackColor = Color.fromARGB(255, 225, 46, 98);

  @override
  void initState(){
    super.initState();
    _onDrawerTap();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Color.fromARGB(255,249, 125, 161 ),
          title: Text(appBarTitle, style: fontStyle(null, null, true)),
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ),
        endDrawer: Align(
          alignment: Alignment.centerRight,
          child: Container(

            width: 200,
            height: 176,
            child: Drawer(
              child: Container(
                padding: EdgeInsets.all(16),
                color: Color.fromARGB(255, 225, 46, 98),
                child: Column(
                  children: <Widget>[
                    /*Container(
                      height: MediaQuery.of(context).size.height*0.20,
                      //padding: EdgeInsets.only(top: 25, left: 16),
                      color:Colors.white*//* Color.fromARGB(255, 251, 211, 223 )*//*,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('',style: GoogleFonts.barlow(fontWeight: FontWeight.bold, fontSize: 25)),
                      ),
                    ),*/
                    Container(
                      height: 10,
                    ),
                    Material(
                      color: symBackColor,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            index = 0;
                          });
                          Future.delayed(new Duration(milliseconds: 500), ()
                          {
                            Navigator.of(context).pop();
                          });
                          _onDrawerTap();
                          },
                        splashColor: Color.fromARGB(255,249, 125, 161 ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding( padding:EdgeInsets.only(right: 10),child: Icon(Icons.chevron_right, color: Colors.white,)),
                              Text(drawerSym, style: fontStyle(Colors.white, null, true)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                  Material(
                    color: prevBackColor,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          index = 1;
                        });
                        Future.delayed(new Duration(milliseconds: 500), ()
                        {
                          Navigator.of(context).pop();
                        });
                        _onDrawerTap();
                      },
                      splashColor: Color.fromARGB(255,249, 125, 161 ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding( padding:EdgeInsets.only(right: 10),child: Icon(Icons.chevron_right, color: Colors.white,)),
                            Text(drawerPrevn, style: fontStyle(Colors.white, null, true)),
                          ],
                        ),
                      ),
                    ),
                  ),
                    Container(
                      height: 10,
                    ),
                    Material(
                      color: treatBackColor,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            index = 2;
                          });
                          Future.delayed(new Duration(milliseconds: 500), ()
                          {
                            Navigator.of(context).pop();
                          });
                          _onDrawerTap();
                        },
                        splashColor: Color.fromARGB(255,249, 125, 161 ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding( padding:EdgeInsets.only(right: 10),child: Icon(Icons.chevron_right, color: Colors.white,)),
                              Text(drawerTreat, style: fontStyle(Colors.white, null, true)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Center(
          child: onSymptoms == true ?_getSymptomsContent(): onPrevention == true ?_getPreventionContent(): _getTreatmentContent()
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: floatingButtonTooltip,
          child: Icon(Icons.language, color: Colors.white,),
          backgroundColor: Color.fromARGB(255,249, 125, 161 ),
          onPressed: _changeLang,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  void _onDrawerTap(){
    if(index == 0){
      setState(() {
        onPrevention = false;
        onTreatment = false;
        onSymptoms = true;
        symBackColor = Color.fromARGB(255,249, 125, 161 );
        prevBackColor = Color.fromARGB(255, 225, 46, 98);
        treatBackColor = Color.fromARGB(255, 225, 46, 98);
      });
    }
    else if(index == 1){
      setState(() {
        onPrevention = true;
        onTreatment = false;
        onSymptoms = false;
        symBackColor = Color.fromARGB(255, 225, 46, 98);
        prevBackColor = Color.fromARGB(255,249, 125, 161 );
        treatBackColor = Color.fromARGB(255, 225, 46, 98);
      });

    }
    else{
      setState(() {
        onPrevention = false;
        onTreatment = true;
        onSymptoms = false;
        symBackColor = Color.fromARGB(255, 225, 46, 98);
        prevBackColor = Color.fromARGB(255, 225, 46, 98);
        treatBackColor = Color.fromARGB(255,249, 125, 161 );
      });
    }
  }

  Widget _getSymptomsContent(){
    return currentLang == 'eng'?SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('SYMPTOMS',
                style: fontStyle(null, 20, true)

              ),
            ),
            Text('People may be sick with the virus for 1 to 14 days before'
                ' developing symptoms. The most common symptoms of '
                'coronavirus disease (COVID-19) are fever, tiredness, '
                'and dry cough. Most people (about 80%) recover from the'
                ' disease without needing special treatment.',
              style: fontStyle(null, 18, false),
              textAlign: TextAlign.justify,
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('People may experience:\n'
                      '  • cough\n'
                      '  • fever\n'
                      '  • tiredness\n'
                      '  • difficulty breathing (severe cases)',
                    style: fontStyle(null, 18, false))
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Color.fromARGB(255, 225, 46, 98),
                  child: Text('Read More', style: fontStyle(Colors.white, 15, true),),
                  onPressed: (){
                    _launchURL('https://www.cdc.gov/coronavirus/2019-ncov/symptoms-testing/symptoms.html');
                  },
                ),
            ),
          ],
        ),
      ),
    ):SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('लक्षण',
                style: fontStyle(null, 20, true),

              ),
            ),
            Text('कोरोना वायरस (COVID-19) एक संक्रामक रोग है. यह एक नए तरह के वायरस'
            'की वजह से होता है जिसे पहले कभी इंसानों में नहीं देखा गया.\nइस वायरस की वजह से'
            'सांस की बीमारी (जैसे कि फ़्लू) होती है. खांसी, बुखार, और ज़्यादा गंभीर मामलों में'
            'न्यूमोनिया होना इस रोग के लक्षण हैं. इस वायरस से सुरक्षित रहने के लिए, हाथों को '
                'बार-बार धोएं और अपने चेहरे को छूने से बचें.',
              style: fontStyle(null, 18, false),
              textAlign: TextAlign.justify,
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('संक्रमित लोगों में ये लक्षण हो सकते हैं:\n'
                      '  • गले में खराश\n'
                      '  • खांसी\n'
                      '  • बुखार\n'
                      '  • सांस लेने में दिक्कत (गंभीर मामलों में)',
                    style: fontStyle(null, 18, false))
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _getPreventionContent(){
    return currentLang == 'eng'?SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('PREVENTION',
                style: fontStyle(null, 20, true),

              ),
            ),
            Text('There’s currently no vaccine to prevent coronavirus disease (COVID-19).',
              style: fontStyle(null, 18, false),
              textAlign: TextAlign.justify,
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text('You can protect yourself and help prevent spreading the virus to others if you:',
                style:fontStyle(null, 18, false)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Do\n'
                      '  • Wash your hands regularly for 20 seconds, with soap and water or alcohol-based hand rub\n'
                      '  • Cover your nose and mouth with a disposable tissue or flexed elbow when you cough or sneeze\n'
                      '  • Avoid close contact (1 meter or 3 feet) with people who are unwell\n'
                      '  • Stay home and self-isolate from others in the household if you feel unwell',
                    style: fontStyle(null, 18, false))
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Don\'t\n'
                      '  • Touch your eyes, nose, or mouth if your hands are not clean\n',
                    style: fontStyle(null, 18, false))
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Color.fromARGB(255, 225, 46, 98),
                child: Text('Read More', style: fontStyle(Colors.white, 15, true),),
                onPressed: (){
                  _launchURL('https://www.cdc.gov/coronavirus/2019-ncov/prevent-getting-sick/index.html');
                },
              ),
            ),
          ],
        ),
      ),
    ):SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text('रोकथाम',
                  style: fontStyle(null, 20, true),

                ),
              ),
              Text('कोरोना वायरस (COVID-19) को रोकने के लिए, फ़िलहाल किसी तरह का टीका नहीं है.',
                style: fontStyle(null, 18, false),
                textAlign: TextAlign.justify,
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('आप संक्रमण को होने से रोक सकते हैं, अगर आप:\n'
                        '  • अल्कोहल वाले सैनिटाइज़र का इस्तेमाल करते हैं या साबुन और पानी से अक्सर अपने हाथ साफ़ करते हैं\n'
                        '  • खांसने और छींकने के दौरान टिश्यू पेपर से या कोहनी को मोड़कर, अपनी नाक और मुंह को ढक रहे हैं\n'
                        '  • ठंड या फ्लू जैसे लक्षणों वाले किसी भी व्यक्ति के साथ निकट संपर्क (1 मीटर या 3 फीट) से बचते हैं\n',
                      style: fontStyle(null, 18, false))
                ),
              ),
            ],
          ),
      ),
    );
  }

  Widget _getTreatmentContent(){
    return currentLang == 'eng'?SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('TREATMENT',
                style: fontStyle(null, 20, true),

              ),
            ),
            Text('There is no specific medicine to prevent or treat coronavirus disease (COVID-19). People may need supportive care to help them breathe.',
              style: fontStyle(null, 18, false),
              textAlign: TextAlign.justify,
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Self-care\n'
                      '---------\n'
                      'If you have mild symptoms, stay at home until you’ve recovered. You can relieve your symptoms if you:\n'
                      '  • rest and sleep\n'
                      '  • keep warm\n'
                      '  • drink plenty of liquids\n'
                      '  • use a room humidifier or take a hot shower to help ease a sore throat and cough',
                    style: fontStyle(null, 18, false))
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Medical treatments\n'
                      '---------\n'
                      'If you develop a fever, cough, and have difficulty breathing, promptly seek medical care. Call in advance and tell your health provider of any recent travel or recent contact with travelers.',
                    style: fontStyle(null, 18, false))
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Color.fromARGB(255, 225, 46, 98),
                child: Text('Read More', style: fontStyle(Colors.white, 15, true),),
                onPressed: (){
                  _launchURL('https://www.cdc.gov/coronavirus/2019-ncov/if-you-are-sick/index.html');
                },
              ),
            ),
          ],
        ),
      ),
    ):SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('इलाज',
                style: fontStyle(null, 20, true)

              ),
            ),
            Text('कोरोना वायरस (COVID-19) को रोकने या इसके उपचार के लिए कोई भी खास दवा नहीं है. हो सकता है कि लोगों को सांस लेने में होने वाली दिक्क्त से बचने के लिए, मेडिकल सहायता लेनी पड़े.',
              style: fontStyle(null, 18, false),
              textAlign: TextAlign.justify,
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('खुद की देखभाल\n'
                      '---------\n'
                      'अगर आप में इस रोग के कुछ लक्षण हैं, तो पूरी तरह ठीक होने तक घर पर ही रहें. आपको इन लक्षणों में राहत मिल सकती है, अगर आप:\n'
                      '  • आराम करते हैं और सोते हैं\n'
                      '  • खुद को किसी तरह गर्म रखते हैं\n'
                      '  • खूब पानी या दूसरी तरल चीज़ें लेते हैं\n'
                      '  • गले की खराश और खांसी को कम करने के लिए, कमरे में ह्यूमिडिफ़ायर का इस्तेमाल करते हैं और गर्म पानी से नहाते हैं',
                    style: fontStyle(null, 18, false))
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('मेडिकल ट्रीटमेंट\n'
                      '---------\n'
                      'अगर आपको बुखार या खांसी है, तो आप जब तक ठीक नहीं हो जाते, तब तक घर पर ही रहें. कम से कम 14 दिनों तक घर पर आराम करें, ताकि दूसरे लोगों को संक्रमण होने का खतरा न रहे.',
                    style: fontStyle(null, 18, false))
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeLang(){
    if(currentLang == 'eng')
      setState(() {
        appBarTitle = 'कोरोना वायरस (COVID-19)';
        drawerSym = 'लक्षण';
        drawerPrevn = 'रोकथाम';
        drawerTreat = 'इलाज';
        backButtonTooltip = 'वापस';
        drawerTooltip = 'नेविगेशन मेनू खोलें';
        floatingButtonTooltip = 'भाषा परिवर्तन';
        currentLang = 'hindi';
      });
    else if(currentLang == 'hindi')
      setState(() {

        appBarTitle = 'Coronavirus Disease';
        drawerSym = 'SYMPTOMS';
        drawerPrevn = 'PREVENTION';
        drawerTreat = 'TREATMENT';
        floatingButtonTooltip = 'Change language';
        backButtonTooltip = 'Back';
        drawerTooltip = 'Open Navigation Menu';
        currentLang = 'eng';

      });
  }
}
