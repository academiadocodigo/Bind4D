unit Bind4D;

interface

uses
  System.JSON,
  Vcl.Forms,
  System.Classes,
  System.Rtti,
  System.SysUtils,
  System.Variants,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Data.DB;

type

  TRttiFieldHelper = class helper for TRttiField
  public
    function Tem<T: TCustomAttribute>: Boolean;
    function GetAttribute<T: TCustomAttribute>: T;
  end;

  TRttiTypeHelper = class helper for TRttiType
  public
    function Tem<T: TCustomAttribute>: Boolean;
    function GetAttribute<T: TCustomAttribute>: T;
  end;

  ClassToBind = class(TCustomAttribute)
    private
    FTitle: String;
    FPK: String;
    FEndPoint: String;
    procedure SetEndPoint(const Value: String);
    procedure SetPK(const Value: String);
    procedure SetTitle(const Value: String);
    public
      constructor Create(aEndPoint : String = ''; aPK : String = ''; aTitle : String = '');
      property EndPoint : String read FEndPoint write SetEndPoint;
      property PK : String read FPK write SetPK;
      property Title : String read FTitle write SetTitle;
  end;


  FieldJsonBind = class(TCustomAttribute)
  private
    FJsonName: string;
    procedure SetJsonName(const Value: string);
  public
    constructor Create(aJsonName: string);
    property JsonName : string read FJsonName write SetJsonName;
  end;

  FieldDataSetBind = class(TCustomAttribute)
    private
    FFieldName: String;
    FDisplayName: String;
    FWidth: Integer;
    FVisible: Boolean;
    procedure SetFieldName(const Value: String);
    procedure SetDisplayName(const Value: String);
    procedure SetWidth(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
    public
      constructor Create(aFieldName : String; aVisible : Boolean = True; aWidth : Integer = 50; aDisplayName : String = '');
      property FieldName : String read FFieldName write SetFieldName;
      property Width : Integer read FWidth write SetWidth;
      property DisplayName : String read FDisplayName write SetDisplayName;
      property Visible : Boolean read FVisible write SetVisible;
  end;

  FbIgnorePut = class(TCustomAttribute)
  end;

  FbIgnorePost = class(TCustomAttribute)
  end;

  FbIgnoreDelete = class(TCustomAttribute)
  end;

  FbIgnoreGet = class(TCustomAttribute)
  end;

  TTypeBindFormJson = (fbGet, fbPost, fbPut, fbDelete);

  iBindFormJson = interface
    ['{2846B843-7533-4987-B7B4-72F7B5654D1A}']
    function FormToJson(aForm : TForm; aType : TTypeBindFormJson) : TJsonObject;
    procedure ClearFieldForm(aForm : TForm);
    procedure BindDataSetToForm(aForm : TForm; aDataSet : TDataSet);
    procedure BindFormatListDataSet(aForm : TForm; aDataSet : TDataSet);
    procedure BindClassToForm (aForm : TForm; var aEndPoint : String; var aPK : String; var aTitle : String);
    function GetFieldsByType (aForm : TForm; aType : TTypeBindFormJson) : String;
  end;

  TBindFormJson = class(TInterfacedObject, iBindFormJson)
    private
      function __GetComponentToValue(aComponent: TComponent): TValue;
      procedure __BindValueToComponent(aComponent: TComponent; aValue: Variant);
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iBindFormJson;
      function FormToJson(aForm : TForm; aType : TTypeBindFormJson) : TJsonObject;
      procedure ClearFieldForm(aForm : TForm);
      procedure BindDataSetToForm(aForm : TForm; aDataSet : TDataSet);
      procedure BindFormatListDataSet(aForm : TForm; aDataSet : TDataSet);
      procedure BindClassToForm (aForm : TForm; var aEndPoint : String; var aPK : String; var aTitle : String);
      function GetFieldsByType (aForm : TForm; aType : TTypeBindFormJson) : String;
  end;

implementation

uses
  Vcl.ComCtrls;


{ FieldBind }

constructor FieldJsonBind.Create(aJsonName: string);
begin
  FJsonName := aJsonName;
end;

procedure FieldJsonBind.SetJsonName(const Value: string);
begin
  FJsonName := Value;
end;

{ TBindFormJson }

procedure TBindFormJson.__BindValueToComponent(aComponent: TComponent;
  aValue: Variant);
begin
  if VarIsNull(aValue) then exit;
  if aComponent is TEdit then
    (aComponent as TEdit).Text := aValue;
  if aComponent is TComboBox then
    (aComponent as TComboBox).ItemIndex := (aComponent as TComboBox).Items.IndexOf(aValue);
  if aComponent is TRadioGroup then
    (aComponent as TRadioGroup).ItemIndex := (aComponent as TRadioGroup).Items.IndexOf(aValue);
  if aComponent is TCheckBox then
    (aComponent as TCheckBox).Checked := aValue;
  if aComponent is TTrackBar then
    (aComponent as TTrackBar).Position := aValue;
  if aComponent is TDateTimePicker then
    (aComponent as TDateTimePicker).Date := aValue;
  if aComponent is TShape then
    (aComponent as TShape).Brush.Color := aValue;
end;

procedure TBindFormJson.BindClassToForm(aForm : TForm; var aEndPoint : String; var aPK : String; var aTitle : String);
var
  vCtxRtti: TRttiContext;
  vTypRtti: TRttiType;
begin
  vCtxRtti := TRttiContext.Create;
  try
    vTypRtti := vCtxRtti.GetType(aForm.ClassInfo);
    if vTypRtti.Tem<ClassToBind> then
      aEndPoint := vTypRtti.GetAttribute<ClassToBind>.FEndPoint;
      aPK := vTypRtti.GetAttribute<ClassToBind>.FPK;
      aTitle := vTypRtti.GetAttribute<ClassToBind>.FTitle;
  finally
    vCtxRtti.Free;
  end;
end;

procedure TBindFormJson.BindDataSetToForm(aForm: TForm; aDataSet: TDataSet);
var
  ctxRtti : TRttiContext;
  typRtti : TRttiType;
  prpRtti : TRttiField;
begin
  ctxRtti := TRttiContext.Create;
  try
    typRtti := ctxRtti.GetType(aForm.ClassInfo);
    for prpRtti in typRtti.GetFields do
    begin
      if prpRtti.Tem<FieldDataSetBind> then
      begin
        __BindValueToComponent(
                          aForm.FindComponent(prpRtti.Name),
                          aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName).AsVariant
        );
      end;
    end;
  finally
    ctxRtti.Free;
  end;

