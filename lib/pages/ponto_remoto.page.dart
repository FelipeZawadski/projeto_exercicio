

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projeto_exercicio/dao/ponto_remoto_dao.dart';
import 'package:projeto_exercicio/model/ponto_remoto.dart';

import 'filtro_page.dart';
import 'lista_historico_page.dart';

class ListaPontoRemotoPage extends StatefulWidget{
  @override
  _ListaPontoRemotoPageState createState() => _ListaPontoRemotoPageState();
}

class _ListaPontoRemotoPageState extends State<ListaPontoRemotoPage>{

  final _pontoRemoto = <PontoRemoto> [];
  late final Position? _localizacaoAtual;
  late final PontoRemotoDao _pontoDao;
  var data;
  var _carregando = false;

  @override
  void initState(){
    super.initState();
    _atualizarLista();
  }


  Widget build(BuildContext context){
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
    );
  }

  AppBar _criarAppBar(){
      return AppBar(
        title: Text('Ponto Remoto'),
      );
  }

  Widget _criarBody() => Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          ElevatedButton(
              onPressed: _registrarPonto,
              child: Text('Registrar Ponto'),
          ),
          ElevatedButton(
              onPressed: _verificarHistorico,
              child: Text('Verificar Histórico'),
          ),
        ],
      ),
  );

  void _registrarPonto(){
    _obterLocalizacaoAtual();
    data = DateTime.now().day;
    data += '/';
    data += DateTime.now().month;
    data += '/';
    data += DateTime.now().year;
    data += '   ';
    data += DateTime.now().hour;
    data += ':';
    data += DateTime.now().minute;

    final retorno = _pontoDao.salvar(PontoRemoto(data: data, longitude: _localizacaoAtual!.longitude, latitude:_localizacaoAtual!.latitude));

    if(retorno == true){
      _mostrarMensagemDialog('Registro Salvo com sucesso');
    }
    print(_pontoDao);
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Row(
                children: [

                ],
              ),
            );
          }
      );
  }

  Future<void> _mostrarMensagemDialog(String mensagem) async{
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Atenção'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _atualizarLista() async {
    setState(() {
        _carregando = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final campoOrdenacao = prefs.getString(FiltroPage.CAMPO_ORDENACAO) ?? PontoRemoto.CAMPO_ID;

    final pontoRemoto = await _pontoDao.listar(
      filtro: campoOrdenacao,
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

  void _obterLocalizacaoAtual() async{
    bool servicoHabilitado = await _servicoHabilitado();
    if(!servicoHabilitado){
      return;
    }
    bool permissoesPermitidas = await _permissoesPermitidas();
    if(!permissoesPermitidas){
      return;
    }
    _localizacaoAtual = await Geolocator.getCurrentPosition();
    setState(() {

    });
  }

  Future<bool> _servicoHabilitado() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado){
      await _mostrarDialogMensagem('Para utilizar esse recurso, você deverá habilitar o serviço'
          ' de localização');
      Geolocator.openLocationSettings();
      return false;
    }
    return true;
  }
  Future<bool> _permissoesPermitidas() async {
    LocationPermission permissao = await Geolocator.checkPermission();
    if(permissao == LocationPermission.denied){
      permissao = await Geolocator.requestPermission();
      if(permissao == LocationPermission.denied){
        _mostrarMensagem('Não será possível utilizar o recurso '
            'por falta de permissão');
      }
    }
    if(permissao == LocationPermission.deniedForever){
      await _mostrarDialogMensagem('Para utilizar esse recurso, você deverá acessar '
          'as configurações do app para permitir a utilização do serviço de localização');
      Geolocator.openAppSettings();
      return false;
    }
    return true;
  }
  void _mostrarMensagem(String mensagem){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _mostrarDialogMensagem(String mensagem) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Atenção'),
        content: Text(mensagem),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK')
          )
        ],
      ),
    );
  }

  void _verificarHistorico(){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ListaHistoricoPage(),
    ));
  }

}

class Campo extends StatelessWidget{
  final String descricao;

  const Campo({Key? key,required this.descricao}) : super(key: key);

  @override
  Widget build (BuildContext context){
    return Expanded(
      flex: 1,
      child: Text(descricao,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class Valor extends StatelessWidget{
  final String valor;

  const Valor({Key? key,required this.valor}) : super(key: key);

  @override
  Widget build (BuildContext context){
    return Expanded(
      flex: 4,
      child: Text(valor),
    );
  }
}