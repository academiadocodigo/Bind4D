unit Bind4D;

interface

uses
  System.JSON,
  Vcl.Forms,
  System.Classes,
  System.Rtti,
  System.Variants,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.DBGrids,
  Vcl.Buttons,
  Data.DB, System.SysUtils;

type

  TEspecialType = (teNull, teCoin, teCell, teDate, teDateTime, teCPF, teCNPJ);
  TTypeBindFormJson = (fbGet, fbPost, fbPut, fbDelete);

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


  //Attributos de Validação

  fvNotNull = class(TCustomAttribute)
  private
    FMsg: String;
    procedure SetMsg(const Value: String);
  public
    constructor Create(aMsg : String);
    property Msg : String read FMsg write SetMsg;
  end;

  FormDefault = class(TCustomAttribute)
    private
    FTitle: String;
    procedure SetTitle(const Value: String);
    public
      constructor Create ( aTitle : String = '' );
      property Title : String read FTitle write SetTitle;
  end;

  FormRest = class(TCustomAttribute)
    private
    FPK: String;
    FEndPoint: String;
    FOrder: String;
    FSort: String;
    procedure SetEndPoint(const Value: String);
    procedure SetPK(const Value: String);
    procedure SetOrderBy(const Value: String);
    procedure SetSort(const Value: String);
    public
      constructor Create(aEndPoint : String = ''; aPK : String = ''; aSort : String = ''; aOrder : String = 'asc');
      property EndPoint : String read FEndPoint write SetEndPoint;
      property PK : String read FPK write SetPK;
      property Order : String read FOrder write SetOrderBy;
      property Sort : String read FSort write SetSort;
  end;

  ComponentBindStyle = class(TCustomAttribute)
    private
    FFontSize: Integer;
    FColor: TColor;
    FFontColor: TColor;
    FFontName: String;
    FEspecialType: TEspecialType;
    procedure SetColor(const Value: TColor);
    procedure SetFontColor(const Value: TColor);
    procedure SetFontSize(const Value: Integer);
    procedure SetFontName(const Value: String);
    procedure SetEspecialType(const Value: TEspecialType);
    public
      constructor Create(aColor : TColor = clBtnFace; aFontSize : Integer = 12; aFontColor : TColor = clBtnFace;  aFontName : String = 'Tahoma'; aEspecialType : TEspecialType = teNull);
      property Color : TColor read FColor write SetColor;
      property FontSize : Integer read FFontSize write SetFontSize;
      property FontColor : TColor read FFontColor write SetFontColor;
      property FontName : String read FFontName write SetFontName;
      property EspecialType : TEspecialType read FEspecialType write SetEspecialType;
  end;

  ComponentBindFormat = class(TCustomAttribute)
    private
    FEspecialType: TEspecialType;
    procedure SetEspecialType(const Value: TEspecialType);
    public
      constructor Create(aEspecialType : TEspecialType = teNull);
      property EspecialType : TEspecialType read FEspecialType write SetEspecialType;
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
    FFDType: TFieldType;
    FDisplayName: String;
    FWidth: Integer;
    FVisible: Boolean;
    FAlignment: TAlignment;
    FEditMask: String;
    procedure SetFieldName(const Value: String);
    procedure SetDisplayName(const Value: String);
    procedure SetWidth(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetEditMask(const Value: String);
    procedure SetFieldType(const Value: TFieldType);
    public
      constructor Create(aFieldName : String; aFdType : TFieldType; aVisible : Boolean = True; aWidth : Integer = 0; aDisplayName : String = ''; aEditMask : String = ''; aAlignment : TAlignment = taLeftJustify);
      property FieldName : String read FFieldName write SetFieldName;
      property Width : Integer read FWidth write SetWidth;
      property DisplayName : String read FDisplayName write SetDisplayName;
      property Visible : Boolean read FVisible write SetVisible;
      property Alignment : TAlignment read FAlignment write SetAlignment;
      property EditMask : String read FEditMask write SetEditMask;
      property FDType : TFieldType read FFDType write SetFieldType;
  end;

  FbIgnorePut = class(TCustomAttribute)
  end;

  FbIgnorePost = class(TCustomAttribute)
  end;

  FbIgnoreDelete = class(TCustomAttribute)
  end;

  FbIgnoreGet = class(TCustomAttribute)
  end;



  iBind4D = interface
    ['{2846B843-7533-4987-B7B4-72F7B5654D1A}']
    function Form( aValue : TForm) : iBind4D;
    function FormToJson(aType : TTypeBindFormJson) : TJsonObject;
    function ClearFieldForm : iBind4D;
    function BindDataSetToForm(aDataSet : TDataSet) : iBind4D;
    function BindFormatListDataSet(aDataSet : TDataSet; aDBGrid : TDBGrid) : iBind4D;
    function BindFormRest (var aEndPoint : String; var aPK : String; var aSort : String; var aOrder : String) : iBind4D;
    function BindFormDefault (var aTitle : String) : iBind4D;
    function GetFieldsByType (aType : TTypeBindFormJson) : String;
    function SetStyleComponents : iBind4D;
  end;

  TBind4D = class(TInterfacedObject, iBind4D)
    private
      FForm : TForm;
      function __GetComponentToValue(aComponent: TComponent; pRtti : TRttiField): String;
      procedure __BindValueToComponent(aComponent: TComponent; aFieldType : TFieldType; aValue : Variant; aEspecialType : TEspecialType = teNull);
      procedure AdjustDateTimeDataSet(prpRtti: TRttiField; aDataSet: TDataSet);
      procedure AdjustDateDataSet(prpRtti: TRttiField; aDataSet: TDataSet);
      procedure AdjustTimeDataSet(prpRtti: TRttiField; aDataSet: TDataSet);
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iBind4D;
      function Form( aValue : TForm) : iBind4D;
      function FormToJson(aType : TTypeBindFormJson) : TJsonObject;
      function ClearFieldForm : iBind4D;
      function BindDataSetToForm(aDataSet : TDataSet) : iBind4D;
      function BindFormatListDataSet(aDataSet : TDataSet; aDBGrid : TDBGrid) : iBind4D;
      function BindFormRest (var aEndPoint : String; var aPK : String; var aSort : String; var aOrder : String) : iBind4D;
      function BindFormDefault (var aTitle : String) : iBind4D;
      function GetFieldsByType (aType : TTypeBindFormJson) : String;
      function SetStyleComponents : iBind4D;
  end;

implementation

uses
  Vcl.ComCtrls,
  Vcl.Mask,
  StrUtils,
  Bind4D.Utils,
  Bind4D.ChangeCommand;

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

procedure TBind4D.__BindValueToComponent(aComponent: TComponent; aFieldType : TFieldType; aValue: Variant; aEspecialType : TEspecialType = teNull);
begin
  if VarIsNull(aValue) then exit;
  if aComponent is TEdit then
  begin
    case aFieldType of
      ftUnknown: ;
      ftBCD,
      ftBytes,
      ftVarBytes,
      ftAutoInc,
      ftBlob,
      ftMemo,
      ftGraphic,
      ftFmtMemo,
      ftParadoxOle,
      ftDBaseOle,
      ftTypedBinary,
      ftCursor,
      ftFixedChar,
      ftWideString,
      ftLargeint,
      ftADT,
      ftArray,
      ftReference,
      ftDataSet,
      ftOraBlob,
      ftOraClob,
      ftVariant,
      ftInterface,
      ftIDispatch,
      ftGuid,
      ftTimeStamp,
      ftFMTBcd,
      ftFixedWideChar,
      ftWideMemo,
      ftOraTimeStamp,
      ftOraInterval,
      ftLongWord,
      ftShortint,
      ftByte,
      ftExtended,
      ftConnection,
      ftParams,
      ftStream,
      ftTimeStampOffset,
      ftObject,
      ftSingle,
      ftString :
      begin
        (aComponent as TEdit).Text := aValue;
      end;
      ftSmallint: ;
      ftInteger:
      begin
        (aComponent as TEdit).Text := IntToStr(aValue);
      end;

      ftWord: ;
      ftBoolean:
      begin
        (aComponent as TEdit).Text := aValue.ToString;
      end;

      ftFloat,
      ftCurrency:
      begin
        (aComponent as TEdit).Text := FloatToStr(aValue);
      end;
      ftTime,
      ftDate,
      ftDateTime: ;
    end;
  end;

  if aComponent is TMaskEdit then
    (aComponent as TMaskEdit).Text := FloatToStr(aValue);
  if aComponent is TComboBox then
    (aComponent as TComboBox).ItemIndex := (aComponent as TComboBox).Items.IndexOf(aValue);
  if aComponent is TRadioGroup then
    (aComponent as TRadioGroup).ItemIndex := (aComponent as TRadioGroup).Items.IndexOf(aValue);
  if aComponent is TCheckBox then
    (aComponent as TCheckBox).Checked := aValue;
  if aComponent is TTrackBar then
    (aComponent as TTrackBar).Position := aValue;
  if aComponent is TDateTimePicker then
  begin
    case aFieldType of
      ftDate,
      ftDateTime :
      begin
        (aComponent as TDateTimePicker).Date := TBind4DUtils.FormatStrJsonToDateTime(aValue);
      end;
      ftTime :
      begin
        (aComponent as TDateTimePicker).Date := TBind4DUtils.FormatStrJsonToTime(aValue);
      end;
    end;

    exit;
  end;

  if aComponent is TShape then
    (aComponent as TShape).Brush.Color := aValue;
end;

function TBind4D.BindFormRest(var aEndPoint : String; var aPK : String; var aSort : String; var aOrder : String) : iBind4D;
var
  vCtxRtti: TRttiContext;
  vTypRtti: TRttiType;
begin
  Result := Self;
  vCtxRtti := TRttiContext.Create;
  try
    vTypRtti := vCtxRtti.GetType(FForm.ClassInfo);
    if vTypRtti.Tem<FormRest> then
      aEndPoint := vTypRtti.GetAttribute<FormRest>.FEndPoint;
      aPK := vTypRtti.GetAttribute<FormRest>.FPK;
      aOrder := vTypRtti.GetAttribute<FormRest>.FOrder;
      aSort := vTypRtti.GetAttribute<FormRest>.FSort;
  finally
    vCtxRtti.Free;
  end;
end;

function TBind4D.BindDataSetToForm(aDataSet : TDataSet) : iBind4D;
var
  ctxRtti : TRttiContext;
  typRtti : TRttiType;
  prpRtti : TRttiField;
  aEspTyp : TEspecialType;
begin
  Result := Self;
  ctxRtti := TRttiContext.Create;
  aEspTyp := teNull;
  try
    typRtti := ctxRtti.GetType(FForm.ClassInfo);
    for prpRtti in typRtti.GetFields do
    begin
      if prpRtti.Tem<FieldDataSetBind> then
      begin
        if prpRtti.Tem<ComponentBindFormat> then
          aEspTyp := prpRtti.GetAttribute<ComponentBindFormat>.FEspecialType;

        __BindValueToComponent(
                          FForm.FindComponent(prpRtti.Name),
                          prpRtti.GetAttribute<FieldDataSetBind>.FFDType,
                          aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName).AsVariant,
                          aEspTyp
        );
      end;
    end;
  finally
    ctxRtti.Free;
  end;

