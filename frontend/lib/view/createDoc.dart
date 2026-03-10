import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:apppeminjaman/model/CreateDocRequest.dart';
import 'package:apppeminjaman/model/CountPayment.dart';
import 'package:apppeminjaman/model/UserData.dart';
import 'package:apppeminjaman/model/Assign.dart';
import 'package:apppeminjaman/model/DetailItem.dart';
import 'package:apppeminjaman/service/CountPaymentService.dart';
import 'package:apppeminjaman/service/CreateDocService.dart';
import 'package:apppeminjaman/service/UserService.dart';

class CreateDoc extends StatefulWidget {
  final UserData userData;
  const CreateDoc({super.key, required this.userData});

  @override
  State<CreateDoc> createState() => _CreateDocState();
}

class _CreateDocState extends State<CreateDoc> {
  final _formKey = GlobalKey<FormState>();
  final CreateDocService _createDocService = CreateDocService();
  final CountPaymentService _countPaymentService = CountPaymentService();
  final UserService _userService = UserService();

  String? _payerName;
  final List<TextEditingController> _detailTextControllers = [];
  final List<TextEditingController> _detailSubtotalControllers = [];
  DateTime? _startDate;
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _interestController = TextEditingController();
  List<CountPayment> _payments = [];
  final List<List<Assign>> _assignments = [[]];

