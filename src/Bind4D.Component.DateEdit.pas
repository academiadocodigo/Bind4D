unit Bind4D.Component.DateEdit;

interface

uses
  {$IFDEF HAS_FMX}
    FMX.StdCtrls,
    FMX.DateTimeCtrls,
  {$ELSE}
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
  {$ENDIF}
  Bind4D.Component.Interfaces, Bind4D.Utils, Bind4D.Attributes;

type
  TBind4DComponentDateEdit = class(TInterfacedObject, iBind4DComponent)
    private
      {$IFDEF HAS_FMX}
      FComponent : TDateEdit;
      {$ENDIF}
      FAttributes : iBind4DComponentAttributes;
    public
      {$IFDEF HAS_FMX}
      constructor Create(aValue : TDateEdit);
      class function New(aValue : TDateEdit) : iBind4DComponent;
      {$ENDIF}
      destructor Destroy; override;
      function Attributes : iBind4DComponentAttributes;
      function AdjusteResponsivity : iBind4DComponent;
      function FormatFieldGrid (aAttr : FieldDataSetBind) : iBind4DComponent;
      function ApplyStyles : iBind4DComponent;
      function ApplyText : iBind4DComponent;
      function ApplyImage : iBind4DComponent;
      function ApplyValue : iBind4DComponent;
      function ApplyRestData : iBind4DComponent;
      function GetValueString : String;
      function GetCaption : String;
      function Clear : iBind4DComponent;
  end;

implementation

uses
  Bind4D.Component.Attributes, Data.DB;

{ TBind4DComponentDateEdit }

function TBind4DComponentDateEdit.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentDateEdit.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentDateEdit.ApplyImage: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentDateEdit.ApplyRestData: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentDateEdit.ApplyStyles: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
  FComponent.StyledSettings := FAttributes.StyleSettings;
  FComponent.TextSettings.FontColor := FAttributes.Color;
  FComponent.TextSettings.Font.Family := FAttributes.FontName;
  FComponent.TextSettings.Font.Size := FAttributes.FontSize;
  {$ENDIF}
end;

function TBind4DComponentDateEdit.ApplyText: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentDateEdit.ApplyValue: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
  case FAttributes.FieldType of
    ftDate,
    ftDateTime :
    begin
      FComponent.Date := TBind4DUtils.FormatStrJsonToDateTime(aValue);
    end;
    ftTime :
    begin
      FComponent.Date := TBind4DUtils.FormatStrJsonToTime(aValue);
    end;
  end;
  {$ENDIF}
end;

function TBind4DComponentDateEdit.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;

function TBind4DComponentDateEdit.Clear: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
    FComponent.DateTime := now;
  {$ENDIF}
end;

{$IFDEF HAS_FMX}
constructor TBind4DComponentDateEdit.Create(aValue : TDateEdit);
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
  FComponent := aValue;
end;
{$ENDIF}

destructor TBind4DComponentDateEdit.Destroy;
begin

  inherited;
end;

function TBind4DComponentDateEdit.GetCaption: String;
begin
  Result := '';
end;

function TBind4DComponentDateEdit.GetValueString: String;
begin
  {$IFDEF HAS_FMX}
  Result := TBind4DUtils.FormatDateTimeToJson(FComponent.DateTime);
  {$ENDIF}
end;

{$IFDEF HAS_FMX}
class function TMinhaClass.New(aValue : TDateEdit) : iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;
{$ENDIF}

end.
