import 'package:flutter/material.dart';
import 'package:to_do_list/data.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Datas datad = Datas();

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity, // Ekranın tamamını kapla
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Giriş Yap",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Hesabınıza giriş yaparak\ntüm özelliklere erişin.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                    labelText: "E-posta",
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.email, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                    labelText: "Şifre",
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      if (username.text == "") {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                                content: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Gmail adresinizi giriniz !")
                              ],
                            )
                          ],
                        )));
                      } else {
                        try {
                          await datad.forgotmypassword(username.text);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Column(
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              SizedBox(
                                height: 100,
                                child: Icon(
                                  Icons.mark_email_read_rounded,
                                  color: Colors.white,
                                  size: 72,
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Text(
                                  "Parola sıfırlama linki\ne-posta adresinize gönderilmiştir")
                            ],
                          )));
                        } catch (err) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.error,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                      "Gmail adresinizi veya internet\nbağlantınızı kontrol ediniz!")
                                ],
                              )
                            ],
                          )));
                        }
                      }
                    },
                    child: const Text(
                      "Şifrenizi mi unuttunuz?",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (username.text == "" || password.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Row(children: [
                            Icon(
                              Icons.error,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                                "Kullanıcı adı veya şifre kısmını boş bırakmayınız!")
                          ])),
                        );
                      } else {
                        await datad.logIn(
                            username.text.toString(), password.text.toString());
                        List<dynamic> userdata = datad.userdata;
                        if ((userdata.toString() == "[]"
                                ? " "
                                : userdata[0]['username'].toString()) ==
                            username.text.toString()) {
                          var box = Hive.box("app_configure");
                          box.put("user", userdata[0]['username'].toString());
                          box.put(
                              "companyId", userdata[0]['companyId'].toString());
                          box.put("companyname",
                              userdata[0]['company.name'].toString());
                          Navigator.pop(context);
                          Navigator.pushNamed(context, "/main_page");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Row(children: [
                              Icon(
                                Icons.error,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Kullanıcı adı veya şifre hatalı!")
                            ])),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2575FC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Giriş Yap",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Hesabınız yok mu?",
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/sign_up");
                      },
                      child: const Text(
                        "Kaydol",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
