import 'package:rt_flutter/models/base_model.dart';
import 'package:rt_flutter/models/item_model.dart';

typedef S Itemizer<S>(Map<String, dynamic> item);

class Paginable<T extends ItemModel> extends BaseModel {
  int total;
  int count;
  int page;
  int pages;
  int perPage;
  List<T> items;

  Paginable.readJson(Map<String, dynamic> json, Itemizer<T> itemizer)
      : super() {
    assert(json != null);

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

  T getElementById(String id) {
    return items.firstWhere((q) => q.id == id, orElse: () => null);
  }

  Paginable<T> mergeWith(Paginable<T> p) {
    total = p.total;
    count += p.count;
    page = p.page;
    pages = p.pages;
    items.addAll(p.items);

    return this;
  }
}
