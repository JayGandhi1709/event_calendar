import 'dart:convert';

import 'package:event_calendar/utils/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  Map<String, List> mySelectedEvents = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    loadEvents();
  }

  loadEvents() {
    mySelectedEvents = {
      "2023-09-25": [
        {
          "title": "Title 1",
          "note": "Note 1",
          "category": "Work",
        },
        {
          "title": "Title 2",
          "note": "Note 2",
          "category": "Personal",
        }
      ],
      "2023-09-26": [
        {
          "title": "Title 1",
          "note": "Note 1",
          "category": "Work",
        },
        {
          "title": "Title 2",
          "note": "Note 2",
          "category": "Personal",
        }
      ]
    };
  }

  List _listOfDayEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime!)]!;
    } else {
      return [];
    }
  }

  _showAddEventDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Add New Event'),
              centerTitle: false,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    if (_titleController.text.isNotEmpty ||
                        _noteController.text.isNotEmpty ||
                        _categoryController.text.isNotEmpty) {
                      if (mySelectedEvents[
                              DateFormat('yyyy-MM-dd').format(_selectedDay!)] !=
                          null) {
                        mySelectedEvents[
                                DateFormat('yyyy-MM-dd').format(_selectedDay!)]
                            ?.add(
                          {
                            "title": _titleController.text,
                            "note": _noteController.text,
                            "category": _categoryController.text,
                          },
                        );
                      } else {
                        mySelectedEvents[
                            DateFormat('yyyy-MM-dd').format(_selectedDay!)] = [
                          {
                            "title": _titleController.text,
                            "note": _noteController.text,
                            "category": _categoryController.text,
                          }
                        ];
                      }
                      setState(() {});
                      print(
                        "New Event for backend devloper ${json.encode(mySelectedEvents)}",
                      );
                      showSnackBar(context, 'New Event Added!');
                      Navigator.of(context).pop();
                      _titleController.clear();
                      _noteController.clear();
                      _categoryController.clear();
                    } else {
                      showSnackBar(
                          context, 'Please All Field Must Not Be Empty!');
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Title"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Note"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Categoty"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Calender"),
        centerTitle: true,
        elevation: 10,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2023),
            lastDay: DateTime(2090),
            calendarFormat: _calendarFormat,
            // On Other Day Select
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.

              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              return isSameDay(_selectedDay, day);
            },

            // For Calendar Format Chanage
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },

            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },

            // Event Load
            eventLoader: _listOfDayEvents,
          ),
          ..._listOfDayEvents(_selectedDay!).map((myEvents) {
            return ListTile(
              leading: const Icon(
                Icons.done,
                color: Colors.teal,
              ),
              title: Text("Title : ${myEvents['title']}"),
              subtitle: Text("Note : ${myEvents['note']}"),
            );
          })
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEventDialog(),
        icon: const Icon(Icons.add),
        label: const Text("Add Event"),
      ),
    );
  }
}
