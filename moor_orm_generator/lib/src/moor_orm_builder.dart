import 'package:build/build.dart';
import 'package:moor_generator/src/analyzer/options.dart';
import 'package:moor_generator/src/backends/build/moor_builder.dart';
import 'package:moor_orm_generator/src/foo_generator.dart';
import 'package:source_gen/source_gen.dart';

T _createBuilder<T extends MoorBuilder>(
  BuilderOptions options,
  T Function(List<Generator> generators, MoorOptions parsedOptions) creator,
) {
  final parsedOptions = MoorOptions.fromJson(options.config);

  final generators = <Generator>[
    FooGenerator(),
  ];

  final builder = creator(generators, parsedOptions);

  for (final generator in generators.cast<BaseGenerator>()) {
    generator.builder = builder;
  }

  return builder;
}

class MoorOrmSharedPartBuilder extends SharedPartBuilder with MoorBuilder {
  @override
  final MoorOptions options;

  MoorOrmSharedPartBuilder._(
      List<Generator> generators, String name, this.options)
      : super(generators, name);

  factory MoorOrmSharedPartBuilder(BuilderOptions options) {
    return _createBuilder(options, (generators, parsedOptions) {
      return MoorOrmSharedPartBuilder._(generators, 'moor_orm', parsedOptions);
    });
  }
}
