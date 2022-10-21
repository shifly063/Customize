class Data {
  int? id;
  String? judul;
  String? date;
  String? cust;
  String? partner;
  String? descrip;

  Data({this.id, this.judul, this.date, this.cust, this.partner, this.descrip});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = id;
    }
    map['judul'] = judul;
    map['date'] = date;
    map['cust'] = cust;
    map['partner'] = partner;
    map['descrip'] = descrip;

    return map;
  }

  Data.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.judul = map['judul'];
    this.date = map['date'];
    this.cust = map['cust'];
    this.partner = map['partner'];
    this.descrip = map['descrip'];
  }
}
