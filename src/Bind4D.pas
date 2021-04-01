unit Bind4D;

interface

uses
  System.JSON,
  System.Classes,
  System.Rtti,
  System.Variants,
  {$IFDEF HAS_FMX}
    FMX.Types,
    FMX.Controls,
    FMX.Forms,
    FMX.Graphics,
    FMX.Dialogs,
    FMX.Layouts,
    FMX.Objects,
    FMX.Grid.Style,
    FMX.Controls.Presentation,
    FMX.ScrollBox,
    FMX.Grid,
    FMX.StdCtrls,
    FMX.Edit,
    FMX.ListBox,
    FMX.DateTimeCtrls,
    FMX.ComboEdit,
  {$ELSE}
    Vcl.Forms,
    Vcl.Graphics,
    Vcl.Controls,
    Vcl.Dialogs,
    Vcl.StdCtrls,
    Vcl.ExtCtrls,
    Vcl.DBGrids,
    Vcl.Buttons,
    Vcl.ComCtrls,
    Vcl.Mask,
  {$ENDIF}

  Data.DB,
  System.SysUtils,
  Translator4D,
  Translator4D.Interfaces,
  Bind4D.Types,
  Bind4D.Interfaces,
  Bind4D.Utils,
  AWS4D.Interfaces,
  AWS4D;

type
  TBind4D = class(TInterfacedObject, iBind4D)
    private
      FForm : TForm;
      FAWSService : iAWS4D;
      function __GetComponentToValue(aComponent: TComponent; pRtti : TRttiField): String;
      procedure __BindValueToComponent(aComponent: TComponent; aFieldType : TFieldType; aValue : Variant; aTField : TField; pRtti : TRttiField; aEspecialType : TEspecialType = teNull);
      procedure __BindResourceImageToComponent(pRtti : TRttiField);
      procedure __BindCaptionToComponent(aComponent : TComponent; pRtti : TRttiField);
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
      {$IFDEF HAS_FMX}
        function BindFormatListDataSet(aDataSet : TDataSet; aDBGrid : TStringGrid) : iBind4D;
      {$ELSE}
        function BindFormatListDataSet(aDataSet : TDataSet; aDBGrid : TDBGrid) : iBind4D;
      {$ENDIF}
      function BindFormRest (var aEndPoint : String; var aPK : String; var aSort : String; var aOrder : String) : iBind4D;
      function BindFormDefault (var aTitle : String) : iBind4D;
      function GetFieldsByType (aType : TTypeBindFormJson) : String;
      function SetStyleComponents : iBind4D;
      function Translator : iTranslator4D;
      function AWSService : iAWS4D;
  end;

var
  vBind4D : iBind4D;

implementation

uses
  StrUtils,
  Bind4D.ChangeCommand,
  System.NetEncoding,
  Data.Cloud.CloudAPI,
  Data.Cloud.AmazonAPI,
  System.Types,
  Bind4D.Helpers,
  Bind4D.Attributes, 
  Bind4D.ImageList,
  Bind4D.Image;

{ TBind4D }

procedure TBind4D.__BindCaptionToComponent(aComponent: TComponent;
  pRtti: TRttiField);
begin
  if aComponent is TLabel then
    if pRtti.Tem<Translation> then
    {$IFDEF HAS_FMX}
      (aComponent as TLabel).Text :=
        TTranslator4D
          .New
            .Google
              .Params
                .Query(pRtti.GetAttribute<Translation>.Query)
              .&End
            .Execute;
    {$ELSE}
      (aComponent as TLabel).Caption :=
        TTranslator4D
          .New
            .Google
              .Params
                .Query(pRtti.GetAttribute<Translation>.Query)
              .&End
            .Execute;
    {$ENDIF}


  if aComponent is TSpeedButton then
    if pRtti.Tem<Translation> then
    {$IFDEF HAS_FMX}
      (aComponent as TSpeedButton).Text :=
        TTranslator4D
          .New
            .Google
              .Params
                .Query(pRtti.GetAttribute<Translation>.Query)
              .&End
            .Execute;
    {$ELSE}
      (aComponent as TSpeedButton).Caption :=
        TTranslator4D
          .New
            .Google
              .Params
                .Query(pRtti.GetAttribute<Translation>.Query)
              .&End
            .Execute;
    {$ENDIF}

