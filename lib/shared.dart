import 'package:flutter/material.dart';

const EdgeInsets topPadding = EdgeInsets.only(top: 800*0.5*0.75);

EdgeInsets customTopPadding(double factor){
  return EdgeInsets.only(top: 800*0.5*factor);
}

EdgeInsets customBottomPadding(double factor){
  return EdgeInsets.only(bottom: 800*0.5*factor);
}