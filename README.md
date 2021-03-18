# Bind4D
Framework para realização de Bind via notação de Atributos nos componentes do formulário.

O Bind4D tem o objetivo de facilitar a transição de dados entre a camada de visão e as demais camadas do seu sistema, realizando de forma automatica mediante notação a conversão dos dados de um formulário para JSON, atribuindo estilos a componentes, realizando validação de campos, configuração de exibição de dados do dataset em um DbGrid e muito mais.

## Instalação

Basta registrar no Library Path do seu Delphi o caminho da pasta SRC da Biblioteca ou utilizar o Boss (https://github.com/HashLoad/boss) para facilitar ainda mais, executando o comando boss install https://github.com/bittencourtthulio/Bind4D

## Primeiros Passos - Tutorial

Para utilizar o Bind4D você deve adicionar a uses Bind4D.

## Atributos do Formulário

Existem 2 atributos para o formulário que permitem que você deixe pré-configurados informações para recuperar em momentos distintos.

#### [FormRest(EndPoint, Key, Sort, Order)]

O atributo FormRest permite que você deixe configurado a qual endpoint rest as ações de crud deste formulario devem responder

Os parametros deste atributo são:

EndPoint = EndPoint da requisição rest;
Key = Chave das Requisições para Put e Delete;
Sort = Campos default da ordenação do Get podendo ser passado mais de um campo separado por virgula
Order = Ordem da Listagem asc ou desc;

Exemplo

```delphi

[FormRest('/users', 'guuid', 'name', 'asc')]
TPageTemplate = class(TForm)
private
public
end;
```

Para recuperar esses dados, você pode a qualquer momento no seu projeto chamar a função abaixo,
passando o Form como parametro e as variaveis as quais você deseja armazenar o retorno

```delphi
TBind4D.New.Form(Self).BindFormRest(FEndPoint,FPK,FSort,FOrder);
```

####  [FormDefault(Title)]

O atributo FormDefault permite que você deixe configurado o Titulo para o Formulário.

Os parametros destre atributo são:

Title = Titulo do Formulários

Exemplo

```delphi
[FormDefault('Cadastro de Usuários')]
TPageTemplate = class(TForm)
private
public
end;
```