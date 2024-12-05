import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Datas datad = Datas();
var box = Hive.box("app_configure");
String compId = "";
String person = "";

class GroupWorks extends StatefulWidget {
  const GroupWorks({super.key});

  @override
  State<GroupWorks> createState() => _GroupWorksState();
}

class _GroupWorksState extends State<GroupWorks> {
  List<dynamic> works = [];
  List<dynamic> drawer = [];
  List<dynamic> groups = [];
  List<dynamic> workDetail = [];
  TextEditingController name = TextEditingController();
  TextEditingController iletisim = TextEditingController();
  TextEditingController aciklama = TextEditingController();
  TextEditingController adres = TextEditingController();
  TextEditingController grpnamec = TextEditingController();
  TextEditingController grpnamec2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    basla();
  }

  basla() async {
    compId = await box.get("companyId").toString();
    person = await box.get("user").toString();
    await vericek();
    await getGroups(compId);
  }

  Future<void> vericek() async {
    await datad.workOfGroups(box.get("routing_page").toString());
    setState(() {
      works = datad.Works; // List değişikliğini bildir
    });
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

  Future<void> workDelete(String id) async {
    await datad.workDelete(id);
    await vericek();
  }

  void conf(int index, bool? value) async {
    await datad.worksConf(works[index]['id'].toString(), value, person);
    await vericek();
  }

  void dialogGoster(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String groupName = workDetail[0]['group.name'];

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Row(
                  children: [
                    const Icon(Icons.add),
                    const SizedBox(width: 8),
                    Text(workDetail[0]['ekleyen']),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.group),
                    const SizedBox(width: 8),
                    Text(workDetail[0]['isim']),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.phone),
                    const SizedBox(width: 8),
                    Text(workDetail[0]['iletisim']),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.content_paste),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        workDetail[0]['aciklama'],
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
                        workDetail[0]['adres'],
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
                    Text(groupName),
                    const SizedBox(width: 8),
                    PopupMenuButton<int>(
                      itemBuilder: (BuildContext context) {
                        return groups.map((dynamic group) {
                          return PopupMenuItem<int>(
                            value: group['id'],
                            child: Text(group['name'].toString()),
                          );
                        }).toList();
                      },
                      onSelected: (value) async {
                        await datad.changeGroup(
                            workDetail[0]['id'].toString(), value.toString());

                        setState(() {
                          groupName = groups.firstWhere(
                              (group) => group['id'] == value)['name'];
                        });

                        await vericek();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Grup değiştirildi!")),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          kaydetdialog(index);
                        },
                        child: const Text("Düzenle")),
                    ElevatedButton(
                        onPressed: () {
                          conf(index, true);
                          Navigator.pop(context);
                        },
                        child: const Text("Onayla")),
                    ElevatedButton(
                        onPressed: () {
                          workDelete(workDetail[0]['id'].toString());
                          Navigator.pop(context);
                        },
                        child: const Text("Sil"))
                  ],
                ),
              ]),
            );
          },
        );
      },
    );
  }

  void kaydetdialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(Icons.person),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 230,
                          child: TextField(controller: name),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(Icons.phone),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 230,
                          child: TextField(controller: iletisim),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(Icons.content_paste),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 230,
                          child: TextField(controller: aciklama),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(Icons.location_on),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 230,
                          child: TextField(controller: adres),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await workSave();
                          await vericek();
                          await getdetails(index);
                          Navigator.of(context).pop();
                          dialogGoster(index);
                        },
                        child: const Text("Kaydet"))
                  ],
                ),
              );
            },
          );
        });
  }

  Future<void> workSave() async {
    await datad.worksave(workDetail[0]['id'].toString(), name.text,
        iletisim.text, aciklama.text, adres.text, box.get("user").toString());
  }

  Future<void> add_task(
    String gId,
  ) async {
    await datad.addWork(name.text, iletisim.text, aciklama.text, adres.text,
        box.get("routing_page").toString(), compId, box.get("user").toString());
  }

  Future<void> add_group(String grpname) async {
    await datad.addGroup(grpname, compId);
  }

  Future<void> edit_group(String id, String grpname) async {
    await datad.editGroup(id, grpname);
  }

  Future<void> delete_group(String id) async {
    await datad.deleteGroup(id);
  }

  Future<void> worksave() async {
    await datad.worksave(workDetail[0]['id'].toString(), name.text,
        iletisim.text, aciklama.text, adres.text, box.get("user").toString());
  }

  Future<void> getdetails(int index) async {
    await datad.workDetails(works[index]['id'].toString());
    setState(() {
      workDetail = datad.workdetails;
      name.text = workDetail[0]['isim'];
      iletisim.text = workDetail[0]['iletisim'];
      aciklama.text = workDetail[0]['aciklama'];
      adres.text = workDetail[0]['adres'];
    });
  }

  void makePhoneCall(String telNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: telNumber);
    await launchUrl(launchUri);
  }

  bool _isMenuOpen = false;
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
                itemCount: works.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            Checkbox(
                                value:
                                    (works[index]['onay'] == 1 ? true : false),
                                onChanged: (bool? value) => {
                                      setState(() {
                                        conf(index, value);
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
                                    works[index]['isim'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
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
                                    onTap: () =>
                                        makePhoneCall(works[index]['iletisim']),
                                    child: Text(
                                      works[index]['iletisim'],
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Container veya SizedBox ile genişlik sınırlaması yapın
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
                                      works[index]['aciklama'],
                                      style: const TextStyle(fontSize: 17),
                                      softWrap: false,
                                      overflow: TextOverflow
                                          .ellipsis, // Taşmayı kontrol etmek için
                                    ),
                                  ),
                                ],
                              ),
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
                                        works[index]['adres'],
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline),
                                        softWrap: false,
                                        overflow: TextOverflow
                                            .ellipsis, // Taşmayı kontrol etmek için
                                      ),
                                      onDoubleTap: () => {
                                        Clipboard.setData(ClipboardData(
                                            text: works[index]['adres']
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
                              height: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () async {
                      await getdetails(index);
                      dialogGoster(index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          // Menüyü açma butonunu yerleştiriyoruz
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'h1',
              onPressed: () {
                setState(() {
                  _isMenuOpen = !_isMenuOpen; // Menü durumunu değiştir
                });
              },
              backgroundColor: Colors.blue,
              child: Icon(
                _isMenuOpen ? Icons.edit_off : Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
          // Menü açıldığında, iş ekleme ve grup ekleme butonları
          if (_isMenuOpen)
            Positioned(
              bottom: 80,
              right: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Butonlar birbirine yakın olur
                children: [
                  // İş ekleme butonu
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10), // Butonlar arasına mesafe ekleyelim
                    child: FloatingActionButton(
                      heroTag: 'h2',
                      onPressed: addWork,
                      backgroundColor: Colors.blue,
                      child: const Icon(
                        Icons.add_task,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Grup ekleme butonu
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10), // Butonlar arasına mesafe ekleyelim
                    child: FloatingActionButton(
                      heroTag: 'h3',
                      onPressed: editGroup,
                      backgroundColor: Colors.blue,
                      child: const Icon(
                        Icons.group_add_sharp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void addWork() {
    name.clear();
    iletisim.clear();
    aciklama.clear();
    adres.clear();
    String groupName = "";
    String groupId = "";

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: const Text('İş ekle'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 230,
                            child: TextField(
                              controller: name,
                              decoration: const InputDecoration(
                                labelText: 'İsim',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.phone),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 230,
                            child: TextField(
                              controller: iletisim,
                              decoration: const InputDecoration(
                                labelText: 'Telefon',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.content_paste),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 230,
                            child: TextField(
                              controller: aciklama,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: 'Açıklama',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 230,
                            child: TextField(
                              controller: adres,
                              decoration: const InputDecoration(
                                labelText: 'Adres',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.group),
                          const SizedBox(
                            width: 10,
                          ),
                          const SizedBox(width: 8),
                          Text(groups
                              .firstWhere((group) =>
                                  group['id'].toString() ==
                                  box.get('routing_page').toString())['name']
                              .toString()),
                          Text(groupName),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () async {
                            await add_task(groupId.toString());
                            Navigator.pop(context);
                            await vericek();
                          },
                          child: const Text("Ekle"))
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  void editGroup() {
    String groupname = "";
    String groupid = "";
    String groupname2 = "";
    String groupid2 = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                  title: const Text("Grup Ekle/Sil/Güncelle"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.group_add_rounded),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 240,
                            child: TextField(
                              controller: grpnamec,
                              decoration: const InputDecoration(
                                labelText: 'Grup adı',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          )
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await add_group(grpnamec.text.toString());
                            await getGroups(compId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Grup Eklendi!")),
                            );
                            grpnamec.text = "";
                          },
                          child: const Text("Ekle")),
                      Row(
                        children: [
                          const Icon(Icons.group_remove),
                          const SizedBox(
                            width: 5,
                          ),
                          PopupMenuButton<int>(
                            itemBuilder: (BuildContext context) {
                              return groups.map((dynamic group) {
                                return PopupMenuItem<int>(
                                  value: group['id'],
                                  child: Text(group['name'].toString()),
                                );
                              }).toList();
                            },
                            onSelected: (value) async {
                              setState(() {
                                groupname = groups.firstWhere(
                                    (group) => group['id'] == value)['name'];
                              });
                              groupid = value.toString();
                            },
                          ),
                          Text(groupname),
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await delete_group(groupid);
                            await getGroups(compId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Grup silindi!")),
                            );
                            setState(() {
                              groupname = "";
                            });
                          },
                          child: const Text("Sil")),
                      Row(
                        children: [
                          const Icon(Icons.group_remove),
                          const SizedBox(
                            width: 5,
                          ),
                          PopupMenuButton<int>(
                            itemBuilder: (BuildContext context) {
                              return groups.map((dynamic group) {
                                return PopupMenuItem<int>(
                                  value: group['id'],
                                  child: Text(group['name'].toString()),
                                );
                              }).toList();
                            },
                            onSelected: (value) async {
                              setState(() {
                                groupname2 = groups.firstWhere(
                                    (group) => group['id'] == value)['name'];
                              });
                              groupid2 = value.toString();
                              grpnamec2.text = groupname2;
                            },
                          ),
                          SizedBox(
                            width: 190,
                            child: TextField(
                              controller: grpnamec2,
                            ),
                          )
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await edit_group(groupid2, grpnamec2.text);
                            await getGroups(compId);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Grup ismi düzenlendi!")),
                            );
                            grpnamec2.text = "";
                          },
                          child: const Text("Düzenle")),
                    ],
                  ));
            },
          );
        });
  }
}
