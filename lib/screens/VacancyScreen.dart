import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VacancyScreen extends StatefulWidget {
  static const routeName = 'vacancies';
  @override
  _VacancyState createState() => _VacancyState();
}

class Vacancy {
  late final String name;
  late final String description;

  Vacancy({required this.name, required this.description});

  // Convert Vacancy object to a JSON representation
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }

  // Create a Vacancy object from a JSON map
  factory Vacancy.fromJson(Map<String, dynamic> json) {
    return Vacancy(
      name: json['name'],
      description: json['description'],
    );
  }
}

class _VacancyState extends State<VacancyScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  List<Vacancy> items = [];

  Future<void> saveVacanciesToSharedPreferences(List<Vacancy> vacancies) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encodedVacancies = vacancies.map((v) => json.encode(v.toJson())).toList();
    await prefs.setStringList('vacancies', encodedVacancies);
  }

  Future<List<Vacancy>> loadVacanciesFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedVacancies = prefs.getStringList('vacancies') ?? [];
    return encodedVacancies.map((v) => Vacancy.fromJson(json.decode(v))).toList();
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('vacancies')) {
      // Load the list of Vacancy objects from SharedPreferences
      items = await loadVacanciesFromSharedPreferences();
    } else {
      final response = await http.get(Uri.parse('https://dlg.kz/career/'));
      if (response.statusCode == 200) {
        var document = parse(response.body);
        for (var element in document.querySelectorAll('.card')) {
          if(element.querySelector('h2.t-1')?.text != null) {
            setState(() {
              items.add(Vacancy(name: element.querySelector('h2.t-1')!.text, description: element.querySelector('h2.t-1')!.text));
            });
          }
        }

        await saveVacanciesToSharedPreferences(items);
      } else {
        print('Failed to fetch data');
      }
    }


  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _key,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(126, 184, 39, 1.0),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back navigation here
              Navigator.pop(context);
            },
          ),
          title: Text('Вакансии'),
        ),
        body: FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator(); // Loading indicator
              }

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index].name),
                    subtitle: Text('Description: ${items[index].name}'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Handle the tap action, e.g., navigate to vacancy details
                    },
                  );
                },
              );
            }
        ),
      )
    );
  }
  
}
