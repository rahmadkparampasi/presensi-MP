import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:presensi/constants/var_constant.dart';
import 'package:http/http.dart' as http;
import 'package:presensi/models/absen_model.dart';
import 'package:presensi/models/api_response.dart';

class AbsenService {
  Future<APIResponse<FeedBackAbsen>> createDftrWI(
      String peg, String pass, String path, String s) async {
    Uri newApiUrl = Uri.parse('$s${apiURL}createDftr');
    final send = http.MultipartRequest('POST', newApiUrl);
    send.fields["peg"] = peg;
    send.fields["pass"] = pass;

    send.files.add(await http.MultipartFile.fromPath(
      'peg_fl',
      path,
    ));

    try {
      final streamedResponse = await send.send();

      final response = await http.Response.fromStream(streamedResponse);

      if (streamedResponse.statusCode == 200) {
        final jsonData = json.decode(response.body)['response'];

        return APIResponse<FeedBackAbsen>(
          data: FeedBackAbsen.fromJson(jsonData),
          status: streamedResponse.statusCode,
          dialog: (jsonData['type'] == "info")
              ? DialogType.INFO
              : (jsonData['type'] == "warning")
                  ? DialogType.WARNING
                  : DialogType.SUCCES,
        );
      } else {
        final jsonData = json.decode(response.body)['response'];

        return APIResponse<FeedBackAbsen>(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          data: FeedBackAbsen.fromJson(jsonData),
          status: streamedResponse.statusCode,
          dialog: DialogType.ERROR,
        );
      }
    } catch (e) {
      return APIResponse<FeedBackAbsen>(
        error: true,
        errorMessage: 'Terjadi Kesalahan',
        dialog: DialogType.ERROR,
      );
    }
  }

  Future<APIResponse<FeedBackAbsen>> createAbsenWL(
    String peg,
    String tipe,
    String long,
    String lat,
    String path,
    String dev,
    String s,
  ) async {
    Uri newApiUrl = Uri.parse('$s${apiURL}insertDataPabWL');
    final send = http.MultipartRequest('POST', newApiUrl);

    send.fields["peg"] = peg;
    send.fields["tipe"] = tipe;
    send.fields["long"] = long;
    send.fields["lat"] = lat;
    send.fields["dev"] = dev;

    send.files.add(await http.MultipartFile.fromPath(
      'peg_fl',
      path,
    ));
    try {
      final streamedResponse = await send.send();

      final response = await http.Response.fromStream(streamedResponse);

      if (streamedResponse.statusCode == 200) {
        final jsonData = json.decode(response.body)['response'];

        return APIResponse<FeedBackAbsen>(
          data: FeedBackAbsen.fromJson(jsonData),
          status: streamedResponse.statusCode,
          dialog: (jsonData['type'] == "info")
              ? DialogType.INFO
              : (jsonData['type'] == "warning")
                  ? DialogType.WARNING
                  : DialogType.SUCCES,
        );
      } else {
        final jsonData = json.decode(response.body)['response'];

        return APIResponse<FeedBackAbsen>(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          data: FeedBackAbsen.fromJson(jsonData),
          status: streamedResponse.statusCode,
          dialog: DialogType.ERROR,
        );
      }
    } catch (e) {
      return APIResponse<FeedBackAbsen>(
        error: true,
        errorMessage: 'Terjadi Kesalahan',
        dialog: DialogType.ERROR,
      );
    }
  }

