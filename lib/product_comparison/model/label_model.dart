import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Labels {
  int? id;
  String? name;
  Rx<double>? height = 70.0.obs;

  Labels({this.id, this.name, this.height});

  Labels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    height?.value = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['height'] = this.height?.value;
    return data;
  }
}