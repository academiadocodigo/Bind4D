unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, BindFormJson,
  Vcl.ComCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm2 = class(TForm)

    [FieldJsonBind('Nome'), FbIgnoreDelete]
    Edit1: TEdit;

    [FieldJsonBind('Telefone'), FbIgnoreDelete]
    Edit2: TEdit;

    [FieldJsonBind('Sexo'), FbIgnoreDelete]
    ComboBox1: TComboBox;

    [FieldJsonBind('Status'), FbIgnoreDelete]
    CheckBox1: TCheckBox;

    [FieldJsonBind('Tipo'), FbIgnoreDelete]
    RadioGroup1: TRadioGroup;

    [FieldJsonBind('Data'), FbIgnoreDelete]
    DateTimePicker1: TDateTimePicker;

    [FieldJsonBind('Id'), FbIgnorePost]
    edtId: TEdit;

    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Memo1: TMemo;
    Button1: TButton;
    FDMemTable1: TFDMemTable;

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
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
  aJson := TBindFormJson.New.FormToJson(Self, fbGet);
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
  aJson := TBindFormJson.New.FormToJson(Self, fbPost);
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
  aJson := TBindFormJson.New.FormToJson(Self, fbPut);
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
  aJson := TBindFormJson.New.FormToJson(Self, fbDelete);
  try
    Memo1.Lines.Add(aJson.ToString);
  finally
    aJson.Free;
  end;
end;

end.
