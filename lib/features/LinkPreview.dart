import 'dart:async';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

/// Model representing link preview data
class LinkPreview {
  final String url;
  final String? title;
  final String? description;
  final String? image;
  final String? siteName;
  final bool isError;
  final String? errorMessage;

  LinkPreview({
    required this.url,
    this.title,
    this.description,
    this.image,
    this.siteName,
    this.isError = false,
    this.errorMessage,
  });

  /// Returns an error preview
  factory LinkPreview.error(String url, String message) {
    return LinkPreview(url: url, isError: true, errorMessage: message);
  }
}

/// Service to fetch Open Graph metadata from a URL
class LinkPreviewService {
  /// Fetch metadata for [url], with a [timeoutSec] fallback
  Future<LinkPreview> fetchPreview(String url, {int timeoutSec = 5}) async {
    try {
      final uri = Uri.parse(url);

      // Perform GET request with timeout
      final response = await http
          .get(uri)
          .timeout(Duration(seconds: timeoutSec));

      if (response.statusCode != 200) {
        return LinkPreview.error(url, 'HTTP error: ${response.statusCode}');
      }

      // Parse HTML document
      final document = parse(response.body);

      // Helper to read meta tag content
      String? readMeta(String property) {
        final meta = document.head
            ?.querySelector('meta[property="$property"]')
            ?.attributes['content'];
        return meta?.isNotEmpty == true ? meta : null;
      }

      // Try Open Graph tags
      final ogUrl = readMeta('og:url') ?? url;
      final title =
          readMeta('og:title') ?? document.head?.querySelector('title')?.text;
      final description =
          readMeta('og:description') ??
          document.head
              ?.querySelector('meta[name="description"]')
              ?.attributes['content'];
      final image = readMeta('og:image');
      final siteName = readMeta('og:site_name');

      return LinkPreview(
        url: ogUrl,
        title: title,
        description: description,
        image: image,
        siteName: siteName,
      );
    } on TimeoutException {
      return LinkPreview.error(
        url,
        'Request timed out after \$timeoutSec seconds',
      );
    } on http.ClientException catch (e) {
      return LinkPreview.error(url, 'Network error: \${e.message}');
    } catch (e) {
      return LinkPreview.error(url, 'Unexpected error: \$e');
    }
  }
}
