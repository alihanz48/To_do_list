import 'package:flutter/material.dart';
import 'data.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Datas datad = Datas();
var box = Hive.box("app_configure");
String compId = "";
String personid = "";

class Personal extends StatefulWidget {
  const Personal({super.key});

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  List<dynamic> drawer = [];
  List<dynamic> groups = [];
  List<dynamic> persons = [];
  String user = "";
  TextEditingController usernamec = TextEditingController();

  void initState() {
    super.initState();
    basla();
  }

  Future<void> basla() async {
    compId = await box.get("companyId").toString();
    await getGroups(compId);
    await getPersons(compId);
  }

  Future<void> getGroups(String compId) async {
    await datad.getGroups(compId);
    setState(() {
      drawer = [
        {'id': -1, 'name': "Ana sayfa"},
        {'id': -2, 'name': 'Tamamlanan işler'},
        {'id': -3, 'name': 'Personel ekle/çıkar'}
      ];
      groups = datad.groups;
      drawer = drawer + groups;
    });

    return;
  }

  Future<void> getPersons(String compId) async {
    await datad.getPerson(compId);
    setState(() {
      persons = datad.persons;
    });
  }

  final FocusNode textFieldFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "To Do List",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 9, 110, 192),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                child: Container(
                  color: Colors.blueAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.business,
                        size: 30,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          box.get("companyname").toString(),
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white),
                          textAlign: TextAlign.center, // Metni ortala
                          overflow: TextOverflow
                              .ellipsis, // Uzun metni üç nokta ile kısalt
                          maxLines: 2, // Maksimum 2 satır göster
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: drawer.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        drawer[index]['id'] == -1
                            ? const Icon(Icons.home)
                            : drawer[index]['id'] == -2
                                ? const Icon(Icons.workspace_premium)
                                : drawer[index]['id'] == -3
                                    ? const Icon(Icons.co_present_outlined)
                                    : const Icon(Icons.group),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          drawer[index]['name'],
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    onTap: () => {
                      Navigator.pop(context),
                      setState(() {
                        var box = Hive.box("app_configure");
                        box.put("routing_page", drawer[index]['id'].toString());
                      }),
                      Navigator.pushNamed(
                          context,
                          drawer[index]['id'] == -1
                              ? "/main_page"
                              : drawer[index]['id'] == -2
                                  ? "/confirm_works"
                                  : drawer[index]['id'] == -3
                                      ? "/personal_process"
                                      : "/groups_work")
                    },
                  );
                },
              )),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Personel Ekle",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    child: TextFormField(
                      focusNode: textFieldFocus,
                      controller: usernamec,
                      decoration: InputDecoration(
                        labelText: "Personel E-Posta",
                        labelStyle: const TextStyle(color: Colors.black),
                        prefixIcon:
                            const Icon(Icons.email, color: Colors.black),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await datad.addPersontoComp(compId, usernamec.text);
                          if (datad.existperson == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Personel başarıyla eklendi!")));
                            await basla();
                            usernamec.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Personel eklenemedi e-posta\nadresini kontrol ediniz")));
                          }
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Personel ekleme başarısız oldu!")));
                        }
                      },
                      child: Text("Ekle"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white)),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Personel Çıkar",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(12), // Kenarlıkları yuvarlatır
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 8),
                            Icon(Icons.person),
                            SizedBox(width: 8),
                            PopupMenuButton<int>(
                              itemBuilder: (BuildContext context) {
                                return persons.map((dynamic person) {
                                  return PopupMenuItem<int>(
                                    value: person['id'],
                                    child: Text(person['username'].toString()),
                                  );
                                }).toList();
                              },
                              onSelected: (value) {
                                setState(() {
                                  user = persons.firstWhere((person) =>
                                      person['id'].toString() ==
                                      value.toString())['username'];
                                  personid = value.toString();
                                });
                              },
                            ),
                            Text(user),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await datad.extractionPerson(personid, compId);
                        await basla();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Personel başarıyla silindi")));
                        setState(() {
                          user = "";
                        });
                      },
                      child: Text("Çıkar"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white)),
                ],
              )
            ],
          ),
        ));
  }
}
