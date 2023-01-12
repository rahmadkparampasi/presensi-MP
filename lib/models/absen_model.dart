class CheckConnect {
  String c;

  CheckConnect({required this.c});

  Map<String, dynamic> toJson() {
    return {"c": c};
  }
}

class CreateAbsen {
  String peg;
  String tipe;
  double long;
  double lat;

  CreateAbsen(
      {required this.peg,
      required this.tipe,
      required this.long,
      required this.lat});

  Map<String, dynamic> toJson() {
    return {
      "peg": peg,
      "tipe": tipe,
      "long": long,
      "lat": lat,
    };
  }
}

class FeedBackAbsen {
  String message;
  String response;
  String type;
  FeedBackAbsen(
      {required this.message, required this.response, required this.type});

  factory FeedBackAbsen.fromJson(Map<String, dynamic> item) {
    return FeedBackAbsen(
      message: item['message'],
      response: item['response'],
      type: item['type'],
    );
  }
}

class FeedBackAnnounc {
  String no;
  String message;
  FeedBackAnnounc({required this.no, required this.message});
  factory FeedBackAnnounc.fromJson(Map<String, dynamic> item) {
    return FeedBackAnnounc(
      no: item['no'],
      message: item['message'],
    );
  }
}

class FeedBackCheckConnect {
  String useLoc = "0";
  FeedBackCheckConnect({required this.useLoc});

  factory FeedBackCheckConnect.fromJson(Map<String, dynamic> item) {
    return FeedBackCheckConnect(
      useLoc: item['geo'],
    );
  }
}

class CheckMasuk {
  String user;
  String pass;

  CheckMasuk({required this.user, required this.pass});

  Map<String, dynamic> toJson() {
    return {"user": user, "pass": pass};
  }
}

class FeedBackMasuk {
  String id;
  String message;
  String response;
  String type;
  FeedBackMasuk(
      {required this.id,
      required this.message,
      required this.response,
      required this.type});

  factory FeedBackMasuk.fromJson(Map<String, dynamic> item) {
    return FeedBackMasuk(
      id: item['id'],
      message: item['message'],
      type: item['type'],
      response: item['response'],
    );
  }
}

class FeedBack {
  String message;
  String response;
  String type;
  FeedBack({required this.message, required this.response, required this.type});

  factory FeedBack.fromJson(Map<String, dynamic> item) {
    return FeedBack(
      message: item['message'],
      type: item['type'],
      response: item['response'],
    );
  }
}

class AbBrt {
  String brtId;
  String brtTgl;
  String brtMsk;
  String brtPlg;
  String brtJamKrj;
  String brtKet;
  String brtJns;
  AbBrt({
    required this.brtId,
    required this.brtTgl,
    required this.brtMsk,
    required this.brtPlg,
    required this.brtJamKrj,
    required this.brtKet,
    required this.brtJns,
  });
  factory AbBrt.fromJson(Map<String, dynamic> item) {
    return AbBrt(
      brtId: item['id_berita'],
      brtTgl: item['tanggal'],
      brtMsk: item['masuk'],
      brtPlg: item['pulang'],
      brtJamKrj: item['jam_kerja'],
      brtKet: item['ket'],
      brtJns: item['jenis'],
    );
  }
}

class InsertUser {
  String regNm;
  String regMail;
  String regWa;
  String regUser;
  String regPass;
  String regPpk;
  InsertUser({
    required this.regNm,
    required this.regMail,
    required this.regWa,
    required this.regUser,
    required this.regPass,
    required this.regPpk,
  });

  Map<String, dynamic> toJson() {
    return {
      "nama": regNm,
      "email": regMail,
      "nomor_telp": regWa,
      "username": regUser,
      "password": regPass,
      "ppk": regPpk,
    };
  }
}

