import 'package:rt_flutter/models/base_model.dart';

typedef S Itemizer<S>(Map<String, dynamic> item);

class Paginable<T extends BaseModel> extends BaseModel {
  int total;
  int count;
  int page;
  int pages;
  int perPage;
  List<BaseModel> items;

  Paginable.readJson(Map<String, dynamic> json, Itemizer<T> itemizer) {
    total = json['total'];
    count = json['count'];
    page = json['page'];
    pages = json['pages'];
    perPage = json['per_page'];
    items = List<T>();

    for (var item in json['items']) {
      items.add(itemizer(item));
    }
  }
}