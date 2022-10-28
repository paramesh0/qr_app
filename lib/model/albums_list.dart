class IPValues {
  String? ip;

  IPValues({this.ip});

  IPValues.fromJson(Map<String, dynamic> json) {
    ip = json['ip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['ip'] = ip;
    return data;
  }
}
