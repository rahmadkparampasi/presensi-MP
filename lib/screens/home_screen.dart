import 'package:presensi/screens/detailp_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:presensi/services/file_services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/screens/absen_screen.dart';
import 'package:presensi/screens/bantu_screen.dart';
import 'package:presensi/screens/beranda_screen.dart';
import 'package:presensi/screens/set_screen.dart';
import 'package:presensi/screens/ubah_screen.dart';

class HomeScreen extends StatefulWidget {
  final int changeOptions;
  final String id;
  HomeScreen({this.changeOptions = 0, required this.id});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late String _id;

  var bottomTextStyle =
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late var options = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _id = widget.id;
      options = [
        BerandaScreen(id: _id),
        AbsenScreen(id: _id),
        DetailPScreen(id: _id),
        SetScreen(id: _id),
      ];
    });
    if (widget.changeOptions != 0) {
      setState(() {
        _selectedIndex = widget.changeOptions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackgroundColor,
        title: Image.asset(
          'assets/images/sp_logo_header.png',
          height: 15,
        ),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.help_outline,
              color: mBluePu,
            ),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BantuScreen(
                  id: _id,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.power_settings_new,
              color: mBluePu,
            ),
            onPressed: () {
              AwesomeDialog(
                context: context,
                title: 'Menyetujui',
                desc: 'Ingin Keluar Dari Aplikasi',
                dialogType: DialogType.QUESTION,
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  FileUtilsUser.saveToFile("").then((value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MasukScreen(),
                      ),
                    );
                  });
                },
              ).show();
            },
          ),
        ],
      ),
      backgroundColor: mBackgroundColor,
      bottomNavigationBar: Container(
        height: 100,
        decoration: BoxDecoration(
          color: mFillColor,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 15,
                offset: const Offset(0, 5))
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _selectedIndex == 0
                  ? SvgPicture.asset(
                      'assets/icons/home_colored.svg',
                      height: 20,
                    )
                  : SvgPicture.asset(
                      'assets/icons/home.svg',
                      height: 20,
                    ),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 1
                  ? SvgPicture.asset(
                      'assets/icons/absen_colored.svg',
                      height: 20,
                    )
                  : SvgPicture.asset(
                      'assets/icons/absen.svg',
                      height: 20,
                    ),
              label: 'Absen',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 2
                  ? SvgPicture.asset(
                      'assets/icons/user_colored.svg',
                      height: 20,
                    )
                  : SvgPicture.asset(
                      'assets/icons/user.svg',
                      height: 20,
                    ),
              label: 'Profil',
            ),
            BottomNavigationBarItem(
              icon: _selectedIndex == 3
                  ? SvgPicture.asset(
                      'assets/icons/set_colored.svg',
                      height: 20,
                    )
                  : SvgPicture.asset(
                      'assets/icons/set.svg',
                      height: 20,
                    ),
              label: 'Pengaturan',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: mYellowPu,
          unselectedItemColor: mBluePu,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          selectedFontSize: 12,
          showUnselectedLabels: true,
          elevation: 0,
        ),
      ),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tekan Tombol Kembali Sekali Lagi Untuk Keluar'),
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 5),
          child: options.elementAt(_selectedIndex),
        ),
      ),
    );
  }
}
