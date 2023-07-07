import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/models/absen_model.dart';
import 'package:presensi/screens/detailpc_screen.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/services/absen_services.dart';
import 'package:presensi/services/file_services.dart';

class DetailPScreen extends StatefulWidget {
  final String id;
  const DetailPScreen({
    super.key,
    required this.id,
  });

  @override
  State<DetailPScreen> createState() => _DetailPScreenState();
}

class _DetailPScreenState extends State<DetailPScreen> {
  File? _image;

  final ImagePicker _picker = ImagePicker();

  late String _idBerita;
  late String _id;

  AbsenService get service => GetIt.I<AbsenService>();

  bool _isLoading = false;

  String errorMessage = 'Terjadi Masalah, Silahkan Muat Kembali';

  String server = '';

  Adm? adm;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _id = widget.id;

      _isLoading = false;
    });
    FileUtils.readFromFile().then((content) {
      setState(() {
        if (content == "") {
          server = "http://presensi2.bws-sulawesi3.com";
        } else {
          server = content;
        }
        _fetchAdm();
      });
    });
  }

  _fetchAdm() async {
    setState(() {
      _isLoading = true;
    });
    service.getAdm(_id, server).then((value) {
      setState(() {
        adm = value.data;
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: adm == null
          ? ListView(
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      const Text('Tidak Ada Data'),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(
                                id: widget.id,
                                changeOptions: 2,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Muat Kembali',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          : ListView(
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      Image.asset(
                        "assets/images/sp_logo_splash.png",
                        width: 100.0,
                        height: 100.0,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        'Profil ${adm!.admNm}',
                        style: const TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Container(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPCScreen(
                            id: widget.id,
                            profUser: adm!.admUser,
                            profUserTemp: adm!.admUser,
                            profNama: adm!.admNm,
                            profTelp: adm!.admHP,
                            profMail: adm!.admMail,
                            profJnsKel: adm!.admJK,
                            profJnsId: adm!.admJnsId,
                            profIdentitas: adm!.admIdentitas,
                            profAlt: adm!.admAlt,
                            profAbout: adm!.admAbout,
                            profFb: adm!.admFb,
                            profPpkId: adm!.admPpkId,
                            profPpkNm: adm!.admPpkNm,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mBluePu,
                        fixedSize: const Size(200, 50),
                        primary: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'UBAH PROFIL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 3,
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.only(top: 10, right: 5, left: 5),
                    subtitle: Column(
                      children: <Widget>[
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.1,
                            horizontal: 10,
                          ),
                          title: const Text(
                            'Username',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            adm!.admUser,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.1,
                            horizontal: 10,
                          ),
                          title: const Text(
                            'Nama',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            adm!.admNm,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.1,
                            horizontal: 10,
                          ),
                          title: const Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            adm!.admMail,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.1,
                            horizontal: 10,
                          ),
                          title: const Text(
                            'Nomor HP',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            adm!.admHP,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.1,
                            horizontal: 10,
                          ),
                          title: const Text(
                            'Status',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            adm!.admAct == "1" ? 'Aktif' : 'Tidak',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.1,
                            horizontal: 10,
                          ),
                          title: const Text(
                            'PPK',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                            adm!.admPpkNm,
                            style: const TextStyle(fontSize: 18),
                            textWidthBasis: TextWidthBasis.longestLine,
                          ),
                        ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.1,
                            horizontal: 10,
                          ),
                          title: const Text(
                            'Foto',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Container(
                            margin: const EdgeInsets.only(top: 10),
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    _image == null
                                        ? SizedBox(
                                            height: 200,
                                            width: 250,
                                            child: Image.network(
                                              '$server/data/profil/${adm!.admFoto}',
                                              scale: 0.5,
                                            ),
                                          )
                                        : Image(
                                            width: 150,
                                            height: 180,
                                            image: FileImage(_image!)
                                                as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                    InkWell(
                                      onTap: (() async {
                                        final XFile? image =
                                            await _picker.pickImage(
                                          source: ImageSource.gallery,
                                          imageQuality: 30,
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
                                          margin: _image != null
                                              ? const EdgeInsets.only(
                                                  left: 115,
                                                  top: 140,
                                                )
                                              : const EdgeInsets.only(
                                                  left: 210, top: 160),
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
                                _image != null
                                    ? SizedBox(
                                        height: 0,
                                        width: 0,
                                        child: Image.file(_image!),
                                      )
                                    : Container(),
                                _image != null
                                    ? Column(
                                        children: <Widget>[
                                          Container(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                setState(() {
                                                  _isLoading = true;
                                                });

                                                final result =
                                                    await service.changePic(
                                                  widget.id,
                                                  _image!.path,
                                                  server,
                                                );
                                                setState(() {
                                                  _isLoading = false;
                                                });

                                                final title = result.error
                                                    ? 'Maaf'
                                                    : 'Terima Kasih';
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
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomeScreen(
                                                          changeOptions: 2,
                                                          id: widget.id,
                                                        ),
                                                      ),
                                                      (Route<dynamic> route) =>
                                                          false,
                                                    );
                                                  },
                                                ).show();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: mBluePu,
                                                fixedSize: const Size(200, 50),
                                                primary: kPrimaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                elevation: 3,
                                              ),
                                              child: const Text(
                                                'SIMPAN FOTO',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                setState(() {
                                                  _image = null;
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: mBluePu,
                                                fixedSize: const Size(200, 50),
                                                primary: kPrimaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                elevation: 3,
                                              ),
                                              child: const Text(
                                                'BATAL',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
