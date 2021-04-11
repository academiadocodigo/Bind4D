<p align="center">
  <a href="https://github.com/bittencourtthulio/Bind4D/blob/main/assets/Sem%20t%C3%ADtulo-2.fw.png">
    <img alt="bind4d" src="https://github.com/bittencourtthulio/Bind4D/blob/main/assets/Sem%20t%C3%ADtulo-2.fw.png">
  </a>  
</p><br>

<p align="center">
  <img src="https://img.shields.io/github/v/release/bittencourtthulio/Bind4D?style=flat-square">
  <img src="https://img.shields.io/github/stars/bittencourtthulio/Bind4D?style=flat-square">
  <img src="https://img.shields.io/github/contributors/bittencourtthulio/Bind4D?color=orange&style=flat-square">
  <img src="https://img.shields.io/github/forks/bittencourtthulio/Bind4D?style=flat-square">
   <img src="https://tokei.rs/b1/github/bittencourtthulio/Bind4D?color=red&category=lines">
  <img src="https://tokei.rs/b1/github/bittencourtthulio/Bind4D?color=green&category=code">
  <img src="https://tokei.rs/b1/github/bittencourtthulio/Bind4D?color=yellow&category=files">
</p>

# Bind4D
Framework para realização de Bind via notação de Atributos nos componentes do formulário.

O Bind4D tem o objetivo de facilitar a transição de dados entre a camada de visão e as demais camadas do seu sistema, realizando de forma automatica mediante notação a conversão dos dados de um formulário para JSON, atribuindo estilos a componentes, realizando validação de campos, configuração de exibição de dados do dataset em um DbGrid e muito mais.

<br>


## Instalação