end;

procedure TBind4D.__BindResourceImageToComponent(pRtti : TRttiField);
var
  aComponent : TComponent;
begin
  aComponent := FForm.FindComponent(pRtti.Name);
  if (aComponent is TSpeedButton) then
  begin
    if pRtti.Tem<ImageAttribute> then
    begin
      {$IFDEF HAS_FMX}
      {$ELSE}
        TBind4DImageList
        .New(
          pRtti.GetAttribute<ImageAttribute>.Width,
          pRtti.GetAttribute<ImageAttribute>.Heigth)
        .LoadImageResource(
          pRtti.GetAttribute<ImageAttribute>.DefaultResourceImage,
          (aComponent as TSpeedButton).Glyph
        );
      {$ENDIF}
    end;
  end;

  if (aComponent is TImage) then
  begin
    if pRtti.Tem<ImageAttribute> then
    begin
      TBind4DImage
        .New
          .LoadResource(
            pRtti.GetAttribute<ImageAttribute>.DefaultResourceImage,
            (aComponent as TImage)
          )
    end;
  end;
    
end;

procedure TBind4D.__BindValueToComponent(aComponent: TComponent; aFieldType : TFieldType; aValue : Variant; aTField : TField; pRtti : TRttiField; aEspecialType : TEspecialType = teNull);
var
  FFileName: string;
begin
  if VarIsNull(aValue) then
  begin
    if aComponent is TImage then
      if pRtti.Tem<ImageAttribute> then
        TBind4DUtils.LoadDefaultResourceImage((aComponent as TImage), pRtti.GetAttribute<ImageAttribute>.DefaultResourceImage);
    exit;
  end;
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

  {$IFDEF HAS_FMX}
    if aComponent is TCheckBox then
      (aComponent as TCheckBox).IsChecked := aValue;
    if aComponent is TTrackBar then
      (aComponent as TTrackBar).Value := aValue;

    if aComponent is TDateEdit then
    begin
      case aFieldType of
        ftDate,
        ftDateTime :
        begin
          (aComponent as TDateEdit).Date := TBind4DUtils.FormatStrJsonToDateTime(aValue);
        end;
        ftTime :
        begin
          (aComponent as TDateEdit).Date := TBind4DUtils.FormatStrJsonToTime(aValue);
        end;
      end;
      exit;
    end;


  {$ELSE}
    if aComponent is TMaskEdit then
      (aComponent as TMaskEdit).Text := FloatToStr(aValue);
    if aComponent is TRadioGroup then
      (aComponent as TRadioGroup).ItemIndex := (aComponent as TRadioGroup).Items.IndexOf(aValue);
    if aComponent is TCheckBox then
      (aComponent as TCheckBox).Checked := aValue;
    if aComponent is TTrackBar then
      (aComponent as TTrackBar).Position := aValue;
    if aComponent is TShape then
      (aComponent as TShape).Brush.Color := aValue;
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
  {$ENDIF}

  if aComponent is TComboBox then
    (aComponent as TComboBox).ItemIndex := (aComponent as TComboBox).Items.IndexOf(aValue);

  if aComponent is TImage then
    if pRtti.Tem<S3Storage> then
    begin
      TBind4DUtils.GetImageS3Storage((aComponent as TImage), aValue, pRtti, FFileName);
      {$IFDEF HAS_FMX}
        (aComponent as TImage).Hint := FFileName;
      {$ELSE}
        (aComponent as TImage).HelpKeyword := FFileName;
      {$ENDIF}

    end;

      //TBind4DUtils.GetImageS3Storage((aComponent as TImage),  aValue, pRtti);
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
    begin
      aEndPoint := vTypRtti.GetAttribute<FormRest>.EndPoint;
      aPK := vTypRtti.GetAttribute<FormRest>.PK;
      aOrder := vTypRtti.GetAttribute<FormRest>.Order;
      aSort := vTypRtti.GetAttribute<FormRest>.Sort;
    end;
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
          aEspTyp := prpRtti.GetAttribute<ComponentBindFormat>.EspecialType;

        __BindValueToComponent(
                          FForm.FindComponent(prpRtti.Name),
                          prpRtti.GetAttribute<FieldDataSetBind>.FDType,
                          aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).AsVariant,
                          aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName),
                          prpRtti,
                          aEspTyp
        );
      end;
    end;
  finally
    ctxRtti.Free;
  end;

