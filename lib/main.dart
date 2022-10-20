// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, non_constant_identifier_names, avoid_types_as_parameter_names, avoid_function_literals_in_foreach_calls, unused_local_variable, unused_import, use_key_in_widget_constructors

import 'dart:ui';
import 'package:flutter/material.dart';
import 'database/base.dart';
import 'mydata.dart';
import 'inputVar/datainput.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red, fontFamily: "CaviarDreams"),
      title: 'Custom',
      home: getsdatePage(),
    );
  }
}

class getsdatePage extends StatefulWidget {
  const getsdatePage({Key? key}) : super(key: key);

  @override
  _getsdatePageState createState() => _getsdatePageState();
}

class _getsdatePageState extends State<getsdatePage> {
  List<Data> getsdate = [];
  Base db = Base();

  @override
  void initState() {
    //menjalankan fungsi getallkontak saat pertama kali dimuat
    _putData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Center(
          child: Text(
            "Customize",
            style: TextStyle(
                fontSize: 30,
                fontFamily: "gabriola",
                fontFeatures: [FontFeature.stylisticSet(6)]),
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: getsdate.length,
          itemBuilder: (context, index) {
            Data inputdata = getsdate[index];
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListTile(
                leading: Icon(
                  Icons.list_alt,
                  size: 50,
                  color: Colors.red[300],
                ),
                title: Text('${inputdata.judul}'),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text("Your Custom  : ${inputdata.cust}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text("Date                 : ${inputdata.date}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text("Owner              : ${inputdata.partner}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text("Description     : ${inputdata.descrip}"),
                    ),
                  ],
                ),
                trailing: FittedBox(
                  fit: BoxFit.fill,
                  child: Row(
                    children: [
                      // button edit
                      IconButton(
                          padding: EdgeInsets.only(top: 40),
                          onPressed: () {
                            _openFormEdit(inputdata);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blueGrey,
                          )),
                      // button hapus
                      IconButton(
                        padding: EdgeInsets.only(top: 40),
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          //membuat dialog konfirmasi hapus
                          AlertDialog hapus = AlertDialog(
                            backgroundColor: Colors.brown[200],
                            title: Text("Information!"),
                            content: SizedBox(
                              height: 20,
                              child: Column(
                                children: [
                                  Text("data ${inputdata.judul} akan terhapus")
                                ],
                              ),
                            ),
                            //terdapat 2 button.
                            //jika ya maka jalankan _deleteKontak() dan tutup dialog
                            //jika tidak maka tutup dialog
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    _deleteKontak(inputdata, index);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Yes"),
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.brown[800])),
                              TextButton(
                                child: Text('Cancle'),
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.brown[800]),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                          showDialog(
                              context: context, builder: (context) => hapus);
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
      backgroundColor: Colors.white,
      //membuat button mengapung di bagian bawah kanan layar

      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[600]),
        child: Icon(
          Icons.add_box_sharp,
          color: Colors.white,
        ),
        onPressed: () {
          _openFormCreate();
        },
      ),
    );
  }

  //mengambil semua data Kontak
  Future<void> _putData() async {
    //list menampung data dari database
    var list = await db.putData();

    //ada perubahanan state
    setState(() {
      //hapus data pada listKontak
      getsdate.clear();

      //lakukan perulangan pada variabel list
      list!.forEach((inputdata) {
        //masukan data ke listKontak
        getsdate.add(Data.fromMap(inputdata));
      });
    });
  }

  //menghapus data Kontak
  Future<void> _deleteKontak(Data inputdata, int position) async {
    await db.deleteKontak(inputdata.id!);
    setState(() {
      getsdate.removeAt(position);
    });
  }

  // membuka halaman tambah Kontak
  Future<void> _openFormCreate() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ListDate()));
    if (result == 'save') {
      await _putData();
    }
  }

  //membuka halaman edit Kontak
  Future<void> _openFormEdit(Data inputdata) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListDate(inputdata: inputdata)));
    if (result == 'update') {
      await _putData();
    }
  }
}
