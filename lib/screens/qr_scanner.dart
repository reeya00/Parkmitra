import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'globals.dart';
import 'package:esewa_pnp/esewa.dart';
import 'package:esewa_pnp/esewa_pnp.dart';

class QRCodeScannerEntry extends StatelessWidget {
  final qrscannerController = Get.put(QRScannerEntryController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: _buildQrViewEntry(context),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Obx(() {
                final result = QRScannerEntryController.to.result.value;
                return result != null
                    ? Text(
                        'Barcode Type: ${result.format}   Data: ${result.code}')
                    : Text('Scan a QR Code');
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrViewEntry(BuildContext context) {
    return QRView(
      key: QRScannerEntryController.to.qrKey,
      onQRViewCreated: QRScannerEntryController.to.onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderRadius: 10,
        borderColor: Colors.red,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }
}

class QRScannerEntryController extends GetxController {
  static QRScannerEntryController get to => Get.find();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final result = Rxn<Barcode>();

  void onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) async {
      final barcodeValue = scanData.code.toString();
      print(barcodeValue);
      // Send a POST request to some API endpoint with the scanned data as payload
      final response =
          await http.post(Uri.parse(baseUrl + 'parkmitra/verifyentry/'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'qr_code': spaceList[index - 1],
              }));

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('Error: ${response.statusCode}');
      }

      // Dispose of the QR controller and navigate back to the previous page
      controller.dispose();
      Get.back(result: scanData);
    });
  }
}

class QRCodeScannerExit extends StatelessWidget {
  final qrscannerController = Get.put(QRScannerExitController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: _buildQrViewExit(context),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Obx(() {
                final result = QRScannerExitController.to.result.value;
                return result != null
                    ? Text(
                        'Barcode Type: ${result.format}   Data: ${result.code}')
                    : Text('Scan a QR Code');
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrViewExit(BuildContext context) {
    return QRView(
      key: QRScannerExitController.to.qrKey,
      onQRViewCreated: QRScannerExitController.to.onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderRadius: 10,
        borderColor: Colors.red,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }
}

class QRScannerExitController extends GetxController {
  static QRScannerExitController get to => Get.find();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final result = Rxn<Barcode>();

  void onQRViewCreated(QRViewController controller) {
    var fee = 0.0;
    controller.scannedDataStream.listen((scanData) async {
      final barcodeValue = scanData.code.toString();
      print(barcodeValue);
      // Send a POST request to some API endpoint with the scanned data as payload
      final response =
          await http.post(Uri.parse(baseUrl + 'parkmitra/verifyexit/'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'qr_code': spaceList[index - 1],
              }));

      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('Error: ${response.statusCode}');
      }

      // Dispose of the QR controller and navigate back to the previous page
      controller.dispose();
      Get.back(result: scanData);
    });
    initpayment(fee);
  }
}

initpayment(double amount) async {
  print("Payment entered");
  ESewaConfiguration _configuration = ESewaConfiguration(
      clientID: "JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R",
      secretKey: "BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==",
      environment: ESewaConfiguration.ENVIRONMENT_TEST);
  ESewaPnp _esewapnp = ESewaPnp(configuration: _configuration);
  ESewaPayment _payment = ESewaPayment(
      amount: amount,
      productName: "Parking Fee",
      productID: "01",
      callBackURL: "https://example.com");
  try {
    final _res = await _esewapnp.initPayment(payment: _payment);
    print(_res.message);
  } on ESewaPaymentException catch (e) {
    print("Payment error");
    print(e.message);
  }
}