end;

procedure TBindFormJson.BindFormatListDataSet(aForm: TForm; aDataSet: TDataSet);
var
  ctxRtti : TRttiContext;
  typRtti : TRttiType;
  prpRtti : TRttiField;
begin
  ctxRtti := TRttiContext.Create;
  try
    try
      typRtti := ctxRtti.GetType(aForm.ClassInfo);
      for prpRtti in typRtti.GetFields do
      begin
        if prpRtti.Tem<FieldDataSetBind> then
        begin
          aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName).Visible := prpRtti.GetAttribute<FieldDataSetBind>.FVisible;
          aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName).DisplayLabel := prpRtti.GetAttribute<FieldDataSetBind>.FDisplayName;
          aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName).DisplayWidth := prpRtti.GetAttribute<FieldDataSetBind>.FWidth;
        end;
      end;
    except
      //
    end;
  finally
    ctxRtti.Free;
  end;

end;

procedure TBindFormJson.ClearFieldForm(aForm : TForm);
var
  ctxRtti : TRttiContext;
  typRtti : TRttiType;
  prpRtti : TRttiField;
  aComponent : TComponent;
begin
  ctxRtti := TRttiContext.Create;
  try
    typRtti := ctxRtti.GetType(aForm.ClassInfo);
    for prpRtti in typRtti.GetFields do
    begin
      aComponent := aForm.FindComponent(prpRtti.Name);
      if aComponent is TEdit then
        (aComponent as TEdit).Text := '';
      if aComponent is TComboBox then
        (aComponent as TComboBox).ItemIndex := -1;
      if aComponent is TRadioGroup then
        (aComponent as TRadioGroup).ItemIndex := -1;
//      if aComponent is TCheckBox then
//        (aComponent as TCheckBox).Checked := aValue;
      if aComponent is TTrackBar then
        (aComponent as TTrackBar).Position := 0;
      if aComponent is TDateTimePicker then
        (aComponent as TDateTimePicker).Date := now;
//      if aComponent is TShape then
//        (aComponent as TShape).Brush.Color := aValue;
    end;
  finally
    ctxRtti.Free;
  end;

end;

constructor TBindFormJson.Create;
begin

end;

destructor TBindFormJson.Destroy;
begin

  inherited;
end;

function TBindFormJson.FormToJson(aForm : TForm; aType : TTypeBindFormJson) : TJsonObject;
var
  ctxRtti : TRttiContext;
  typRtti : TRttiType;
  prpRtti : TRttiField;
begin
  ctxRtti := TRttiContext.Create;
  Result := TJsonObject.Create;
  try
    typRtti := ctxRtti.GetType(aForm.ClassInfo);
    for prpRtti in typRtti.GetFields do
    begin
      if prpRtti.Tem<FieldJsonBind> then
      begin
        case aType of
          fbGet:
          begin
              Result
                .AddPair(
                  prpRtti.GetAttribute<FieldJsonBind>.FJsonName,
                  __GetComponentToValue(aForm.FindComponent(prpRtti.Name)).ToString
                );
          end;
          fbPost:
          begin
            if not prpRtti.Tem<FbIgnorePost> then
              Result
                .AddPair(
                  prpRtti.GetAttribute<FieldJsonBind>.FJsonName,
                  __GetComponentToValue(aForm.FindComponent(prpRtti.Name)).ToString
                );
          end;
          fbPut:
          begin
            if not prpRtti.Tem<FbIgnorePut> then
              Result
                .AddPair(
                  prpRtti.GetAttribute<FieldJsonBind>.FJsonName,
                  __GetComponentToValue(aForm.FindComponent(prpRtti.Name)).ToString
                );
          end;
          fbDelete:
          begin
            if not prpRtti.Tem<FbIgnoreDelete> then
              Result
                .AddPair(
                  prpRtti.GetAttribute<FieldJsonBind>.FJsonName,
                  __GetComponentToValue(aForm.FindComponent(prpRtti.Name)).ToString
                );
          end;
        end;
      end;
    end;
  finally
    ctxRtti.Free;
  end;
