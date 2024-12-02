import 'package:flutter/material.dart';
import 'data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConfirmWorks extends StatefulWidget {
  const ConfirmWorks({super.key});

  @override
  State<ConfirmWorks> createState() => _ConfirmWorksState();
}

Datas datad = Datas();
var box = Hive.box("app_configure");
String compId = "";

class _ConfirmWorksState extends State<ConfirmWorks> {
  List<dynamic> confworks = [];
  List<dynamic> drawer = [];
  List<dynamic> groups = [];

  @override
  void initState() {
    super.initState();
    basla();
  }

  Future<void> basla() async {
    compId = await box.get("companyId").toString();
    await getGroups();
    await vericek();
  }

  Future<void> vericek() async {
    await datad.confirmWorks(compId);
    setState(() {
      confworks = datad.Works; // List değişikliğini bildir
    });
  }

  Future<void> getGroups() async {
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
  }

  void makePhoneCall(String telNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: telNumber);
    await launchUrl(launchUri);
  }

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
                        style:
                            const TextStyle(fontSize: 24, color: Colors.white),
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
            Expanded(
              child: ListView.builder(
                itemCount: confworks.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            Checkbox(
                                value: (confworks[index]['onay'] == 1
                                    ? true
                                    : false),
                                onChanged: (bool? value) => {
                                      setState(() {
                                        void conf() async {
                                          await datad.worksConf(
                                              confworks[index]['id'].toString(),
                                              value,
                                              null.toString());
                                          vericek();
                                        }

                                        conf();
                                        //vericek();
                                      }),
                                    })
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.8),
                              child: Row(
                                children: [
                                  const Icon(Icons.account_circle_rounded),
                                  const SizedBox(width: 8),
                                  Text(
                                    confworks[index]['isim'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.8),
                              child: Row(
                                children: [
                                  const Icon(Icons.phone),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => makePhoneCall(
                                        confworks[index]['iletisim']),
                                    child: Text(
                                      confworks[index]['iletisim'],
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Container veya SizedBox ile genişlik sınırlaması yapın
                            const SizedBox(
                              height: 1,
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width *
                                      0.8), // Genişliği sınırla
                              child: Row(
                                children: [
                                  const Icon(Icons.content_paste_rounded),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    // Expanded yerine Flexible kullanın
                                    child: Text(
                                      confworks[index]['aciklama'],
                                      style: const TextStyle(fontSize: 17),
                                      softWrap: false,
                                      overflow: TextOverflow
                                          .ellipsis, // Taşmayı kontrol etmek için
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width *
                                      0.8), // Genişliği sınırla
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on_sharp),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: GestureDetector(
                                      child: Text(
                                        confworks[index]['adres'],
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline),
                                        softWrap: false,
                                        overflow: TextOverflow
                                            .ellipsis, // Taşmayı kontrol etmek için
                                      ),
                                      onDoubleTap: () => {
                                        Clipboard.setData(ClipboardData(
                                            text: confworks[index]['adres']
                                                .toString())),
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content:
                                                    Text("Adres kopyalandı")))
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width *
                                      0.8), // Genişliği sınırla
                              child: Row(
                                children: [
                                  const Icon(Icons.group),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    // Expanded yerine Flexible kullanın
                                    child: Text(
                                      confworks[index]['group.name'].toString(),
                                      style: const TextStyle(fontSize: 17),
                                      softWrap: true,
                                      overflow: TextOverflow
                                          .fade, // Taşmayı kontrol etmek için
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width *
                                      0.8), // Genişliği sınırla
                              child: Row(
                                children: [
                                  const Icon(Icons.ads_click),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    // Expanded yerine Flexible kullanın
                                    child: Text(
                                      confworks[index]['onaylayan'].toString(),
                                      style: const TextStyle(fontSize: 17),
                                      softWrap: true,
                                      overflow: TextOverflow
                                          .fade, // Taşmayı kontrol etmek için
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width *
                                      0.8), // Genişliği sınırla
                              child: Row(
                                children: [
                                  const Icon(Icons.add),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    // Expanded yerine Flexible kullanın
                                    child: Text(
                                      confworks[index]['ekleyen'].toString(),
                                      style: const TextStyle(fontSize: 17),
                                      softWrap: true,
                                      overflow: TextOverflow
                                          .fade, // Taşmayı kontrol etmek için
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.group),
                                          const SizedBox(width: 8),
                                          Text(confworks[index]['isim']
                                              .toString()),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(Icons.phone),
                                          const SizedBox(width: 8),
                                          Text(confworks[index]['iletisim']
                                              .toString()),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(Icons.content_paste),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              confworks[index]['aciklama']
                                                  .toString(),
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              confworks[index]['adres']
                                                  .toString(),
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(Icons.group),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              confworks[index]['group.name']
                                                  .toString(),
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(Icons.ads_click),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              confworks[index]['onaylayan']
                                                  .toString(),
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(Icons.add),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: Text(
                                              confworks[index]['ekleyen']
                                                  .toString(),
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
