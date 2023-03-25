import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'globals.dart';


class QRCodeScanner extends StatelessWidget {
  final qrscannerController = Get.put(QRScannerController());
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
            child: _buildQrView(context),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Obx(() {
                final result = QRScannerController.to.result.value;
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

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: QRScannerController.to.qrKey,
      onQRViewCreated: QRScannerController.to.onQRViewCreated,
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

class QRScannerController extends GetxController {
  static QRScannerController get to => Get.find();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final result = Rxn<Barcode>();

  void onQRViewCreated(QRViewController controller) {
  controller.scannedDataStream.listen((scanData) async {
    // Send a POST request to some API endpoint with the scanned data as payload
    final response = await http.post(
      Uri.parse(baseUrl + 'parking/verifyentry/'),
      body: {'data': scanData.code},
    );

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
