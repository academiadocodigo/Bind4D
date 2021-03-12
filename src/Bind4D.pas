unit Bind4D;

{$I Bind4D.inc}

interface

uses
  System.JSON,
  {$IFDEF HAS_FMX}
  FMX.Forms,
  FMX.Graphics,
  FMX.Controls,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.ExtCtrls,
  FMX.Edit,
  FMX.ListBox,
  FMX.Objects,
  FMX.Types,
  System.UITypes,
  FMX.DateTimeCtrls,
  {$ELSE}
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.DBGrids,
  Vcl.Buttons,
  {$ENDIF}
  System.Classes,
  System.Rtti,
  System.SysUtils,
  System.Variants,
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

  ComponentBindStyle = class(TCustomAttribute)
    private
    FFontSize: Integer;
    {$IFDEF HAS_FMX}
    FColor: TAlphaColor;
    FFontColor: TAlphaColor;
    {$ELSE}
    FColor: TColor;
    FFontColor: TColor;
    {$ENDIF}
    FFontName: String;
    {$IFDEF HAS_FMX}
    procedure SetColor(const Value: TAlphaColor);
    procedure SetFontColor(const Value: TAlphaColor);
    {$ELSE}
    procedure SetColor(const Value: TColor);
    procedure SetFontColor(const Value: TColor);
    {$ENDIF}
    procedure SetFontSize(const Value: Integer);
    procedure SetFontName(const Value: String);
    public
      {$IFDEF HAS_FMX}
      constructor Create( aColor : TAlphaColor; aFontSize : Integer; aFontColor : TAlphaColor; aFontName : String = 'Tahoma');
      property Color : TAlphaColor read FColor write SetColor;
      property FontColor : TAlphaColor read FFontColor write SetFontColor;
      {$ELSE}
      constructor Create( aColor : TColor; aFontSize : Integer; aFontColor : TColor; aFontName : String = 'Tahoma');
      property Color : TColor read FColor write SetColor;
      property FontColor : TColor read FFontColor write SetFontColor;
      {$ENDIF}
      property FontSize : Integer read FFontSize write SetFontSize;
      property FontName : String read FFontName write SetFontName;
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

  iBind4D = interface
    ['{2846B843-7533-4987-B7B4-72F7B5654D1A}']
    function FormToJson(aForm : TForm; aType : TTypeBindFormJson) : TJsonObject;
    procedure ClearFieldForm(aForm : TForm);
    procedure BindDataSetToForm(aForm : TForm; aDataSet : TDataSet);
    procedure BindFormatListDataSet(aForm : TForm; aDataSet : TDataSet);
    procedure BindClassToForm (aForm : TForm; var aEndPoint : String; var aPK : String; var aTitle : String);
    function GetFieldsByType (aForm : TForm; aType : TTypeBindFormJson) : String;
    procedure SetStyleComponents (aForm : TForm);
  end;

  TBind4D = class(TInterfacedObject, iBind4D)
    private
      function __GetComponentToValue(aComponent: TComponent): TValue;
      procedure __BindValueToComponent(aComponent: TComponent; aValue: Variant);
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iBind4D;
      function FormToJson(aForm : TForm; aType : TTypeBindFormJson) : TJsonObject;
      procedure ClearFieldForm(aForm : TForm);
      procedure BindDataSetToForm(aForm : TForm; aDataSet : TDataSet);
      procedure BindFormatListDataSet(aForm : TForm; aDataSet : TDataSet);
      procedure BindClassToForm (aForm : TForm; var aEndPoint : String; var aPK : String; var aTitle : String);
      function GetFieldsByType (aForm : TForm; aType : TTypeBindFormJson) : String;
      procedure SetStyleComponents (aForm : TForm);
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

{ TBind4D }

procedure TBind4D.__BindValueToComponent(aComponent: TComponent;
  aValue: Variant);
