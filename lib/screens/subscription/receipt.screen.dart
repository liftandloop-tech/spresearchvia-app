import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/snackbar.service.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> receiptData = Get.arguments ?? {};
    final String invoiceNo = receiptData['invoiceNo'];
    final String date = receiptData['date'];
    final String paymentMode = receiptData['paymentMode'];
    final String status = receiptData['status'];
    final String clientName = receiptData['clientName'];
    final String fatherName = receiptData['fatherName'];
    final String address = receiptData['address'];
    final String mobile = receiptData['mobile'];
    final String pan = receiptData['pan'];
    final String email = receiptData['email'];
    final String aadhaar = receiptData['aadhaar'];
    final String subtotal = receiptData['subtotal'];
    final String cgst = receiptData['cgst'];
    final String sgst = receiptData['sgst'];
    final String totalGst = receiptData['totalGst'];
    final String totalPayable = receiptData['totalPayable'];
    final String amountPaid = receiptData['amountPaid'];
    final String balance = receiptData['balance'];
    final String validity = receiptData['validity'];
    final String paymentRefId = receiptData['paymentRefId'];

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
        actions: [
          IconButton(
            icon: const Icon(Icons.print, color: Color(0xff163174)),
            onPressed: () {
              SnackbarService.showInfo('Print functionality coming soon');
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Color(0xff163174)),
            onPressed: () {
              SnackbarService.showInfo('PDF download coming soon');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                          paymentMode,
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
                            color: const Color(0xff10B981),
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
                      'Research Subscription - Index Option',
                      'Splendid Plan | 1 Year',
                      '₹1,51,000',
                    ),
                    const SizedBox(height: 12),
                    _buildServiceItem(
                      '2.',
                      'Research Subscription - Stock Future',
                      'Spark Plan | 1 Year',
                      '₹99,000',
                    ),
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
                    _buildPriceRow('CGST (9%):', cgst),
                    const SizedBox(height: 8),
                    _buildPriceRow('SGST (9%):', sgst),
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
                          totalPayable,
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
                          amountPaid,
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
                          balance,
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
}