end;

function TBind4D.BindFormatListDataSet(aDataSet : TDataSet; aDBGrid : TDBGrid) : iBind4D;
var
  ctxRtti : TRttiContext;
  typRtti : TRttiType;
  prpRtti : TRttiField;
  aAux1: Integer;
  aAux2: Integer;
  i: Integer;
begin
  Result := Self;
  ctxRtti := TRttiContext.Create;
  try
    try
      typRtti := ctxRtti.GetType(FForm.ClassInfo);
      for prpRtti in typRtti.GetFields do
      begin
        if prpRtti.Tem<FieldDataSetBind> then
        begin
          aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName).Visible := prpRtti.GetAttribute<FieldDataSetBind>.FVisible;
          if aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName).Visible then
          begin
            aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName).DisplayLabel := prpRtti.GetAttribute<FieldDataSetBind>.FDisplayName;
            aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName).DisplayWidth := Round((prpRtti.GetAttribute<FieldDataSetBind>.FWidth * aDBGrid.Width ) / 1000);
            aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName).Alignment := prpRtti.GetAttribute<FieldDataSetBind>.FAlignment;

            if prpRtti.GetAttribute<FieldDataSetBind>.EditMask <> '' then
              case prpRtti.GetAttribute<FieldDataSetBind>.FFDType of
                ftString :
                  TStringField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName)).EditMask := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
                ftCurrency,
                ftInteger :
                  TNumericField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName)).DisplayFormat := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
                ftDateTime :
                begin
                  AdjustDateTimeDataSet(prpRtti, aDataSet);
                  TStringField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName)).EditMask := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
                end;
                ftDate :
                begin
                  AdjustDateDataSet(prpRtti, aDataSet);
                  TStringField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName)).EditMask := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
                end;
                ftTime :
                begin
                  AdjustTimeDataSet(prpRtti, aDataSet);
                  TStringField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName)).EditMask := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
                end

                else
                  TStringField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName)).EditMask := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
              end;

