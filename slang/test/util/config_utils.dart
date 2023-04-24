import 'package:slang/builder/model/enums.dart';
import 'package:slang/builder/model/obfuscation_config.dart';
import 'package:slang/builder/model/raw_config.dart';
import 'package:slang/builder/model/context_type.dart';
import 'package:slang/builder/model/i18n_locale.dart';
import 'package:slang/builder/model/interface.dart';

final defaultLocale = I18nLocale.fromString(RawConfig.defaultBaseLocale);

final baseConfig = RawConfig(
  baseLocale: defaultLocale,
  fallbackStrategy: RawConfig.defaultFallbackStrategy,
  inputDirectory: RawConfig.defaultInputDirectory,
  inputFilePattern: RawConfig.defaultInputFilePattern,
  outputDirectory: RawConfig.defaultOutputDirectory,
  outputFileName: RawConfig.defaultOutputFileName,
  outputFormat: RawConfig.defaultOutputFormat,
  localeHandling: RawConfig.defaultLocaleHandling,
  flutterIntegration: RawConfig.defaultFlutterIntegration,
  namespaces: RawConfig.defaultNamespaces,
  translateVar: RawConfig.defaultTranslateVar,
  enumName: RawConfig.defaultEnumName,
  translationClassVisibility: RawConfig.defaultTranslationClassVisibility,
  keyCase: RawConfig.defaultKeyCase,
  keyMapCase: RawConfig.defaultKeyMapCase,
  paramCase: RawConfig.defaultParamCase,
  stringInterpolation: RawConfig.defaultStringInterpolation,
  renderFlatMap: RawConfig.defaultRenderFlatMap,
  translationOverrides: RawConfig.defaultTranslationOverrides,
  renderTimestamp: RawConfig.defaultRenderTimestamp,
  maps: RawConfig.defaultMaps,
  pluralAuto: RawConfig.defaultPluralAuto,
  pluralParameter: RawConfig.defaultPluralParameter,
  pluralCardinal: RawConfig.defaultCardinal,
  pluralOrdinal: RawConfig.defaultOrdinal,
  contexts: RawConfig.defaultContexts,
  interfaces: RawConfig.defaultInterfaces,
  obfuscation: RawConfig.defaultObfuscationConfig,
  imports: RawConfig.defaultImports,
);

extension BuildConfigCopy on RawConfig {
  RawConfig copyWith({
    FallbackStrategy? fallbackStrategy,
    String? inputFilePattern,
    OutputFormat? outputFormat,
    bool? renderLocaleHandling,
    bool? flutterIntegration,
    CaseStyle? keyCase,
    CaseStyle? keyMapCase,
    bool? translationOverrides,
    List<String>? maps,
    PluralAuto? pluralAuto,
    List<String>? pluralCardinal,
    List<String>? pluralOrdinal,
    List<ContextType>? contexts,
    List<InterfaceConfig>? interfaces,
    ObfuscationConfig? obfuscation,
  }) {
    return RawConfig(
      baseLocale: baseLocale,
      fallbackStrategy: fallbackStrategy ?? this.fallbackStrategy,
      inputDirectory: inputDirectory,
      inputFilePattern: inputFilePattern ?? this.inputFilePattern,
      outputDirectory: outputDirectory,
      outputFileName: outputFileName,
      outputFormat: outputFormat ?? this.outputFormat,
      localeHandling: renderLocaleHandling ?? this.localeHandling,
      flutterIntegration: flutterIntegration ?? this.flutterIntegration,
      namespaces: namespaces,
      translateVar: translateVar,
      enumName: enumName,
      translationClassVisibility: translationClassVisibility,
      keyCase: keyCase ?? this.keyCase,
      keyMapCase: keyMapCase ?? this.keyMapCase,
      paramCase: paramCase,
      stringInterpolation: stringInterpolation,
      renderFlatMap: renderFlatMap,
      renderTimestamp: renderTimestamp,
      translationOverrides: translationOverrides ?? this.translationOverrides,
      maps: maps ?? this.maps,
      pluralAuto: pluralAuto ?? this.pluralAuto,
      pluralParameter: pluralParameter,
      pluralCardinal: pluralCardinal ?? this.pluralCardinal,
      pluralOrdinal: pluralOrdinal ?? this.pluralOrdinal,
      contexts: contexts ?? this.contexts,
      interfaces: interfaces ?? this.interfaces,
      obfuscation: obfuscation ?? this.obfuscation,
      imports: imports,
    );
  }
}
