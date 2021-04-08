unit Bind4D.Component.Mock;

interface

uses
  {$IFDEF HAS_FMX}
    FMX.StdCtrls,
  {$ELSE}
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
  {$ENDIF}
  Bind4D.Component.Interfaces, Bind4D.Attributes;

type
  TBind4DComponentMock = class(TInterfacedObject, iBind4DComponent)
    private
      FAttributes : iBind4DComponentAttributes;
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iBind4DComponent;
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
  Bind4D.Component.Attributes;

{ TBind4DComponentMock }

function TBind4DComponentMock.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentMock.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentMock.ApplyImage: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentMock.ApplyStyles: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentMock.ApplyText: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentMock.ApplyValue: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentMock.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;

function TBind4DComponentMock.Clear: iBind4DComponent;
begin
  Result := Self;
end;

constructor TBind4DComponentMock.Create;
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
end;

destructor TBind4DComponentMock.Destroy;
begin

  inherited;
end;

function TBind4DComponentMock.GetValueString: String;
begin
  Result := '';
end;

class function TBind4DComponentMock.New: iBind4DComponent;
begin
  Result := Self.Create;
end;

end.
