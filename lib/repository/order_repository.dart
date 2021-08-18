import '../../utility/api_provider.dart';

class OrderRepository {
  ApiProvider _apiProvider = ApiProvider();

  fetchMyOrders(page, skip, limit, search, sort, status) {
    return _apiProvider.fetchMyOrders(page, skip, limit, search, sort, status);
  }

  orderItem(id){
    return _apiProvider.orderItem(id);
  }

  returnItem(id,pid,reason,request,qty){
    return _apiProvider.returnItem(id,pid,reason,request,qty);
  }
}