//            if prpRtti.GetAttribute<FieldDataSetBind>.EditMask <> '' then
//              TNumericField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName)).DisplayFormat := prpRtti.GetAttribute<FieldDataSetBind>.EditMask
//            else
//              TStringField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName)).EditMask := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
          end;
        end;
        //else
          //aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName).Visible := False;

      end;

      aAux1 := 0;
      for i := 0 to aDBGrid.Columns.Count-1 do
        aAux1 := aAux1 + aDBGrid.Columns[i].Width;

      aAux2 := Round(((aDBGrid.Width - 29) - aAux1) / aDBGrid.Columns.Count);

      for i := 0 to aDBGrid.Columns.Count-1 do
        aDBGrid.Columns[i].Width := aDBGrid.Columns[i].Width + aAux2;

    except
      //
    end;
  finally
    ctxRtti.Free;
  end;
end;

function TBind4D.BindFormDefault(var aTitle : String) : iBind4D;
var
  vCtxRtti: TRttiContext;
  vTypRtti: TRttiType;
begin
  Result := Self;
  vCtxRtti := TRttiContext.Create;
  try
    vTypRtti := vCtxRtti.GetType(FForm.ClassInfo);
    if vTypRtti.Tem<FormDefault> then
      aTitle := vTypRtti.GetAttribute<FormDefault>.FTitle;
  finally
    vCtxRtti.Free;
  end;
