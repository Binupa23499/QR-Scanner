import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'scan_result_page.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _startScanning() {
    setState(() {
      isScanning = true;
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera(); // Pause scanning after a QR code is found
      setState(() {
        isScanning = false;
      });
      String qrResult = scanData.code ?? 'No data found';  // Provide a fallback if scanData.code is null
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanResultPage(result: qrResult), // Pass scanned data
        ),
      ).then((_) => controller.resumeCamera()); // Resume camera when coming back
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: isScanning ? null : _startScanning, // Disable button when scanning
                child: Text('Scan QR Code'),
              ),
            ),
          ),
          if (isScanning)
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.green,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
