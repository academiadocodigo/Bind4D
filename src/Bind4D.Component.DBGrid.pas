unit Bind4D.Component.DBGrid;

interface

uses
  {$IFDEF HAS_FMX}
    FMX.StdCtrls,
  {$ELSE}
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
    Vcl.DBGrids,
  {$ENDIF}
  Bind4D.Component.Interfaces, Bind4D.Attributes, Vcl.Grids, System.Types;

type
  TBind4DComponentDBGrid = class(TInterfacedObject, iBind4DComponent)
    private
      FComponent : TDBGrid;
      FAttributes : iBind4DComponentAttributes;
      procedure AdjustDateTimeDataSet(aAttr : FieldDataSetBind);
      procedure AdjustDateDataSet(aAttr : FieldDataSetBind);
      procedure AdjustTimeDataSet(aAttr : FieldDataSetBind);
      procedure DrawColCel (Sender : TObject; const Rect : TRect; DataCol : Integer; Column : TColumn; State : TGridDrawState);
    public
      constructor Create(aValue : TDBGrid);
      destructor Destroy; override;
      class function New(aValue : TDBGrid) : iBind4DComponent;
      function Attributes : iBind4DComponentAttributes;
      function AdjusteResponsivity : iBind4DComponent;
      function FormatFieldGrid (aAttr : FieldDataSetBind) : iBind4DComponent;
      function ApplyStyles : iBind4DComponent;
      function ApplyText : iBind4DComponent;
      function ApplyImage : iBind4DComponent;
      function ApplyValue : iBind4DComponent;
      function GetValueString : String;
      function Clear : iBind4DComponent;
  end;

implementation

uses
  Bind4D.Component.Attributes,
  Data.DB, Bind4D.Utils.Rtti,
  Translator4D,
  System.Classes,
  StrUtils,
  Translator4D.Interfaces,
  Bind4D.Utils,
  Bind4D.Component.Helpers,
  Bind4D.Helpers, System.SysUtils, Vcl.Graphics;

{ TBind4DComponentDBGrid }

procedure TBind4DComponentDBGrid.AdjustDateDataSet(aAttr: FieldDataSetBind);
begin
FComponent.DataSource.DataSet.DisableControls;
  while not FComponent.DataSource.DataSet.Eof do
  begin
    FComponent.DataSource.DataSet.Edit;
    FComponent.DataSource.DataSet.FieldByName(aAttr.FieldName).Value := TBind4DUtils.FormatDateDataSet(FComponent.DataSource.DataSet.FieldByName(aAttr.FieldName).AsString);
    FComponent.DataSource.DataSet.Post;
    FComponent.DataSource.DataSet.Next;
  end;
  FComponent.DataSource.DataSet.First;
  FComponent.DataSource.DataSet.EnableControls;
end;

procedure TBind4DComponentDBGrid.AdjustDateTimeDataSet(aAttr: FieldDataSetBind);
begin
  FComponent.DataSource.DataSet.DisableControls;
  while not FComponent.DataSource.DataSet.Eof do
  begin
    FComponent.DataSource.DataSet.Edit;
    FComponent.DataSource.DataSet.FieldByName(aAttr.FieldName).Value := TBind4DUtils.FormatDateTimeDataSet(FComponent.DataSource.DataSet.FieldByName(aAttr.FieldName).AsString);
    FComponent.DataSource.DataSet.Post;
    FComponent.DataSource.DataSet.Next;
  end;
  FComponent.DataSource.DataSet.First;
  FComponent.DataSource.DataSet.EnableControls;
end;

function TBind4DComponentDBGrid.AdjusteResponsivity: iBind4DComponent;
var
  i: Integer;
  FCoEficient : Integer;
  aAttr : FieldDataSetBind;
  aTotalWidthAttr: Integer;
  aCountTotalColumnsVisible: Integer;
  aDifColumns: Currency;
begin
  Result := Self;
  FCoEficient := 27;
  aTotalWidthAttr := 0;
  aCountTotalColumnsVisible := 0;

  for aAttr in RttiUtils.Get<FieldDataSetBind>(FAttributes.Form) do
  begin
    FComponent.DataSource.DataSet.FieldByName(aAttr.FieldName).Visible := aAttr.Visible;
    if aAttr.Visible then
      if FAttributes.Form.Width < aAttr.FLimitWidth then
        FComponent.DataSource.DataSet.FieldByName(aAttr.FieldName).Visible := False
      else
        FComponent.DataSource.DataSet.FieldByName(aAttr.FieldName).Visible := True;

    if FComponent.DataSource.DataSet.FieldByName(aAttr.FieldName).Visible then
    begin
      aTotalWidthAttr := aTotalWidthAttr + aAttr.Width;
      Inc(aCountTotalColumnsVisible);
    end;
  end;

  aDifColumns := (100 - aTotalWidthAttr) /  aCountTotalColumnsVisible;

  for aAttr in RttiUtils.Get<FieldDataSetBind>(FAttributes.Form) do
    for I := 0 to Pred(FComponent.Columns.Count) do
        if UpperCase(aAttr.FieldName) = UpperCase(FComponent.Columns[i].Field.FieldName) then
          FComponent.Columns[i].Width := Trunc(((aAttr.Width+aDifColumns)*(FComponent.Width-FCoEficient))/100);
