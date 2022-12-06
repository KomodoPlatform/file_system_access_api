import 'dart:html';

import 'package:file_system_access_api/file_system_access_api.dart';

import 'light_storage.dart';
import 'view.dart';

extension HtmlElementState on HtmlElement {
  void show() {
    style.display = "";
  }

  void hide() {
    style.display = "none";
  }
}

final view = View();

void main() async {
  if (!FileSystemAccess.supported || !LightStorage.supported) {
    view.$unsupported.show();
    return;
  }
  view.$unsupported.remove();
  view.$header.show();
  view.$about.show();

  LightStorage db = LightStorage();

  await db.open();
  await view.init(db);

  redirectTab();
}

void redirectTab() {
  var url = window.location.href;

  if (!url.contains("#")) {
    return;
  }
  final tab = url.substring(url.lastIndexOf("#") + 1);

  view.selectTab(tab, false);
}

/// Return true when permission is granted on [handle] with [mode] access, false otherwise.
Future<bool> verifyPermission(FileSystemHandle handle, {PermissionMode mode = PermissionMode.read}) async {
  var permission = await handle.queryPermission(mode: mode);

  if (permission == PermissionState.granted) {
    return true;
  }
  permission = await handle.requestPermission(mode: mode);
  return permission == PermissionState.granted;
}