end;

{$IFDEF HAS_FMX}
function TBind4D.BindFormatListDataSet(aDataSet : TDataSet; aDBGrid : TStringGrid) : iBind4D;
var
  ctxRtti : TRttiContext;
  typRtti : TRttiType;
  prpRtti : TRttiField;
  aAux1, aColCount: Integer;
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
          aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).Visible := prpRtti.GetAttribute<FieldDataSetBind>.Visible;

          if aDBGrid.Width < prpRtti.GetAttribute<FieldDataSetBind>.FLimitWidth then
            aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).Visible := False;


          if aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).Visible then
          begin

            if prpRtti.Tem<Translation> then
              aDataSet
                .FieldByName(
                    prpRtti.GetAttribute<FieldDataSetBind>.FieldName
                ).DisplayLabel :=
                TTranslator4D
                  .New
                    .Google
                      .Params
                        .Query(prpRtti.GetAttribute<Translation>.Query)
                      .&End
                    .Execute
            else
              aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).DisplayLabel := prpRtti.GetAttribute<FieldDataSetBind>.DisplayName;


            aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).DisplayWidth := Round((prpRtti.GetAttribute<FieldDataSetBind>.Width * aDBGrid.Width ) / 1000);
            aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).Alignment := prpRtti.GetAttribute<FieldDataSetBind>.Alignment;

            if prpRtti.GetAttribute<FieldDataSetBind>.EditMask <> '' then
              case prpRtti.GetAttribute<FieldDataSetBind>.FDType of
                ftString :
                  TStringField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName)).EditMask := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
                ftCurrency,
                ftInteger :
                  TNumericField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName)).DisplayFormat := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
                ftDateTime :
                begin
                  AdjustDateTimeDataSet(prpRtti, aDataSet);
                  TStringField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName)).EditMask := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
                end;
                ftDate :
                begin
                  AdjustDateDataSet(prpRtti, aDataSet);
                  TStringField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName)).EditMask := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
                end;
                ftTime :
                begin
                  AdjustTimeDataSet(prpRtti, aDataSet);
                  TStringField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName)).EditMask := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
                end

                else
                  TStringField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName)).EditMask := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
              end;
          end;
        end;
      end;

      aAux1 := 0;
      aColCount := 0;
      for i := 0 to Pred(aDBGrid.ColumnCount) do
        if aDBGrid.Columns[i].Visible then
        begin
          Inc(aColCount);
          aAux1 := aAux1 + Round(aDBGrid.Columns[i].Width);
        end;

      aAux2 := Round(((aDBGrid.Width-22) - aAux1) / aColCount);

      for i := 0 to Pred(aDBGrid.ColumnCount) do
        if aDBGrid.Columns[i].Visible then
          aDBGrid.Columns[i].Width := aDBGrid.Columns[i].Width + aAux2;


      if aDBGrid.EnabledScroll then
        aDBGrid.Columns[Pred(aDBGrid.ColumnCount)].Width := aDBGrid.Columns[Pred(aDBGrid.ColumnCount)].Width
      else
        aDBGrid.Columns[Pred(aDBGrid.ColumnCount)].Width := aDBGrid.Columns[Pred(aDBGrid.ColumnCount)].Width + 10;

    except
      //
    end;
  finally
    ctxRtti.Free;
  end;
