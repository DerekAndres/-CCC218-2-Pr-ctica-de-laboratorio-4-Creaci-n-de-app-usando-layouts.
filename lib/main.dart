import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Noticias(),
    );
  }
}

class Noticias extends StatefulWidget {
  @override
  _NoticiasState createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {
  List Noticias = [];
  
  get index => null;
  @override
  void initState() {
    super.initState();
    fetchNoticias();
  }
  

Future<void> fetchNoticias() async { 
  
  final response = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=tesla&from=2024-04-19&sortBy=publishedAt&apiKey=4f8552913cdf433981c4c77ab136e558'),);
  if (response.statusCode == 200) {

   Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> fetchedNoticias = json['articles'];
      fetchedNoticias.sort((a, b) => a['title'].compareTo(b['title']));

      setState(() {
        Noticias = fetchedNoticias;
      });
    } else {
      print('No se pudo cargar los datos');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noticias'),
      ),
      body: Noticias.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: Noticias.length,
              itemBuilder: (context, index) {
                var noticia = Noticias[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(noticia['titulo'] ?? 'Inexistente'),
                    subtitle: Text(
                      'Descripción: ${noticia['descripcion'] ?? 'No disponible'}\nFuente: ${noticia['fuente']['nombre'] ?? 'Desconocida'}',
                    ),
                       leading: noticia!['urlToImage'] != null ? Image.network(noticia!['urlToImage'],
                      width: 50,
                      height: 50,
                    )
                  : null,
                  ),
                );
              },
            ),
    );
  }}

  
 
