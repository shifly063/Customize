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
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.add_box_sharp),
            onPressed: () {
              _openFormCreate();
            },
          )
        ],
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
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 2,
                      ),
                      child: Text(
                          "--------------------------------------------------"),
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
                              height: 50,
                              child: Column(
                                children: [
                                  Text("data ${inputdata.judul} akan terhapus")
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    _deletelist(inputdata, index);
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
    );
  }

  Future<void> _putData() async {
    //list menampung data dari database
    var list = await db.putData();

    //ada perubahanan state
    setState(() {
      //hapus data pada listlist
      getsdate.clear();

      //lakukan perulangan pada variabel list
      list!.forEach((inputdata) {
        //masukan data ke listlist
        getsdate.add(Data.fromMap(inputdata));
      });
    });
  }

  //menghapus data list
  Future<void> _deletelist(Data inputdata, int position) async {
    await db.deletelist(inputdata.id!);
    setState(() {
      getsdate.removeAt(position);
    });
  }

  // membuka halaman tambah list
  Future<void> _openFormCreate() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ListDate()));
    if (result == 'save') {
      await _putData();
    }
  }

  //membuka halaman edit list
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
