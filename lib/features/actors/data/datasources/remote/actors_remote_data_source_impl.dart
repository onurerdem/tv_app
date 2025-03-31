import 'package:tv_app/core/network/api_client.dart';
import 'package:tv_app/features/actors/data/datasources/actors_remote_data_source.dart';
import 'package:tv_app/features/actors/data/models/actor_model.dart';
import 'package:tv_app/core/utils/constants.dart';

class ActorsRemoteDataSourceImpl implements ActorsRemoteDataSource {
  final ApiClient apiClient;

  ActorsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ActorModel>> getAllActors() async {
    final response = await apiClient.get(GET_ACTORS);
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => ActorModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load actors.");
    }
  }

  @override
  Future<List<ActorModel>> searchActors(String query) async {
    final response = await apiClient.get(GET_SEARCH_ACTORS + query);
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => ActorModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load actors.");
    }
  }
}
