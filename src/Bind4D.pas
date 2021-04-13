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
  AWS4D,
  Bind4D.Forms.QuickRegistration;

type
  TBind4D = class(TInterfacedObject, iBind4D)
    private
      FForm : TForm;
      FAWSService : iAWS4D;
      FBind4DRest : iBind4DRest;
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
      function ResponsiveAdjustment : iBind4D;
      function SetStyleComponents : iBind4D;
      function SetCaptionComponents : iBind4D;
      function SetImageComponents : iBind4D;
      function SetRestDataComponents : iBind4D;
      function ClearCacheComponents : iBind4D;
      function Translator : iTranslator4D;
      function AWSService : iAWS4D;
      function Rest : iBind4DRest;
      function QuickRegistration : TPageQuickRegistration;
  end;

var
  vBind4D : iBind4D;

implementation

uses
  StrUtils,
  Bind4D.ChangeCommand,
  System.Types,
  Bind4D.Helpers,
  Bind4D.Attributes, 
  Bind4D.Component.ImageList,
  Bind4D.Component.Image,
  Bind4D.Component.Factory,
  Bind4D.Utils.Rtti,
  Bind4D.Types.Helpers, Bind4D.Component.Helpers, Bind4D.Rest;

{ TBind4D }

function TBind4D.BindFormRest(var aEndPoint : String; var aPK : String; var aSort : String; var aOrder : String) : iBind4D;
var
  aAttr : FormRest;
begin
  Result := Self;
  for aAttr in RttiUtils.GetAttClass<FormRest>(FForm) do
  begin
    aEndPoint := aAttr.EndPoint;
    aPK := aAttr.PK;
    aOrder := aAttr.Order;
    aSort := aAttr.Sort;
  end;
end;

function TBind4D.BindDataSetToForm(aDataSet : TDataSet) : iBind4D;
var
  Attribute : FieldDataSetBind;
begin
  Result := Self;
  for Attribute in RttiUtils.Get<FieldDataSetBind>(FForm) do
  begin
    TBind4DComponentFactory
      .New
        .Component(Attribute.Component)
          .Attributes
            .FieldType(Attribute.FDType)
            .ValueVariant(aDataSet.FieldByName(Attribute.FieldName).AsVariant)
            .Field(aDataSet.FieldByName(Attribute.FieldName))
          .&End
        .ApplyValue;
  end;
end;

{$IFDEF HAS_FMX}
function TBind4D.BindFormatListDataSet(aDataSet : TDataSet; aDBGrid : TStringGrid) : iBind4D;
var
  //ctxRtti : TRttiContext;
  //typRtti : TRttiType;
  //prpRtti : TRttiField;
  aAux1, aColCount: Integer;
  aAux2: Integer;
  i: Integer;
  aAttr : FieldDataSetBind;
begin
  Result := Self;



  //for aAttr in RttiUtils. do


 {* ctxRtti := TRttiContext.Create;
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


    except
      //
    end;
  finally
    ctxRtti.Free;
  end;    *}

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

end;
{$ELSE}
function TBind4D.BindFormatListDataSet(aDataSet : TDataSet; aDBGrid : TDBGrid) : iBind4D;
var
  aAttr : FieldDataSetBind;
begin
  Result := Self;
  for aAttr in RttiUtils.Get<FieldDataSetBind>(FForm) do
    TBind4DComponentFactory
      .New
        .Component(aDBGrid)
        .FormatFieldGrid(aAttr);
end;
{$ENDIF}

function TBind4D.BindFormDefault(var aTitle : String) : iBind4D;
var
  aAttr : FormDefault;
begin
  Result := Self;
  for aAttr in RttiUtils.GetAttClass<FormDefault>(FForm) do
    aTitle := aAttr.Title;
end;

function TBind4D.ClearCacheComponents: iBind4D;
begin
  Result := Self;
  RttiUtils.ClearCache;
end;

function TBind4D.ClearFieldForm: iBind4D;
var
  aComp : TComponent;
begin
  for aComp in RttiUtils.GetComponents(FForm) do
    TBind4DComponentFactory.New.Component(aComp).Clear;
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

  if not Assigned(FForm.OnResize) then
    FForm.OnResize :=
      TBind4DUtils.AnonProc2NotifyEvent(
        FForm,
        procedure (Sender : TObject)
        begin
          Self.ResponsiveAdjustment;
        end
      );

  FForm.OnDestroy :=
    TBind4DUtils.AnonProc2NotifyEvent(
    FForm,
    procedure (Sender : TObject)
    var
      I : Integer;
      Index : Integer;
    begin
      for I := 0 to Pred(TForm(Sender).ComponentCount) do
        if TForm(Sender).Components[I] is TComboBox then
          for Index := 0 to Pred(TComboBox(TForm(Sender).Components[I]).Items.Count) do
          begin
            if Assigned(TComboBox(TForm(Sender).Components[I]).Items.Objects[Index]) then
            begin
              TComboBox(TForm(Sender).Components[I]).Items.Objects[Index].Free;
              TComboBox(TForm(Sender).Components[I]).Items.Objects[Index]:=nil;
            end;
          end;
        end
    )

