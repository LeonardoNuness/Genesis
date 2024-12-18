import 'package:flutter/material.dart';
import 'package:flutter_mobile/lista.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http;

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _idController = TextEditingController();
  final _nomeController = TextEditingController();
  final _dataController = TextEditingController();
  final _horaController = TextEditingController();
  final _palestranteController = TextEditingController();
  final _maxAlunosController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _idController.dispose();
    _nomeController.dispose();
    _dataController.dispose();
    _horaController.dispose();
    _palestranteController.dispose();
    _maxAlunosController.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (_formKey.currentState!.validate()) {
      final id = _idController.text;
      final nome = _nomeController.text;
      final data = _dataController.text;
      final hora = _horaController.text;
      final palestrante = _palestranteController.text;
      final maxAlunos = _maxAlunosController.text;

      final url = 'http://localhost:8080/apiEvento/insert';
      final body = json.encode({
        'id': id,
        'nome': nome,
        'data': data,
        'hora': hora,
        'palestrante': palestrante,
        'maxAlunos': maxAlunos,
      });

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: body,
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cadastro realizado')),
          );
          Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Lista()),
                );
        } else {
          throw Exception('Erro ao cadastrar evento');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dataController.text = picked.toLocal().toString().split(' ')[0]; // format the date
      });
    }
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a data';
    }
    final date = DateTime.tryParse(value);
    if (date == null) {
      return 'Por favor, insira uma data válida';
    }
    return null;
  }

  String? _validateHora(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a hora';
    }
    final horaRegExp = RegExp(r'^(0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])$');
    if (!horaRegExp.hasMatch(value)) {
      return 'Por favor, insira uma hora válida no formato HH:mm';
    }
    return null;
  }

  String? _validateMaxAlunos(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o número máximo de alunos';
    }
    final maxAlunos = int.tryParse(value);
    if (maxAlunos == null || maxAlunos <= 0) {
      return 'Por favor, insira um número válido maior que 0';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dataController,
                decoration: const InputDecoration(
                  labelText: 'Data',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: _validateDate,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _horaController,
                decoration: const InputDecoration(
                  labelText: 'Hora',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
                validator: _validateHora,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _palestranteController,
                decoration: const InputDecoration(
                  labelText: 'Palestrante',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do palestrante';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _maxAlunosController,
                decoration: const InputDecoration(
                  labelText: 'Máximo de Alunos',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: _validateMaxAlunos,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _cadastrar,
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
