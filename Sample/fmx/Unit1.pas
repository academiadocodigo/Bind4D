unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.Edit, FMX.ListBox, FMX.DateTimeCtrls,
  FMX.StdCtrls, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Objects,Bind4D;

type
  TForm1 = class(TForm)

    [FieldJsonBind('Id'), FbIgnorePost]
    edtid: TEdit;

    [FieldJsonBind('Nome'), FbIgnoreDelete]
    edtnome: TEdit;

    [FieldJsonBind('Telefone'), FbIgnoreDelete]
    edttelofone: TEdit;

    [FieldJsonBind('Sexo'), FbIgnoreDelete]
    ComboBox1: TComboBox;

    [FieldJsonBind('Data'), FbIgnoreDelete]
    DateEdit1: TDateEdit;

    [FieldJsonBind('Status'), FbIgnoreDelete]
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
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
  Form1: TForm1;

implementation

uses
  System.JSON;

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
  aJson : TJsonObject;
begin
  Memo1.Lines.Clear;
  aJson := TBind4D.New.FormToJson(Self, fbGet);
  try
    Memo1.Lines.Add(aJson.ToString);
  finally
    aJson.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  aJson : TJsonObject;
begin
  Memo1.Lines.Clear;
  aJson := TBind4D.New.FormToJson(Self, fbPost);
  try
    Memo1.Lines.Add(aJson.ToString);
  finally
    aJson.Free;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  aJson : TJsonObject;
begin
  Memo1.Lines.Clear;
  aJson := TBind4D.New.FormToJson(Self, fbPut);
  try
    Memo1.Lines.Add(aJson.ToString);
  finally
    aJson.Free;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  aJson : TJsonObject;
begin
  Memo1.Lines.Clear;
  aJson := TBind4D.New.FormToJson(Self, fbDelete);
  try
    Memo1.Lines.Add(aJson.ToString);
  finally
    aJson.Free;
  end;
end;

end.
