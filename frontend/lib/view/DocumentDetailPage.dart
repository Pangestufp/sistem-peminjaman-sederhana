import 'package:apppeminjaman/authentification/AuthStateManager.dart';
import 'package:apppeminjaman/authentification/AuthService.dart';
import 'package:apppeminjaman/model/Detail.dart';
import 'package:apppeminjaman/model/Payment.dart';
import 'package:apppeminjaman/model/UserAccess.dart';
import 'package:apppeminjaman/model/Workflow.dart';
import 'package:apppeminjaman/service/ApproveService.dart';
import 'package:apppeminjaman/service/PaymentService.dart';
import 'package:apppeminjaman/service/RejectService.dart';
import 'package:apppeminjaman/service/UserAccessService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:apppeminjaman/model/transactionData.dart';
import 'package:apppeminjaman/service/PeminjamanDetailService.dart';

class DocumentDetailPage extends StatefulWidget {
  final String docNo;
  final int showAction;

  const DocumentDetailPage({Key? key, required this.docNo, required this.showAction}) : super(key: key);

  @override
  State<DocumentDetailPage> createState() => _DocumentDetailPageState();
}

class _DocumentDetailPageState extends State<DocumentDetailPage> {

  TransactionData? _document;

  bool _isLoading = true;
  bool _showDetails = false;
  bool _showPayments = false;
  bool _showWorkflow = false;

  final ApproveService _approveService = ApproveService();
  final RejectService _rejectService = RejectService();
  final PaymentService _paymentService = PaymentService();
  final UserAccessService _userAccessService = UserAccessService();
  UserAccess? _userAccess;

  @override
  void initState() {
    super.initState();
    _loadDocument();
    _loadUserAccess();
  }

  Future<void> _loadDocument() async {
    final service = PeminjamanDetailService();
    final doc = await service.getPeminjamanByDocNo(widget.docNo);



    setState(() {
      _document = doc;
      _isLoading = false;
    });
  }

  Future<void> _loadUserAccess() async {
    try {
      final userAccess = await _userAccessService.getUserAccess();
      setState(() {
        _userAccess = userAccess;
      });
    } catch (e) {
      print('Error loading user access: $e');
    }
  }



