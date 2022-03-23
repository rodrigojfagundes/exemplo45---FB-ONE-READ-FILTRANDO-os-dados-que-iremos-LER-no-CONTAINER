//DA FORMA A BAIXO...
//FOI POSSIVEL USAR 2 IFS dessa forma... Podemos FILTRAR 2 dados ao mesmo
//tempo... Em containers DIFERENTES... Tipo
//Em uns container vai exiber apenas SE FUNCIONARIO for ATIVO... e em OUTRO CONTAINER
//apenas se FUNCIONARIO for do TI

//
//importando classes
import 'package:flutter/material.dart';
// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

//
//criando classe Lerusuario
class Lerusuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //criando a REFENCIA a collection USERS... o nome da REFERENCIA vai ser
    //USERS
    CollectionReference users = FirebaseFirestore.instance.collection('users');
//
//retornando um FutureBuilder... Um FutureBuilder é uma funcao que ira CONSTRUIR
//algo com base nos dados q vierem no no "future:"... Ele/builder ira construir um
//Container
    return FutureBuilder<QuerySnapshot>(
      //o FUTURE vai receber a nossa CollectionReference acima... o USERS e vamos passar
      //o comando .GET para pegar TODOS os dados q esta nessa COLLECTION
      future: users.get(),
      //o builder ta dizendo q nesse contexto de forma ASSINCRONA nos vamos
      //tirar uma "foto"/copia "querysnapshot" de como ta os dados na collection
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //se nao der certo exibe a mensagme
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        //se der certo exibe a mensagem
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        //acima nos fizemos a CONEXAO com a COLLECTION users...
        //
        //nas linhas a baixo vamos, extrair esses dados e exibir eles na tela
        //do app
        //Scaffold é para criar o "esqueleto do app"
        return Scaffold(
          //singleChildScrollView é para q possamos "rolar" os containers com SCROLL
          body: SingleChildScrollView(
            //criando um Column pois assim iremos poder colocar VARIOS containers
            //um em baixo do outro... pois cada Container se tornar como um "item"
            //em um vetor
            child: Column(
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
                //os codigos q estao a baixo sao referente ao q ira aparecer
                //na tela do app
                //
                //se a CHAVE ['SEXO'] de cada um dos DOC tiver o valor "F", significa
                //q os dados q estao nesse DOC é de uma pessoa do SEXO FEMININO
                if (data['sexo'] == 'f') {
                  //entao iremos retornar um CONTAINER para cada pessoa do SEXO FEMININO
                  return Container(
                    //caracteristicas do Container... Altura e tamanho... Cor ROSA
                    height: 200,
                    width: 300,
                    color: Colors.pink,
                    //dentro desse container nos vamos exibir o NOME da pessoa
                    //e vamos exibir o SEXO dela...
                    child: Text("Full Name: ${data['full_name']}"
                        "##sexo: ${data['sexo']}"),
                  );
                }
                //se o valor da CHAVE SEXO for "M", significa que a pessoa
                //q ta com os dados armazenados nesse DOC é do SEXO MASCULINO
                if (data['sexo'] == 'm') {
                  //caso seja, masculino... Nos vamos retornar um Container
                  return Container(
                    //passando ALTURA, LARGURA, e a COR AZUL...
                    height: 200,
                    width: 300,
                    color: Colors.blue,
                    //neste CONTAINER vamos exibir o NOME da pessoa, e o SEXO dela
                    child: Text("Full Name: ${data['full_name']}"
                        "##sexo: ${data['sexo']}"),
                  );
                  //se a pessoa NAO for do SEXO MASCULINO ou FEMININO...
                  //nos vamos retornar um CONTAINER sem nada escrito...
                  //um container vazio
                } else {
                  return Container();
                }
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
