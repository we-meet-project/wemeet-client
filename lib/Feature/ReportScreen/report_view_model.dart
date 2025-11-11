import 'package:flutter/material.dart';
import 'package:wemeet_client/Model/Sleep_report_model.dart';

class ReportViewModel with ChangeNotifier{

  final SleepReport _report;
  SleepReport get report => _report;

  ReportViewModel(this._report){
    //어쩌구 저쩌구...
  }

}