/// BaseModel is base abstract class used by all fetched models
abstract class BaseModel {
  DateTime? _createdAt;
  // TODO: Find out if we really need _updatedAt or only _createdAt
  DateTime? _updatedAt;
  Duration stalenessThreshold = const Duration(hours: 1);

  BaseModel() {
    _createdAt = DateTime.now();
  }

  isStale() {
    return modelAge()!.add(stalenessThreshold).isBefore(DateTime.now());
  }

  modelUpdated() {
    _updatedAt = DateTime.now();
  }

  // TODO: At some point we should use this to set If-Modified-Since header
  DateTime? modelAge() {
    return _updatedAt ?? _createdAt;
  }
}
