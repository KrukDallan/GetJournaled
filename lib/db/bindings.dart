
// bind to get_it the services
import 'package:get_it/get_it.dart';
import 'package:getjournaled/db/abstraction/local_note_map_service.dart';
import 'package:getjournaled/db/abstraction/note_map_service.dart';

Future<void> bindDependencies() async{
  // If you want to change the 'database', just change "LocalNoteMapService"
  // synchronous
  GetIt.I.registerSingleton<NoteService>(LocalNoteMapService());

/* // "transparent" activation
  GetIt.I.registerSingletonAsync(() async {
    var instance = LocalNoteMapService();
    await instance.open();
    return instance;
  });

  // initialize all singleton async
await GetIt.I.allReady(); */
}