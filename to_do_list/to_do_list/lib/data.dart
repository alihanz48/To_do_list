import 'dart:async';
import 'package:dio/dio.dart';
import 'package:to_do_list/group_works.dart';

Dio dio = Dio();

class Datas {
  List<dynamic> Works = [];
  List<dynamic> groups = [];
  List<dynamic> workdetails = [];
  List<dynamic> persons = [];
  String ip = "192.168.1.103:3000";

  Future<void> allWorks(String compId) async {
    Response response = await dio.get("http://$ip/works?compid=${compId}");
    Works = response.data; // Verileri al
  }

  Future<void> confirmWorks(String compId) async {
    Response response = await dio.get("http://$ip/confworks?compid=$compId");
    Works = response.data; // Verileri al
  }

  Future<void> worksConf(String id, bool? onay, String person) async {
    int conf = (onay == true ? 1 : 0);
    await dio.get("http://$ip/works/updatedata/$id/$conf?person=$person");
  }

  Future<void> getGroups(String compId) async {
    Response response = await dio.get("http://$ip/groups?compid=${compId}");
    groups = response.data;
  }

  Future<void> workOfGroups(String groupid) async {
    Response response = await dio.get("http://$ip/works/$groupid");
    Works = response.data;
  }

  Future<void> workDetails(String wid) async {
    Response response = await dio.get("http://$ip/workdetail/$wid");
    workdetails = response.data;
  }

  Future<void> changeGroup(String wid, String gid) async {
    await dio.get("http://$ip/changegroup/$wid/$gid");
  }

  Future<void> worksave(String id, String name, String tel, String aciklama,
      String adres, String editor) async {
    await dio.get(
        "http://$ip/work-save?id=$id&name=$name&tel=$tel&aciklama=$aciklama&adres=$adres&ekleyen=$editor",
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
  }

  Future<void> addWork(String name, String tel, String aciklama, String adres,
      String groupid, String compid, String byadded) async {
    await dio.get(
        "http://$ip/addwork?name=$name&tel=$tel&aciklama=$aciklama&adres=$adres&groupid=$groupid&compid=$compid&byadded=$byadded",
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
  }

  Future<void> workDelete(String id) async {
    await dio.get("http://$ip/work-delete/$id");
  }

  Future<void> deleteGroup(String id) async {
    await dio.get("http://$ip/deletegroup/$id");
  }

  Future<void> editGroup(String id, String grpname) async {
    await dio.get("http://$ip/editgroup/$id/$grpname");
  }

  Future<void> addGroup(String grpName, String compid) async {
    await dio.get("http://$ip/addgroup/$grpName?compid=$compid");
  }

  Future<void> signUp_personal(List<String> signupdata) async {
    await dio.get(
        "http://$ip/signuppersonal/${signupdata[0]}/${signupdata[1]}/${signupdata[2]}/${signupdata[3]}",
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
  }

  Future<void> signUp_company(List<String> signupdata) async {
    await dio.get(
        "http://$ip/signupcompany/${signupdata[0]}/${signupdata[1]}/${signupdata[2]}/${signupdata[3]}/${signupdata[4]}/${signupdata[5]}",
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
  }

  bool? existUser;
  Future<void> checkUser(String username) async {
    Response response = await dio.get("http://$ip/checkuser/$username/");
    if (response.data.toString() == "[]") {
      existUser = false;
    } else {
      existUser = true;
    }
  }

  List<dynamic> userdata = [];
  Future<void> logIn(String username, String password) async {
    Response response = await dio.get("http://$ip/login/$username/$password");
    userdata = response.data;
  }

  Future<void> forgotmypassword(String username) async {
    await dio.get(
      "http://$ip/reqforgotmypass/$username",
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
  }

  Future<void> getPerson(String compid) async {
    Response response = await dio.get(
      "http://$ip/persons/$compid",
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    persons = response.data;
  }

  bool existperson = true;
  Future<void> addPersontoComp(String compid, String person) async {
    Response response = await dio.get("http://$ip/checkperson?person=$person");
    if (response.data == true) {
      existperson = true;
      await dio.get(
        "http://$ip/persons?compid=$compid&person=$person",
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
    } else {
      existperson = false;
    }
  }

  Future<void> extractionPerson(String personid, String compid) async {
    await dio
        .get("http://$ip/extractionperson?compid=$compid&personid=$personid");
  }
}
