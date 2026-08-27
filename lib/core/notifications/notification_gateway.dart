abstract interface class NotificationGateway {
  Future<void> requestPermission();

  Stream<String> get tokenChanges;
}
