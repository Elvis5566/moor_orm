import 'package:build/build.dart';
import 'package:moor_generator/src/backends/build/moor_builder.dart';
import 'package:source_gen/source_gen.dart';

class FooGenerator extends Generator implements BaseGenerator {
  @override
  MoorBuilder builder;

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    // return 'int i = 0;';
    final parsed = await builder.analyzeDartFile(buildStep);
    final writer = builder.createWriter();

    for (final dao in parsed.declaredDaos) {
      final classScope = writer.child();
      final element = dao.fromClass;

      final daoName = element.displayName;

      classScope.leaf().write('mixin _\$${daoName}Mixin on '
          'DatabaseAccessor<${dao.dbClass.getDisplayString()}> {\n');

      for (final table in dao.tables) {
        final infoType = table.tableInfoName;
        final getterName = table.dbGetterName;
        classScope.leaf().write(
            '$infoType get $getterName => attachedDatabase.$getterName;\n');
      }

      for (final query in dao.queries) {
        QueryWriter(query, classScope.child()).write();
      }

      classScope.leaf().write('}');
    }

    return writer.writeGenerated();
  }
}