//
//
// BUSCANDO PELO NOME DANIEL UTILIZANDO O COMANDO WHERE
//
//importando bibliotecas
import 'package:flutter/material.dart';
// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

//
//
// criando classe Lerusuario2
class Lerusuario2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //criando uma REFERENCIA a collection USERS... essa referencia vai ser chamar
    //USERS
    CollectionReference users = FirebaseFirestore.instance.collection('users');
//
//
//Retornando um FUTURE BUILDER... o FutureBuilder é uma funcao que irá construir
//com base nos dados q vierem no "FUTURE:"/futuro... e no Nosso BUILDER vamos
//contruir um CONTAINER para cada um desses dados...
    return FutureBuilder<QuerySnapshot>(
      //
      //para a funcao FUTURE, estamos passando a nossa COLLECTION REFERENCE USERS
      //feita ali em cima... E estamos passando o comando WHERE... Q diz q dentro
      //da COLLECTION USERS, nos vamos pegar APENAS os DOC q tenham DANIEL
      //como VALOR da CHAVE FULL_NAME
      future: users.where('full_name', isEqualTo: 'daniel').get(),
      //o builder ta dizendo q nesse contexto de forma ASSINCRONA nos vamos
      //tirar uma "foto"/copia "querysnapshot" de como ta os dados na collection
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //se houver erro, exibe a mensagem a baixo
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        //se estiver tudo certo, exibe a mensagem
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        //
        //fazendo um ListView, pois assim podemos exibir o conteudo de varios
        //DOCS um em baixo do outro
        return ListView(
          //pegando a foto"snapshot"/pegando o estado atual e nela pegando
          //os valores (chave:valores) q estao nos DOC da Collection
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            //vamos receber valores no tipo Map sendo String e Dynamic, pois
            //o STRING vai ser a {CHAVE:} do documento...
            // e o DYNAMIC sera o valor da chave, pois assim
            //pd ser (numeros, bool, etc...) {STRING: VALOR}
            Map<String, dynamic> data =
                //a variavel DATA acima, vai receber os DADOS dos DOCUMENTOS q estao
                //dentro da COLLECTION USERS... esses dados q a variavel DATA vai
                //receber são do tipo MAP sendo CHAVE:VALOR (string, dynamic)
                document.data()! as Map<String, dynamic>;
            //
            //
            //aqui começa a parte do q sera exibido na tela do APP
            //
            return Material(
              //criando um ListTile... para exibir todos os DOC q tem o
              //full_name = daniel
              child: ListTile(
                //caso o DOC tenha o nome DANIEL... VAmos exibir o FULL_NAME e
                //a COMPANY/EMPRESA q os DANIEL trabalha
                title: Text(data['full_name']),

                subtitle: Text(data['company']),
                //
                //tambem podemos fazer com um CONTAINER no lugar de LISTTILE
                //return Container(
                //child: Text(data['full_name']),
                //);
                //
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