  String _formatDate(int timestamp) {
    if (timestamp == 0) return 'Not set';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd MMM yyyy HH:mm').format(date);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'CLOSED':
        return Colors.green.shade700;
      case 'OVERDUE':
        return Colors.red.shade700;
      case 'REJECTED':
        return Colors.red.shade700;
      case 'REJECT':
        return Colors.red.shade700;

      case 'APPROVED':
        return Colors.amber.shade700;

      case 'OPEN':
        return Colors.lightBlue.shade600;

      case 'PAID':
        return Colors.green.shade700;

      case 'APPROVE':
        return Colors.green.shade700;

      default:
        return Colors.grey.shade500;
    }
  }

  Widget _buildSectionToggle(String title, bool isExpanded, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Icon(
        isExpanded ? Icons.expand_less : Icons.expand_more,
      ),
      onTap: onTap,
    );
  }


  Widget _buildHeaderSection() {

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Row(
                 children: [
                   const Icon(Icons.description, color: Colors.blue,size: 50,),
                   SizedBox(width: 20,),
                   Text(
                     '${_document!.header.docNo}',
                     style: const TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.bold,
                     ),
                   )
                 ],
               ),
                const SizedBox(height: 8),
                Chip(
                  backgroundColor: _getStatusColor(_document!.header.status),
                  label: Text(
                    _document!.header.status,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('Created by', _document!.header.creatorName),
            _buildInfoRow('Payer', _document!.header.payerName),
            _buildInfoRow('Created on', _formatDate(_document!.header.createdDate)),
            _buildInfoRow('Total Amount', 'Rp ${NumberFormat.decimalPattern('id').format(_document!.header.allTotal)}'),
            _buildInfoRow('Jenis Bunga', 'Bunga Anuitas'),
            _buildInfoRow('Bunga', _document!.header.bunga.toString()+"%"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection() {
    if (_document!.payments.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildSectionToggle(
            'Payment Information',
            _showPayments,
                () => setState(() => _showPayments = !_showPayments),
          ),
          if (_showPayments) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: _document!.payments.map(_buildPaymentItem).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentItem(Payment payment) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.payment, size: 20, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'Payment #${payment.id.id}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Chip(
                backgroundColor: _getStatusColor(payment.status),
                label: Text(
                  payment.status,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Amount', 'Rp ${NumberFormat.decimalPattern('id').format(payment.total)}'),
          _buildInfoRow('Due Date', _formatDate(payment.maxPaymentDate)),
          if (payment.paymentDate != null)
            _buildInfoRow('Paid Date', _formatDate(payment.paymentDate!)),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildSectionToggle(
            'Transaction Details',
            _showDetails,
                () => setState(() => _showDetails = !_showDetails),
          ),
          if (_showDetails) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: _document!.details.isEmpty
                  ? const Text('No details available')
                  : Column(
                children: _document!.details.map(_buildDetailItem).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailItem(Detail detail) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Item #${detail.id.id}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(detail.text),
          const SizedBox(height: 8),
          Text(
            'Subtotal: Rp ${NumberFormat.decimalPattern('id').format(detail.subTotal)}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkflowTimeline() {
    if (_document!.workflows.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildSectionToggle(
            'Approval Workflow',
            _showWorkflow,
                () => setState(() => _showWorkflow = !_showWorkflow),
          ),
          if (_showWorkflow) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: _buildTimelineSteps(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildTimelineSteps() {
    final steps = <Widget>[];
    final workflows = _document!.workflows;

    for (int i = 0; i < workflows.length; i++) {
      final wf = workflows[i];
      final isLast = i == workflows.length - 1;
      final hasExtraContent = wf.action != null || wf.actionDate != null || wf.reason != null;

      steps.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getStatusColor(wf.action ?? 'PENDING'),
                  ),
                  child: Icon(
                    _getWorkflowIcon(wf),
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: hasExtraContent ? 170 : 40,
                    color: Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        wf.assignedAction,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      wf.id.pararel>0?
                      Text(
                        " ${wf.id.id} (GROUP)",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ):Text(
                        " ${wf.id.id}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Assigned to: ${wf.assignedName}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  if (wf.action != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Status: ${wf.action}',
                      style: TextStyle(
                        color: _getStatusColor(wf.action!),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (wf.actionDate != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Completed: ${_formatDate(wf.actionDate!)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                  if (wf.reason != null) ...[
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reason:',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Container(
                          margin:  const EdgeInsets.only(left: 10),
                          child: Text(
                            '${wf.reason}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                      ],
                    )
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return steps;
  }

  IconData _getWorkflowIcon(Workflow wf) {
    switch (wf.assignedAction.toUpperCase()) {
      case 'APPROVAL':
        return Icons.check_circle;
      case 'REVIEW':
        return Icons.visibility;
      case 'VERIFICATION':
        return Icons.verified;
      case 'PAYMENT':
        return Icons.payment;
      default:
        return Icons.assignment;
    }
  }


  Widget _buildActionButtons() {
    if (widget.showAction != 1 || _userAccess == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (_userAccess!.approve == 1)
                _buildActionButton(
                  icon: Icons.check_circle,
                  color: Colors.green,
                  label: 'Approve',
                  onPressed: () => _showApproveDialog(),
                ),
              if (_userAccess!.reject == 1)
                _buildActionButton(
                  icon: Icons.cancel,
                  color: Colors.red,
                  label: 'Reject',
                  onPressed: () => _showRejectDialog(),
                ),
              if (_userAccess!.pay == 1)
                _buildActionButton(
                  icon: Icons.payment,
                  color: Colors.blue,
                  label: 'Payment',
                  onPressed: () => _processPayment(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: 28),
          color: color,
          onPressed: onPressed,
        ),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }

  Future<void> _showApproveDialog() async {
    final reason = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildReasonInputSheet('Approve Document'),
    );

    if (reason != null && reason.isNotEmpty) {
      final result = await _approveService.approveDocument(
        docNo: widget.docNo,
        reason: reason,
      );

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
        _loadDocument();
      }
    }
  }

  Future<void> _showRejectDialog() async {
    final reason = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildReasonInputSheet('Reject Document'),
    );

    if (reason != null && reason.isNotEmpty) {
      final result = await _rejectService.rejectDocument(
        docNo: widget.docNo,
        reason: reason,
      );

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
        _loadDocument();
      }
    }
  }

  Future<void> _processPayment() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Payment'),
        content: const Text('Are you sure you want to process this payment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await _paymentService.processPayment(widget.docNo);
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
        _loadDocument();
      }
    }
  }

  Widget _buildReasonInputSheet(String title) {
    final controller = TextEditingController();
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Reason',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.green, width: 1)),
                focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.green, width: 1)),
                errorBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.green, width: 1)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.green, width: 1)),

              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: const Text('Submit',style: TextStyle(color: Colors.green),),
              ),
            ),
          ],
        ),
      ),
    );
  }


    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Document'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _document == null
          ? const Center(child: Text('Document not found'))
          : RefreshIndicator(
        onRefresh: _loadDocument,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeaderSection(),
              _buildActionButtons(),
              _buildDetailsSection(),
              _buildPaymentSection(),
              _buildWorkflowTimeline(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

