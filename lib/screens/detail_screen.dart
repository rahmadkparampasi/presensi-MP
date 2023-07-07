import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get_it/get_it.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/models/absen_model.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/services/absen_services.dart';
import 'package:presensi/services/file_services.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final String idBerita;
  final String id;
  final int changeOptions;
  const DetailScreen({
    super.key,
    required this.idBerita,
    required this.id,
    required this.changeOptions,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late String _idBerita;
  late String _id;

  AbsenService get service => GetIt.I<AbsenService>();

  bool _isLoading = false;

  String errorMessage = 'Terjadi Masalah, Silahkan Muat Kembali';

  String server = '';

  Brt? brt;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _idBerita = widget.idBerita;
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
        _fetchBerita();
      });
    });
  }

  _fetchBerita() async {
    setState(() {
      _isLoading = true;
    });
    service.getBrt(_idBerita, server, '/admin/Beritam/getRead/').then((value) {
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: mBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                changeOptions: widget.changeOptions,
                id: _id,
              ),
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
        child: brt == null
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
                                builder: (context) => DetailScreen(
                                  id: widget.id,
                                  idBerita: widget.idBerita,
                                  changeOptions: widget.changeOptions,
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
                          'Absen ${brt!.brtNm}, ${brt!.brtTgl}',
                          style: const TextStyle(
                            fontFamily: 'RobotoCondensed',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 3,
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.only(top: 10, right: 5, left: 5),
                      title: const Text(
                        'Absen Masuk',
                        style: TextStyle(
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
                            title: const Text('Jam Masuk'),
                            trailing: Text(brt!.brtMsk),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.1,
                              horizontal: 10,
                            ),
                            title: const Text('Lokasi Absen'),
                            trailing: Text(brt!.brtMskLoc),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.1,
                              horizontal: 10,
                            ),
                            title: const Text('Peta Lokasi'),
                            trailing: ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(mBluePu)),
                              onPressed: () async {
                                String url =
                                    'www.google.com/maps/search/?api=1&query=${brt!.brtMskLat},${brt!.brtMskLong}';
                                final Uri launcUri =
                                    Uri(scheme: 'https', path: url);
                                if (await canLaunchUrl(launcUri)) {
                                  await launchUrl(
                                    launcUri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  throw "Could not launch $url";
                                }
                              },
                              child: const Text(
                                'MAPS',
                              ),
                            ),
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
                            title: const Text('Foto'),
                            subtitle: SizedBox(
                              height: 200,
                              child: Image.network(
                                '$server/data/berita/${brt!.brtGambar}',
                                scale: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 3,
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.only(top: 10, right: 5, left: 5),
                      title: const Text(
                        'Absen Keluar',
                        style: TextStyle(
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
                            title: const Text('Jam Pulang'),
                            trailing: Text(brt!.brtPlg),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.1,
                              horizontal: 10,
                            ),
                            title: const Text('Lokasi Absen'),
                            trailing: Text(brt!.brtPlgLoc),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.1,
                              horizontal: 10,
                            ),
                            title: const Text('Peta Lokasi'),
                            trailing: ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(mBluePu)),
                              onPressed: () async {
                                String url =
                                    'www.google.com/maps/search/?api=1&query=${brt!.brtPlgLat},${brt!.brtPlgLong}';
                                final Uri launcUri =
                                    Uri(scheme: 'https', path: url);
                                if (await canLaunchUrl(launcUri)) {
                                  await launchUrl(
                                    launcUri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  throw "Could not launch $url";
                                }
                              },
                              child: const Text(
                                'MAPS',
                              ),
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.1,
                              horizontal: 10,
                            ),
                            title: const Text('Foto'),
                            subtitle: SizedBox(
                              height: 200,
                              child: Image.network(
                                '$server/data/berita/${brt!.brtGambar1}',
                                scale: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
