import 'package:build/build.dart';
import 'package:moor_orm_generator/src/foo_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder moorOrmBuilder(BuilderOptions options) =>
    MoorOrmSharedPartBuilder(options);

class MoorOrmSharedPartBuilder extends SharedPartBuilder {
  MoorOrmSharedPartBuilder._(List<Generator> generators, String name)
      : super(generators, name);

  factory MoorOrmSharedPartBuilder(BuilderOptions options) {
    final generators = <Generator>[
      FooGenerator(),
    ];
    return MoorOrmSharedPartBuilder._(generators, 'moor_orm');
    ;
  }
}
