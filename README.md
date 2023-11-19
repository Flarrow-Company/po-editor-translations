## POEditor Translations
CLI tool for automatic updating translations in flutter projects from [POEditor](https://poeditor.com/).

---
### Working with Translations 🌐
```sh
dart dart run po_editor_translations --api_token=key --project_id=id --files_path=lib/translations
```

### Parameters 
- api_token - API token from POEditor
- project_id - Project ID from POEditor
- files_path - Path where you want to save the downloaded files relative to where you run the script
- filter - Filter assets by comma-separated tag names. Match any tag with * and negate tags by prefixing with

### API Reference
- [POEditor API Reference](https://poeditor.com/docs/api)