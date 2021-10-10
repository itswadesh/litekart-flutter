import 'dart:convert';

import 'package:anne/main.dart';
import 'package:dio/dio.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeService {
  static String apiURL = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiURL}/payment_intents';
  static String secret =   settingData.stripePublishableKey; //your secret from stripe dashboard
  static Map<String, String> headers = {
    // 'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    StripePayment.setOptions(
        StripeOptions(
            publishableKey:settingData.stripePublishableKey, // user your api key
            // merchantId: "Test",
            // androidPayMode: 'test'
        )
    );
  }

  static Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount, // amount charged will be specified when the method is called
        'currency': currency, // the currency
        'payment_method_types[]': 'card' //card
      };

      Dio dio = Dio();
      var response =
      await dio.post(
          StripeService.paymentApiUrl,  //api url
          data: body,  //request body
          options: Options(headers:StripeService.headers) //headers of the request specified in the base class
      );
      return jsonDecode(response.data); //decode the response to json
    } catch (error) {
      print('Error occured : ${error.toString()}');
    }
    return null;
  }
}

class PaymentResponse {
  String message; // message from the response
  bool success; //state of the processs

  //class constructor
  PaymentResponse({this.message, this.success});
}

