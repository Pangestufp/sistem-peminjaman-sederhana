import 'package:apppeminjaman/authentification/AuthStateManager.dart';
import 'package:apppeminjaman/authentification/AuthService.dart';

import 'package:apppeminjaman/authentification/AuthService.dart';
import 'package:apppeminjaman/authentification/AuthStateManager.dart';
import 'package:apppeminjaman/view/createDoc.dart';
import 'package:flutter/material.dart';
import 'package:apppeminjaman/model/transactionData.dart';
import 'package:apppeminjaman/service/AllUserDocumentsService.dart';
import 'package:apppeminjaman/view/DocumentDetailPage.dart';
import 'package:apppeminjaman/service/UserService.dart';
import 'package:apppeminjaman/model/UserData.dart';
import 'package:apppeminjaman/service/WorkflowService.dart';
import 'package:apppeminjaman/model/Workflow.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  UserData? _userData;
  List<Workflow> _workflows = [];
  List<TransactionData> _createdDocs = [];
  List<TransactionData> _loadDocs = [];
  bool _isLoading = true;
  late TabController _tabController;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final userService = UserService();
    final workflowService = WorkflowService();
    final allDocsService = AllUserDocumentsService();

    final user = await userService.getUserData();
    final workflows = await workflowService.getAssignedWorkflows();
    final createdDocs = await allDocsService.getAllUserDocuments();
    final loanDocs=await allDocsService.getAllUserLoanDocuments();

    setState(() {
      _userData = user;
      _workflows = workflows;
      _createdDocs = createdDocs;
      _loadDocs = loanDocs;
      _isLoading = false;
    });
  }




  Widget _buildUserInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.green[400]!, Colors.green[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.person, color: Colors.white, size: 30),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userData!.userName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: ${_userData!.idUser}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _userData!.status == 1
                              ? Colors.green[100]
                              : Colors.orange[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _userData!.status == 1? "Online":"Offline",
                          style: TextStyle(
                            color: _userData!.status == 1
                                ? Colors.green[800]
                                : Colors.orange[800],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _userData!.role,
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowItem(Workflow wf) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DocumentDetailPage(docNo: wf.id.docNo,showAction: 1,),
            ),
          ).then((_) {
            _loadData();
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.assignment_turned_in,
                  color: Colors.green[800],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wf.id.docNo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Assigned to: ${wf.assignedName}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Chip(
                          backgroundColor: _getStatusColor(wf.action ?? 'PENDING'),
                          label: Text(
                            wf.action ?? 'PENDING',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Action: ${wf.assignedAction}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreatedDocItem(TransactionData doc) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DocumentDetailPage(docNo: doc.header.docNo, showAction: doc.header.status=="CLOSED"&&_userData!.role=="ADMIN"?1:0,),
            ),
          ).then((_) {
            _loadData();
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.description,
                  color: Colors.blue[800],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.header.docNo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      backgroundColor: _getStatusColor(doc.header.status ?? 'PENDING'),
                      label: Text(
                        doc.header.status ?? 'PENDING',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'CLOSED':
        return Colors.green.shade700;

      case 'REJECTED':
        return Colors.red.shade700;

      case 'APPROVED':
        return Colors.amber.shade700;

      case 'OPEN':
        return Colors.lightBlue.shade600;

      default:
        return Colors.grey.shade500;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_userData == null) {
      return const Scaffold(
        body: Center(
          child: Text('Failed to load user data'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white
          ),
          tabs: const [
            Tab(text: 'Job List'),
            Tab(text: 'My Documents'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildUserInfoCard(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _workflows.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No assigned workflows',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
                    : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    itemCount: _workflows.length,
                    itemBuilder: (context, index) {
                      return _buildWorkflowItem(_workflows[index]);
                    },
                  ),
                ),
                _userData!.role=="ADMIN"?(
                _createdDocs.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder_open_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No documents created yet',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
                    : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    itemCount: _createdDocs.length,
                    itemBuilder: (context, index) {
                      return _buildCreatedDocItem(_createdDocs[index]);
                    },
                  ),
                )
                )

    :
                (
                    _loadDocs.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No documents loaned yet',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                        : RefreshIndicator(
                      onRefresh: _loadData,
                      child: ListView.builder(
                        itemCount: _loadDocs.length,
                        itemBuilder: (context, index) {
                          return _buildCreatedDocItem(_loadDocs[index]);
                        },
                      ),
                    )
                )

              ],
            ),
          ),
        ],
      ),

        floatingActionButton: _userData!.role.trim()=="ADMIN"?FloatingActionButton(
            onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateDoc(userData: _userData!,),
            ),
          ).then((_) {
            _loadData();
          });
        },
          backgroundColor: Colors.green,
          child: Icon(Icons.add, color: Colors.white,),
        ):null,
        


        drawer: Drawer(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.green[700],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _userData!.userName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _userData!.role,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[100],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: Icon(Icons.home, color: Colors.green[700]),
                      title: const Text('Pengajuan Pinjaman'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings, color: Colors.green[700]),
                      title: const Text('Settings'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.help_outline, color: Colors.green[700]),
                      title: const Text('Help & Feedback'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      try {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                        await _authService.deleteToken();
                        AuthStateManager.signOut();
                        SystemNavigator.pop();
                      } catch (e) {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Logout failed: $e')),
                        );
                      }
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Log Out",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )

    );
  }
}