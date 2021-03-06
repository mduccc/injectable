import 'package:injectable_generator/dependency_config.dart';
import 'package:injectable_generator/generator/register_func_generator.dart';
import 'package:injectable_generator/utils.dart';

class ModuleFactoryParamGenerator extends RegisterFuncGenerator {
  @override
  String generate(DependencyConfig dep) {
    throwBoxedIf(dep.preResolve,
        'Error generating [${dep.type}]! FactoryParams can not be pre resolved');

    final constructBody = generateConstructorForModule(dep);
    var asyncStr = dep.isAsync && !dep.preResolve ? 'Async' : '';

    var typeArgs = dep.moduleConfig.params;
    if (typeArgs.length < 2) {
      typeArgs['_'] = 'dynamic';
    }

    final argsDeclaration = '<${dep.type},${typeArgs.values.join(',')} >';

    final methodParams = typeArgs.keys.join(',');

    writeln(
        "g.registerFactoryParam$asyncStr$argsDeclaration(($methodParams)=> $constructBody");

    closeRegisterFunc(dep);
    return buffer.toString();
  }
}
