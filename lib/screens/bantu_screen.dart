import 'package:flutter/material.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/screens/home_screen.dart';

class BantuScreen extends StatefulWidget {
  final String id;

  const BantuScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<BantuScreen> createState() => _BantuScreenState();
}

class _BantuScreenState extends State<BantuScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
      _isLoading = false;
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
                builder: (context) => HomeScreen(
                  id: widget.id,
                ),
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
                  children: const <Widget>[
                    Center(
                      child: Text(
                        'Apa Itu PRESENSI',
                        style: TextStyle(
                          color: Color(0xFF11249F),
                          fontStyle: FontStyle.normal,
                          fontSize: 18.0,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text('Kirana'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
