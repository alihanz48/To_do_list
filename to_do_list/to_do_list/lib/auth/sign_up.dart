import 'package:flutter/material.dart';
import 'package:to_do_list/auth/log_in.dart';
import 'package:to_do_list/data.dart';

Datas datad = Datas();

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController name = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confpassword = TextEditingController();
  //
  TextEditingController companyname = TextEditingController();
  TextEditingController sektor = TextEditingController();
  TextEditingController yil = TextEditingController();
  TextEditingController vergino = TextEditingController();
  TextEditingController sicilno = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Kayıt Ol",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Hemen bir hesap oluştur ve\nyeni özellikleri keşfet!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 30),
                buildTextField("İsim", name),
                buildTextField("Soyisim", lastname),
                buildTextField("E-Posta", username),
                buildTextField("Şifre", password, obscureText: true),
                buildTextField("Şifre Onay", confpassword, obscureText: true),
                const SizedBox(
                  height: 5,
                ),
                const Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    "Yöneticiler için",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                buildTextField("Şirket İsmi", companyname),
                buildTextField("Faaliyet Alanı/Sektör", sektor),
                buildTextField("Kuruluş Yılı", yil),
                buildTextField("Vergi Numarası", vergino),
                buildTextField("Ticaret Sicil Numarası", sicilno),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await datad.checkUser(username.text);
                      if (datad.existUser == false) {
                        kayitsorgu();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Bu eposta zaten kayıtlı !"),
                          ),
                        );
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
                      "Kayıt Ol",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Zaten bir hesabın var mı?",
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/log_in");
                      },
                      child: const Text(
                        "Giriş Yap",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void kayitsorgu() {
    if (password.text.toString() == confpassword.text.toString()) {
      if (name.text != "" &&
          lastname.text != "" &&
          username.text != "" &&
          password.text != "" &&
          confpassword != "") {
        if (companyname.text != "" &&
            sektor.text != "" &&
            yil.text != "" &&
            vergino.text != "" &&
            sicilno.text != "") {
          onaypopup("manager");
        } else if (companyname.text == "" &&
            sektor.text == "" &&
            yil.text == "" &&
            vergino.text == "" &&
            sicilno.text == "") {
          onaypopup("person");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "Yönetici olarak kayıt olmak için \n tüm şirket bilgilerini girmelisiniz!"),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Kişisel bilgilerinizde boş alanlar bırakmayınız!"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Şifreler uyuşmuyor!"),
        ),
      );
    }
  }

  Future<void> onaypopup(String remembertype) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 100,
                      child: Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 50,
                      ),
                    ),
                    Text(
                      (remembertype == "manager" ? "Yönetici" : "Çalışan") +
                          " olarak kayıt olacaksınız onaylıyormusunuz ?",
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await kayitekle(remembertype);
                          Navigator.pop(context);
                        },
                        child: Text("Onay"))
                  ],
                ),
              );
            },
          );
        });
  }

  Future<void> kayitekle(String remembertype) async {
    try {
      await datad.signUp_personal([
        name.text,
        lastname.text,
        username.text,
        password.text,
      ]);

      if (remembertype == "manager") {
        await datad.signUp_company([
          companyname.text,
          sektor.text,
          yil.text,
          vergino.text,
          sicilno.text,
          username.text,
        ]);
      }

      clearFields();

      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
              const SnackBar(
                  content: Text("Kayıt başarılı! Yönlendiriliyorsunuz...")),
            )
            .closed
            .then((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LogIn()),
          );
        });
      }
    } catch (err) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "İşlem sırasında hata oluştu, lütfen daha sonra tekrar deneyiniz!")),
        );
      }
    }
  }

  Widget buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  void clearFields() {
    name.clear();
    lastname.clear();
    username.clear();
    password.clear();
    confpassword.clear();
    companyname.clear();
    sektor.clear();
    yil.clear();
    vergino.clear();
    sicilno.clear();
  }
}
