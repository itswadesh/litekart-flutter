import 'package:flutter/cupertino.dart';
import '../../repository/order_repository.dart';
import '../../response_handler/orderReponse.dart';
import '../../response_handler/orderTrackResponse.dart';
import '../../utility/query_mutation.dart';

class OrderViewModel with ChangeNotifier {
  QueryMutation addMutation = QueryMutation();
  String? pendingStatus = "loading";
  String? trackingStatus = "loading";
  String? deliveredStatus = "loading";
  String? trackOrderStatus = "loading";
  OrderTrackResponse? _orderTrackResponse;
  OrderRepository orderRepository = OrderRepository();
  OrderResponse? _pendingOrderResponse;
  OrderResponse? _trackingOrderResponse;
  OrderResponse? _deliveredOrderResponse;
  OrderResponse? get pendingOrderResponse {
    return _pendingOrderResponse;
  }

  OrderResponse? get trackingOrderResponse {
    return _trackingOrderResponse;
  }

  OrderResponse? get deliveredOrderResponse {
    return _deliveredOrderResponse;
  }

  OrderTrackResponse? get orderTrackResponse{
    return _orderTrackResponse;
  }

  fetchPendingOrder() async {
    var resultData = await orderRepository.fetchMyOrders(0, "", 0, "", "",  "Pending");
    pendingStatus = resultData["status"];
    if (pendingStatus == "completed") {
      _pendingOrderResponse = OrderResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }


  fetchTrackingOrder() async {
    var resultData = await orderRepository.fetchMyOrders(0, "", 0, "", "", "Tracking");
    trackingStatus = resultData["status"];
    if (trackingStatus == "completed") {
      _trackingOrderResponse = OrderResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }

  fetchDeliveredOrder() async {
    var resultData = await orderRepository.fetchMyOrders(0, "", 0, "", "", "Delivered");
    deliveredStatus = resultData["status"];
    if (deliveredStatus == "completed") {
      _deliveredOrderResponse = OrderResponse.fromJson(resultData["value"]);
    }
    notifyListeners();
  }


  refreshOrderPage() {
    pendingStatus = "loading";
    trackingStatus = "loading";
    deliveredStatus = "loading";
    notifyListeners();
  }

  fetchOrderTrack(id)async{
    var resultData = await orderRepository.orderItem(id);
    trackOrderStatus = resultData["status"];
    if (trackOrderStatus == "completed") {
      _orderTrackResponse = OrderTrackResponse.fromJson(resultData["value"]);

    }
    notifyListeners();
  }

  returnItem(id,pid,reason,request,qty)async{
    bool result  = await orderRepository.returnItem(id, pid, reason, request, qty);
    return result;
  }

  changeTrackStatus(){
    trackOrderStatus = "loading";
  }
}
