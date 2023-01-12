import 'package:presensi/screens/absend_screen.dart';
import 'package:presensi/screens/detail_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presensi/constants/color_constant.dart';

import 'dart:io';

import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/absen_model.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/services/absen_services.dart';
import 'package:presensi/services/file_services.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AbsenScreen extends StatefulWidget {
  final String id;

  const AbsenScreen({required this.id});

  @override
  State<AbsenScreen> createState() => _AbsenScreenState();
}

class _AbsenScreenState extends State<AbsenScreen> {
  File? _image;

  bool _isLoading = false;
  bool _isConnect = false;

  String? _valMsk;

  Brt? brt;

  AbsenService get service => GetIt.I<AbsenService>();

  final checkConnet = CheckConnect(c: 'c');
  String server = '';

  final ImagePicker _picker = ImagePicker();

  Position? _position;

  String errorMessage = 'Terjadi Masalah, Silahkan Muat Kembali';

  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _position = position;
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permision are Denied');
      }
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return '${androidDeviceInfo.id!}-${androidDeviceInfo.device!}-${androidDeviceInfo.product}'; // unique ID on Android
    }
  }

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
        _fetchBerita();
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

  _fetchBerita() async {
    setState(() {
      _isLoading = true;
    });
    service
        .getBrtAb(widget.id, server, '/admin/Beritam/getByDate/')
        .then((value) {
      setState(() {
        brt = value.data;
        if (value.error) {
          _isLoading = false;
          errorMessage = value.errorMessage!;
        } else {
          _isLoading = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : brt == null
                ? Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: ListView(
                      children: <Widget>[
                        const Center(
                          child: Text(
                            'ABSENSI',
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
                                        imageQuality: 40,
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
                                    fontWeight: FontWeight.bold, fontSize: 12),
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
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldContainer(
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              prefixIcon: Icon(
                                Icons.sync,
                                size: 20,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'WHO',
                                child: Text('WHO'),
                              ),
                              DropdownMenuItem(
                                value: 'WFH',
                                child: Text('WFH'),
                              ),
                              DropdownMenuItem(
                                value: 'DINAS',
                                child: Text('DINAS'),
                              ),
                              DropdownMenuItem(
                                value: 'ON-SITE',
                                child: Text('ON-SITE'),
                              ),
                            ],
                            hint: const Text(
                              "PILIH SALAH SATU JENIS ABSEN",
                              style: TextStyle(fontSize: 15),
                            ),
                            value: _valMsk,
                            onChanged: (value) {
                              setState(() {
                                _valMsk = value as String?;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              if (_valMsk == null ||
                                  _valMsk! == '' ||
                                  _image == null) {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.ERROR,
                                  animType: AnimType.TOPSLIDE,
                                  title: 'Maaf',
                                  desc: 'Lengkapi Data Terlebih Dahulu',
                                  btnOkOnPress: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                          changeOptions: 1,
                                          id: widget.id,
                                        ),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                ).show();
                              } else {
                                Position position = await _determinePosition();
                                setState(() {
                                  _position = position;
                                });

                                String? deviceId = await _getId();
                                final result = await service.createAbsenWLD(
                                  widget.id,
                                  _position!.longitude.toString(),
                                  _position!.latitude.toString(),
                                  _valMsk!,
                                  _image!.path,
                                  deviceId!,
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
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                          changeOptions: 1,
                                          id: widget.id,
                                        ),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                ).show();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mBluePu,
                              fixedSize: const Size(10, 50),
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
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: ListView(
                      children: <Widget>[
                        const Center(
                          child: Text(
                            'ABSENSI',
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
                        Card(
                          elevation: 3,
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(
                                top: 10, right: 5, left: 5),
                            title: Text(
                              'Absen ${brt!.brtTgl}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              children: <Widget>[
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text('Masuk'),
                                  trailing: Text(brt!.brtMsk),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text('Pulang'),
                                  trailing: Text(brt!.brtPlg),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text('Jam Kerja'),
                                  trailing: Text(brt!.brtMskJamKrj),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text('Keterangan'),
                                  trailing: Text(brt!.brtKet),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text('Status Absen'),
                                  trailing: Text(brt!.brtJenis),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text('Aksi'),
                                  trailing: ElevatedButton(
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                mBluePu)),
                                    onPressed: brt!.brtStatus != "Pulang"
                                        ? () => Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AbsenDScreen(
                                                  idBerita: brt!.brtId,
                                                  id: widget.id,
                                                  changeOptions: 1,
                                                  tgl: brt!.brtTgl,
                                                ),
                                              ),
                                            )
                                        : () => Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailScreen(
                                                  idBerita: brt!.brtId,
                                                  id: widget.id,
                                                  changeOptions: 1,
                                                ),
                                              ),
                                            ),
                                    child: brt!.brtStatus != "Pulang"
                                        ? const Text('Absen Pulang')
                                        : const Text('Detail'),
                                  ),
                                ),
                              ],
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
