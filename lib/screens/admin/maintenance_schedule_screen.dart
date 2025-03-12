import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MaintenanceScheduleScreen extends StatefulWidget {
  const MaintenanceScheduleScreen({super.key});

  @override
  State<MaintenanceScheduleScreen> createState() => _MaintenanceScheduleScreenState();
}

class _MaintenanceScheduleScreenState extends State<MaintenanceScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  
  // Exemple de données de maintenance
  final Map<DateTime, List<Map<String, dynamic>>> _events = {
    DateTime.now(): [
      {
        'title': 'Maintenance ascenseur',
        'building': 'Résidence Bellevue',
        'technician': 'Jean Dupont',
        'status': 'Planifié',
      },
      {
        'title': 'Inspection piscine',
        'building': 'Résidence Les Oliviers',
        'technician': 'Marie Laurent',
        'status': 'Planifié',
      },
    ],
    DateTime.now().add(const Duration(days: 2)): [
      {
        'title': 'Maintenance porte garage',
        'building': 'Résidence La Perle',
        'technician': 'Marc Petit',
        'status': 'Planifié',
      },
    ],
    DateTime.now().add(const Duration(days: 5)): [
      {
        'title': 'Vérification escalier secours',
        'building': 'Résidence Bellevue',
        'technician': 'Jean Dupont',
        'status': 'Planifié',
      },
    ],
  };

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              eventLoader: _getEventsForDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                markerDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedDay == null 
                ? 'Maintenance planifiée aujourd\'hui' 
                : 'Maintenance planifiée le ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _selectedDay == null || _getEventsForDay(_selectedDay!).isEmpty
                ? Center(
                    child: Text(
                      'Aucune maintenance planifiée pour cette date',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : ListView.builder(
                    itemCount: _getEventsForDay(_selectedDay!).length,
                    itemBuilder: (context, index) {
                      final event = _getEventsForDay(_selectedDay!)[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(Icons.calendar_today, color: Colors.blue),
                          title: Text(event['title']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Bâtiment: ${event['building']}'),
                              Text('Technicien: ${event['technician']}'),
                            ],
                          ),
                          trailing: Chip(
                            label: Text(
                              event['status'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                          isThreeLine: true,
                          onTap: () {
                            // Naviguer vers les détails de la maintenance
                          },
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Naviguer vers l'écran de planification de maintenance
              },
              child: const Text('Planifier une maintenance'),
            ),
          ),
        ],
      ),
    );
  }
}

