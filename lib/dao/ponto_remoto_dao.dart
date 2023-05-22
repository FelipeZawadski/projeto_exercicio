

import 'package:projeto_exercicio/model/ponto_remoto.dart';

import '../database/database_provider.dart';

class PontoRemotoDao{

  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar(PontoRemoto pontoRemoto) async {
    final database = await dbProvider.database;
    final valores = pontoRemoto.toMap();
    if (pontoRemoto.id == null) {
      pontoRemoto.id = await database.insert(PontoRemoto.NOME_TABLE, valores);
      return true;
    } else {
      final registrosAtualizados = await database.update(
        PontoRemoto.NOME_TABLE,
        valores,
        where: '${PontoRemoto.CAMPO_ID} = ?',
        whereArgs: [pontoRemoto.id],
      );
      return registrosAtualizados > 0;
    }
  }

  Future<List<PontoRemoto>> listar(
      {String filtro = '',
        String campoOrdenacao = PontoRemoto.CAMPO_ID,
        bool usarOrdemDecrescente = false
      }) async {
    String? where;
    if(filtro.isNotEmpty){
      where = "UPPER(${PontoRemoto.CAMPO_ID}) LIKE '${filtro.toUpperCase()}%'";
    }
    var orderBy = campoOrdenacao;

    if(usarOrdemDecrescente){
      orderBy += ' DESC';
    }

    final database = await dbProvider.database;
    final resultado = await database.query(PontoRemoto.NOME_TABLE,
      columns: [PontoRemoto.CAMPO_ID, PontoRemoto.DATA, PontoRemoto.LONGITUDE, PontoRemoto.LATITUDE],
      where: where,
      orderBy: orderBy,
    );
    return resultado.map((m) => PontoRemoto.fromMap(m)).toList();
  }
}