begin
  if VarIsNull(aValue) then exit;
  {$IFDEF HAS_FMX}
  if aComponent is TCheckBox then
    (aComponent as TCheckBox).isChecked := aValue;
  if aComponent is TRadioButton then
    (aComponent as TRadioButton).isChecked := aValue;
  if aComponent is TShape then
    (aComponent as TShape).Fill.Color := aValue;
    if aComponent is TDateEdit then
    (aComponent as TDateEdit).Date := aValue;
  {$ELSE}
  if aComponent is TRadioGroup then
    (aComponent as TRadioGroup).ItemIndex := (aComponent as TRadioGroup).Items.IndexOf(aValue);
  if aComponent is TCheckBox then
    (aComponent as TCheckBox).Checked := aValue;
  if aComponent is TShape then
    (aComponent as TShape).Brush.Color := aValue;
  if aComponent is TDateTimePicker then
    (aComponent as TDateTimePicker).Date := aValue;
  {$ENDIF}
  if aComponent is TEdit then
    (aComponent as TEdit).Text := aValue;
  if aComponent is TComboBox then
    (aComponent as TComboBox).ItemIndex := (aComponent as TComboBox).Items.IndexOf(aValue);
  if aComponent is TTrackBar then
    (aComponent as TTrackBar).Position := aValue;
end;

procedure TBind4D.BindClassToForm(aForm : TForm; var aEndPoint : String; var aPK : String; var aTitle : String);
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

procedure TBind4D.BindDataSetToForm(aForm: TForm; aDataSet: TDataSet);
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

procedure TBind4D.BindFormatListDataSet(aForm: TForm; aDataSet: TDataSet);
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

procedure TBind4D.ClearFieldForm(aForm : TForm);
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
      {$IFDEF HAS_FMX}
      if aComponent is TDateEdit then
        (aComponent as TDateEdit).Date := now;
      {$ELSE}
      if aComponent is TRadioGroup then
        (aComponent as TRadioGroup).ItemIndex := -1;
      if aComponent is TDateTimePicker then
        (aComponent as TDateTimePicker).Date := now;
      {$ENDIF}
      if aComponent is TTrackBar then
        (aComponent as TTrackBar).Position := 0;
    end;
  finally
    ctxRtti.Free;
  end;

end;

constructor TBind4D.Create;
begin

end;

destructor TBind4D.Destroy;
begin

  inherited;
end;

function TBind4D.FormToJson(aForm : TForm; aType : TTypeBindFormJson) : TJsonObject;
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

function TBind4D.GetFieldsByType(aForm : TForm; aType : TTypeBindFormJson) : String;
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

function TBind4D.__GetComponentToValue(aComponent: TComponent): TValue;
var
  a: string;
begin
  if aComponent is TEdit then
    Result := TValue.FromVariant((aComponent as TEdit).Text);
  if aComponent is TComboBox then
    Result := TValue.FromVariant((aComponent as TComboBox).Items[(aComponent as TComboBox).ItemIndex]);
  {$IFDEF HAS_FMX}
  if aComponent is TCheckBox then
    Result := TValue.FromVariant((aComponent as TCheckBox).isChecked);
  if aComponent is TShape then
    Result := TValue.FromVariant((aComponent as TShape).Fill.Color);
  if aComponent is TDateEdit then
    Result := TValue.FromVariant((aComponent as TDateEdit).DateTime);
  {$ELSE}
  if aComponent is TRadioGroup then
    Result := TValue.FromVariant((aComponent as TRadioGroup).Items[(aComponent as TRadioGroup).ItemIndex]);
  if aComponent is TCheckBox then
    Result := TValue.FromVariant((aComponent as TCheckBox).Checked);
  if aComponent is TShape then
    Result := TValue.FromVariant((aComponent as TShape).Brush.Color);
  if aComponent is TDateTimePicker then
    Result := TValue.FromVariant((aComponent as TDateTimePicker).DateTime);
  {$ENDIF}
  if aComponent is TTrackBar then
    Result := TValue.FromVariant((aComponent as TTrackBar).Position);
  a := Result.TOString;
end;

class function TBind4D.New: iBind4D;
begin
  Result := Self.Create;
end;



