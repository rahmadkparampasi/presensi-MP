import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/absen_model.dart';
import 'package:presensi/models/api_response.dart';
import 'package:presensi/screens/detailp_screen.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/services/absen_services.dart';
import 'package:presensi/services/file_services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get_it/get_it.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class DetailPCScreen extends StatefulWidget {
  final String id;
  final String profUser;
  final String profUserTemp;
  final String profMail;
  final String profNama;
  final String profJnsId;
  final String profIdentitas;
  final String profJnsKel;
  final String profTelp;
  final String profAlt;
  final String profAbout;
  final String profFb;
  final String profPpkId;
  final String profPpkNm;
  const DetailPCScreen({
    super.key,
    required this.id,
    required this.profUser,
    required this.profUserTemp,
    required this.profMail,
    required this.profNama,
    required this.profJnsId,
    required this.profIdentitas,
    required this.profJnsKel,
    required this.profTelp,
    required this.profAlt,
    required this.profAbout,
    required this.profFb,
    required this.profPpkId,
    required this.profPpkNm,
  });

  @override
  State<DetailPCScreen> createState() => _DetailPCScreenState();
}

class _DetailPCScreenState extends State<DetailPCScreen> {
  final TextEditingController _profUser = TextEditingController();
  final TextEditingController _profPass = TextEditingController();
  final TextEditingController _profPassCon = TextEditingController();

  final TextEditingController _profMail = TextEditingController();

  final TextEditingController _profNama = TextEditingController();
  final TextEditingController _profIdentitas = TextEditingController();
  final TextEditingController _profTelp = TextEditingController();
  final TextEditingController _profAlt = TextEditingController();
  final TextEditingController _profAbout = TextEditingController();
  final TextEditingController _profFb = TextEditingController();

  String _profJnsId = 'KTP';
  String _profJnsKel = 'L';
  String? _profPpk;

  AbsenService get service => GetIt.I<AbsenService>();

  bool _isLoading = false;