end;

function TBindFormJson.GetFieldsByType(aForm : TForm; aType : TTypeBindFormJson) : String;
var
  ctxRtti : TRttiContext;
  typRtti : TRttiType;
  prpRtti : TRttiField;
begin
  ctxRtti := TRttiContext.Create;
  try
    typRtti := ctxRtti.GetType(aForm.ClassInfo);
    for prpRtti in typRtti.GetFields do
    begin
      if prpRtti.Tem<FieldJsonBind> then
      begin
        case aType of
          fbGet:
          begin
            if not prpRtti.Tem<FbIgnoreGet> then
              Result := Result + prpRtti.GetAttribute<FieldJsonBind>.FJsonName + ',';
          end;
          fbPost:
          begin
            if not prpRtti.Tem<FbIgnorePost> then
              Result := Result + prpRtti.GetAttribute<FieldJsonBind>.FJsonName + ',';
          end;
          fbPut:
          begin
            if not prpRtti.Tem<FbIgnorePut> then
              Result := Result + prpRtti.GetAttribute<FieldJsonBind>.FJsonName + ',';
          end;
          fbDelete:
          begin
            if not prpRtti.Tem<FbIgnoreDelete> then
              Result := Result + prpRtti.GetAttribute<FieldJsonBind>.FJsonName + ',';
          end;
        end;
      end;
    end;
  finally
    Result := Copy(Result, 1, Length(Result) -1);
    ctxRtti.Free;
  end;

end;

function TBindFormJson.__GetComponentToValue(aComponent: TComponent): TValue;
var
  a: string;
begin
  if aComponent is TEdit then
    Result := TValue.FromVariant((aComponent as TEdit).Text);
  if aComponent is TComboBox then
    Result := TValue.FromVariant((aComponent as TComboBox).Items[(aComponent as TComboBox).ItemIndex]);
  if aComponent is TRadioGroup then
    Result := TValue.FromVariant((aComponent as TRadioGroup).Items[(aComponent as TRadioGroup).ItemIndex]);
  if aComponent is TCheckBox then
    Result := TValue.FromVariant((aComponent as TCheckBox).Checked);
  if aComponent is TTrackBar then
    Result := TValue.FromVariant((aComponent as TTrackBar).Position);
  if aComponent is TDateTimePicker then
    Result := TValue.FromVariant((aComponent as TDateTimePicker).DateTime);
  if aComponent is TShape then
    Result := TValue.FromVariant((aComponent as TShape).Brush.Color);
  a := Result.TOString;
end;

class function TBindFormJson.New: iBindFormJson;
begin
  Result := Self.Create;
end;



{ TRttiFieldHelper }

function TRttiFieldHelper.GetAttribute<T>: T;
var
  oAtributo: TCustomAttribute;
begin
  Result := nil;
  for oAtributo in GetAttributes do
    if oAtributo is T then
      Exit((oAtributo as T));
end;

function TRttiFieldHelper.Tem<T>: Boolean;
begin
  Result := GetAttribute<T> <> nil;
end;

{ FieldDataSetBind }

constructor FieldDataSetBind.Create(aFieldName : String; aVisible : Boolean = True; aWidth : Integer = 50; aDisplayName : String = '');
begin
  FFieldName := aFieldName;
  FWidth := aWidth;
  FDisplayName := aDisplayName;
  FVisible := aVisible;
end;

procedure FieldDataSetBind.SetDisplayName(const Value: String);
begin
  FDisplayName := Value;
end;

procedure FieldDataSetBind.SetFieldName(const Value: String);
begin
  FFieldName := Value;
end;

procedure FieldDataSetBind.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
end;

procedure FieldDataSetBind.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

{ ClassToBind }

constructor ClassToBind.Create(aEndPoint, aPK, aTitle: String);
begin
  FEndPoint := aEndPoint;
  FPK := aPK;
  FTitle := aTitle;
end;

procedure ClassToBind.SetEndPoint(const Value: String);
begin
  FEndPoint := Value;
end;

procedure ClassToBind.SetPK(const Value: String);
begin
  FPK := Value;
end;

procedure ClassToBind.SetTitle(const Value: String);
begin
  FTitle := Value;
end;

{ TRttiTypeHelper }

function TRttiTypeHelper.GetAttribute<T>: T;
var
  oAtributo: TCustomAttribute;
begin
  Result := nil;
  for oAtributo in GetAttributes do
    if oAtributo is T then
      Exit((oAtributo as T));

end;

function TRttiTypeHelper.Tem<T>: Boolean;
begin
  Result := GetAttribute<T> <> nil
end;

end.
