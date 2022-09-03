import 'package:kartforyou/services/data_streams/data_stream.dart';
import 'package:kartforyou/services/database/user_database_helper.dart';

class AddressesStream extends DataStream<List<String>>{
  @override
  void reload(){
    final addressesList = UserDatabaseHelper().addressesList;
    addressesList.then((list){
      addData(list);
    }).catchError((e){
      addError(e);
    });
  }
}