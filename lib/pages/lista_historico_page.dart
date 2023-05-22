

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:projeto_exercicio/dao/ponto_remoto_dao.dart';
import 'package:projeto_exercicio/model/ponto_remoto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'filtro_page.dart';

class ListaHistoricoPage extends StatefulWidget{

  @override
  _ListaHistoricoPageState createState() => _ListaHistoricoPageState();
}

class _ListaHistoricoPageState extends State<ListaHistoricoPage> {

  static const ACAO_ABRIR_MAPA = 'abrirMapa';
  final _pontoRemoto = <PontoRemoto> [];
  final _controller = TextEditingController();
  var _carregando = false;
  final _dao = PontoRemotoDao();

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes dos Pontos Turisticos'),
      ) ,
      body: _criaBody(),
    );
  }

  Widget _criaBody(){
    return ListView.separated(
      itemBuilder: (BuildContext context, int index){
        final pontoRemoto = _pontoRemoto[index];

        return PopupMenuButton<String>(
          child: ListTile(
            title: Text('${pontoRemoto.id} - ${pontoRemoto.data}',
              style: TextStyle(
              ),
            ),
          ),
          itemBuilder: (BuildContext context) => criarItensMenuPopup(),
          onSelected: (String valorSelecionado){
            if (valorSelecionado == ACAO_ABRIR_MAPA){
              _controller.text = '${pontoRemoto.longitude}  ${pontoRemoto.latitude}';
              _abrirMapa();
            }
          },
        );
      },
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: _pontoRemoto.length
    );
  }

  List<PopupMenuEntry<String>> criarItensMenuPopup(){
    return [
      PopupMenuItem<String>(
          value: ACAO_ABRIR_MAPA,
          child: Row(
              children: [
                Icon (Icons.map, color: Colors.black),
                Padding(padding: EdgeInsets.only(left: 10),
                    child: Text('Editar')),
              ]
          ),
      ),
    ];
  }

  void _abrirMapa(){
    if(_controller.text.trim().isEmpty){
      return;
    }
    MapsLauncher.launchQuery(_controller.text);
  }

  void _atualizarLista() async {
    setState(() {
      _carregando = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final campoOrdenacao = prefs.getString(FiltroPage.CAMPO_ORDENACAO) ?? PontoRemoto.CAMPO_ID;

    final pontoRemoto = await _dao.listar(
      campoOrdenacao: campoOrdenacao,
    );

    setState(() {
      _pontoRemoto.clear();
      if (pontoRemoto.isNotEmpty) {
        _pontoRemoto.addAll(pontoRemoto);
      }
    });
    setState(() {
      _carregando = false;
    });
  }
}