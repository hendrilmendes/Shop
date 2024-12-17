import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pix_flutter/pix_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shop/api/api.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:shop/provider/order_provider.dart' as shop;
import 'package:shop/provider/stripe_provider.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout';

  const CheckoutScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final Map<String, String> _checkoutData = {
    'name': '',
    'address': '',
    'cpf': '',
    'email': '',
    'payment': '',
    'cardNumber': '',
    'pixKey': '',
  };

  String? _paymentMethod;
  final stripePaymentHandle = StripePaymentHandle();
  final User? user = FirebaseAuth.instance.currentUser;

  bool _isPixGenerated = false;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    if (user != null) {
      try {
        DocumentSnapshot userInfo = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (userInfo.exists) {
          setState(() {
            // Atualize os TextEditingController com os valores recuperados
            _nameController.text = userInfo.get('name') ?? '';
            _addressController.text = userInfo.get('address') ?? '';
            _cpfController.text = userInfo.get('cpf') ?? '';
            _emailController.text = userInfo.get('email') ?? '';
          });
          if (kDebugMode) {
            print('Informações do usuário recuperadas com sucesso.');
            print('Nome: ${_nameController.text}');
            print('Endereço: ${_addressController.text}');
            print('CPF: ${_cpfController.text}');
            print('Email: ${_emailController.text}');
          }
        } else {
          if (kDebugMode) {
            print('Documento não encontrado.');
          }
        }
      } catch (error) {
        if (kDebugMode) {
          print('Erro ao recuperar dados do Firestore: $error');
        }
      }
    } else {
      if (kDebugMode) {
        print('Usuário não autenticado.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final formatter = NumberFormat('#,##0.00', 'pt_BR');
    final totalAmount = cart.totalAmount;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.buyOrders,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome Completo'),
                  onSaved: (value) {
                    _checkoutData['name'] = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Endereço'),
                  onSaved: (value) {
                    _checkoutData['address'] = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu endereço.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cpfController,
                  decoration: const InputDecoration(labelText: 'CPF'),
                  onSaved: (value) {
                    _checkoutData['cpf'] = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu cpf.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  onSaved: (value) {
                    _checkoutData['email'] = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu email.';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Método de Pagamento'),
                  value: _paymentMethod,
                  items: ['Cartão', 'Pix']
                      .map((method) => DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value!;
                      if (_paymentMethod == 'Pix') {
                        _generatePixPayment(); // Gere o QR Code quando Pix for selecionado
                      }
                    });
                  },
                  onSaved: (value) {
                    _checkoutData['payment'] = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione um método de pagamento.';
                    }
                    return null;
                  },
                ),
                if (_paymentMethod == 'Pix' && _isPixGenerated)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Escaneie o QR Code abaixo ou utilize a chave Pix para realizar o pagamento:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Center(
                        child: Column(
                          children: [
                            if (_isPixGenerated)
                              Card(
                                color: Colors.white,
                                child: QrImageView(
                                  data: _checkoutData['pixKey']!,
                                  version: QrVersions.auto,
                                  size: 200.0,
                                ),
                              ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                final pixKey = _checkoutData['pixKey'] ??
                                    'Chave Pix não disponível';
                                Clipboard.setData(
                                  ClipboardData(text: pixKey),
                                );
                                Fluttertoast.showToast(
                                  msg:
                                      'Chave Pix copiada para a área de transferência.',
                                );
                              },
                              child: const Text('Copiar Chave Pix'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total:',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      'R\$ ${formatter.format(totalAmount)}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: FilledButton(
                    onPressed: () {
                      _submitOrder();
                      if (_paymentMethod == 'Cartão') {
                        final amountInCents = (totalAmount * 100).round();
                        stripePaymentHandle
                            .stripeMakePayment(amountInCents.toString());
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.buyOrderSub),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Verifique se a forma de pagamento foi selecionada
      if (_checkoutData['payment'] == null ||
          _checkoutData['payment']!.isEmpty) {
        Fluttertoast.showToast(
          msg: 'Por favor, selecione uma forma de pagamento.',
        );
        return; // Não envia o pedido se a forma de pagamento não estiver selecionada
      }

      final cart = Provider.of<CartProvider>(context, listen: false);
      final order = shop.Order(
        id: DateTime.now().toString(),
        customerName: _checkoutData['name']!,
        address: _checkoutData['address']!,
        paymentMethod: _checkoutData['payment']!,
        amount: cart.totalAmount,
        date: DateTime.now(),
        items: cart.items,
      );

      try {
        if (kDebugMode) {
          print('Enviando pedido: $order');
        }

        // Envia o pedido para o servidor
        final response = await http.post(
          Uri.parse('$apiUrl/api/orders'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(order.toJson()),
        );

        if (kDebugMode) {
          print(
              'Resposta do servidor: ${response.statusCode} - ${response.body}');
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Adiciona o pedido ao Firestore
          // ignore: use_build_context_synchronously
          await Provider.of<shop.OrderProvider>(context, listen: false)
              .addOrder(order);

          cart.clear();
          if (!mounted) return;
          Navigator.of(context).popUntil((route) => route.settings.name == '/');
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pedido realizado com sucesso!'),
            ),
          );
        } else {
          Fluttertoast.showToast(
            msg:
                'Erro ao realizar o pedido: ${response.statusCode} - ${response.body}',
          );
        }
      } catch (error) {
        Fluttertoast.showToast(
          msg: 'Erro ao conectar ao servidor: $error',
        );
        if (kDebugMode) {
          print('Erro ao conectar ao servidor: $error');
        }
      }
    }
  }

  void _generatePixPayment() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final amount = cart.totalAmount.toString();
    const pixKey = '07558844185';
    const description = 'ShopTem';

    final txid =
        'TXID${DateTime.now().millisecondsSinceEpoch}'; // Gerar um txid único

    PixFlutter pixFlutter = PixFlutter(
      payload: Payload(
        pixKey: pixKey,
        description: description,
        merchantName: 'Hendril Mendes',
        merchantCity: 'Jauru-MT',
        txid: txid, // ID único para a transação
        amount: amount,
      ),
    );

    try {
      final qrCode = pixFlutter.getQRCode();
      if (kDebugMode) {
        print('QR Code: $qrCode');
      } // Log para depuração

      setState(() {
        _isPixGenerated = true;
        _checkoutData['pixKey'] = qrCode; // Armazenar a chave Pix
      });

      Fluttertoast.showToast(
        msg: 'QR Code Pix gerado com sucesso!',
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Erro ao gerar QR Code Pix: $error',
      );
      if (kDebugMode) {
        print('Erro ao gerar QR Code Pix: $error');
      } // Log para depuração
    }
  }
}
