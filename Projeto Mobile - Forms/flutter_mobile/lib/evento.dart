import 'package:flutter/material.dart';

class Evento {
  String _id = '';
  String _nome = '';
  String _data = '';
  String _hora = '';
  String _palestrante = '';
  int _maxAlunos = 0;

  String get id => _id;
  set id(String value) => _id = value;

  String get nome => _nome;
  set nome(String value) => _nome = value;

  String get data => _data;
  set data(String value) => _data = value;

  String get hora => _hora;
  set hora(String value) => _hora = value;

  String get palestrante => _palestrante;
  set palestrante(String value) => _palestrante = value;

  int get maxAlunos => _maxAlunos;
  set maxAlunos(int value) => _maxAlunos = value;
}

