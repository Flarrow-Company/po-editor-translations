import 'package:po_editor_translations/arguments_parser.dart';
import 'package:args/args.dart';
import 'package:po_editor_translations/po_editor_service.dart';
import 'package:po_editor_translations/re_case.dart';
import 'dart:convert';
import 'dart:io';

const apiTokenOption = 'api_token';
const projectIdOption = 'project_id';
const filtersOption = 'filters';
const filesPathOption = 'files_path';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption(apiTokenOption, mandatory: true)
    ..addOption(projectIdOption, mandatory: true)
    ..addOption(filesPathOption, mandatory: true)
    ..addOption(filtersOption, mandatory: false);

  final result = parser.parse(arguments);

  final apiKey = parseArguments(apiTokenOption, result.arguments);
  final projectId = parseArguments(projectIdOption, result.arguments);

  if (apiKey == null || projectId == null) {
    throw Exception('Please provide an API token with project ID "api_token" and "project_id"');
  }
  final filesPath = parseArguments(filesPathOption, result.arguments);

  if (filesPath == null) {
    throw Exception('Please specify the path where to save the files "files_path"');
  }
  final filters = parseArguments(filtersOption, result.arguments);

  final service = PoEditorService(
    apiToken: apiKey,
    projectId: projectId,
    filters: filters,
  );

  final languages = await service.getLanguages();

  for (final language in languages) {
    print("$language\n");

    final translationsDetails = <String, dynamic>{
      '@@locale': language.code,
      '@@updated': language.updated,
      '@@language': language.name,
      '@@percentage': '${language.percentage}',
    };

    final translations = await service.getTranslations(language).then(
      (value) {
        return value.map(
          (key, value) {
            final entry = MapEntry(ReCase(key).toCamelCase(), value);
            print(entry);
            return entry;
          },
        );
      },
    );

    translationsDetails.addAll(translations);

    final arbText = json.encode(translationsDetails)
      ..replaceAll('",', r'",\n')
      ..replaceAll('},', r'},\n');

    final file = File('$filesPath/app_${language.code}.arb');
    file.writeAsStringSync(arbText);
  }
}
