import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class StripePaymentHandle {
  Map<String, dynamic>? paymentIntent;

  Future<void> stripeMakePayment(String amount) async {
    try {
      // Normalize and log the amount
      final normalizedAmount = normalizeAmount(amount);
      if (kDebugMode) {
        print('Normalized Amount: $normalizedAmount');
      }

      // Convert to cents and log the result
      final amountInCents = calculateAmount(normalizedAmount);
      if (kDebugMode) {
        print('Amount in Cents: $amountInCents');
      }

      paymentIntent = await createPaymentIntent(amountInCents, 'BRL');

      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  billingDetails: const BillingDetails(
                      name: 'Hendril Mendes',
                      email: 'hendrilmendes2015@gmail.com',
                      phone: '+556599361184',
                      address: Address(
                          city: 'Jauru',
                          country: 'Brazil',
                          line1: 'Rua Pedra Azul, 0',
                          line2: 'Cidade Nova',
                          postalCode: '78255000',
                          state: 'Mato Grosso')),
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], // Gotten from payment intent
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Hendril'))
          .then((value) {});

      // STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      Fluttertoast.showToast(msg: 'Pagamento feito com sucesso');
    } on Exception catch (e) {
      if (e is StripeException) {
        Fluttertoast.showToast(
            msg: 'Error from Stripe: ${e.error.localizedMessage}');
      } else {
        Fluttertoast.showToast(msg: 'Unforeseen error: $e');
      }
    }
  }

  // Create Payment
  createPaymentIntent(String amount, String currency) async {
    try {
      // Request body
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      // Make post request to Stripe
      String stripeSecret =
          'sk_test_51PhgcYRrdJeN8anlwBWlj0BamDlyYENWsiNFetyJztR7C6bXOur8OmxDXOc9cI5S1mBcGGRgxWjxeqA8thhQ54TC00oJvsJ8by';
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $stripeSecret',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      if (kDebugMode) {
        print('Stripe Response: ${response.body}');
      }
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  // Normalize Amount to use '.' as decimal separator
  normalizeAmount(String amount) {
    return amount.replaceAll('.', ',');
  }

  // Calculate Amount in cents
  calculateAmount(String amount) {
    try {
      final double parsedAmount = double.parse(amount);
      final int amountInCents = (parsedAmount).toInt();
      return amountInCents.toString();
    } catch (e) {
      throw Exception('Invalid amount format: $e');
    }
  }
}
