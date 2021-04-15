unit Bind4D.Component.Rectangle;

interface

uses
  {$IFDEF HAS_FMX}
    FMX.StdCtrls,
    FMX.Objects,
  {$ELSE}
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
  {$ENDIF}
  Bind4D.Component.Interfaces, Bind4D.Attributes;

type
  TBind4DComponentRectangle = class(TInterfacedObject, iBind4DComponent)
    private
      {$IFDEF HAS_FMX}
      FComponent : TRectangle;
      {$ENDIF}
      FAttributes : iBind4DComponentAttributes;
    public
      {$IFDEF HAS_FMX}
      constructor Create(aValue : TRectangle);
      class function New(aValue : TRectangle) : iBind4DComponent;
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
  Bind4D.Component.Attributes;

{ TBind4DComponentRectangle }

function TBind4DComponentRectangle.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentRectangle.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentRectangle.ApplyImage: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentRectangle.ApplyRestData: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentRectangle.ApplyStyles: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
  FComponent.Fill.Color := FAttributes.Color;
  {$ENDIF}
end;

function TBind4DComponentRectangle.ApplyText: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentRectangle.ApplyValue: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentRectangle.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;

function TBind4DComponentRectangle.Clear: iBind4DComponent;
begin
  Result := Self;
end;

{$IFDEF HAS_FMX}
constructor TBind4DComponentRectangle.Create(aValue : TRectangle);
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
  FComponent := aValue;
end;

class function TBind4DComponentRectangle.New(aValue : TRectangle) : iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;
{$ENDIF}

destructor TBind4DComponentRectangle.Destroy;
begin

  inherited;
end;

function TBind4DComponentRectangle.GetCaption: String;
begin
  Result := '';
end;

function TBind4DComponentRectangle.GetValueString: String;
begin
  Result := '';
end;

end.
