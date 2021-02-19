import 'dart:convert';
import 'dart:io';

import 'package:covid_tracker_app/Commons/Constants.dart';
import 'package:covid_tracker_app/models/CoronaAreaModel.dart';
import 'package:http/http.dart' as http;

class CallApi{
  var response;
  Future<T> hitCoronaApi<T>(String url)async{
      try{
        response = await http.get(url);

      } catch(e){
        print('Exception Catched!');
      }
      return response;
  }

  Future<T> hitChartApi<T>(String url, String token) async{
    try {
      response = await http.get(url,
        headers: {HttpHeaders.authorizationHeader: token},
      );
    } catch(e){
        return null;
      print(e.toString());
    }
    return response;
  }

  Future<T> hitUrlApi<T>()async{
    try{
      response = await http.get("corona_data_api");

    } catch(e){
      print('Exception Catched!');
    }
    return response;
  }

  Future<T> hitChartUrlApi<T>()async{
    try{
      response = await http.get("chart_api");

    } catch(e){
      print('Exception Catched!');
    }
    return response;
  }


}