end;

function TBind4D.FormToJson(aType : TTypeBindFormJson) : TJsonObject;
var
  aAttr : FieldJsonBind;
begin
  Result := TJsonObject.Create;
  try
    for aAttr in RttiUtils.Get<FieldJsonBind>(FForm) do
      aType.This.TryAddJsonPair(aAttr.Component, Result);
  except on e : exception do
    begin
        if assigned(Result) then Result.Free;
          raise Exception.Create(e.Message);
    end;
  end;
end;

function TBind4D.GetFieldsByType(aType : TTypeBindFormJson) : String;
var
  aAttr : FieldJsonBind;
  aJsonName : string;
begin
  for aAttr in RttiUtils.Get<FieldJsonBind>(FForm) do
    if aType.This.TryGetJsonName(aAttr.Component, aJsonName) then
      Result := Result + aJsonName + ',';
  Result := Copy(Result, 1, Length(Result) -1);
end;

class function TBind4D.New: iBind4D;
begin
  if not Assigned(vBind4D) then
    vBind4D := Self.Create;

  Result := vBind4D;
end;

function TBind4D.QuickRegistration: TPageQuickRegistration;
begin
  Result := PageQuickRegistration;
end;

function TBind4D.SetImageComponents : iBind4D;
var
  Attribute : ImageAttribute;
begin
  Result := Self;
  for Attribute in RttiUtils.Get<ImageAttribute>(FForm) do
  begin
    TBind4DComponentFactory
      .New
        .Component(Attribute.Component)
          .Attributes
            .Width(Attribute.Width)
            .Heigth(Attribute.Heigth)
            .ResourceImage(Attribute.DefaultResourceImage)
          .&End
        .ApplyImage;
  end;
end;

function TBind4D.SetRestDataComponents: iBind4D;
var
  Attribute : RestData;
  Attr : RestQuickRegistration;
begin
  Result := Self;
  for Attribute in RttiUtils.Get<RestData>(FForm) do
  begin
    TBind4DComponentFactory
      .New
        .Component(Attribute.Component)
          .Attributes
            .Form(FForm)
            .EndPoint(Attribute.EndPoint)
            .FieldKey(Attribute.FieldKey)
            .FieldValue(Attribute.FieldValue)
            .FieldBind(Attribute.FieldBind)
            .ComponentNameBind(Attribute.ComponentName)
          .&End
        .ApplyRestData;
  end;

  for Attr in RttiUtils.Get<RestQuickRegistration>(FForm) do
  begin
    TBind4DComponentFactory
      .New
        .Component(Attr.Component)
          .Attributes
            .Form(FForm)
            .EndPoint(Attr.EndPoint)
            .FieldKey(Attr.Field)
            .Title(Attr.Title)
          .&End
        .ApplyRestData;
  end;
end;

function TBind4D.SetCaptionComponents : iBind4D;
var
  Attribute : Translation;
begin
  Result := Self;
  for Attribute in RttiUtils.Get<Translation>(FForm) do
  begin
    TBind4DComponentFactory
      .New
        .Component(Attribute.Component)
          .Attributes
            .Text(Attribute.Query)
          .&End
        .ApplyText;
  end;
end;

function TBind4D.SetStyleComponents: iBind4D;
var
  Attribute : ComponentBindStyle;
begin
  Result := Self;
  for Attribute in RttiUtils.Get<ComponentBindStyle>(FForm) do
  begin
    TBind4DComponentFactory
      .New
        .Component(Attribute.Component)
          .Attributes
            .Color(Attribute.Color)
            .FontColor(Attribute.FontColor)
            .FontName(Attribute.FontName)
            .FontSize(Attribute.FontSize)
            .EspecialType(Attribute.EspecialType)
            .ParentBackground(False)
            {$IFDEF HAS_FMX}
            .StyleSettings([TStyledSetting.Other])
            {$ELSE}
            .StyleSettings([seClient, seBorder])
            {$ENDIF}
          .&End
        .ApplyStyles;
  end;
end;

function TBind4D.Translator: iTranslator4D;
begin
  Result := TTranslator4D.New;
end;

function TBind4D.ResponsiveAdjustment: iBind4D;
var
  Attribute : AdjustResponsive;
begin
  Result := Self;
  for Attribute in RttiUtils.Get<AdjustResponsive>(FForm) do
  begin
    TBind4DComponentFactory
      .New
        .Component(Attribute.Component)
        .Attributes
          .Form(FForm)
        .&End
        .AdjusteResponsivity;
  end;
end;

function TBind4D.Rest: iBind4DRest;
begin
  if not Assigned(FBind4DRest) then
    FBind4DRest := TBind4DRest.New(Self);

  Result := FBind4DRest;
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