end;

function TBind4D.ClearFieldForm: iBind4D;
var
  ctxRtti : TRttiContext;
  typRtti : TRttiType;
  prpRtti : TRttiField;
  aComponent : TComponent;
begin
  Result := Self;
  ctxRtti := TRttiContext.Create;
  try
    typRtti := ctxRtti.GetType(FForm.ClassInfo);
    for prpRtti in typRtti.GetFields do
    begin
      aComponent := FForm.FindComponent(prpRtti.Name);
      if aComponent is TEdit then
        (aComponent as TEdit).Text := '';
      if aComponent is TMaskEdit then
        (aComponent as TMaskEdit).Text := '';
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

constructor TBind4D.Create;
begin

end;

destructor TBind4D.Destroy;
begin

  inherited;
end;

function TBind4D.Form( aValue : TForm) : iBind4D;
begin
  Result := Self;
  FForm := aValue;
end;

function TBind4D.FormToJson(aType : TTypeBindFormJson) : TJsonObject;
var
  ctxRtti : TRttiContext;
  typRtti : TRttiType;
  prpRtti : TRttiField;
begin
  ctxRtti := TRttiContext.Create;
  Result := TJsonObject.Create;
  try
    try
      typRtti := ctxRtti.GetType(FForm.ClassInfo);
      for prpRtti in typRtti.GetFields do
      begin
        if prpRtti.Tem<FieldJsonBind> then
        begin
          case aType of
            fbGet:
            begin
              try
                Result
                  .AddPair(
                    prpRtti.GetAttribute<FieldJsonBind>.FJsonName,
                    __GetComponentToValue(FForm.FindComponent(prpRtti.Name), prpRtti)
                  );
              except
                Result.Free;
              end;
            end;
            fbPost:
            begin
              if not prpRtti.Tem<FbIgnorePost> then
                  Result
                    .AddPair(
                      prpRtti.GetAttribute<FieldJsonBind>.FJsonName,
                      __GetComponentToValue(FForm.FindComponent(prpRtti.Name), prpRtti)
                    );
            end;
            fbPut:
            begin
              if not prpRtti.Tem<FbIgnorePut> then
                Result
                  .AddPair(
                    prpRtti.GetAttribute<FieldJsonBind>.FJsonName,
                    __GetComponentToValue(FForm.FindComponent(prpRtti.Name), prpRtti)
                  );
            end;
            fbDelete:
            begin
              if not prpRtti.Tem<FbIgnoreDelete> then
                Result
                  .AddPair(
                    prpRtti.GetAttribute<FieldJsonBind>.FJsonName,
                    __GetComponentToValue(FForm.FindComponent(prpRtti.Name), prpRtti)
                  );
            end;
          end;
        end;
      end;
      except on e : exception do
      begin
          if assigned(Result) then Result.Free;
          raise Exception.Create(e.Message);
      end;
    end;
  finally
    ctxRtti.Free;
  end;
