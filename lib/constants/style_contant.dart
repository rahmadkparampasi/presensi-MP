import 'package:flutter/material.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:google_fonts/google_fonts.dart';

//style for title
var mTitleStyle = GoogleFonts.inter(
  fontWeight: FontWeight.w600,
  color: mTitleColor,
  fontSize: 16,
);

// Style for

//Style for petunjuk
var mServiceTitleStyle = GoogleFonts.inter(
  fontWeight: FontWeight.w500,
  fontSize: 12,
  color: mTitleColor,
);
var mServiceSubtitleStyle = GoogleFonts.inter(
  fontWeight: FontWeight.w400,
  fontSize: 10,
  color: mTitleColor,
);

var mDateStyle = GoogleFonts.inter(
  fontWeight: FontWeight.w600,
  fontSize: 16,
  color: mTitleColor,
);
var mTimeStyle = GoogleFonts.inter(
  fontWeight: FontWeight.bold,
  fontSize: 20,
  color: mTitleColor,
);

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      width: size.width * 1.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      child: child,
    );
  }
}
