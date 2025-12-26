import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/snackbar.service.dart';
import '../../services/api_client.service.dart';
import '../../services/api_exception.service.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic> _invoice = {};

  @override
  void initState() {
    super.initState();
    _loadInvoice();
  }

  Future<void> _loadInvoice() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final args = Get.arguments ?? {};

      if (args is Map<String, dynamic> && args.containsKey('invoiceNo')) {
        _invoice = args;
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (args is Map<String, dynamic> &&
          args['type'] == 'registration' &&
          args.containsKey('purchase')) {
        final purchase = Map<String, dynamic>.from(args['purchase'] as Map);
        final double basic = _toDouble(purchase['basicAmount']);
        final double cgst = _toDouble(purchase['cgstAmount']);
        final double sgst = _toDouble(purchase['sgstAmount']);
        final double gst = cgst + sgst;
        _invoice = {
          'invoiceNumber': purchase['_id'] ?? '',
          'createdAt': purchase['createdAt'] ?? purchase['startDate'],
          'paymentMode': purchase['paymentMode'] ?? '',
          'status': purchase['status'] ?? '',
          'userId': purchase['userId'] ?? {},
          'segmentId': {
            'segmentName': purchase['packageName'] ?? '',
            'amount': basic,
            'gstAmount': gst,
            'validity': purchase['validity'] ?? '',
          },
          'amountPaid': (basic + gst),
          'paymentRefId':
              purchase['paymentRefId'] ?? purchase['paymentId'] ?? '',
        };
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final segmentId = args is Map<String, dynamic>
          ? args['segmentId'] ?? args['segment_id'] ?? args['id']
          : null;

      if (segmentId != null) {
        final response = await _apiClient.get(
          '/serments/segment-invoice',
          queryParameters: {'segmentId': segmentId},
        );

        if (response.statusCode == 200) {
          final data = response.data['data'];
          if (data != null) {
            _invoice = Map<String, dynamic>.from(data as Map);
          } else {
            _error = 'No invoice data available';
          }
        } else {
          _error = 'Failed to load invoice';
        }
      } else if (args is Map<String, dynamic> && args.isNotEmpty) {
        _invoice = Map<String, dynamic>.from(args);
      } else {
        _error = 'No invoice identifier provided';
      }
    } catch (e) {
      final apiError = ApiErrorHandler.handleError(e);
      _error = apiError.message;
      SnackbarService.showError(_error!);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatInvoiceNumber(String invoiceNo) {
    if (invoiceNo.isEmpty) return 'N/A';

    // If it's a MongoDB ID (24 hex characters), take first 12 characters
    if (invoiceNo.length >= 24 &&
        RegExp(r'^[a-f0-9]+$').hasMatch(invoiceNo.substring(0, 24))) {
      return invoiceNo.substring(0, 12).toUpperCase();
    }

    // If it's too long, truncate to reasonable length
    if (invoiceNo.length > 20) {
      return invoiceNo.substring(0, 20).toUpperCase();
    }

    return invoiceNo.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    String invoiceNo = _formatInvoiceNumber(
      _invoice['invoiceNumber']?.toString() ?? '',
    );
    String date = '';
    try {
      date =
          _invoice['createdAt']?.toString() ??
          _invoice['userActiveSegmentsId']?['purchaseDate']?.toString() ??
          '';
    } catch (_) {}
    String paymentMode = _invoice['paymentMode']?.toString() ?? '';
    String status = _invoice['status']?.toString() ?? '';
    final user = _invoice['userId'];

    String clientName = '';
    String fatherName = '';
    String address = '';
    String mobile = '';
    String pan = '';
    String email = '';
    String aadhaar = '';

    if (user is Map) {
      clientName =
          (user['fullName']?.toString() ??
          user['userObject']?['APP_NAME']?.toString() ??
          '');
      fatherName = user['userObject']?['fatherName']?.toString() ?? '';
      address = user['userObject']?['address']?.toString() ?? '';
      mobile = user['phone']?.toString() ?? '';
      pan = user['userObject']?['pan']?.toString() ?? '';
      email = user['userObject']?['APP_EMAIL']?.toString() ?? '';
      aadhaar = user['aadhaarNumber']?.toString() ?? '';
    } else if (user is String) {
      clientName = user;
    } else if (user != null) {
      clientName = user.toString();
    }

    final segment = _invoice['segmentId'] ?? {};
    final double amount = _toDouble(segment['amount']);
    final double gstAmount = _toDouble(segment['gstAmount'] ?? 0);
    final double cgst = gstAmount / 2;
    final double sgst = gstAmount / 2;
    final double totalPayable = amount + gstAmount;
    final double amountPaid =
        _invoice['status']?.toString().toLowerCase() == 'paid'
        ? totalPayable
        : (_toDouble(_invoice['amountPaid']));
    final double balance = totalPayable - amountPaid;
    final String subtotal = _fmt(amount);
    final String cgstStr = _fmt(cgst);
    final String sgstStr = _fmt(sgst);
    final String totalGst = _fmt(gstAmount);
    final String totalPayableStr = _fmt(totalPayable);
    final String amountPaidStr = _fmt(amountPaid);
    final String balanceStr = _fmt(balance);
    final String validity = segment['validity']?.toString() ?? '';
    final String paymentRefId = _invoice['paymentRefId']?.toString() ?? '';

    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff163174)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Receipt',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xff163174),
          ),
        ),
        actions: const [],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xff163174),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'SP RESEARCHVIA',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'PRIVATE LIMITED',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '129 A, Kalani Bagh, AB Road',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              Text(
                                'Dewas, MP - 455001',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              Text(
                                'info@researchvia.in',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              Text(
                                'www.researchvia.in',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'GSTIN: [Enter GST Number]',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              Text(
                                'SEBI RA No: [Enter SEBI Number]',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'SP',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff163174),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'INVOICE',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff163174),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Invoice No:',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Color(0xff6B7280),
                                ),
                              ),
                              Text(
                                invoiceNo,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff163174),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Date:',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Color(0xff6B7280),
                                ),
                              ),
                              Text(
                                date,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff163174),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Payment Mode:',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Color(0xff6B7280),
                                ),
                              ),
                              Text(
                                paymentMode.isNotEmpty ? paymentMode : 'N/A',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff163174),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Status:',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Color(0xff6B7280),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: status.toLowerCase() == 'paid'
                                      ? const Color(0xff10B981)
                                      : const Color(0xffF59E0B),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  status,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xffF9FAFB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CLIENT INFORMATION',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff163174),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow('Name:', clientName),
                          const SizedBox(height: 8),
                          _buildInfoRow('Father\'s Name:', fatherName),
                          const SizedBox(height: 8),
                          _buildInfoRow('Address:', address),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(child: _buildInfoRow('Mobile:', mobile)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildInfoRow('PAN:', pan)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow('Email:', email),
                          const SizedBox(height: 8),
                          _buildInfoRow('Aadhaar:', aadhaar),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xffF9FAFB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SERVICE DETAILS',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff163174),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildServiceItem(
                            '1.',
                            segment['segmentName']?.toString() ??
                                'Subscription',
                            '${segment['segmentName'] ?? ''} | ${validity.isNotEmpty ? '$validity Days' : ''}',
                            '₹$subtotal',
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildPriceRow('Subtotal:', subtotal),
                          const SizedBox(height: 8),
                          _buildPriceRow('CGST (9%):', cgstStr),
                          const SizedBox(height: 8),
                          _buildPriceRow('SGST (9%):', sgstStr),
                          const SizedBox(height: 8),
                          _buildPriceRow('Total GST (18%):', totalGst),
                          const SizedBox(height: 16),
                          const Divider(color: Color(0xffE5E7EB), thickness: 1),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Payable:',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff163174),
                                ),
                              ),
                              Text(
                                totalPayableStr,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff163174),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Amount Paid:',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff10B981),
                                ),
                              ),
                              Text(
                                amountPaidStr,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff10B981),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Balance:',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff10B981),
                                ),
                              ),
                              Text(
                                balanceStr,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff10B981),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xffF9FAFB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ADDITIONAL INFORMATION',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff163174),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow('Service Validity:', validity),
                          const SizedBox(height: 8),
                          _buildInfoRow('Payment Ref ID:', paymentRefId),
                          const SizedBox(height: 8),
                          _buildInfoRow('Generated By:', 'ResearchVia Admin'),
                          const SizedBox(height: 12),
                          const Text(
                            'Authorized Signatory:',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color(0xff6B7280),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '[Digital Signature]',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Color(0xff9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xffF9FAFB),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'This is a computer-generated invoice. No physical signature required.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              color: Color(0xff6B7280),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Disclaimer: SP ResearchVia Pvt. Ltd. is a SEBI-registered Research Analyst entity. All services provided are subject to SEBI guidelines and market risks.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              color: Color(0xff9CA3AF),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Support: For billing queries, contact support@researchvia.in',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              color: Color(0xff9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Color(0xff6B7280),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xff163174),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceItem(
    String number,
    String title,
    String subtitle,
    String amount,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xff163174),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff163174),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: Color(0xff6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xff163174),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Color(0xff6B7280),
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xff163174),
          ),
        ),
      ],
    );
  }

  double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v.replaceAll(',', '')) ?? 0.0;
    return 0.0;
  }

  String _fmt(double v) {
    if (v == 0) return '₹0';
    return '₹${v.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},')}';
  }
}
