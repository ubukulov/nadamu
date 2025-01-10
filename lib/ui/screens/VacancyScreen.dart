import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:nadamu/ui/layouts/CommonLayout.dart';
import 'package:nadamu/ui/widgets/error_widget.dart';
import 'package:nadamu/ui/widgets/loading_widget.dart';
import 'package:nadamu/business/models/vacancy.dart';

class VacancyScreen extends StatefulWidget {
  static const routeName = 'vacancies';
  @override
  _VacancyState createState() => _VacancyState();
}

class _VacancyState extends State<VacancyScreen> {

  Future<List<Vacancy>> fetchData() async {
    List<Vacancy> items = [];
    final response = await http.get(Uri.parse('https://dlg.kz/career/'));
    if (response.statusCode == 200) {
      var document = parse(response.body);
      for (var element in document.querySelectorAll('.card')) {
        if(element.querySelector('h2.t-1')?.text != null) {
          items.add(Vacancy(name: element.querySelector('h2.t-1')!.text, description: element.querySelector('h2.t-1')!.text));
        }
      }
      return items;
    } else {
      throw Exception('Не удалось загрузить данные. Попробуйте позже');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonLayout(
      title: 'Вакансии',
      content: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingWidget();
            } else if(snapshot.hasError) {
              return ErrorsWidget(errorText: snapshot.error.toString());
            } else {
              final data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index].name),
                    subtitle: Text('Description: ${data[index].name}'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Handle the tap action, e.g., navigate to vacancy details
                    },
                  );
                },
              );
            }
          }
      ),
    );
  }
}