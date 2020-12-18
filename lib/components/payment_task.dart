import 'package:flutter/material.dart';
import 'package:splitlegal/components/dialog.dart';
import 'package:splitlegal/components/task.dart';
import 'package:splitlegal/models/app_state.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../app_state_container.dart';

class PaymentTask extends StatefulWidget {
  Activity task;

  PaymentTask({this.task});

  @override
  _PaymentTaskState createState() => _PaymentTaskState();
}

class _PaymentTaskState extends State<PaymentTask> {
  @override
  void initState() {
    super.initState();

    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
            'pk_test_51HxBTIJL8k7rbZDCcpjXe5fc90F8AOf8Yi9ms4bxbmfWHNL18T06kFmG5gwVjVcNRP1ZVza8bKxFfF6HhB0eXWcV00VtXjnMo7',
        androidPayMode: 'test',
      ),
    );
  }

  Activity task;
  String text = 'Click the button to start the payment';
  double totalCost = 9900;
  int amount = 9900;
  bool showSpinner = false;
  String url = 'https://us-central1-splitlegal.cloudfunctions.net/StripePI';

  List<Widget> getTaskDescription(context) {
    return [
      Text(
        task.description != null
            ? task.description
            : 'There was an issue getting task data.',
        softWrap: true,
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.white,
        ),
      ),
    ];
  }

  List<Widget> getCurrentView(context) {
    return [
      MaterialButton(
        child: Text('Pay Now'),
        onPressed: () {
          checkIfNativePayReady();
        },
        color: Theme.of(context).secondaryHeaderColor,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
        ),
        textColor: Colors.white,
        height: 30,
      ),
    ];
  }

  List<Widget> getPendingView(context) {
    return [
      Text(
        'Thank you for making your payment. We are reviewing it now.',
        softWrap: true,
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.white,
        ),
      ),
    ];
  }

  List<Widget> getChildren(context) {
    return widget.task.status == 'current'
        ? getCurrentView(context)
        : getPendingView(context);
  }

  @override
  Widget build(BuildContext context) {
    return Task(task: widget.task, children: getChildren(context));
  }

  void checkIfNativePayReady() async {
    print('started to check if native pay ready');
    bool deviceSupportNativePay = await StripePayment.deviceSupportsNativePay();
    bool isNativeReady = await StripePayment.canMakeNativePayPayments(
        ['american_express', 'visa', 'maestro', 'master_card']);
    deviceSupportNativePay && isNativeReady
        ? createPaymentMethodNative()
        : createPaymentMethod();
  }

  Future<void> createPaymentMethod() async {
    StripePayment.setStripeAccount(null);
    amount = 99;
    print('amount in pence/cent which will be charged = $amount');
    //step 1: add card
    PaymentMethod paymentMethod = PaymentMethod();
    paymentMethod = await StripePayment.paymentRequestWithCardForm(
      CardFormPaymentRequest(),
    ).then((PaymentMethod paymentMethod) {
      return paymentMethod;
    }).catchError((e) {
      print('Errore Card: ${e.toString()}');
    });
    paymentMethod != null
        ? processPaymentAsDirectCharge(paymentMethod)
        : showDialog(
            context: context,
            builder: (BuildContext context) => ShowDialogToDismiss(
                title: 'Error',
                content:
                    'It is not possible to pay with this card. Please try again with a different card',
                buttonText: 'CLOSE'));
  }

  Future<void> processPaymentAsDirectCharge(PaymentMethod paymentMethod) async {
    var container = AppStateContainer.of(context);

    setState(() {
      showSpinner = true;
    });
    //step 2: request to create PaymentIntent, attempt to confirm the payment & return PaymentIntent
    final http.Response response = await http
        .post('$url?amount=$amount&currency=USD&paym=${paymentMethod.id}');
    print('Now i decode');
    if (response.body != null && response.body != 'error') {
      final paymentIntentX = jsonDecode(response.body);
      final status = paymentIntentX['paymentIntent']['status'];
      final strAccount = paymentIntentX['stripeAccount'];
      //step 3: check if payment was succesfully confirmed
      if (status == 'succeeded') {
        //payment was confirmed by the server without need for futher authentification
        StripePayment.completeNativePayRequest();
        setState(() {
          widget.task.activityData['stripe_payment_intent'] = paymentIntentX;
          widget.task.status = 'pending';

          container.updateActivity(widget.task).then((value) {
            container.setUpUserData().then(
              (value) {
                setState(
                  () {
                    container.loadUserTasks().then(() {
                      setState(() {
                        showSpinner = false;
                      });
                    });
                  },
                );
              },
            );
          });
        });
      } else {
        //step 4: there is a need to authenticate
        StripePayment.setStripeAccount(strAccount);
        await StripePayment.confirmPaymentIntent(PaymentIntent(
                paymentMethodId: paymentIntentX['paymentIntent']
                    ['payment_method'],
                clientSecret: paymentIntentX['paymentIntent']['client_secret']))
            .then(
          (PaymentIntentResult paymentIntentResult) async {
            //This code will be executed if the authentication is successful
            //step 5: request the server to confirm the payment with
            final statusFinal = paymentIntentResult.status;
            if (statusFinal == 'succeeded') {
              StripePayment.completeNativePayRequest();
              setState(() {
                showSpinner = false;
              });
            } else if (statusFinal == 'processing') {
              StripePayment.cancelNativePayRequest();
              setState(() {
                showSpinner = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) => ShowDialogToDismiss(
                      title: 'Warning',
                      content:
                          'The payment is still in \'processing\' state. This is unusual. Please contact us',
                      buttonText: 'CLOSE'));
            } else {
              StripePayment.cancelNativePayRequest();
              setState(() {
                showSpinner = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) => ShowDialogToDismiss(
                      title: 'Error',
                      content:
                          'There was an error to confirm the payment. Details: $statusFinal',
                      buttonText: 'CLOSE'));
            }
          },
          //If Authentication fails, a PlatformException will be raised which can be handled here
        ).catchError((e) {
          //case B1
          StripePayment.cancelNativePayRequest();
          setState(() {
            showSpinner = false;
          });
          showDialog(
              context: context,
              builder: (BuildContext context) => ShowDialogToDismiss(
                  title: 'Error',
                  content:
                      'There was an error to confirm the payment. Please try again with another card',
                  buttonText: 'CLOSE'));
        });
      }
    } else {
      //case A
      StripePayment.cancelNativePayRequest();
      setState(() {
        showSpinner = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) => ShowDialogToDismiss(
              title: 'Error',
              content:
                  'There was an error in creating the payment. Please try again with another card',
              buttonText: 'CLOSE'));
    }
  }

  Future<void> createPaymentMethodNative() async {
    print('started NATIVE payment...');
    StripePayment.setStripeAccount(null);
    List<ApplePayItem> items = [];
    items.add(ApplePayItem(
      label: 'Split Legal Services',
      amount: totalCost.toString(),
    ));
    items.add(ApplePayItem(
      label: 'Total Cost',
      amount: (totalCost).toString(),
    ));
    amount = 9900;
    print('amount in pence/cent which will be charged = $amount');
    //step 1: add card
    PaymentMethod paymentMethod = PaymentMethod();
    Token token = await StripePayment.paymentRequestWithNativePay(
      androidPayOptions: AndroidPayPaymentRequest(
        totalPrice: (totalCost).toStringAsFixed(2),
        currencyCode: 'USA',
      ),
      applePayOptions: ApplePayPaymentOptions(
        countryCode: 'US',
        currencyCode: 'USA',
        items: items,
      ),
    );
    paymentMethod = await StripePayment.createPaymentMethod(
      PaymentMethodRequest(
        card: CreditCard(
          token: token.tokenId,
        ),
      ),
    );
    paymentMethod != null
        ? processPaymentAsDirectCharge(paymentMethod)
        : showDialog(
            context: context,
            builder: (BuildContext context) => ShowDialogToDismiss(
                title: 'Error',
                content:
                    'It is not possible to pay with this card. Please try again with a different card',
                buttonText: 'CLOSE'));
  }
}
