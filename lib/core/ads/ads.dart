// Ads are only compiled in where dart:io exists (the Android/iOS apps). The
// website gets a do-nothing stand-in with the same names.
export 'ad_service_stub.dart' if (dart.library.io) 'ad_service_mobile.dart';
