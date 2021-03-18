unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Bind4D,
  Vcl.ComCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm2 = class(TForm)

    [FieldJsonBind('Nome'), FbIgnoreDelete]
    [ComponentBindStyle(clWindow, 8, $00322f2d, 'Segoe UI')]
    Edit1: TEdit;

    [FieldJsonBind('Telefone'), FbIgnoreDelete]
    [ComponentBindStyle(clWindow, 8, $00322f2d, 'Segoe UI', teCell)]
    Edit2: TEdit;

    [FieldJsonBind('Sexo'), FbIgnoreDelete]
    [ComponentBindStyle(clWindow, 8, $00322f2d, 'Segoe UI')]
    ComboBox1: TComboBox;

    [FieldJsonBind('Status'), FbIgnoreDelete]
    [ComponentBindStyle(clWindow, 8, $00322f2d, 'Segoe UI')]
    CheckBox1: TCheckBox;

    [FieldJsonBind('Tipo'), FbIgnoreDelete]
    [ComponentBindStyle(clWindow, 8, $00322f2d, 'Segoe UI')]
    RadioGroup1: TRadioGroup;

    [FieldJsonBind('Data'), FbIgnoreDelete]
    [ComponentBindStyle(clWindow, 8, $00322f2d, 'Segoe UI')]
    DateTimePicker1: TDateTimePicker;

    [FieldJsonBind('Id'), FbIgnorePost]
    [ComponentBindStyle(clWindow, 8, $00322f2d, 'Segoe UI')]
    [fvNotNull('Campo ID não pode ser nulo')]
    edtId: TEdit;

    [ComponentBindStyle(clWindow, 8, $00322f2d, 'Segoe UI')]
    Button2: TButton;

    [ComponentBindStyle(clWindow, 8, $00322f2d, 'Segoe UI')]
    Button3: TButton;

    [ComponentBindStyle(clWindow, 8, $00322f2d, 'Segoe UI')]
    Button4: TButton;

    [ComponentBindStyle(clWindow, 8, $00322f2d, 'Segoe UI')]
    Memo1: TMemo;

    [ComponentBindStyle(clWindow, 8, $00322f2d, 'Segoe UI')]
    Button1: TButton;


    FDMemTable1: TFDMemTable;

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses
  System.JSON;

{$R *.dfm}


procedure TForm2.Button1Click(Sender: TObject);
var
  aJson : TJsonObject;
begin
  Memo1.Lines.Clear;
  aJson := TBind4D.New.Form(Self).FormToJson(fbGet);
  try
    Memo1.Lines.Add(aJson.ToString);
  finally
    aJson.Free;
  end;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  aJson : TJsonObject;
begin
  Memo1.Lines.Clear;
  aJson := TBind4D.New.Form(Self).FormToJson(fbPost);
  try
    Memo1.Lines.Add(aJson.ToString);
  finally
    aJson.Free;
  end;
end;

procedure TForm2.Button3Click(Sender: TObject);
var
  aJson : TJsonObject;
begin
  Memo1.Lines.Clear;
  aJson := TBind4D.New.Form(Self).FormToJson(fbPut);
  try
    Memo1.Lines.Add(aJson.ToString);
  finally
    aJson.Free;
  end;
end;

procedure TForm2.Button4Click(Sender: TObject);
var
  aJson : TJsonObject;
begin
  Memo1.Lines.Clear;
  aJson := TBind4D.New.Form(Self).FormToJson(fbDelete);
  try
    Memo1.Lines.Add(aJson.ToString);
  finally
    aJson.Free;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  TBind4D.New.Form(Self).SetStyleComponents;
end;

end.
