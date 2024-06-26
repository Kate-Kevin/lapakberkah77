import 'dart:convert'as convert;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lapakberkah77/model/place_model.dart';
import 'package:lapakberkah77/repositories/places/base_places_repositories.dart';
import 'package:http/http.dart'as http;
import '../../model/place_autocomplete_model.dart';

class PlaceRepository extends BasePlaceRepository{
  final String? key = dotenv.env['API_KEY'];
  final String types = 'geocode';

  @override
  Future<List<PlaceAutocomplete>> getAutocomplete(String searchInput) async{
    final String url = 
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchInput&types=$types&key=$key';

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['predictions'] as List;

    return results.map((place) => PlaceAutocomplete.fromJson(place)).toList();
  }

  @override
  Future<Place> getPlace(String placeId) async {
      final String url = 
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

      var response = await http.get(Uri.parse(url));
      var json = convert.jsonDecode(response.body);
      var results = json['result'] as Map<String,dynamic>;

      return Place.fromJson(results);
    }
}