  Future<APIResponseMasuk<FeedBackMasuk>> masuk(CheckMasuk masuk, String s) {
    Uri newApiUrl = Uri.parse('$s/Authm');
    return http.post(newApiUrl, body: masuk.toJson()).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['response'];
        return APIResponseMasuk<FeedBackMasuk>(
          data: FeedBackMasuk.fromJson(jsonData),
          status: data.statusCode,
          dialog: (jsonData['type'] == "info")
              ? DialogType.INFO
              : (jsonData['type'] == "warning")
                  ? DialogType.WARNING
                  : DialogType.SUCCES,
        );
      } else {
        final jsonData = json.decode(data.body)['response'];
        return APIResponseMasuk<FeedBackMasuk>(
          error: true,
          data: FeedBackMasuk.fromJson(jsonData),
          errorMessage: 'Terjadi Kesalahan',
          status: jsonData.statusCode,
          dialog: DialogType.ERROR,
        );
      }
    }).catchError((_) => APIResponseMasuk<FeedBackMasuk>(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          dialog: DialogType.ERROR,
        ));
  }

  Future<APIResponseC<FeedBackCheckConnect>> checkConnectWL(
      CheckConnect create, String s) {
    Uri newApiUrl = Uri.parse('$s${apiURL}checkConnectWL');
    return http.post(newApiUrl, body: create.toJson()).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['response'];
        return APIResponseC<FeedBackCheckConnect>(
            data: FeedBackCheckConnect.fromJson(jsonData));
      } else {
        final jsonData = json.decode(data.body)['response'];
        return APIResponseC<FeedBackCheckConnect>(
          error: true,
          data: FeedBackCheckConnect.fromJson(jsonData),
        );
      }
    }).catchError((_) => APIResponseC<FeedBackCheckConnect>(error: true));
  }

  Future<APIResponse<FeedBackAbsen>> createAbsen(CreateAbsen item, String s) {
    Uri newApiUrl = Uri.parse('$s${apiURL}insertDataPabWL');

    return http.post(newApiUrl, body: item.toJson()).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['response'];

        return APIResponse<FeedBackAbsen>(
          data: FeedBackAbsen.fromJson(jsonData),
          status: data.statusCode,
          dialog: (jsonData['type'] == "info")
              ? DialogType.INFO
              : (jsonData['type'] == "warning")
                  ? DialogType.WARNING
                  : DialogType.SUCCES,
        );
      } else {
        final jsonData = json.decode(data.body)['response'];
        return APIResponse<FeedBackAbsen>(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          data: FeedBackAbsen.fromJson(jsonData),
          status: data.statusCode,
          dialog: DialogType.ERROR,
        );
      }
    }).catchError((_) => APIResponse<FeedBackAbsen>(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          dialog: DialogType.ERROR,
        ));
  }

  Future<bool> checkConnection(CheckConnect item, String s) {
    Uri newApiUrl = Uri.parse('$s${apiURL}checkConnect');
    return http.post(newApiUrl, body: item.toJson()).then((data) {
      if (data.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }).catchError((_) => false);
  }

  Future getAnnounce(String s) async {
    Uri newApiUrl = Uri.parse('$s${apiURL}getAnnounce');

    try {
      final response = await http.get(newApiUrl);
      if (response.statusCode == 200) {
        return jsonEncode(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<APIResponse<FeedBackAbsen>> createAbsenWLD(
    String id,
    String long,
    String lat,
    String jns,
    String path,
    String dev,
    String s,
  ) async {
    Uri newApiUrl = Uri.parse('$s$apiURL');
    final send = http.MultipartRequest('POST', newApiUrl);

    send.fields["id"] = id;
    send.fields["long"] = long;
    send.fields["lat"] = lat;
    send.fields["jenis"] = jns;
    send.fields["dev"] = dev;

    send.files.add(await http.MultipartFile.fromPath(
      'pic',
      path,
    ));
    try {
      final streamedResponse = await send.send();

      final response = await http.Response.fromStream(streamedResponse);

      if (streamedResponse.statusCode == 200) {
        final jsonData = json.decode(response.body)['response'];

        return APIResponse<FeedBackAbsen>(
          data: FeedBackAbsen.fromJson(jsonData),
          status: streamedResponse.statusCode,
          dialog: (jsonData['type'] == "info")
              ? DialogType.INFO
              : (jsonData['type'] == "warning")
                  ? DialogType.WARNING
                  : DialogType.SUCCES,
        );
      } else {
        final jsonData = json.decode(response.body)['response'];

        return APIResponse<FeedBackAbsen>(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          data: FeedBackAbsen.fromJson(jsonData),
          status: streamedResponse.statusCode,
          dialog: DialogType.ERROR,
        );
      }
    } catch (e) {
      return APIResponse<FeedBackAbsen>(
        error: true,
        errorMessage: 'Terjadi Kesalahan',
        dialog: DialogType.ERROR,
      );
    }
  }

  Future<APIResponse<FeedBackAbsen>> createAbsenWLDC(
    String id,
    String long,
    String lat,
    String path,
    String dev,
    String s,
  ) async {
    Uri newApiUrl = Uri.parse('$s/admin/Beritam/edit/$id');
    final send = http.MultipartRequest('POST', newApiUrl);

    send.fields["id"] = id;
    send.fields["long"] = long;
    send.fields["lat"] = lat;
    send.fields["dev"] = dev;

    send.files.add(await http.MultipartFile.fromPath(
      'pic',
      path,
    ));
    try {
      final streamedResponse = await send.send();

      final response = await http.Response.fromStream(streamedResponse);

      if (streamedResponse.statusCode == 200) {
        final jsonData = json.decode(response.body)['response'];

        return APIResponse<FeedBackAbsen>(
          data: FeedBackAbsen.fromJson(jsonData),
          status: streamedResponse.statusCode,
          dialog: (jsonData['type'] == "info")
              ? DialogType.INFO
              : (jsonData['type'] == "warning")
                  ? DialogType.WARNING
                  : DialogType.SUCCES,
        );
      } else {
        final jsonData = json.decode(response.body)['response'];

        return APIResponse<FeedBackAbsen>(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          data: FeedBackAbsen.fromJson(jsonData),
          status: streamedResponse.statusCode,
          dialog: DialogType.ERROR,
        );
      }
    } catch (e) {
      return APIResponse<FeedBackAbsen>(
        error: true,
        errorMessage: 'Terjadi Kesalahan',
        dialog: DialogType.ERROR,
      );
    }
  }

  Future<APIResponseBrt<List<AbBrt>>> getAbBrt(String s, String id) {
    Uri newApiUrl = Uri.parse('$s/admin/Beritam/getBerita/$id');

    return http.get(newApiUrl).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['response'];
        final uslBrksList = <AbBrt>[];
        for (var item in jsonData) {
          uslBrksList.add(AbBrt.fromJson(item));
        }
        return APIResponseBrt<List<AbBrt>>(data: uslBrksList);
      } else {
        final jsonData = json.decode(data.body)['response'];
        final uslBrksList = <AbBrt>[];
        for (var item in jsonData) {
          uslBrksList.add(AbBrt.fromJson(item));
        }
        return APIResponseBrt<List<AbBrt>>(data: uslBrksList);
      }
    }).catchError((_) => APIResponseBrt<AbBrt>(
        error: true, errorMessage: 'Terjadi Kesalahan', status: 500));
  }

  Future<APIResponseBrt<List<Ppk>>> getPpk(String s) {
    Uri newApiUrl = Uri.parse('$s/admin/ppkm/getPpk');

    return http.get(newApiUrl).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['response'];
        final ppk = <Ppk>[];
        for (var item in jsonData) {
          ppk.add(Ppk.fromJson(item));
        }
        return APIResponseBrt<List<Ppk>>(data: ppk);
      } else {
        final jsonData = json.decode(data.body)['response'];
        final ppk = <Ppk>[];
        for (var item in jsonData) {
          ppk.add(Ppk.fromJson(item));
        }
        return APIResponseBrt<List<Ppk>>(data: ppk);
      }
    }).catchError((_) => APIResponseBrt<Ppk>(
        error: true, errorMessage: 'Terjadi Kesalahan', status: 500));
  }

  Future<APIResponseMasuk<FeedBack>> insertUser(String s, InsertUser user) {
    Uri newApiUrl = Uri.parse('$s/registerm/add');
    return http.post(newApiUrl, body: user.toJson()).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['response'];
        return APIResponseMasuk<FeedBack>(
          data: FeedBack.fromJson(jsonData),
          status: data.statusCode,
          dialog: (jsonData['type'] == "info")
              ? DialogType.INFO
              : (jsonData['type'] == "warning")
                  ? DialogType.WARNING
                  : DialogType.SUCCES,
        );
      } else {
        final jsonData = json.decode(data.body)['response'];
        return APIResponseMasuk<FeedBack>(
          error: true,
          data: FeedBack.fromJson(jsonData),
          errorMessage: 'Terjadi Kesalahan',
          status: data.statusCode,
          dialog: DialogType.ERROR,
        );
      }
    }).catchError((_) => APIResponseMasuk<FeedBack>(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          dialog: DialogType.ERROR,
        ));
  }

  Future<APIResponseBrt<Brt>> getBrt(String id, String s, String l) {
    Uri newApiUrl = Uri.parse('$s$l$id');

    return http.get(newApiUrl).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['response'];

        return APIResponseBrt<Brt>(data: Brt.fromJson(jsonData));
      } else {
        final jsonData = json.decode(data.body)['response'];
        return APIResponseBrt<Brt>(
          error: true,
          errorMessage: 'Terjadi Masalah',
          data: Brt.fromJson(jsonData),
        );
      }
    }).catchError((_) =>
        APIResponseBrt<Brt>(error: true, errorMessage: 'Terjadi Kesalahan'));
  }

  Future<APIResponseBrt<Adm>> getAdm(String id, String s) {
    Uri newApiUrl = Uri.parse('$s/admin/profilm/detail/$id');
    print('$s/admin/profilm/detail/$id');
    return http.get(newApiUrl).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['response'];
        return APIResponseBrt<Adm>(data: Adm.fromJson(jsonData));
      } else {
        final jsonData = json.decode(data.body)['response'];
        return APIResponseBrt<Adm>(
          error: true,
          errorMessage: 'Terjadi Masalah',
          data: Adm.fromJson(jsonData),
        );
      }
    }).catchError((_) =>
        APIResponseBrt<Adm>(error: true, errorMessage: 'Terjadi Kesalahan'));
  }

  Future<APIResponse<FeedBackAbsen>> changePic(
    String id,
    String path,
    String s,
  ) async {
    Uri newApiUrl = Uri.parse('$s/admin/profilm/changePic/$id');
    final send = http.MultipartRequest('POST', newApiUrl);

    send.files.add(await http.MultipartFile.fromPath(
      'pic',
      path,
    ));
    try {
      final streamedResponse = await send.send();

      final response = await http.Response.fromStream(streamedResponse);

      if (streamedResponse.statusCode == 200) {
        final jsonData = json.decode(response.body)['response'];

        return APIResponse<FeedBackAbsen>(
          data: FeedBackAbsen.fromJson(jsonData),
          status: streamedResponse.statusCode,
          dialog: (jsonData['type'] == "info")
              ? DialogType.INFO
              : (jsonData['type'] == "warning")
                  ? DialogType.WARNING
                  : DialogType.SUCCES,
        );
      } else {
        final jsonData = json.decode(response.body)['response'];

        return APIResponse<FeedBackAbsen>(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          data: FeedBackAbsen.fromJson(jsonData),
          status: streamedResponse.statusCode,
          dialog: DialogType.ERROR,
        );
      }
    } catch (e) {
      return APIResponse<FeedBackAbsen>(
        error: true,
        errorMessage: 'Terjadi Kesalahan',
        dialog: DialogType.ERROR,
      );
    }
  }

  Future<APIResponseMasuk<FeedBack>> changeUser(
      String s, ChangeUser user, String id) {
    Uri newApiUrl = Uri.parse('$s/admin/profilm/edit/$id');
    return http.post(newApiUrl, body: user.toJson()).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['response'];
        return APIResponseMasuk<FeedBack>(
          data: FeedBack.fromJson(jsonData),
          status: data.statusCode,
          dialog: (jsonData['type'] == "info")
              ? DialogType.INFO
              : (jsonData['type'] == "warning")
                  ? DialogType.WARNING
                  : DialogType.SUCCES,
        );
      } else {
        final jsonData = json.decode(data.body)['response'];
        return APIResponseMasuk<FeedBack>(
          error: true,
          data: FeedBack.fromJson(jsonData),
          errorMessage: 'Terjadi Kesalahan',
          status: jsonData.statusCode,
          dialog: DialogType.ERROR,
        );
      }
    }).catchError((_) => APIResponseMasuk<FeedBack>(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          dialog: DialogType.ERROR,
        ));
  }

  Future<APIResponseBrt<Brt>> getBrtAb(String id, String s, String l) {
    Uri newApiUrl = Uri.parse('$s$l$id');

    return http.get(newApiUrl).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['response'];

        return APIResponseBrt<Brt>(data: Brt.fromJson(jsonData));
      } else {
        final jsonData = json.decode(data.body)['response'];
        return APIResponseBrt<Brt>(
          error: true,
          errorMessage: 'Terjadi Masalah',
          data: Brt.fromJson(jsonData),
        );
      }
    }).catchError((_) =>
        APIResponseBrt<Brt>(error: true, errorMessage: 'Terjadi Kesalahan'));
  }
}