  List<UserData> _allUsers = [];
  bool _isLoadingUsers = false;
  bool _isCalculating = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _addDetailRow();
    _loadAllUsers();
  }

  @override
  void dispose() {
    for (var controller in _detailTextControllers) {
      controller.dispose();
    }
    for (var controller in _detailSubtotalControllers) {
      controller.dispose();
    }
    _durationController.dispose();
    _interestController.dispose();
    super.dispose();
  }

  Future<void> _loadAllUsers() async {
    setState(() => _isLoadingUsers = true);
    try {
      final users = await _userService.getAllUsers();
      setState(() {
        _allUsers = users ?? [];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat pengguna: $e')),
      );
    } finally {
      setState(() => _isLoadingUsers = false);
    }
  }

  void _addDetailRow() {
    setState(() {
      _detailTextControllers.add(TextEditingController());
      _detailSubtotalControllers.add(TextEditingController());
    });
  }

  void _removeDetailRow(int index) {
    if (_detailTextControllers.length > 1) {
      setState(() {
        _detailTextControllers.removeAt(index).dispose();
        _detailSubtotalControllers.removeAt(index).dispose();
      });
    }
  }

  void _addAssignmentBox() {
    setState(() {
      _assignments.add([]);
    });
  }

  void _removeAssignmentBox(int index) {
    if (_assignments.length > 1) {
      setState(() {
        _assignments.removeAt(index);
      });
    }
  }

  void _addUserToBox(int boxIndex, String userName) {
    setState(() {
      bool alreadyExists = _assignments[boxIndex].any((assign) => assign.assignnedName == userName);

      if (!alreadyExists) {
        int parallel = _assignments[boxIndex].length;
        _assignments[boxIndex].add(Assign(
          index: boxIndex + 1,
          pararel: parallel,
          assignnedName: userName,
          action: 'APPROVE',
        ));
      }
    });
  }

  void _removeUserFromBox(int boxIndex, int userIndex) {
    setState(() {
      _assignments[boxIndex].removeAt(userIndex);
      for (int i = 0; i < _assignments[boxIndex].length; i++) {
        _assignments[boxIndex][i] = _assignments[boxIndex][i].copyWith(pararel: i);
      }
    });
  }

  Future<void> _showDetailDialog(int index) async {
    final controller1 = TextEditingController(text: _detailTextControllers[index].text);
    final controller2 = TextEditingController(text: _detailSubtotalControllers[index].text);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Peminjaman ${index + 1}', style: TextStyle(color: Colors.green[800])),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              maxLength: 45,
              controller: controller1,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                filled: true,
                fillColor: Colors.green[50],
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
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller2,
              decoration: InputDecoration(
                labelText: 'Jumlah',
                labelStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                prefixText: 'Rp ',
                filled: true,
                fillColor: Colors.green[50],
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
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.green[800])),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _detailTextControllers[index].text = controller1.text;
                _detailSubtotalControllers[index].text = controller2.text;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _calculatePayments() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap pilih tanggal mulai')),
      );
      return;
    }

    if (_durationController.text.isEmpty || _interestController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap isi durasi dan bunga')),
      );
      return;
    }

    int total = 0;
    for (int i = 0; i < _detailSubtotalControllers.length; i++) {
      final subtotal = int.tryParse(_detailSubtotalControllers[i].text) ?? 0;
      total += subtotal;
    }

    if (total == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap masukkan jumlah detail yang valid')),
      );
      return;
    }

    setState(() => _isCalculating = true);
    try {
      final dateFormat = DateFormat('dd/MM/yyyy');
      final startDateStr = dateFormat.format(_startDate!);

      final payments = await _countPaymentService.countPayment(
        total: total.toString(),
        startDate: startDateStr,
        durasiBulan: _durationController.text,
        bunga: _interestController.text,
      );

      if (payments != null) {
        setState(() => _payments = payments);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghitung pembayaran: $e')),
      );
    } finally {
      setState(() => _isCalculating = false);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_payerName == null || _payerName!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap pilih pembayar')),
      );
      return;
    }

    if (_payments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap hitung pembayaran terlebih dahulu')),
      );
      return;
    }

    for (int i = 0; i < _detailTextControllers.length; i++) {
      if (_detailTextControllers[i].text.isEmpty ||
          _detailSubtotalControllers[i].text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Harap isi semua detail')),
        );
        return;
      }
    }

    bool hasAssignments = false;
    for (var box in _assignments) {
      if (box.isNotEmpty) {
        hasAssignments = true;
        break;
      }
    }
    if (!hasAssignments) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap tambahkan setidaknya satu penandatangan')),
      );
      return;
    }

    final detailItems = <DetailItem>[];
    for (int i = 0; i < _detailTextControllers.length; i++) {
      detailItems.add(DetailItem(
        text: _detailTextControllers[i].text,
        subtotal: int.parse(_detailSubtotalControllers[i].text),
      ));
    }

    final allAssignments = <Assign>[];
    for (var box in _assignments) {
      allAssignments.addAll(box);
    }

    final request = CreateDocRequest(
      creatorName: widget.userData.userName,
      payerName: _payerName!,
      bunga: int.parse(_interestController.text.toString()),
      detail: detailItems,
      payment: _payments,
      assign: allAssignments,
    );

    setState(() => _isSubmitting = true);
    try {
      final docNo = await _createDocService.createDoc(request);
      if (docNo != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dokumen berhasil dibuat: $docNo')),
        );
        Navigator.pop(context, docNo);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat dokumen')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error membuat dokumen: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat Dokumen Baru', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[800],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.green[50],
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.green, width: 1),
                  ),
                  child: ListTile(
                    title: Text('Pembuat', style: TextStyle(color: Colors.green[800])),
                    subtitle: Text(widget.userData.userName, style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: 16),

                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.green, width: 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Pembayar',
                        labelStyle: TextStyle(color: Colors.green[800]),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                        filled: true,
                        fillColor: Colors.green[50],
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
                      value: _payerName,
                      items: _allUsers
                          .map((user) => DropdownMenuItem(
                        value: user.userName,
                        child: Text(user.userName),
                      ))
                          .toList(),
                      onChanged: (value) => setState(() => _payerName = value),
                      validator: (value) =>
                      value == null ? 'Harap pilih pembayar' : null,
                    ),
                  ),
                ),
                SizedBox(height: 24),

                Text('Detail Peminjaman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800])),
                SizedBox(height: 8),
                ..._buildDetailRows(),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _addDetailRow,
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text('Tambah', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                Text('Perhitungan Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800])),
                SizedBox(height: 8),
                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.green, width: 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 140,
                              child: TextFormField(
                                controller: _durationController,
                                decoration: InputDecoration(
                                  labelText: 'Durasi (bulan)',
                                  labelStyle: TextStyle(color: Colors.green[800]),
                                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                                  filled: true,
                                  fillColor: Colors.green[50],
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
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _interestController,
                                decoration: InputDecoration(
                                  labelText: 'Bunga Anuitas (%)',
                                  labelStyle: TextStyle(color: Colors.green[800]),
                                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                                  filled: true,
                                  fillColor: Colors.green[50],
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
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        ListTile(
                          title: Text(_startDate == null
                              ? 'Pilih Tanggal Mulai'
                              : 'Tanggal Mulai: ${DateFormat('dd/MM/yyyy').format(_startDate!)}'),
                          trailing: Icon(Icons.calendar_today, color: Colors.green),
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                      primaryColor: Colors.teal[700],
                                      hintColor: Colors.green,
                                      colorScheme: ColorScheme.light(
                                        primary: Colors.green,
                                        onPrimary: Colors.white,
                                        surface: Colors.white,
                                      ),
                                      dialogBackgroundColor: Colors.white
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedDate != null) {
                              setState(() => _startDate = pickedDate);
                            }
                          },
                        ),
                        SizedBox(height: 16),

                        if (_payments.isEmpty)
                          Text('Belum ada perhitungan pembayaran', style: TextStyle(color: Colors.grey)),
                        if (_payments.isNotEmpty) _buildPaymentsTable(),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _isCalculating ? null : _calculatePayments,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isCalculating
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text('Hitung Pembayaran', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                Text('Penandatangan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800])),
                SizedBox(height: 8),
                ..._buildAssignmentBoxes(),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _addAssignmentBox,
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text('Tambah Kotak Persetujuan', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32),

                Center(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSubmitting
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Buat Dokumen', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDetailRows() {
    return List.generate(_detailTextControllers.length, (index) {
      return Card(
        color: Colors.white,
        elevation: 2,
        margin: EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.green, width: 1),
        ),
        child: ListTile(
          title: Text(_detailTextControllers[index].text.isEmpty
              ? 'Detail Peminjaman ${index + 1}'
              : _detailTextControllers[index].text,
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: _detailSubtotalControllers[index].text.isEmpty
              ? null
              : Text(NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
              .format(int.tryParse(_detailSubtotalControllers[index].text) ?? 0)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.green),
                onPressed: () => _showDetailDialog(index),
              ),
              if (_detailTextControllers.length > 1)
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeDetailRow(index),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPaymentsTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Jadwal Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800])),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Table(
            columnWidths: const {
              0: FixedColumnWidth(40),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
            },
            border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.green[300]!),
            ),
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.green[100]),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Jumlah', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Jatuh Tempo', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                ],
              ),
              ..._payments.asMap().entries.map((entry) {
                final index = entry.key;
                final payment = entry.value;
                return TableRow(
                  decoration: BoxDecoration(color: Colors.white),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('${index + 1}', textAlign: TextAlign.center, style: TextStyle(color: Colors.black)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                          .format(payment.total), textAlign: TextAlign.right, style: TextStyle(color: Colors.black)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(payment.maxPaymentDate, textAlign: TextAlign.center, style: TextStyle(color: Colors.black)),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAssignmentBoxes() {
    return List.generate(_assignments.length, (boxIndex) {
      return Card(
        color: Colors.white,
        elevation: 2,
        margin: EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.green, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kotak Persetujuan ${boxIndex + 1}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800])),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeAssignmentBox(boxIndex),
                  ),
                ],
              ),
              SizedBox(height: 8),
              if (_assignments[boxIndex].isNotEmpty)
                ..._assignments[boxIndex].map((assign) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Card(
                      color: Colors.green[50],
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        title: Text(assign.assignnedName, style: TextStyle(color: Colors.black)),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red[400]),
                          onPressed: () => _removeUserFromBox(boxIndex, _assignments[boxIndex].indexOf(assign)),
                        ),
                      ),
                    ),
                  );
                }),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Tambahkan Penandatangan',
                  labelStyle: TextStyle(color: Colors.green[800]),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                  filled: true,
                  fillColor: Colors.green[50],
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
                items: _allUsers
                    .map((user) => DropdownMenuItem(
                  value: user.userName,
                  child: Text(user.userName),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    _addUserToBox(boxIndex, value);
                  }
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}