  String server = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FileUtils.readFromFile().then((content) {
      setState(() {
        if (content == "") {
          server = "http://presensi2.bws-sulawesi3.com";
        } else {
          server = content;
        }
        _fetchPpk();
      });
    });
    setState(() {
      _profUser.text = widget.profUser;
      _profMail.text = widget.profMail;
      _profNama.text = widget.profNama;

      _profJnsId = widget.profJnsId;

      _profIdentitas.text = widget.profIdentitas;
      _profJnsKel = widget.profJnsKel;
      _profTelp.text = widget.profTelp;
      _profAlt.text = widget.profAlt;
      _profAbout.text = widget.profAbout;
      _profFb.text = widget.profFb;
      if (widget.profPpkId != '') {
        _profPpk = widget.profPpkId;
      }
    });
  }

  APIResponseBrt<List<Ppk>>? _apiResponsePpk;

  _fetchPpk() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponsePpk = await service.getPpk(server);
    setState(() {
      if (_apiResponsePpk!.error) {
        _isLoading = false;
      } else {
        _isLoading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(id: widget.id, changeOptions: 2),
            ),
          ),
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.blue,
          ),
        ),
        backgroundColor: mBackgroundColor,
        elevation: 0,
      ),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tekan Tombol Kembali Sekali Lagi Untuk Keluar'),
        ),
        child: Container(
            margin: const EdgeInsets.all(10),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : _apiResponsePpk == null
                    ? Center(
                        child: Column(
                          children: <Widget>[
                            const Text('Terdapat Masalah Pada Koneksi'),
                            SizedBox(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPScreen(
                                      id: widget.id,
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(200, 50),
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 3,
                                ),
                                child: const Text(
                                  'KEMBALI',
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
                            Column(
                              children: <Widget>[
                                const Text(
                                  'EDIT PROFIL',
                                  style: TextStyle(
                                      fontFamily: 'RobotoCondensed',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
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
                                TextFieldContainer(
                                  child: DropdownButtonFormField(
                                    isExpanded: true,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.account_tree_outlined,
                                        size: 20,
                                      ),
                                      labelText: 'PPK',
                                      labelStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    items: _apiResponsePpk!.data == null
                                        ? const [
                                            DropdownMenuItem(
                                              enabled: false,
                                              value: '',
                                              child: Text('Belum Ada Data'),
                                            ),
                                          ]
                                        : _apiResponsePpk!.data!.map((item) {
                                            return DropdownMenuItem(
                                              value: item.ppkId,
                                              child: Text(item.ppkNama),
                                            );
                                          }).toList(),
                                    hint: const Text(
                                      "Jenis PPK",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    value: _profPpk,
                                    onChanged: (value) {
                                      setState(() {
                                        _profPpk = value as String?;
                                      });
                                    },
                                  ),
                                ),
                                TextFieldContainer(
                                  child: TextField(
                                    controller: _profUser,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.groups_outlined,
                                        size: 20,
                                      ),
                                      labelText: 'Username',
                                      labelStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                TextFieldContainer(
                                  child: TextField(
                                    controller: _profMail,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.groups_outlined,
                                        size: 20,
                                      ),
                                      labelText: 'Email',
                                      labelStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                TextFieldContainer(
                                  child: TextField(
                                    controller: _profPass,
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.groups_outlined,
                                        size: 20,
                                      ),
                                      labelText: 'Passowrd',
                                      labelStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                TextFieldContainer(
                                  child: TextField(
                                    controller: _profPassCon,
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.groups_outlined,
                                        size: 20,
                                      ),
                                      labelText: 'Ulangi Passowrd',
                                      labelStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                TextFieldContainer(
                                  child: TextField(
                                    controller: _profNama,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.groups_outlined,
                                        size: 20,
                                      ),
                                      labelText: 'Nama Lengkap',
                                      labelStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                TextFieldContainer(
                                  child: DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.sync,
                                        size: 20,
                                      ),
                                    ),
                                    items: widget.profJnsId == ""
                                        ? const [
                                            DropdownMenuItem(
                                              value: '',
                                              enabled: false,
                                              child: Text(
                                                  'Pilih Jenis Identitas Terlebih Dahulu'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'KTP',
                                              child: Text('KTP'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'SIM',
                                              child: Text('SIM'),
                                            ),
                                          ]
                                        : const [
                                            DropdownMenuItem(
                                              value: 'KTP',
                                              child: Text('KTP'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'SIM',
                                              child: Text('SIM'),
                                            ),
                                          ],
                                    hint: const Text(
                                      "Jenis Identitas",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    value: _profJnsId,
                                    onChanged: (value) {
                                      setState(() {
                                        _profJnsId = (value as String?)!;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                TextFieldContainer(
                                  child: TextField(
                                    controller: _profIdentitas,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.groups_outlined,
                                        size: 20,
                                      ),
                                      labelText: 'Nomor Identitas',
                                      labelStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                TextFieldContainer(
                                  child: DropdownButtonFormField(
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.sync,
                                        size: 20,
                                      ),
                                    ),
                                    items: widget.profJnsKel == ""
                                        ? const [
                                            DropdownMenuItem(
                                              value: '',
                                              enabled: false,
                                              child: Text(
                                                  'Pilih Jenis Kelamin Terlebih Dahulu'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'L',
                                              child: Text('Laki-Laki'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'P',
                                              child: Text('Perempuan'),
                                            ),
                                          ]
                                        : const [
                                            DropdownMenuItem(
                                              value: 'L',
                                              child: Text('Laki-Laki'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'P',
                                              child: Text('Perempuan'),
                                            ),
                                          ],
                                    hint: const Text(
                                      "Jenis Kelamin",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    value: _profJnsKel,
                                    onChanged: (value) {
                                      setState(() {
                                        _profJnsKel = (value as String?)!;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                TextFieldContainer(
                                  child: TextField(
                                    controller: _profTelp,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.phone_outlined,
                                        size: 20,
                                      ),
                                      labelText: 'Nomor Telepon',
                                      labelStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                TextFieldContainer(
                                  child: TextField(
                                    maxLines: 3,
                                    controller: _profAlt,
                                    decoration: const InputDecoration(
                                      alignLabelWithHint: true,
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.map_outlined,
                                        size: 20,
                                      ),
                                      labelText: 'Alamat',
                                      labelStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                TextFieldContainer(
                                  child: TextField(
                                    maxLines: 3,
                                    controller: _profAbout,
                                    decoration: const InputDecoration(
                                      alignLabelWithHint: true,
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.map_outlined,
                                        size: 20,
                                      ),
                                      labelText: 'About',
                                      labelStyle: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                TextFieldContainer(
                                  child: TextField(
                                    controller: _profFb,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.phone_outlined,
                                        size: 20,
                                      ),
                                      labelText: 'Facebook',
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
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      if (_profUser.text == '' ||
                                          _profMail.text == '' ||
                                          _profNama.text == '' ||
                                          _profJnsId == '' ||
                                          _profIdentitas.text == '' ||
                                          _profJnsKel == '' ||
                                          _profTelp.text == '' ||
                                          _profAlt.text == '' ||
                                          _profAbout.text == '' ||
                                          _profFb.text == '' ||
                                          _profPpk == '' ||
                                          _profPpk == null) {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.ERROR,
                                          animType: AnimType.TOPSLIDE,
                                          title: 'Maaf',
                                          desc: 'Lengkapi Data Terlebih Dahulu',
                                          btnOkOnPress: () {},
                                        ).show();
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      } else {
                                        final changeUser = ChangeUser(
                                          profUser: _profUser.text,
                                          profUserTemp: widget.profUserTemp,
                                          profMail: _profMail.text,
                                          profPass: _profPass.text,
                                          profPassCon: _profPassCon.text,
                                          profNama: _profNama.text,
                                          profJnsId: _profJnsId,
                                          profIdentitas: _profIdentitas.text,
                                          profJK: _profJnsKel,
                                          profTelp: _profTelp.text,
                                          profAlt: _profAlt.text,
                                          profAbout: _profAbout.text,
                                          profFB: _profFb.text,
                                          profPpk: _profPpk!,
                                        );
                                        final result = await service.changeUser(
                                            server, changeUser, widget.id);
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
                                        if (result.error) {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: dialog,
                                            animType: AnimType.TOPSLIDE,
                                            title: title,
                                            desc: text!,
                                            btnOkOnPress: () {},
                                          ).show();
                                        } else {
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
                                                  builder: (context) =>
                                                      HomeScreen(
                                                    id: widget.id,
                                                    changeOptions: 2,
                                                  ),
                                                ),
                                                (Route<dynamic> route) => false,
                                              );
                                            },
                                          ).show();
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(200, 50),
                                      backgroundColor: mBluePu,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                  height: 40,
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
      ),
    );
  }
}
