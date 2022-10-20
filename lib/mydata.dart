import 'package:flutter/material.dart';
import 'database/base.dart';
import 'inputVar/datainput.dart';

class ListDate extends StatefulWidget {
  final Data? inputdata;

  ListDate({this.inputdata});

  @override
  _ListDateState createState() => _ListDateState();
}

class _ListDateState extends State<ListDate> {
  Base db = Base();

  TextEditingController? judul;
  TextEditingController? lastName;
  TextEditingController? date;
  TextEditingController? cust;
  TextEditingController? partner;
  TextEditingController? descrip;
  DateTime daynow = DateTime.now();
  String? drop;
  List dropcust = ["Chrusland", "Fancinate", "Gabriola", "Just", "Prisma"];

  @override
  void initState() {
    judul = TextEditingController(
        text: widget.inputdata == null ? '' : widget.inputdata!.judul);

    date = TextEditingController(
        text: widget.inputdata == null ? '' : widget.inputdata!.date);

    cust = TextEditingController(
        text: widget.inputdata == null ? '' : widget.inputdata!.cust);

    partner = TextEditingController(
        text: widget.inputdata == null ? '' : widget.inputdata!.partner);

    descrip = TextEditingController(
        text: widget.inputdata == null ? '' : widget.inputdata!.descrip);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Customize'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: judul,
              decoration: InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: date,
              decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Image.asset("images/logo.jpeg"),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: DropdownButton(
                hint: Text("Custom"),
                value: drop,
                items: dropcust
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    drop = value as String;
                    cust!.text = drop!;
                  });
                },
              )),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: partner,
              decoration: InputDecoration(
                  labelText: 'Owner',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: TextField(
              controller: descrip,
              decoration: InputDecoration(
                  labelText: 'description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: FloatingActionButton(
              child: (widget.inputdata == null)
                  ? Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
              onPressed: () {
                if (judul!.text.isEmpty ||
                    date!.text.isEmpty ||
                    cust!.text.isEmpty ||
                    partner!.text.isEmpty ||
                    descrip!.text.isEmpty) {
                  showAlertDialogKosong(BuildContext context) {
                    // Membuat widget untuk mengatur tombol
                    Widget okButton = TextButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    );
                    // Membuat dialog konfirmasi data jika kosong
                    AlertDialog alertKosong = AlertDialog(
                      title: Text("PERINGATAN!"),
                      content: Text("Data anda belum lengkap!"),
                      actions: [
                        okButton,
                      ],
                    );
                  }
                } else {
                  upsertlist();
                }
              },
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<void> upsertlist() async {
    if (widget.inputdata != null) {
      //update
      await db.updatelist(Data.fromMap({
        'id': widget.inputdata!.id,
        'judul': judul!.text,
        'date': date!.text,
        'cust': cust!.text,
        'partner': partner!.text,
        'describe': descrip!.text,
      }));
      Navigator.pop(context, 'update');
    } else {
      //insert
      await db.savelist(Data(
        judul: judul!.text,
        date: date!.text,
        cust: cust!.text,
        partner: partner!.text,
        descrip: descrip!.text,
      ));
      Navigator.pop(context, 'save');
    }
  }
}
