import 'package:api_integration_with_crud/model/todo_model.dart';
import 'package:api_integration_with_crud/services/remote_service.dart';
import 'package:api_integration_with_crud/utils/helper_methods.dart';
import 'package:flutter/material.dart';

class SearchScreenByDate extends StatefulWidget {
  const SearchScreenByDate({super.key});

  @override
  _SearchScreenByDateState createState() => _SearchScreenByDateState();
}

class _SearchScreenByDateState extends State<SearchScreenByDate> {
  DateTime? startDate;
  DateTime? endDate;
  List<TODO>? todos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search by Date',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Date Range:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                _selectDateRange(context);
              },
              child: Text(
                startDate == null || endDate == null
                    ? 'Select Date Range'
                    : 'Selected Range: ${Utils.formatDate(startDate!)} - ${Utils.formatDate(endDate!)}',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _searchByDate();
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            if (todos != null)
              Expanded(
                child: ListView.builder(
                  itemCount: todos!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(todos![index].todoName),
                        subtitle: Text('ID: ${todos![index].id}'),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: DateTimeRange(
        start: startDate ?? DateTime.now(),
        end: endDate ?? DateTime.now(),
      ),
    );

    if (pickedDateRange != null) {
      setState(() {
        startDate = pickedDateRange.start;
        endDate = pickedDateRange.end;
      });
    }
  }

  void _searchByDate() async {
    final remoteService = RemoteService();
    final DateTime? sD = startDate;
    final DateTime? eD = endDate;

    try {
      final Map<String, dynamic> result =
          await remoteService.getTodosByDateRange(sD, eD);

      debugPrint('Todos found: $result');

      if (result['code'] == 200) {
        List<TODO> filteredTodos = (result['data'] as List)
            .map((todo) => TODO.fromJson(todo))
            .toList();

        setState(() {
          todos = filteredTodos;
        });
      } else {
        debugPrint('Error: ${result['message']}');
      }
    } catch (error) {
      debugPrint('An error occurred: $error');
    }
  }
}