end;
{$ELSE}
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
          aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).Visible := prpRtti.GetAttribute<FieldDataSetBind>.Visible;

          if aDBGrid.Width < prpRtti.GetAttribute<FieldDataSetBind>.FLimitWidth then
            aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).Visible := False;


          if aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).Visible then
          begin

            if prpRtti.Tem<Translation> then
              aDataSet
                .FieldByName(
                    prpRtti.GetAttribute<FieldDataSetBind>.FieldName
                ).DisplayLabel :=
                TTranslator4D
                  .New
                    .Google
                      .Params
                        .Query(prpRtti.GetAttribute<Translation>.Query)
                      .&End
                    .Execute
            else
              aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).DisplayLabel := prpRtti.GetAttribute<FieldDataSetBind>.DisplayName;


            aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).DisplayWidth := Round((prpRtti.GetAttribute<FieldDataSetBind>.Width * aDBGrid.Width ) / 1000);
            aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).Alignment := prpRtti.GetAttribute<FieldDataSetBind>.Alignment;

            if prpRtti.GetAttribute<FieldDataSetBind>.EditMask <> '' then
              case prpRtti.GetAttribute<FieldDataSetBind>.FDType of
                ftString :
                  TStringField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName)).EditMask := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
                ftCurrency,
                ftInteger :
                  TNumericField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName)).DisplayFormat := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
                ftDateTime :
                begin
                  AdjustDateTimeDataSet(prpRtti, aDataSet);
                  TStringField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName)).EditMask := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
                end;
                ftDate :
                begin
                  AdjustDateDataSet(prpRtti, aDataSet);
                  TStringField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName)).EditMask := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
                end;
                ftTime :
                begin
                  AdjustTimeDataSet(prpRtti, aDataSet);
                  TStringField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName)).EditMask := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
                end

                else
                  TStringField(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName)).EditMask := prpRtti.GetAttribute<FieldDataSetBind>.EditMask;
              end;
          end;
        end;
      end;

      aAux1 := 0;
      for i := 0 to aDBGrid.Columns.Count-1 do
        aAux1 := aAux1 + aDBGrid.Columns[i].Width;

      aAux2 := Round(((aDBGrid.Width - 29) - aAux1) / aDBGrid.Columns.Count);

      for i := 0 to aDBGrid.Columns.Count-1 do
        aDBGrid.Columns[i].Width := aDBGrid.Columns[i].Width + aAux2;

      aDBGrid.Columns[Pred(aDBGrid.Columns.Count)].Width := aDBGrid.Columns[Pred(aDBGrid.Columns.Count)].Width - 5;

    except
      //
    end;
  finally
    ctxRtti.Free;
  end;
