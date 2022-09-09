import 'dart:convert';
import 'package:delta_markdown/delta_markdown.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:markdown/markdown.dart';
import 'package:html2md/html2md.dart' as html2md;

class HtmlService {
  //

  static String quillDeltaToHtml(Delta delta) {
    final convertedValue = jsonEncode(delta.toJson());
    final markdown = deltaToMarkdown(convertedValue);
    final html = markdownToHtml(markdown);
    return html;
  }

  static String htmlToQuillDelta(String html) {
    var markdownText = html2md.convert(html);
    return markdownToDelta(markdownText);
  }
}
