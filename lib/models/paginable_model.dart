import 'package:collection/collection.dart' show IterableExtension;
import 'package:rt_flutter/models/base_model.dart';
import 'package:rt_flutter/models/item_model.dart';

typedef Itemizer<S> = S Function(Map<String, dynamic>? item);

class Paginable<T extends ItemModel> extends BaseModel {
  int? total;
  int? count;
  int? page;
  int? pages;
  int? perPage;
  late List<T> items;

  Paginable.readJson(Map<String, dynamic> json, Itemizer<T> itemizer)
      : super() {
    total = json['total'];
    count = json['count'];
    page = json['page'];
    pages = json['pages'];
    perPage = json['per_page'];
    items = [];

    for (var item in json['items']) {
      items.add(itemizer(item));
    }
  }

  T? getElementById(String? id) {
    return items.firstWhereOrNull((q) => q.id == id);
  }

  Paginable<T> mergeWith(Paginable<T> p) {
    total = p.total;
    count = count! + p.count!;
    page = p.page;
    pages = p.pages;
    items.addAll(p.items);
    modelUpdated();

    return this;
  }
}