Basta registrar no Library Path do seu Delphi o caminho da pasta SRC da Biblioteca ou utilizar o Boss (https://github.com/HashLoad/boss) para facilitar ainda mais, executando o comando 

```
boss install https://github.com/bittencourtthulio/Bind4D
```

*Pré-Requisitos*:<br> 

[**aws4d**](https://github.com/bittencourtthulio/aws4d) - Biblioteca para Envio de Arquivos para a AWS S3 <br>
[**localcache4d**](https://github.com/bittencourtthulio/localcache4d) - Mini Banco de Dados Chave-Valor para Cache local <br>
[**translator4d**](https://github.com/bittencourtthulio/translator4d) - Biblioteca para Tradução com Google API <br>
[**restrequest4delphi**](https://github.com/viniciussanchez/restrequest4delphi) - Biblioteca para Requisições REST <br>

## Primeiros Passos - Tutorial

Para utilizar o Bind4D você deve adicionar as uses:

```
Bind4D,
Bind4D.Attributes,
Bind4D.Types;
```

## Atributos do Formulário

Existem 2 atributos para o formulário que permitem que você deixe pré-configurados informações para recuperar em momentos distintos.

#### [FormRest(EndPoint, Key, Sort, Order)]

O atributo FormRest permite que você deixe configurado a qual endpoint rest as ações de crud deste formulario devem responder

Os parametros deste atributo são:

<b>EndPoint</b> = EndPoint da requisição rest;<br>
<b>Key</b> = Chave das Requisições para Put e Delete;<br>
<b>Sort</b> = Campos default da ordenação do Get podendo ser passado mais de um campo separado por virgula;<br>
<b>Order</b> = Ordem da Listagem asc ou desc;<br>

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

<b>Title</b> = Titulo do Formulários<br>

Exemplo

```delphi
[FormDefault('Cadastro de Usuários')]
TPageTemplate = class(TForm)
private
public
end;
```

## Atributos do Componentes

Os atributos dos componentes permitem que você adicione funcionalidades e determine configurações que podem ser adicionadas em lote a todos os componentes do formulário, além de prover configurações para as demais funções de bind.


####  [FieldJsonBind(FieldName)]

O atributo FieldJsonBind permite que você deixe configurado a qual Field do Json o componente irá corresponder na hora do bind do formulário para Json;

Os parametros destre atributo são:

<b>FieldName</b> = Nome do Campo que você deseja que ele se transforme no JSON<br>

Exemplo

```delphi
[FieldJsonBind('guuid')]
edtCodigo: TEdit;
```

Você ainda pode passar alguns atributos especiais para determinar em quais tipos de requisição aquele campo de ser ignorado ou não.

Os atributos especiais são:

<b>FbIgnorePut</b> = O campo será ignorado se o parametro de Put for enviado na hora do bind para json<br>
<b>FbIgnorePost</b> = O campo será ignorado se o parametro de Post for enviado na hora do bind para json<br>
<b>FbIgnoreDelete</b> = O campo será ignorado se o parametro de Delete for enviado na hora do bind para json<br>
<b>FbIgnoreGet</b> = O campo será ignorado se o parametro de Put Get enviado na hora do bind para json<br>

Exemplo

```delphi
[FieldJsonBind('guuid'), FbIgnorePut, FbIgnorePost]
edtCodigo: TEdit;
```

### Converter o Formulário para JSON

Uma vez tendo configurado todos os componentes desejados com o atributo FieldJsonBind, basta executar o comando abaixo passando qual o tipo de json você quer gerar para obter o Json com os valores presentes nos componentes.

Os Parametros deste atributo são:

<b>fbGet, fbPost, fbPut, fbDelete</b><br>

```delphi
var
  aJson: TJSONObject;
begin
  aJson := TBind4D.New.Form(FForm).FormToJson(fbPost);
  try
    //Seu Código
  finally
    aJson.Free;
  end;
```

####  [ComponentBindStyle(COLOR, FONTSIZE, FONTCOLOR, FONTNAME, ESPECIALTYPE)]

O atributo ComponentBindStyle permite que você determine as configurações visuais do componente para elas serem aplicadas de forma automatica, incluindo formatação de Edits e outros

Os parametros destre atributo são:

<b>COLOR</b> = Cor do componentes<br>
<b>FONTSIZE</b> = Tamanho da Fonte do Componente<br>
<b>FONTCOLOR</b> = Cor da Fonte do Componente<br>
<b>FONTNAME</b> =  Nome da Fonte do Componente<br>
<b>ESPECIALTYPE</b> = Tipo Especial usado para formatação.<br>

Os Tipos especiais de formatação disponíveis são:

<b>teNull</b> = Não aplica nenhuma configuração<br>
<b>teCoin</b> = Formatação para Moeda<br>
<b>teCell</b> = Formatação para Número de Celular com 9 digitos<br>
<b>teDate</b> = Formatação para Data<br>
<b>teDateTime</b> = Formatação para Data e Hora<br>
<b>teCPF</b> = Formatação para CPF<br> 
<b>teCNPJ</b> = Formatação para CNPJ<br>

Exemplo

```delphi
[ComponentBindStyle(COLOR_BACKGROUND, FONT_H5, FONT_COLOR3, FONT_NAME, teCell)]
edtCodigo: TEdit;
```

Para que os estilos e formatações sejam aplicados você deve executar o comando abaixo

Exemplo

```delphi
TBind4D.New.Form(Self).SetStyleComponents;
```


####  [FieldDataSetBind(Field, Type, Visible, DisplayWidh_Percent, DisplayName, MaskEdit, Alignment, LimitWidth)]

O atributo FieldDataSetBind permite você configurar o componente tanto para sua exibição no DBGrid quanto para o Bind automatico entre o DataSet e o Componente na Tela

Os parametros destre atributo são:

<b>Key</b> = Nome do Field no DataSet<br>
<b>Type</b> = Tipo de Dado do Campo<br>
<b>DisplayWidh_Percent</b> = Tamanho da Coluna no DBGrid em Porcentagem<br>
<b>DisplayName</b> =  Nome da Coluna a ser Exibido no DBGrid<br>
<b>MaskEdit</b> = Mascara para exibição do valor<br>
<b>Alignment</b> = Posicionamento na Exibição no DBGrid<br>
<b>LimitWidth</b> = Determina qual o tamanho limite de exibição da Coluna no DBGrid, se o formulario for menor que o tamanho informado a coluna é automaticamente oculta<br>

Exemplo

```delphi
[FieldDataSetBind('balance', ftCurrency, True, 8, 'Saldo', 'R$ ###,###,##0.00', taLeftJustify, 600)]
edtSaldo: TEdit;
```

Para que as configurações sejam aplicadas nos FieldsDataSet você deve executar o comando abaixo informando o Form, o DataSet que esta com os dados e o DBGrid de Exibição

Exemplo

```delphi
TBind4D.New.Form(Self).BindFormatListDataSet(FDataSet, DBGrid1);
```

Para que os dados do DataSet sejam automaticamente preenchidos nos componentes da tela simulando o que acontece com os componentes DBEdit e outros, você deve executar o comando abaixo.

Exemplo

```delphi
TBind4D.New.Form(Self).BindDataSetToForm(FDataSet);
```

####  [fvNotNull(Message)]

O atributo fvNotNull valida automaticamente se o valor no componente é nulo e apresenta a mensagem informada caso ele esteja vazio, esse processo ocorre durante o processo de bind do form para json.

Os parametros destre atributo são:

<b>Message</b> = Mensagem de Erro apresentada<br> 

Exemplo

```delphi
[fvNotNull('Campo Nome não pode ser Nulo')]
edtName: TEdit;
```


## Tradução com Google API Translator

O Bind4D executa a tradução automática dos componentes utilizando o framework Translator4D (https://github.com/bittencourtthulio/translator4d). 

Para realizar a tradução é necessário configurar préviamente o Bind4D com os parametros do Google API.

```delphi
TBind4D
    .New
      .Translator
        .Google
          .Credential
            .Key('SUA APIKEY DO GOOGLE API TRANSLATOR')
          .&End
          .Options
            .Cache(True) //Permite que o Bind4d faça o cache automatico das traduções para não refazer as consultas que ele já fez.
          .&End
          .Params
            .Source(TranslateSource) //Código da Linguagem origem que você está usando
            .Target(TranslateTarget); //Código da Linguagem de destino que você deseja traduzir.
```

Os código das linguagem do Google você pode ver aqui: 
https://cloud.google.com/translate/docs/languages?hl=pt-br


O Bind4D trabalha com o padrão Singleton, sendo assim você pode realizar essa configuração a qualquer momento no seu sistema, com a configuração feita você pode adicionar os atributos de tradução nos seus componentes.

```delphi
[Translation('Nome')]
Label1: TLabel;
```

Dessa forma ao chamar o método abaixo ele automaticamente atribuirá a tradução da palavra "Nome" no idioma que você configurou no Target ao Label1.

```delphi
 TBind4D
    .New
      .Form(Self)
      .SetStyleComponents;
```
