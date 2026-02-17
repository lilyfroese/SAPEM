import '../core/api/api.dart';
import '../core/api/api_response.dart';
import '../core/api/auth_storage.dart';

class MetaService {
  Future<ApiResponse> getMetas() async {
    return await Api.client.get('/metas');
  }

  Future<ApiResponse> criarMeta(Map<String, dynamic> data) async {
    return await Api.client.post('/metas', data);
  }
}

