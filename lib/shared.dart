import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const EdgeInsets topPadding = EdgeInsets.only(top: 800*0.5*0.75);

EdgeInsets customTopPadding(double factor){
  return EdgeInsets.only(top: 800*0.5*factor);
}

EdgeInsets customBottomPadding(double factor){
  return EdgeInsets.only(bottom: 800*0.5*factor);
}

EdgeInsets customLeftPadding(double factor){
  return EdgeInsets.only(left: 480*0.5*factor);
}

EdgeInsets customRightPadding(double factor){
  return EdgeInsets.only(right: 480*0.5*factor);
}

SnackBar customSnackBar(String text){
  return SnackBar(
    content: Text(text),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.only(bottom: 45),

    );
}




class CustomTextButton extends StatelessWidget{
  late Color color1;
  late Color color2;
  late String text;
  late Color textColor;
  late double fontsize;
  late double radius;
  late double width;
  late double height;
  

  CustomTextButton({super.key, required this.color1, required this.color2, required this.text, required this.textColor, 
  required this.fontsize, required this.radius, required this.width, required this.height });

  @override
  Widget build(Object context) {

    return Container(
          height: 50,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            gradient: LinearGradient(
              colors: [
            color1,
            color2,
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
          child: TextButton(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.resolveWith((states) => Size(width, height)),
            ),
            onPressed: () {}, 
            child: Text(
                  text,
                  style: TextStyle(
                    fontSize: fontsize,
                    color: textColor,
                  ),
                ),
              ),
      );
  }
}

class MyTextInputFormatter extends TextInputFormatter{

  bool _makingList = false;
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String _textToReturn = newValue.text;
    if(newValue.text.endsWith('\n-')) {
      _makingList = true;
      _textToReturn = _textToReturn.replaceRange(_textToReturn.length -1, _textToReturn.length, '\n • ');
    }
    else if(_makingList == true) {
      if (_textToReturn.endsWith('\n • \n')) {
        _makingList = false;
        _textToReturn = _textToReturn.replaceRange(_textToReturn.length -4, _textToReturn.length, '\n');
      } else if (_makingList == true && _textToReturn.endsWith('\n')){
        _textToReturn += ' • ';
      }
    }

    return TextEditingValue(text: _textToReturn);
  }

  bool getMakingList(){
    return _makingList;
  }

  void setMakingList(bool newValue){
    _makingList = newValue;
  }

}