end;

function TBind4D.GetFieldsByType(aType : TTypeBindFormJson) : String;
var
  ctxRtti : TRttiContext;
  typRtti : TRttiType;
  prpRtti : TRttiField;
begin
  ctxRtti := TRttiContext.Create;
  try
    typRtti := ctxRtti.GetType(FForm.ClassInfo);
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

function TBind4D.__GetComponentToValue(aComponent: TComponent; pRtti : TRttiField): String;
begin
  if aComponent is TEdit then
  begin
    Result := (aComponent as TEdit).Text;

    if pRtti.Tem<fvNotNull> then
    begin
      if Trim((aComponent as TEdit).Text) = '' then
        if pRtti.Tem<FieldDataSetBind> then
        begin
          (aComponent as TEdit).SetFocus;
          raise Exception.Create(pRtti.GetAttribute<fvNotNull>.FMsg);
        end;

    end;

    if pRtti.Tem<ComponentBindStyle> then
    begin
      case pRtti.GetAttribute<ComponentBindStyle>.FEspecialType of
        teNull : Result := (aComponent as TEdit).Text;
        teCoin : Result := TBind4DUtils.ExtrairMoeda((aComponent as TEdit).Text);
        teCell : Result := TBind4DUtils.ApenasNumeros((aComponent as TEdit).Text);
        teCPF  : Result := TBind4DUtils.ApenasNumeros((aComponent as TEdit).Text);
        teCNPJ  : Result := TBind4DUtils.ApenasNumeros((aComponent as TEdit).Text);
      end;
    end;
    exit;
  end;

  if aComponent is TMaskEdit then
    Result := (aComponent as TMaskEdit).Text;
  if aComponent is TComboBox then
    Result := (aComponent as TComboBox).Items[(aComponent as TComboBox).ItemIndex];
  if aComponent is TRadioGroup then
    Result := (aComponent as TRadioGroup).Items[(aComponent as TRadioGroup).ItemIndex];
  if aComponent is TCheckBox then
    Result := (aComponent as TCheckBox).Checked.ToString();
  if aComponent is TTrackBar then
    Result := (aComponent as TTrackBar).Position.ToString;
  if aComponent is TDateTimePicker then
    Result := TBind4DUtils.FormatDateTimeToJson((aComponent as TDateTimePicker).DateTime);
//  if aComponent is TShape then
//    Result := ColorToString((aComponent as TShape).Brush.Color);
end;

class function TBind4D.New: iBind4D;
begin
  Result := Self.Create;
end;

function TBind4D.SetStyleComponents: iBind4D;
var
  ctxRtti : TRttiContext;
  typRtti : TRttiType;
  prpRtti : TRttiField;
  aComponent : TComponent;
