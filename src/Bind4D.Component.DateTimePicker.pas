unit Bind4D.Component.DateTimePicker;

interface

uses
  {$IFDEF HAS_FMX}
    FMX.StdCtrls,
  {$ELSE}
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
    Vcl.ComCtrls,
  {$ENDIF}
  Bind4D.Component.Interfaces, Bind4D.Attributes;

type
  TBind4DComponentDateTimePicker = class(TInterfacedObject, iBind4DComponent)
    private
      FComponent : TDateTimePicker;
      FAttributes : iBind4DComponentAttributes;
    public
      constructor Create(aValue : TDateTimePicker);
      destructor Destroy; override;
      class function New(aValue : TDateTimePicker) : iBind4DComponent;
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
  Bind4D.Component.Attributes, Data.DB, Bind4D.Utils, System.SysUtils;

{ TBind4DComponentDateTimePicker }

function TBind4DComponentDateTimePicker.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentDateTimePicker.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentDateTimePicker.ApplyImage: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentDateTimePicker.ApplyStyles: iBind4DComponent;
begin
  Result := Self;
  FComponent.StyleElements := FAttributes.StyleSettings;
  FComponent.Font.Size := FAttributes.FontSize;
  FComponent.Font.Color := FAttributes.FontColor;
  FComponent.Font.Name := FAttributes.FontName;
end;

function TBind4DComponentDateTimePicker.ApplyText: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentDateTimePicker.ApplyValue: iBind4DComponent;
begin
  Result := Self;
  case FAttributes.FieldType of
    ftDate,
    ftDateTime :
    begin
      FComponent.Date := TBind4DUtils.FormatStrJsonToDateTime(FAttributes.ValueVariant);
    end;
    ftTime :
    begin
      FComponent.Date := TBind4DUtils.FormatStrJsonToTime(FAttributes.ValueVariant);
    end;
  end;
end;

function TBind4DComponentDateTimePicker.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;

function TBind4DComponentDateTimePicker.Clear: iBind4DComponent;
begin
  Result := Self;
  FComponent.DateTime := now;
end;

constructor TBind4DComponentDateTimePicker.Create(aValue : TDateTimePicker);
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
  FComponent := aValue;
end;

destructor TBind4DComponentDateTimePicker.Destroy;
begin

  inherited;
end;

function TBind4DComponentDateTimePicker.GetValueString: String;
begin
  Result := TBind4DUtils.FormatDateTimeToJson(FComponent.DateTime);
end;

class function TBind4DComponentDateTimePicker.New(aValue : TDateTimePicker) : iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;

end.
