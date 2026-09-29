import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:koolbar_demo/features/ride_request/data/models.dart';

@LazySingleton(scope: "RideRequest")
class SavedLocationDao {
  new() {
    Hive.registerAdapter(SavedLocationAdapter());
  }
  Future<Box<SavedLocation>> _openBox() async {
    if(!Hive.isBoxOpen("saved_locations")){
     return await Hive.openBox("saved_locations");
    }
    return Hive.box("saved_locations");
  }

  Future<String> save(SavedLocation location) async {
    final box=await _openBox();
    final counterBox=await Hive.openBox<int>("saved_location_counter_box");
    var lastID=counterBox.get("last_id",defaultValue: 0)!;
    var newID=lastID++;
    location.id=newID.toString();
    await box.put(newID, location);
    await counterBox.put("last_id", newID);
    await counterBox.close();
    await box.close();
    return newID.toString();
  }

  Future<List<SavedLocation>> getSavedLocations() async {
    final box = await _openBox();
    final res = box.values.toList();
    await box.close();
    return res;
  }
  Future<SavedLocation?> findByID(String id) async {
    final box =await _openBox();
    final res=box.get(id);
    await box.close();
    return res;
  }

}
