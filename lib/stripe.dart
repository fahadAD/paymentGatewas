// import 'dart:convert';
//
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// class MakeStripeRepo{
//   Map<String,dynamic>? paymentIntentData;
//
//   calculateAmount({required String amount}){
//     final price=int.tryParse(amount)!*100;
//     return price.toString();
//   }
//
//   createPaymentIntent({required String amount,required String currency}) async {
//     try{
//
//       var response=await http.post(Uri.parse("https://api.stripe.com/v1/payment_intents"),
//         body: {
//           "amount":  calculateAmount(amount: amount),
//           "currency":currency,
//           'payment_method_types[]': 'card',
//         },
//         headers: {
//           "Authorization": "Bearer sk_test_51NkfZPQcTOlW4IdiRN6s8eUVcgIDYHzTB4ur1ZqyIcv1L0bYiwoBy6oXeEXrMtfz9c1Bkw46qy5GTH7f0EJlxm9000Ds1alULv",
//           "Content-Type": "application/x-www-form-urlencoded"
//         },
//       );
//       return jsonDecode(response.body);
//     }catch(e){
//       print("error charging user$e");
//       EasyLoading.showError("CONNECT YOUR INTERNET CONNECTION.. exception error charging user $e");
//     }
//   }
//
//
//   displayPaymentSheet()async{
//     try{
//       await Stripe.instance.presentPaymentSheet();
//       EasyLoading.showSuccess("Payment Successful");
//
//     } on Exception catch (e) {
//       if(e is StripeException){
//         print('error from stripe: ${e.error.localizedMessage}');
//       }else{
//         print("unforced error: $e");
//         EasyLoading.showError("Cancelled");
//       }
//
//     }catch(e){
//       print("exception$e");
//     }
//   }
//
//   Future<void> makePaymentFun({required String amount,required String currency})async{
//     try{
//       paymentIntentData=await createPaymentIntent(amount: amount, currency: currency);
//       if(paymentIntentData != null){
//         await Stripe.instance.initPaymentSheet(paymentSheetParameters:
//         SetupPaymentSheetParameters(
//           billingDetails: const BillingDetails(
//               name: "",
//               address:  Address(city: "",country: "",line1: "",line2: "", postalCode: "", state: ""),
//               email: "",
//               phone: ""
//           ),
//           billingDetailsCollectionConfiguration: const BillingDetailsCollectionConfiguration(
//               phone:  CollectionMode.always,
//               email:    CollectionMode.always,
//               name:  CollectionMode.always,
//               address: AddressCollectionMode.full,
//               attachDefaultsToPaymentMethod: false
//           ),
//           merchantDisplayName: "Prospects",
//           customerId: paymentIntentData!["customer"],
//           paymentIntentClientSecret: paymentIntentData!["client_secret"],
//           customerEphemeralKeySecret: paymentIntentData!["ephemeralKey"],
//
//         ));
//         displayPaymentSheet();
//       }
//     }catch(e,s){
//       print("exception:$e$s");
//     }
//   }
//
//
//
//
// }