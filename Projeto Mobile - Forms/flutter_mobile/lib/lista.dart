import 'package:flutter/material.dart';
import 'package:flutter_mobile/cadastro.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'update.dart'; // Importe a tela de atualização

class Lista extends StatefulWidget {
  const Lista({super.key});

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  // Função para buscar itens da API
  Future<void> fetchItems() async {
    const url = 'http://localhost:8080/apiEvento/findall';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          items = data.map((item) => item as Map<String, dynamic>).toList();
        });
      } else {
        throw Exception('Erro ao carregar dados da API');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeItem(String id, int index) async {
    const url = 'http://localhost:8080/apiEvento/delete/';
    try {
      final response = await http.delete(Uri.parse('$url$id'));

      if (response.statusCode == 200) {
        setState(() {
          items.removeAt(index);
        });
      } else {
        throw Exception('Erro ao excluir o item');
      }
    } catch (e) {
      print(e);
    }
  }

  void showConfirmationDialog(String id, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Item'),
          content: const Text('Tem certeza de que deseja excluir este item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                removeItem(id, index);
              },
              child: const Text('Excluir'),
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
        title: const Text('Lista de Eventos'),
      ),
      body: Column(
        children: [
          // Verifica se a lista está vazia
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Não há itens cadastrados', style: TextStyle(fontSize: 18, color: Colors.grey)),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(item['nome']),
                        onTap: () {
                          // Navegar para a tela de atualização
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Update(item: item), // Passa o item selecionado
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => showConfirmationDialog(item['id'], index),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
          // Botão "Cadastrar" sempre na parte inferior
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Cadastro()),
                  );
                },
                child: const Text('Cadastrar'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
