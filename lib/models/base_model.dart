class CommonListModel {
  int? status;
  String? message;
  int? newTrade;
  List<dynamic>? data;

  CommonListModel({this.status, this.message, this.newTrade, this.data});

  CommonListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    newTrade = json['new_trade'];
    data = json['data'];
  }
}

class CommonApiModel {
  int? status;
  String? message;
  dynamic data;

  CommonApiModel({this.status, this.message, this.data});

  CommonApiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }
}
