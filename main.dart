import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafeterias',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: CafeteriasList(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Cafeteria {
  final int id;
  final String nome;
  final String endereco;
  final String imagem;
  final String contato;

  Cafeteria({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.imagem,
    required this.contato,
  });

  factory Cafeteria.fromJson(Map<String, dynamic> json) {
    return Cafeteria(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
      imagem: json['imagem'],
      contato: json['contato'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'imagem': imagem,
      'contato': contato,
    };
  }
}

class CafeteriasList extends StatefulWidget {
  @override
  _CafeteriasListState createState() => _CafeteriasListState();
}

class _CafeteriasListState extends State<CafeteriasList> {
  final String apiUrl = 'http://192.168.10.12:8080/api/cafeterias';

  Future<List<Cafeteria>> fetchCafeterias() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Cafeteria.fromJson(data)).toList();
    } else {
      throw Exception('Falha ao carregar cafeterias');
    }
  }

  Future<void> addCafeteria(Cafeteria cafeteria) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cafeteria.toJson()),
    );

    if (response.statusCode == 201) {
      setState(() {
        futureCafeterias = fetchCafeterias();
      });
    } else {
      throw Exception('Falha ao adicionar cafeteria');
    }
  }

  Future<void> updateCafeteria(int id, Cafeteria cafeteria) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cafeteria.toJson()),
    );

    if (response.statusCode == 200) {
      setState(() {
        futureCafeterias = fetchCafeterias();
      });
    } else {
      throw Exception('Falha ao editar cafeteria');
    }
  }

  Future<void> deleteCafeteria(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 204) {
      setState(() {
        futureCafeterias = fetchCafeterias();
      });
    } else {
      throw Exception('Falha ao deletar cafeteria');
    }
  }

  late Future<List<Cafeteria>> futureCafeterias;

  @override
  void initState() {
    super.initState();
    futureCafeterias = fetchCafeterias();
  }

  void showCafeteriaForm([Cafeteria? cafeteria]) {
    final TextEditingController nomeController =
        TextEditingController(text: cafeteria?.nome ?? '');
    final TextEditingController enderecoController =
        TextEditingController(text: cafeteria?.endereco ?? '');
    final TextEditingController imagemController =
        TextEditingController(text: cafeteria?.imagem ?? '');
    final TextEditingController contatoController =
        TextEditingController(text: cafeteria?.contato ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(cafeteria == null ? 'Adicionar Cafeteria' : 'Editar Cafeteria'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: enderecoController,
                decoration: InputDecoration(labelText: 'Endereço'),
              ),
              TextField(
                controller: imagemController,
                decoration: InputDecoration(labelText: 'URL da Imagem'),
              ),
              TextField(
                controller: contatoController,
                decoration: InputDecoration(labelText: 'Contato'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final newCafeteria = Cafeteria(
                  id: cafeteria?.id ?? 0,
                  nome: nomeController.text,
                  endereco: enderecoController.text,
                  imagem: imagemController.text,
                  contato: contatoController.text,
                );

                if (cafeteria == null) {
                  addCafeteria(newCafeteria);
                } else {
                  updateCafeteria(cafeteria.id, newCafeteria);
                }

                Navigator.pop(context);
              },
              child: Text(cafeteria == null ? 'Adicionar' : 'Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cafeterias'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showCafeteriaForm();
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Cafeteria>>(
          future: futureCafeterias,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Cafeteria> cafeterias = snapshot.data!;
              return ListView.builder(
                itemCount: cafeterias.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: Container(
                        width: 100,
                        height: 100,
                        child: Image.network(
                          cafeterias[index].imagem,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(cafeterias[index].nome),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cafeterias[index].endereco),
                          SizedBox(height: 5),
                          Text(cafeterias[index].contato),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showCafeteriaForm(cafeterias[index]);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteCafeteria(cafeterias[index].id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