begin
  Result := Self;
  ctxRtti := TRttiContext.Create;
  try
    typRtti := ctxRtti.GetType(FForm.ClassInfo);
    for prpRtti in typRtti.GetFields do
    begin
      if prpRtti.Tem<ComponentBindStyle> then
      begin
        aComponent := FForm.FindComponent(prpRtti.Name);

        if aComponent is TEdit then
        begin

          (aComponent as TEdit).StyleElements := [seClient, seBorder];
          (aComponent as TEdit).Color := prpRtti.GetAttribute<ComponentBindStyle>.FColor;
          (aComponent as TEdit).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FFontSize;
          (aComponent as TEdit).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FFontColor;
          (aComponent as TEdit).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FFontName;

          (aComponent as TEdit).OnChange :=
            TBind4DUtils.AnonProc2NotifyEvent(
              (aComponent  as TEdit),
              procedure (Sender : TObject)
              begin
                TCommandMaster.New.Execute(Sender);
              end
            );

          case prpRtti.GetAttribute<ComponentBindStyle>.FEspecialType of
            teCoin :
            begin
              TCommandMaster.New.Add(
                  (aComponent as TEdit),
                  procedure (Sender : TObject)
                  begin
                    (Sender as TEdit).Text := TBind4DUtils.FormatarMoeda((Sender as TEdit).Text);
                    (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
                  end
              )
            end;
            teCell :
            begin
                TCommandMaster.New.Add(
                    (aComponent as TEdit),
                    procedure (Sender : TObject)
                    begin
                      (Sender as TEdit).Text := TBind4DUtils.FormatarCelular((Sender as TEdit).Text);
                      (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
                    end
                )
            end;
            teCPF :
            begin
              TCommandMaster.New.Add(
                    (aComponent as TEdit),
                    procedure (Sender : TObject)
                    begin
                      (Sender as TEdit).Text := TBind4DUtils.FormatarCPF((Sender as TEdit).Text);
                      (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
                    end
                )
            end;
            teCNPJ :
            begin
              TCommandMaster.New.Add(
                    (aComponent as TEdit),
                    procedure (Sender : TObject)
                    begin
                      (Sender as TEdit).Text := TBind4DUtils.FormatarCNPJ((Sender as TEdit).Text);
                      (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
                    end
              )
            end;
            teNull : ;
          end;
        end;

        if aComponent is TPanel then
        begin
          (aComponent as TPanel).ParentBackground := False;
          (aComponent as TPanel).Color := prpRtti.GetAttribute<ComponentBindStyle>.FColor;
          (aComponent as TPanel).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FFontSize;
          (aComponent as TPanel).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FFontColor;
          (aComponent as TPanel).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FFontName;
        end;

        if aComponent is TLabel then
        begin
          (aComponent as TLabel).StyleElements := [seClient, seBorder];
          (aComponent as TLabel).Color := prpRtti.GetAttribute<ComponentBindStyle>.FColor;
          (aComponent as TLabel).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FFontSize;
          (aComponent as TLabel).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FFontColor;
          (aComponent as TLabel).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FFontName;
        end;

        if aComponent is TMaskEdit then
        begin
          (aComponent as TMaskEdit).StyleElements := [seClient, seBorder];
          (aComponent as TMaskEdit).Color := prpRtti.GetAttribute<ComponentBindStyle>.FColor;
          (aComponent as TMaskEdit).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FFontSize;
          (aComponent as TMaskEdit).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FFontColor;
          (aComponent as TMaskEdit).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FFontName;
        end;

        if aComponent is TDBGrid then
        begin
          (aComponent as TDBGrid).StyleElements := [seClient, seBorder];
          (aComponent as TDBGrid).Color := prpRtti.GetAttribute<ComponentBindStyle>.FColor;
          (aComponent as TDBGrid).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FFontSize;
          (aComponent as TDBGrid).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FFontColor;
          (aComponent as TDBGrid).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FFontName;
        end;

        if aComponent is TSpeedButton then
        begin
          (aComponent as TSpeedButton).StyleElements := [seClient, seBorder];
          (aComponent as TSpeedButton).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FFontSize;
          (aComponent as TSpeedButton).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FFontColor;
          (aComponent as TSpeedButton).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FFontName;
        end;

        if aComponent is TDateTimePicker then
        begin
          (aComponent as TDateTimePicker).StyleElements := [seClient, seBorder];
          (aComponent as TDateTimePicker).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FFontSize;
          (aComponent as TDateTimePicker).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FFontColor;
          (aComponent as TDateTimePicker).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FFontName;
        end;

//        if aComponent is TComboBox then
//        begin
//          (aComponent as TComboBox).ItemIndex := -1;
//        end;
//
//        if aComponent is TRadioGroup then
//        begin
//          (aComponent as TRadioGroup).ItemIndex := -1;
//        end;
//
//        if aComponent is TTrackBar then
//        begin
//          (aComponent as TTrackBar).Position := 0;
//        end;
//
//        if aComponent is TDateTimePicker then
//        begin
//          (aComponent as TDateTimePicker).Date := now;
//        end;

      end;

    end;
  finally
    ctxRtti.Free;
  end;

end;

procedure TBind4D.AdjustDateDataSet(prpRtti: TRttiField; aDataSet: TDataSet);
begin
  aDataSet.DisableControls;
  while not aDataSet.Eof do
  begin
    aDataSet.Edit;
    aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName).Value := TBind4DUtils.FormatDateDataSet(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName).AsString);
    aDataSet.Post;
    aDataSet.Next;
  end;
  aDataSet.First;
  aDataSet.EnableControls;
end;

procedure TBind4D.AdjustDateTimeDataSet(prpRtti: TRttiField; aDataSet: TDataSet);
begin
  aDataSet.DisableControls;
  while not aDataSet.Eof do
  begin
    aDataSet.Edit;
    aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName).Value := TBind4DUtils.FormatDateTimeDataSet(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName).AsString);
    aDataSet.Post;
    aDataSet.Next;
  end;
  aDataSet.First;
  aDataSet.EnableControls;

