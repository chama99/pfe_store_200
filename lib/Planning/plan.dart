import 'package:syncfusion_flutter_calendar/calendar.dart';

class Plan extends CalendarDataSource {
  Plan(List<Appointment> source) {
    appointments = source;
  }
}
