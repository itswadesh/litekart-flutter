import '../../utility/api_provider.dart';

class BrainTreeRepository {
  ApiProvider _apiProvider = ApiProvider();

  brainTreeToken(id) {
    return _apiProvider.brainTreeToken(id);
  }

  brainTreeMakePayment(nonce,token){
    return _apiProvider.brainTreeMakePayment(nonce, token);
  }

}