end;
{$ENDIF}

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
      aTitle := vTypRtti.GetAttribute<FormDefault>.Title;
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
      {$IFDEF HAS_FMX}
        if aComponent is TTrackBar then
          (aComponent as TTrackBar).Value := 0;
        if aComponent is TDateEdit then
          (aComponent as TDateEdit).Date := now;
      {$ELSE}
        if aComponent is TMaskEdit then
          (aComponent as TMaskEdit).Text := '';
        if aComponent is TRadioGroup then
          (aComponent as TRadioGroup).ItemIndex := -1;
        if aComponent is TTrackBar then
          (aComponent as TTrackBar).Position := 0;
        if aComponent is TDateTimePicker then
          (aComponent as TDateTimePicker).Date := now;
      {$ENDIF}


      if aComponent is TEdit then
        (aComponent as TEdit).Text := '';

      if aComponent is TComboBox then
        (aComponent as TComboBox).ItemIndex := -1;



      if aComponent is TImage then
        if prpRtti.Tem<ImageAttribute> then
          TBind4DUtils.LoadDefaultResourceImage((aComponent as TImage), prpRtti.GetAttribute<ImageAttribute>.DefaultResourceImage);
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
                    prpRtti.GetAttribute<FieldJsonBind>.JsonName,
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
                      prpRtti.GetAttribute<FieldJsonBind>.JsonName,
                      __GetComponentToValue(FForm.FindComponent(prpRtti.Name), prpRtti)
                    );
            end;
            fbPut:
            begin
              if not prpRtti.Tem<FbIgnorePut> then
                Result
                  .AddPair(
                    prpRtti.GetAttribute<FieldJsonBind>.JsonName,
                    __GetComponentToValue(FForm.FindComponent(prpRtti.Name), prpRtti)
                  );
            end;
            fbDelete:
            begin
              if not prpRtti.Tem<FbIgnoreDelete> then
                Result
                  .AddPair(
                    prpRtti.GetAttribute<FieldJsonBind>.JsonName,
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
              Result := Result + prpRtti.GetAttribute<FieldJsonBind>.JsonName + ',';
          end;
          fbPost:
          begin
            if not prpRtti.Tem<FbIgnorePost> then
              Result := Result + prpRtti.GetAttribute<FieldJsonBind>.JsonName + ',';
          end;
          fbPut:
          begin
            if not prpRtti.Tem<FbIgnorePut> then
              Result := Result + prpRtti.GetAttribute<FieldJsonBind>.JsonName + ',';
          end;
          fbDelete:
          begin
            if not prpRtti.Tem<FbIgnoreDelete> then
              Result := Result + prpRtti.GetAttribute<FieldJsonBind>.JsonName + ',';
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
          raise Exception.Create(pRtti.GetAttribute<fvNotNull>.Msg);
        end;

    end;

    if pRtti.Tem<ComponentBindStyle> then
    begin
      case pRtti.GetAttribute<ComponentBindStyle>.EspecialType of
        teNull : Result := (aComponent as TEdit).Text;
        teCoin : Result := TBind4DUtils.ExtrairMoeda((aComponent as TEdit).Text);
        teCell : Result := TBind4DUtils.ApenasNumeros((aComponent as TEdit).Text);
        teCPF  : Result := TBind4DUtils.ApenasNumeros((aComponent as TEdit).Text);
        teCNPJ  : Result := TBind4DUtils.ApenasNumeros((aComponent as TEdit).Text);
      end;
    end;
    exit;
  end;

  {$IFDEF HAS_FMX}
    if aComponent is TCheckBox then
      Result := (aComponent as TCheckBox).IsChecked.ToString();
    if aComponent is TTrackBar then
      Result := (aComponent as TTrackBar).Value.ToString;
    if aComponent is TDateEdit then
      Result := TBind4DUtils.FormatDateTimeToJson((aComponent as TDateEdit).DateTime);
  {$ELSE}
    if aComponent is TMaskEdit then
      Result := (aComponent as TMaskEdit).Text;
    if aComponent is TRadioGroup then
      Result := (aComponent as TRadioGroup).Items[(aComponent as TRadioGroup).ItemIndex];
    if aComponent is TCheckBox then
      Result := (aComponent as TCheckBox).Checked.ToString();
    if aComponent is TTrackBar then
      Result := (aComponent as TTrackBar).Position.ToString;
    if aComponent is TDateTimePicker then
      Result := TBind4DUtils.FormatDateTimeToJson((aComponent as TDateTimePicker).DateTime);
  {$ENDIF}


  if aComponent is TComboBox then
    Result := (aComponent as TComboBox).Items[(aComponent as TComboBox).ItemIndex];

  if aComponent is TImage then
    if pRtti.Tem<S3Storage> then
      Result := TBind4DUtils.SendImageS3Storage(TImage(aComponent), pRtti);
end;

class function TBind4D.New: iBind4D;
begin
  if not Assigned(vBind4D) then
    vBind4D := Self.Create;

  Result := vBind4D;
end;

function TBind4D.SetStyleComponents: iBind4D;
var
  ctxRtti : TRttiContext;
  typRtti : TRttiType;
  prpRtti : TRttiField;
  aComponent : TComponent;
  aResource : TResourceStream;
begin
  Result := Self;
  ctxRtti := TRttiContext.Create;
  try
    typRtti := ctxRtti.GetType(FForm.ClassInfo);
    for prpRtti in typRtti.GetFields do
    begin
      __BindCaptionToComponent(FForm.FindComponent(prpRtti.Name), prpRtti);
      __BindResourceImageToComponent(prpRtti);
      if prpRtti.Tem<ComponentBindStyle> then
      begin
        aComponent := FForm.FindComponent(prpRtti.Name);
        if aComponent is TEdit then
        begin
          {$IFDEF HAS_FMX}
            (aComponent as TEdit).StyledSettings := [TStyledSetting.Other];
            (aComponent as TEdit).TextSettings.FontColor := prpRtti.GetAttribute<ComponentBindStyle>.FontColor;
            (aComponent as TEdit).TextSettings.Font.Family := prpRtti.GetAttribute<ComponentBindStyle>.FontName;
          {$ELSE}
            (aComponent as TEdit).StyleElements := [seClient, seBorder];
            (aComponent as TEdit).Color := prpRtti.GetAttribute<ComponentBindStyle>.Color;
            (aComponent as TEdit).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FontColor;
            (aComponent as TEdit).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FontName;
          {$ENDIF}
          (aComponent as TEdit).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FontSize;

          (aComponent as TEdit).OnChange :=
            TBind4DUtils.AnonProc2NotifyEvent(
              (aComponent  as TEdit),
              procedure (Sender : TObject)
              begin
                TCommandMaster.New.Execute(Sender);
              end
            );

          case prpRtti.GetAttribute<ComponentBindStyle>.EspecialType of
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
          {$IFDEF HAS_FMX}
          {$ELSE}
            (aComponent as TPanel).ParentBackground := False;
            (aComponent as TPanel).Color := prpRtti.GetAttribute<ComponentBindStyle>.Color;
            (aComponent as TPanel).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FontSize;
            (aComponent as TPanel).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FontColor;
            (aComponent as TPanel).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FontName;
          {$ENDIF}
        end;

        if aComponent is TLabel then
        begin
          {$IFDEF HAS_FMX}
            (aComponent as TLabel).StyledSettings := [TStyledSetting.Other];
            (aComponent as TLabel).TextSettings.FontColor := prpRtti.GetAttribute<ComponentBindStyle>.FontColor;
            (aComponent as TLabel).TextSettings.Font.Family := prpRtti.GetAttribute<ComponentBindStyle>.FontName;
            (aComponent as TLabel).TextSettings.Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FontSize;
          {$ELSE}
            (aComponent as TLabel).StyleElements := [seClient, seBorder];
            (aComponent as TLabel).Color := prpRtti.GetAttribute<ComponentBindStyle>.Color;
            (aComponent as TLabel).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FontColor;
            (aComponent as TLabel).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FontName;
            (aComponent as TLabel).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FontSize;
          {$ENDIF}
        end;

        {$IFDEF HAS_FMX}
          if aComponent is TDateEdit then
          begin
            (aComponent as TDateEdit).StyledSettings := [TStyledSetting.Other];
            (aComponent as TDateEdit).TextSettings.FontColor := prpRtti.GetAttribute<ComponentBindStyle>.Color;
            (aComponent as TDateEdit).TextSettings.Font.Family := prpRtti.GetAttribute<ComponentBindStyle>.FontName;
            (aComponent as TDateEdit).TextSettings.Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FontSize;
          end;

          if aComponent is TRectangle then
          begin
            (aComponent as TRectangle).Fill.Color := prpRtti.GetAttribute<ComponentBindStyle>.Color
          end;

          if aComponent is TComboEdit then
          begin
            (aComponent as TComboEdit).StyledSettings := [TStyledSetting.Other];
            (aComponent as TComboEdit).TextSettings.FontColor := prpRtti.GetAttribute<ComponentBindStyle>.FontColor;
            (aComponent as TComboEdit).TextSettings.Font.Family := prpRtti.GetAttribute<ComponentBindStyle>.FontName;
          end;

          if aComponent is TCheckBox then
          begin
            (aComponent as TCheckBox).StyledSettings := [TStyledSetting.Other];
            (aComponent as TCheckBox).TextSettings.FontColor := prpRtti.GetAttribute<ComponentBindStyle>.FontColor;
            (aComponent as TCheckBox).TextSettings.Font.Family := prpRtti.GetAttribute<ComponentBindStyle>.FontName;
            (aComponent as TCheckBox).TextSettings.Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FontSize;
          end;

          if aComponent is TStringGrid then
          begin
            (aComponent as TStringGrid).StyledSettings := [TStyledSetting.Other];
            //(aComponent as TStringGrid).Color := prpRtti.GetAttribute<ComponentBindStyle>.Color;
            (aComponent as TStringGrid).TextSettings.Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FontSize;
            (aComponent as TStringGrid).TextSettings.FontColor := prpRtti.GetAttribute<ComponentBindStyle>.FontColor;
            (aComponent as TStringGrid).TextSettings.Font.Family := prpRtti.GetAttribute<ComponentBindStyle>.FontName;
          end;

        {$ELSE}
          if aComponent is TMaskEdit then
          begin
            (aComponent as TMaskEdit).StyleElements := [seClient, seBorder];
            (aComponent as TMaskEdit).Color := prpRtti.GetAttribute<ComponentBindStyle>.Color;
            (aComponent as TMaskEdit).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FontSize;
            (aComponent as TMaskEdit).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FontColor;
            (aComponent as TMaskEdit).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FontName;
          end;

          if aComponent is TDBGrid then
          begin
            (aComponent as TDBGrid).StyleElements := [seClient, seBorder];
            (aComponent as TDBGrid).Color := prpRtti.GetAttribute<ComponentBindStyle>.Color;
            (aComponent as TDBGrid).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FontSize;
            (aComponent as TDBGrid).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FontColor;
            (aComponent as TDBGrid).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FontName;
          end;

          if aComponent is TDateTimePicker then
          begin
            (aComponent as TDateTimePicker).StyleElements := [seClient, seBorder];
            (aComponent as TDateTimePicker).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FontSize;
            (aComponent as TDateTimePicker).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FontColor;
            (aComponent as TDateTimePicker).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FontName;
          end;

          if aComponent is TComboBox then
          begin
            (aComponent as TComboBox).StyleElements := [seClient, seBorder];
            (aComponent as TComboBox).Color := prpRtti.GetAttribute<ComponentBindStyle>.Color;
            (aComponent as TComboBox).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FontColor;
            (aComponent as TComboBox).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FontName;
            (aComponent as TComboBox).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FontSize;
          end;
        {$ENDIF}

        if aComponent is TSpeedButton then
        begin
          {$IFDEF HAS_FMX}
            (aComponent as TSpeedButton).StyledSettings := [TStyledSetting.Other];
            (aComponent as TSpeedButton).TextSettings.FontColor := prpRtti.GetAttribute<ComponentBindStyle>.Color;
            (aComponent as TSpeedButton).TextSettings.Font.Family := prpRtti.GetAttribute<ComponentBindStyle>.FontName;
          {$ELSE}
            (aComponent as TSpeedButton).StyleElements := [seClient, seBorder];
            (aComponent as TSpeedButton).Font.Size := prpRtti.GetAttribute<ComponentBindStyle>.FontSize;
            (aComponent as TSpeedButton).Font.Color := prpRtti.GetAttribute<ComponentBindStyle>.FontColor;
            (aComponent as TSpeedButton).Font.Name := prpRtti.GetAttribute<ComponentBindStyle>.FontName;

            


          {$ENDIF}
          end;
      end;
    end;
  finally
    ctxRtti.Free;
  end;
end;

function TBind4D.Translator: iTranslator4D;
begin
  Result := TTranslator4D.New;
end;

procedure TBind4D.AdjustDateDataSet(prpRtti: TRttiField; aDataSet: TDataSet);
begin
  aDataSet.DisableControls;
  while not aDataSet.Eof do
  begin
    aDataSet.Edit;
    aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).Value := TBind4DUtils.FormatDateDataSet(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).AsString);
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
    aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).Value := TBind4DUtils.FormatDateTimeDataSet(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).AsString);
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
    aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).Value := TBind4DUtils.FormatTimeDataSet(aDataSet.FieldByName(prpRtti.GetAttribute<FieldDataSetBind>.FieldName).AsString);
    aDataSet.Post;
    aDataSet.Next;
  end;
  aDataSet.First;
  aDataSet.EnableControls;
end;

function TBind4D.AWSService: iAWS4D;
begin
  if not Assigned(FAWSService) then
    FAWSService := TAWS4D.New;

  Result := FAWSService;
end;

initialization
  vBind4D := TBind4D.New;

end.
