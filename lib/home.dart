import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
 import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int razorpayAmount=600;
  late Razorpay _razorpay;

  //razorpay...............
  void openCheckout(){

    const price=200*100;
    var options = {
      'key': 'rzp_test_lGm5FLE0Ty9evM', //<YOUR_KEY_ID>
      "id": "order_DBJOWzybf0sJbb",
      "entity": "order",
      "amount": price,
      "currency": "INR",
      "receipt": "rcptid_11",
      "attempts": 0,
      "notes": [],

    };
    // var options = {
    //   'key': 'rzp_test_lGm5FLE0Ty9evM', //<YOUR_KEY_ID>
    //   'amount': 60, //in the smallest currency sub-unit.
    //   'name': 'Acme Corp.',
    //   'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
    //   'description': 'Fine T-Shirt',
    //   'timeout': 180, // in seconds
    //   'prefill': {
    //     'contact': '9000090000',
    //     'email': 'gaurav.kumar@example.com'
    //   },
    //   'external': {'wallets': ['paytm']}
    // };
    try{
      _razorpay.open(options) ;
    }catch(e){
      debugPrint("Error $e");
    }
  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    EasyLoading.showSuccess("Payment Successfully\n\n${response.paymentId}\n\n${response.data}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    EasyLoading.showError("Payment Failure\n\n${response.message}\n\n${response.error}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    EasyLoading.showError("External wallet \n\n${response.walletName}");
  }
//razorpay...............

@override
  void initState() {
  //razorpay...............
  _razorpay=Razorpay();
  _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

  //razorpay...............

     super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // MakeStripeRepo  _stripe=MakeStripeRepo();
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          
          //paypal.........
          Center(
            child: ElevatedButton(
                onPressed: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => UsePaypal(
                          sandboxMode: true,
                          clientId: "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
                          secretKey: "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9",
                          returnURL: "https://samplesite.com/return",
                          cancelURL: "https://samplesite.com/cancel",
                          transactions: const [
                            {
                              "amount": {
                                "total": '10.12',
                                "currency": "USD",
                                "details": {
                                  "subtotal": '10.12',
                                  "shipping": '0',
                                  "shipping_discount": 0
                                }
                              },
                              "description": "The payment transaction description.",

                              "item_list": {
                                "items": [
                                  {
                                    "name": "A demo product",
                                    "quantity": 1,
                                    "price": '10.12',
                                    "currency": "USD"
                                  }
                                ],

                                // shipping address is not required though
                                "shipping_address": {
                                  "recipient_name": "Jane Foster",
                                  "line1": "Travis County",
                                  "line2": "",
                                  "city": "Austin",
                                  "country_code": "US",
                                  "postal_code": "73301",
                                  "phone": "+00000000",
                                  "state": "Texas"
                                },
                              }
                            }
                          ],
                          note: "Contact us for any questions on your order.",
                          onSuccess: (Map params) async {
                            print("onSuccess: $params");
                          },
                          onError: (error) {
                            print("onError: $error");
                          },
                          onCancel: (params) {
                            print('cancelled: $params');
                          }),
                    ),
                  )
                }, child: const Text("Paypal")),
          ),
          //paypal.........

          //razorpay
          Center(
            child: ElevatedButton(
                onPressed: () {
                 openCheckout();
                }, child: const Text("Razorpay")),
          ),
          //razorpay

          //stripe
          Center(
            child: ElevatedButton(
                onPressed: () {
                  makePaymentFun(amount: '500', currency: 'USD');
                  // _stripe.makePaymentFun(amount: '300', currency: 'USD');
                }, child: const Text("Stripe")),
          ),

          //stripe
        ],
      ),
    );
  }

  //stripe
  Map<String,dynamic>? paymentIntentData;
  calculateAmount({required String amount}){
    final price=int.tryParse(amount)!*100;
    return price.toString();
  }


  displayPaymentSheet()async{
    try{
      await Stripe.instance.presentPaymentSheet();
      EasyLoading.showSuccess("Payment Successful");

    } on Exception catch (e) {
      if(e is StripeException){
        print('error from stripe: ${e.error.localizedMessage}');
      }else{
        print("unforced error: $e");
        EasyLoading.showError("Cancelled");
      }

    }catch(e){
      print("exception $e");
    }
  }

  createPaymentIntent({required String amount,required String currency}) async {
    try{
      Map<String,dynamic> body={
        "amount":  calculateAmount(amount: amount),
        "currency":currency,
        'payment_method_types[]': 'card',
      };
      var response=await http.post(Uri.parse("https://api.stripe.com/v1/payment_intents"),
         body: body,
        headers: {
          "Authorization": "Bearer sk_test_51NkfZPQcTOlW4Idi1SYhuJ4hFHbEMQYtPZBTPeW0YRJ2uW4RxBsWHH8DLxbXJGYN781sF2EFT4aMuE9aWno7XtuR0084CvLCRs",
          "Content-Type": "application/x-www-form-urlencoded"
        },
      );
      return jsonDecode(response.body);
    }catch(e){
      print("error charging user$e");
      EasyLoading.showError("CONNECT YOUR INTERNET CONNECTION.. exception error charging user $e");
    }
  }

  Future<void> makePaymentFun({required String amount,required String currency})async{
    try{

      paymentIntentData=await createPaymentIntent(amount: amount, currency: currency);
      var gPay=  PaymentSheetGooglePay(
          merchantCountryCode: currency,
        currencyCode: currency,
        testEnv: true,
      );

      if(paymentIntentData != null){
        await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
          billingDetails: const BillingDetails(
              name: "",
              address:  Address(city: "",country: "",line1: "",line2: "", postalCode: "", state: ""),
              email: "",
              phone: ""
          ),
          billingDetailsCollectionConfiguration: const BillingDetailsCollectionConfiguration(
              phone:  CollectionMode.always,
              email:    CollectionMode.always,
              name:  CollectionMode.always,
              address: AddressCollectionMode.full,
              attachDefaultsToPaymentMethod: false
          ),
          merchantDisplayName: "Fahad",
          customerId: paymentIntentData!["customer"],
          paymentIntentClientSecret: paymentIntentData!["client_secret"],
          customerEphemeralKeySecret: paymentIntentData!["ephemeralKey"],
          googlePay: gPay,
        ));
        displayPaymentSheet();

      }

    }catch(e,s){
      print("exception:$e$s");
    }
  }


  //stripe
}
