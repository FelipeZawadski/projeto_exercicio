

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/ponto_remoto.dart';

class FiltroPage extends StatefulWidget{
  static const ROUTE_NAME = '/filtro';
  static const CAMPO_ORDENACAO = 'campoOrdenacao';

  @override
  _FiltroPageState createState() => _FiltroPageState();
}

class _FiltroPageState extends State<FiltroPage>{

  final _campoParaOrdenacao = {
    PontoRemoto.CAMPO_ID : 'Código', PontoRemoto.DATA : 'Data', PontoRemoto.LONGITUDE : 'Longitude', PontoRemoto.LATITUDE : 'Latitude',
  };

  late final SharedPreferences pref;
  String campoOrdenacao = PontoRemoto.CAMPO_ID;
  bool _alteracaoValores = false;

  @override
  void initState(){
    super.initState();
    _carregarSharedPreferences();
  }

  Widget build(BuildContext context){
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(title: Text('Filtro e Ordenação'),
        ),
        body: _criarBody(),
      ),
      onWillPop: _onClickVoltar,
    );
  }

  Widget _criarBody(){
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top: 10),
          child: Text('Campo para Ordenação'),
        ),
        for(final campo in _campoParaOrdenacao.keys)
          Row(
            children: [
              Radio(
                value: campo,
                groupValue: campoOrdenacao,
                onChanged: _onCampoOrdenacaoChange,
              ),
              Text(_campoParaOrdenacao[campo] ?? ''),
            ],
          ),
      ],
    );
  }

  Future<bool> _onClickVoltar() async {
    Navigator.of(context).pop(_alteracaoValores);
    return true;
  }

  void _carregarSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    pref = prefs;
    setState(() {
      campoOrdenacao = pref.getString(FiltroPage.CAMPO_ORDENACAO) ?? PontoRemoto.CAMPO_ID;
    });
  }

  void _onCampoOrdenacaoChange(String? valor){
    pref.setString(FiltroPage.CAMPO_ORDENACAO, valor ?? '');
    _alteracaoValores = true;
    setState(() {
      campoOrdenacao = valor ?? '';
    });
  }

}