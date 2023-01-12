import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presensi/constants/color_constant.dart';

import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/absen_model.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:presensi/services/absen_services.dart';
import 'package:presensi/services/file_services.dart';

import 'package:geolocator/geolocator.dart';

class SethScreen extends StatefulWidget {
  const SethScreen({Key? key}) : super(key: key);

  @override
  State<SethScreen> createState() => _SethScreenState();
}

class _SethScreenState extends State<SethScreen> {
  String fileContents = "http://presensi2.bws-sulawesi3.com";
  final TextEditingController _setCont = TextEditingController();

  bool _isLoading = false;

  AbsenService get service => GetIt.I<AbsenService>();

  final checkConnet = CheckConnect(c: 'c');

  String server = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    FileUtils.readFromFile().then((content) {
      setState(() {
        _isLoading = false;
        if (content == "") {
          _setCont.text = "http://presensi2.bws-sulawesi3.com";
        } else {
          _setCont.text = content;
        }
        server = _setCont.text;
      });
      service.checkConnectWL(checkConnet, server).then((value) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: Colors.blue,
            ),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MasukScreen(),
              ),
            ),
          ),
        ],
        backgroundColor: mBackgroundColor,
        title: Image.asset(
          'assets/images/sp_logo_header.png',
          height: 15,
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                child: ListView(
                  children: <Widget>[
                    const Center(
                      child: Text(
                        'PENGATURAN SERVER',
                        style: TextStyle(
                          color: Color(0xFF11249F),
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFieldContainer(
                      child: TextField(
                        controller: _setCont,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Isikan IP/Domain Server',
                          labelText: 'IP/Domain',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50, //height of button
                      width: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          FileUtils.saveToFile(_setCont.text).then((value) {
                            setState(() {
                              _isLoading = false;
                            });
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.SUCCES,
                              animType: AnimType.TOPSLIDE,
                              title: 'Terima Kasih',
                              desc: 'Data Server Telah Disimpan',
                              btnOkOnPress: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SethScreen()),
                                );
                              },
                            ).show();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mBluePu,
                          fixedSize: const Size(10, 50),
                          primary: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'SIMPAN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
