import 'package:flutter/material.dart';
import 'user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// widget that displays a list of users
class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<User> users = []; // list hold fetch users
  int rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int sortColumnIndex = 0;
  bool sortAscending = true;
  String filterGender = '';
  String filterCardType = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // fetch user data
  void fetchUserData() async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/users?limit=100'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<User> fetchedUsers =
          (data['users'] as List).map((json) => User.fromJson(json)).toList();
      setState(() {
        users = fetchedUsers;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  //  sort the user list
  void sort<T>(Comparable<T> Function(User user) getField, int columnIndex,
      bool ascending) {
    users.sort((a, b) {
      if (!ascending) {
        final User c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Spacer(),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text('Filter by Gender'),
                        value: filterGender.isEmpty ? null : filterGender,
                        onChanged: (String? newValue) {
                          setState(() {
                            filterGender = newValue ?? '';
                          });
                        },
                        items: <String>['', 'male', 'female']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.isEmpty ? 'All' : value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text('Filter by Card Type'),
                        value: filterCardType.isEmpty ? null : filterCardType,
                        onChanged: (String? newValue) {
                          setState(() {
                            filterCardType = newValue ?? '';
                          });
                        },
                        items: <String>[
                          '',
                          'Elo',
                          'Korean Express',
                          'Mastercard',
                          'American Express',
                          'Diners Club International',
                          'JCB',
                          'Maestro',
                          'Visa',
                          'NPS',
                          'Discover'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.isEmpty ? 'All' : value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: PaginatedDataTable(
                  header: Text('Users'),
                  rowsPerPage: rowsPerPage,
                  onRowsPerPageChanged: (int? value) {
                    setState(() {
                      rowsPerPage =
                          value ?? PaginatedDataTable.defaultRowsPerPage;
                    });
                  },
                  sortColumnIndex: sortColumnIndex,
                  sortAscending: sortAscending,
                  columns: [
                    DataColumn(
                      label: Text('ID'),
                      numeric: true,
                      onSort: (int columnIndex, bool ascending) => sort<num>(
                          (User user) => user.id, columnIndex, ascending),
                    ),
                    DataColumn(
                      label: Text('First Name'),
                      onSort: (int columnIndex, bool ascending) => sort<String>(
                          (User user) => user.firstName,
                          columnIndex,
                          ascending),
                    ),
                    DataColumn(
                      label: Text('Last Name'),
                      onSort: (int columnIndex, bool ascending) => sort<String>(
                          (User user) => user.lastName, columnIndex, ascending),
                    ),
                    DataColumn(
                      label: Text('Age'),
                      numeric: true,
                      onSort: (int columnIndex, bool ascending) => sort<num>(
                          (User user) => user.age, columnIndex, ascending),
                    ),
                    DataColumn(label: Text('Gender')),
                    DataColumn(label: Text('Card Type')),
                    DataColumn(label: Text('Image')),
                  ],
                  source: UserDataSource(users, filterGender, filterCardType),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDataSource extends DataTableSource {
  final List<User> users;
  final String filterGender;
  final String filterCardType;

  UserDataSource(this.users, this.filterGender, this.filterCardType);

  @override
  DataRow getRow(int index) {
    final user = users.where((user) {
      final matchesGender = filterGender.isEmpty || user.gender == filterGender;
      final matchesCardType =
          filterCardType.isEmpty || user.cardType == filterCardType;
      return matchesGender && matchesCardType;
    }).toList()[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text('${user.id}')),
        DataCell(Text(user.firstName)),
        DataCell(Text(user.lastName)),
        DataCell(Text('${user.age}')),
        DataCell(Text(user.gender)),
        DataCell(Text(user.cardType)),
        DataCell(Image.network(user.image, width: 50, height: 50)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users
      .where((user) {
        final matchesGender =
            filterGender.isEmpty || user.gender == filterGender;
        final matchesCardType =
            filterCardType.isEmpty || user.cardType == filterCardType;
        return matchesGender && matchesCardType;
      })
      .toList()
      .length;

  @override
  int get selectedRowCount => 0;
}
