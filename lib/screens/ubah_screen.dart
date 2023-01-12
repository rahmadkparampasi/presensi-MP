import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presensi/constants/color_constant.dart';

import 'dart:io';

import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/absen_model.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:presensi/services/absen_services.dart';
import 'package:presensi/services/file_services.dart';

class UbahScreen extends StatefulWidget {
  const UbahScreen({Key? key}) : super(key: key);

  @override
  State<UbahScreen> createState() => _UbahScreenState();
}

class _UbahScreenState extends State<UbahScreen> {
  final TextEditingController _peg = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  File? _image;

  bool _isLoading = false;
  bool _isConnect = false;

  AbsenService get service => GetIt.I<AbsenService>();

  final checkConnet = CheckConnect(c: 'c');
  String server = '';

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    FileUtils.readFromFile().then((content) {
      setState(() {
        if (content == "") {
          server = "http://presensi2.bws-sulawesi3.com";
        } else {
          server = content;
        }
      });
      service.checkConnection(checkConnet, server).then((value) {
        setState(() {
          _isLoading = false;
        });

        if (value) {
          setState(() {
            _isConnect = true;
          });
        }
      });
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
                child: _isConnect
                    ? ListView(
                        children: <Widget>[
                          const Center(
                            child: Text(
                              'DAFTAR DATA WAJAH',
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
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Image(
                                      width: 150,
                                      height: 180,
                                      image: _image == null
                                          ? const AssetImage(
                                              'assets/images/avatar.png')
                                          : FileImage(_image!) as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    InkWell(
                                      onTap: (() async {
                                        final XFile? image =
                                            await _picker.pickImage(
                                          source: ImageSource.camera,
                                        );
                                        if (image != null) {
                                          setState(() {
                                            _image = File(image.path);
                                          });
                                        }
                                      }),
                                      child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40.0),
                                              color: Colors.black),
                                          margin: const EdgeInsets.only(
                                            left: 115,
                                            top: 140,
                                          ),
                                          child: const Icon(
                                            Icons.photo_camera,
                                            size: 25,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Ketuk Ikon Kamera Untuk Menggambil Gambar',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          _image != null
                              ? SizedBox(
                                  height: 0,
                                  width: 0,
                                  child: Image.file(_image!),
                                )
                              : Container(),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldContainer(
                            child: TextField(
                              controller: _peg,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.credit_card,
                                  size: 20,
                                ),
                                hintText: 'Isikan NIP/NIK Pegawai',
                                labelText: 'NIP/NIK',
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldContainer(
                            child: TextField(
                              controller: _pass,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.key,
                                  size: 20,
                                ),
                                border: InputBorder.none,
                                hintText: 'Isikan Kata Sandi Pegawai',
                                labelText: 'Kata Sandi',
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w800,
                                ),
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
                                if (_image == null ||
                                    _peg.text == '' ||
                                    _pass.text == '') {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.ERROR,
                                    animType: AnimType.TOPSLIDE,
                                    title: 'Maaf',
                                    desc: 'Lengkapi Data Terlebih Dahulu',
                                    btnOkOnPress: () {},
                                  ).show();
                                } else {
                                  final result = await service.createDftrWI(
                                    _peg.text,
                                    _pass.text,
                                    _image!.path,
                                    server,
                                  );
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  final title =
                                      result.error ? 'Maaf' : 'Terima Kasih';

                                  final text = result.error
                                      ? (result.status == 500
                                          ? 'Terjadi Kesalahan'
                                          : result.data?.message)
                                      : result.data?.message;
                                  final dialog = result.dialog;
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: dialog,
                                    animType: AnimType.TOPSLIDE,
                                    title: title,
                                    desc: text!,
                                    btnOkOnPress: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MasukScreen(),
                                        ),
                                      );
                                    },
                                  ).show();
                                }
                              },
                              style: ElevatedButton.styleFrom(
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
                        ],
                      )
                    : ListView(
                        children: <Widget>[
                          const Center(
                            child: Text('Tidak Dapat Terkoneksi Dengan Server'),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 50, //height of button
                            width: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const UbahScreen(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(10, 50),
                                primary: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 3,
                              ),
                              child: const Text(
                                'MUAT KEMBALI',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
      ),
    );
  }
}
