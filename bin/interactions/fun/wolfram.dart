import 'package:http/http.dart' show get, Response, Request;

Future<Object> webRequestHandler(Uri uri, Map<String, String> params) async {
  var response = await get(uri);
  if (response.statusCode == 200) {
    return response;
  } else if (response.statusCode == 400) {
    return 'Sorry, the API did not find any input to interpret.';
  } else if (response.statusCode == 501) {
    return 'Sorry, the API could not understand your input.';
  } else {
    return 'Unidentified error! Status code: ${response.statusCode}, Error: ${response.body}';
  }
}