end;

procedure TBind4D.AdjustTimeDataSet(prpRtti: TRttiField; aDataSet: TDataSet);
begin
  aDataSet.DisableControls;
  while not aDataSet.Eof do
  begin
    aDataSet.Edit;
    aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName).Value := TBind4DUtils.FormatTimeDataSet(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FFieldName).AsString);
    aDataSet.Post;
    aDataSet.Next;
  end;
  aDataSet.First;
  aDataSet.EnableControls;
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

constructor FieldDataSetBind.Create(aFieldName : String; aFdType : TFieldType; aVisible : Boolean = True; aWidth : Integer = 0; aDisplayName : String = ''; aEditMask : String = ''; aAlignment : TAlignment = taLeftJustify);
begin
  FFieldName := aFieldName;
  FWidth := aWidth;
  FDisplayName := aDisplayName;
  FVisible := aVisible;
  FAlignment := aAlignment;
  FEditMask := aEditMask;
  FFdType := aFdType;
end;

procedure FieldDataSetBind.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
end;

procedure FieldDataSetBind.SetDisplayName(const Value: String);
begin
  FDisplayName := Value;
end;

procedure FieldDataSetBind.SetEditMask(const Value: String);
begin
  FEditMask := Value;
end;

procedure FieldDataSetBind.SetFieldName(const Value: String);
begin
  FFieldName := Value;
end;

procedure FieldDataSetBind.SetFieldType(const Value: TFieldType);
begin
  FFDType := Value;
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

constructor FormRest.Create(aEndPoint : String = ''; aPK : String = ''; aSort : String = ''; aOrder : String = 'asc');
begin
  FEndPoint := aEndPoint;
  FPK := aPK;
  FOrder := aOrder;
  FSort := aSort;
end;

procedure FormRest.SetEndPoint(const Value: String);
begin
  FEndPoint := Value;
end;

procedure FormRest.SetOrderBy(const Value: String);
begin
  FOrder := Value;
end;

procedure FormRest.SetPK(const Value: String);
begin
  FPK := Value;
end;

procedure FormRest.SetSort(const Value: String);
begin
  FSort := Value;
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

constructor ComponentBindStyle.Create(aColor : TColor = clBtnFace; aFontSize : Integer = 12; aFontColor : TColor = clBtnFace;  aFontName : String = 'Tahoma'; aEspecialType : TEspecialType = teNull);
begin
  FColor := aColor;
  FFontSize := aFontSize;
  FFontColor := aFontColor;
  FFontName := aFontName;
  FEspecialType := aEspecialType;
end;

procedure ComponentBindStyle.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

procedure ComponentBindStyle.SetEspecialType(const Value: TEspecialType);
begin
  FEspecialType := Value;
end;

procedure ComponentBindStyle.SetFontColor(const Value: TColor);
begin
  FFontColor := Value;
end;

procedure ComponentBindStyle.SetFontName(const Value: String);
begin
  FFontName := Value;
end;

procedure ComponentBindStyle.SetFontSize(const Value: Integer);
begin
  FFontSize := Value;
end;

{ FormDefault }

constructor FormDefault.Create(aTitle: String);
begin
  FTitle := aTitle;
end;

procedure FormDefault.SetTitle(const Value: String);
begin
  FTitle := Value;
end;

{ ComponenteBindFormat }

constructor ComponentBindFormat.Create(aEspecialType: TEspecialType);
begin
  FEspecialType := aEspecialType;
end;

procedure ComponentBindFormat.SetEspecialType(const Value: TEspecialType);
begin
  FEspecialType := Value;
end;


{ fvNotNull }

constructor fvNotNull.Create(aMsg: String);
begin
  FMsg := aMsg;
end;

procedure fvNotNull.SetMsg(const Value: String);
begin
  FMsg := Value;
end;

end.
