import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class SelectedLocation {
  String _selectedLocation;

  String get selLoc => _selectedLocation;
  Box locationBox;

  Future openBox() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    locationBox = await Hive.openBox('location');
    return;
  }

  Future putData(String data) async {
    await locationBox.clear();
    locationBox.add(data);
  }

  Future<String> getLocation() async {
    await openBox();
    List tempList = [];
    tempList = locationBox.values.toList();
    if (tempList.length == 1) {
      _selectedLocation = tempList[0];
    } else {
      _selectedLocation = null;
    }
    return _selectedLocation;
  }

  void dispose() {
    locationBox.close();
  }
}