procedure TBind4D.SetStyleComponents(aForm: TForm);
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
      if prpRtti.Tem<ComponentBindStyle> then
      begin
        aComponent := aForm.FindComponent(prpRtti.Name);

        {$IFDEF HAS_FMX}
        {$ELSE}
        if aComponent is TPanel then
        begin
          (aComponent as TPanel).ParentBackground := False;
          (aComponent as TPanel).Color := prpRtti.GetAttribute<ComponentBindStyle>.FColor;
          (aComponent as TPanel).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FFontSize;
          (aComponent as TPanel).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FFontColor;
          (aComponent as TPanel).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FFontName;
        end;
        {$ENDIF}

        if aComponent is TLabel then
        begin
          {$IFDEF HAS_FMX}
          (aComponent as TLabel).StyledSettings := [TStyledSetting.Family, TStyledSetting.Size, TStyledSetting.Style];
          (aComponent as TLabel).TextSettings.FontColor := prpRtti.GetAttribute<ComponentBindStyle>.FFontColor;
          (aComponent as TLabel).TextSettings.Font.Family := prpRtti.GetAttribute<ComponentBindStyle>.FFontName;
          {$ELSE}
          (aComponent as TLabel).StyleElements := [seClient, seBorder];
          (aComponent as TLabel).Color := prpRtti.GetAttribute<ComponentBindStyle>.FColor;
          (aComponent as TLabel).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FFontColor;
          (aComponent as TLabel).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FFontName;
          {$ENDIF}
          (aComponent as TLabel).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FFontSize;
        end;

        if aComponent is TEdit then
        begin
          {$IFDEF HAS_FMX}
          (aComponent as TEdit).StyledSettings := [TStyledSetting.Family,TStyledSetting.Size, TStyledSetting.Style, TStyledSetting.FontColor];
          (aComponent as TEdit).TextSettings.Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FFontSize;
          (aComponent as TEdit).TextSettings.FontColor := prpRtti.GetAttribute<ComponentBindStyle>.FFontColor;
          (aComponent as TEdit).TextSettings.Font.Family := prpRtti.GetAttribute<ComponentBindStyle>.FFontName;
          {$ELSE}
          (aComponent as TEdit).StyleElements := [seClient, seBorder];
          (aComponent as TEdit).Color := prpRtti.GetAttribute<ComponentBindStyle>.FColor;
          (aComponent as TEdit).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FFontSize;
          (aComponent as TEdit).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FFontColor;
          (aComponent as TEdit).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FFontName;
          {$ENDIF}
        end;

        {$IFDEF HAS_FMX}
        {$ELSE}
        if aComponent is TDBGrid then
        begin
          (aComponent as TDBGrid).StyleElements := [seClient, seBorder];
          (aComponent as TDBGrid).Color := prpRtti.GetAttribute<ComponentBindStyle>.FColor;
          (aComponent as TDBGrid).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FFontSize;
          (aComponent as TDBGrid).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FFontColor;
          (aComponent as TDBGrid).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FFontName;
        end;
        {$ENDIF}

        if aComponent is TSpeedButton then
        begin
          {$IFDEF HAS_FMX}
          (aComponent as TSpeedButton).StyledSettings := [TStyledSetting.Family,TStyledSetting.Size, TStyledSetting.Style, TStyledSetting.FontColor];;
          (aComponent as TSpeedButton).TextSettings.Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FFontSize;
          (aComponent as TSpeedButton).TextSettings.FontColor := prpRtti.GetAttribute<ComponentBindStyle>.FFontColor;
          (aComponent as TSpeedButton).TextSettings.Font.Family := prpRtti.GetAttribute<ComponentBindStyle>.FFontName;
          {$ELSE}
          (aComponent as TSpeedButton).StyleElements := [seClient, seBorder];
          (aComponent as TSpeedButton).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FFontSize;
          (aComponent as TSpeedButton).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FFontColor;
          (aComponent as TSpeedButton).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FFontName;
          {$ENDIF}
        end;
      end;

    end;
  finally
    ctxRtti.Free;
  end;

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

{ ComponentBindStyle }

{$IFDEF HAS_FMX}
constructor ComponentBindStyle.Create( aColor : TAlphaColor; aFontSize : Integer; aFontColor : TAlphaColor; aFontName : String = 'Tahoma');
begin
  FColor := aColor;
  FFontSize := aFontSize;
  FFontColor := aFontColor;
  FFontName := aFontName;
end;

procedure ComponentBindStyle.SetColor(const Value: TAlphaColor);
begin
  FColor := Value;
end;

procedure ComponentBindStyle.SetFontColor(const Value: TAlphaColor);
begin
  FFontColor := Value;
end;
{$ELSE}
constructor ComponentBindStyle.Create( aColor : TColor; aFontSize : Integer; aFontColor : TColor; aFontName : String = 'Tahoma');
begin
  FColor := aColor;
  FFontSize := aFontSize;
  FFontColor := aFontColor;
  FFontName := aFontName;
end;

procedure ComponentBindStyle.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

procedure ComponentBindStyle.SetFontColor(const Value: TColor);
begin
  FFontColor := Value;
end;
{$ENDIF}

procedure ComponentBindStyle.SetFontName(const Value: String);
begin
  FFontName := Value;
end;

procedure ComponentBindStyle.SetFontSize(const Value: Integer);
begin
  FFontSize := Value;
end;

end.