end;

function TBind4DComponentDBGrid.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
var
  aField : TField;
  aAttranslation : Translation;
begin
  Result := Self;
  aField := FComponent.DataSource.DataSet.FieldByName(aAttr.FieldName);
  aField.Visible := aAttr.Visible;

 // if FComponent.Width < aAttr.FLimitWidth then
   // aField.Visible := False;
//
//  for I := 0 to Pred(FComponent.Columns.Count) do
//    if FComponent.Columns[I].Field.DisplayName = aAttr.FieldName then
//      FComponent.Columns[I].Width := Round((aAttr.Width * FComponent.Width ) / 100);

  aField.DisplayWidth := Round((aAttr.Width * FComponent.Width ) / 1000);
  aField.Alignment := aAttr.Alignment;

  if aAttr.EditMask <> '' then
    case aAttr.FDType of
      ftString :
        TStringField(aField).EditMask := aAttr.EditMask;
      ftCurrency,
      ftInteger :
        TNumericField(aField).DisplayFormat := aAttr.EditMask;
      ftDateTime :
      begin
        AdjustDateTimeDataSet(aAttr);
        TStringField(aField).EditMask := aAttr.EditMask;
      end;
      ftDate :
      begin
        AdjustDateDataSet(aAttr);
        TStringField(aField).EditMask := aAttr.EditMask;
      end;
      ftTime :
      begin
        AdjustTimeDataSet(aAttr);
        TStringField(aField).EditMask := aAttr.EditMask;
      end

      else
        TStringField(aField).EditMask := aAttr.EditMask;
    end;


   if RttiUtils.TryGet<Translation>(aAttr.Component, aAttranslation) then
    aField.DisplayLabel :=
      TTranslator4D
        .New
          .Google
            .Params
              .Query(aAttranslation.Query)
            .&End
          .Execute
    else
      aField.DisplayLabel := aAttr.DisplayName;



end;

procedure TBind4DComponentDBGrid.AdjustTimeDataSet(aAttr: FieldDataSetBind);
begin
  FComponent.DataSource.DataSet.DisableControls;
  while not FComponent.DataSource.DataSet.Eof do
  begin
    FComponent.DataSource.DataSet.Edit;
    FComponent.DataSource.DataSet.FieldByName(aAttr.FieldName).Value := TBind4DUtils.FormatTimeDataSet(FComponent.DataSource.DataSet.FieldByName(aAttr.FieldName).AsString);
    FComponent.DataSource.DataSet.Post;
    FComponent.DataSource.DataSet.Next;
  end;
  FComponent.DataSource.DataSet.First;
  FComponent.DataSource.DataSet.EnableControls;
end;

function TBind4DComponentDBGrid.ApplyImage: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentDBGrid.ApplyStyles: iBind4DComponent;
begin
  Result := Self;
  FComponent.StyleElements := FAttributes.StyleSettings;
  FComponent.Color := FAttributes.Color;
  FComponent.Font.Size := FAttributes.FontSize;
  FComponent.Font.Color := FAttributes.FontColor;
  FComponent.Font.Name := FAttributes.FontName;
end;

function TBind4DComponentDBGrid.ApplyText: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentDBGrid.ApplyValue: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentDBGrid.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;

function TBind4DComponentDBGrid.Clear: iBind4DComponent;
begin
  Result := Self;
end;

constructor TBind4DComponentDBGrid.Create(aValue : TDBGrid);
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
  FComponent := aValue;

  FComponent.OnDrawColumnCell := DrawColCel;


end;

destructor TBind4DComponentDBGrid.Destroy;
begin

  inherited;
end;

procedure TBind4DComponentDBGrid.DrawColCel(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if not (gdSelected in State) then
  begin
    if Odd((Sender as TDBGrid).DataSource.DataSet.RecNo) then
      (Sender as TDBGrid).Canvas.Brush.Color:= clWhite
    else
      (Sender as TDBGrid).Canvas.Brush.Color:= $00fcfaf9;
              //TODO: Pegar a Cor do Attribute
    
    (Sender as TDBGrid).Canvas.FillRect(Rect);
    (Sender as TDBGrid).Canvas.TextOut(Rect.Left + 2, Rect.Top,
    Column.Field.DisplayText);
  end;
end;

function TBind4DComponentDBGrid.GetValueString: String;
begin
  Result := '';
end;

class function TBind4DComponentDBGrid.New(aValue : TDBGrid) : iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;

end.