class Brt {
  String brtId;
  String brtNm;
  String brtTgl;
  String brtMsk;
  String brtMskLoc;
  String brtMskJamKrj;
  String brtMskLat;
  String brtMskLong;
  String brtKet;
  String brtJenis;
  String brtGambar;
  String brtPlg;
  String brtPlgLoc;
  String brtPlgLat;
  String brtPlgLong;
  String brtGambar1;
  String brtStatus;
  Brt({
    required this.brtId,
    required this.brtNm,
    required this.brtTgl,
    required this.brtMsk,
    required this.brtMskLoc,
    required this.brtMskJamKrj,
    required this.brtMskLat,
    required this.brtMskLong,
    required this.brtKet,
    required this.brtJenis,
    required this.brtGambar,
    required this.brtPlg,
    required this.brtPlgLoc,
    required this.brtPlgLat,
    required this.brtPlgLong,
    required this.brtGambar1,
    required this.brtStatus,
  });
  factory Brt.fromJson(Map<String, dynamic> item) {
    return Brt(
      brtId: item['id_berita'],
      brtNm: item['nama'],
      brtTgl: item['tanggal'],
      brtMsk: item['masuk'],
      brtMskLoc: item['masuk_loc'],
      brtMskJamKrj: item['jam_kerja'],
      brtMskLat: item['masuk_lat'],
      brtMskLong: item['masuk_long'],
      brtKet: item['ket'],
      brtJenis: item['jenis'],
      brtGambar: item['gambar'],
      brtPlg: item['pulang'],
      brtPlgLoc: item['pulang_loc'],
      brtPlgLat: item['pulang_lat'],
      brtPlgLong: item['pulang_long'],
      brtGambar1: item['gambar2'],
      brtStatus: item['status'],
    );
  }
}

class Adm {
  String admId;
  String admUser;
  String admNm;
  String admMail;
  String admHP;
  String admAct;
  String admFoto;
  String admJK;
  String admJnsId;
  String admIdentitas;
  String admAlt;
  String admAbout;
  String admFb;
  String admPpkNm;
  String admPpkId;
  Adm({
    required this.admId,
    required this.admUser,
    required this.admNm,
    required this.admMail,
    required this.admHP,
    required this.admAct,
    required this.admFoto,
    required this.admJK,
    required this.admJnsId,
    required this.admIdentitas,
    required this.admAlt,
    required this.admAbout,
    required this.admFb,
    required this.admPpkNm,
    required this.admPpkId,
  });
  factory Adm.fromJson(Map<String, dynamic> item) {
    return Adm(
      admId: item['id'],
      admUser: item['username'],
      admNm: item['nama'],
      admMail: item['email'],
      admHP: item['nomor_telp'],
      admAct: item['active'],
      admFoto: item['foto'],
      admJK: item['jenis_kelamin'],
      admJnsId: item['jenis_identitas'],
      admIdentitas: item['no_identitas'],
      admAlt: item['alamat'],
      admAbout: item['about'],
      admFb: item['facebook'],
      admPpkNm: item['nama_ppk'],
      admPpkId: item['id_ppk'],
    );
  }
}

class ChangeUser {
  String profUser;
  String profUserTemp;
  String profMail;
  String profPass;
  String profPassCon;
  String profNama;
  String profJnsId;
  String profIdentitas;
  String profJK;
  String profTelp;
  String profAlt;
  String profAbout;
  String profFB;
  String profPpk;
  ChangeUser({
    required this.profUser,
    required this.profUserTemp,
    required this.profMail,
    required this.profPass,
    required this.profPassCon,
    required this.profNama,
    required this.profJnsId,
    required this.profIdentitas,
    required this.profJK,
    required this.profTelp,
    required this.profAlt,
    required this.profAbout,
    required this.profFB,
    required this.profPpk,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": profUser,
      "username_temp": profUserTemp,
      "email": profMail,
      "password": profPass,
      "password_confirm": profPassCon,
      "nama": profNama,
      "jenis_identitas": profJnsId,
      "no_identitas": profIdentitas,
      "jenis_kelamin": profJK,
      "nomor_telp": profTelp,
      "alamat": profAlt,
      "about": profAbout,
      "facebook": profFB,
      "ppk": profPpk,
    };
  }
}

class Ppk {
  String ppkId;
  String ppkNama;
  String ppkTahun;
  String ppkDesc;
  Ppk({
    required this.ppkId,
    required this.ppkNama,
    required this.ppkTahun,
    required this.ppkDesc,
  });
  factory Ppk.fromJson(Map<String, dynamic> item) {
    return Ppk(
      ppkId: item['id_ppk'],
      ppkNama: item['nama_ppk'],
      ppkTahun: item['tahun_ppk'],
      ppkDesc: item['des_ppk'],
    );
  }
}
