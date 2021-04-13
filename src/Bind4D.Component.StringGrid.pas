unit Bind4D.Component.StringGrid;

interface

uses
  {$IFDEF HAS_FMX}
    FMX.StdCtrls,
    FMX.Grid,
  {$ELSE}
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
    Vcl.Grids,
  {$ENDIF}
  Bind4D.Component.Interfaces, Bind4D.Attributes;

type
  TBind4DComponentStringGrid = class(TInterfacedObject, iBind4DComponent)
    private
      FComponent : TStringGrid;
      FAttributes : iBind4DComponentAttributes;
    public
      constructor Create(aValue : TStringGrid);
      destructor Destroy; override;
      class function New(aValue : TStringGrid) : iBind4DComponent;
      function Attributes : iBind4DComponentAttributes;
      function AdjusteResponsivity : iBind4DComponent;
      function FormatFieldGrid (aAttr : FieldDataSetBind) : iBind4DComponent;
      function ApplyStyles : iBind4DComponent;
      function ApplyText : iBind4DComponent;
      function ApplyImage : iBind4DComponent;
      function ApplyValue : iBind4DComponent;
      function ApplyRestData : iBind4DComponent;
      function GetValueString : String;
      function Clear : iBind4DComponent;
  end;

implementation

uses
  Bind4D.Component.Attributes;

{ TBind4DComponentStringGrid }

function TBind4DComponentStringGrid.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentStringGrid.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentStringGrid.ApplyImage: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentStringGrid.ApplyRestData: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentStringGrid.ApplyStyles: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
    FComponent.StyledSettings := FAttributes.StyleSettings;
    FComponent.TextSettings.Font.Size := FAttributes.FontSize;
    FComponent.TextSettings.FontColor := FAttributes.FontColor;
    FComponent.TextSettings.Font.Family := FAttributes.FontName;
  {$ELSE}
  {$ENDIF}
end;

function TBind4DComponentStringGrid.ApplyText: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentStringGrid.ApplyValue: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentStringGrid.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;

function TBind4DComponentStringGrid.Clear: iBind4DComponent;
begin
  Result := Self;
end;

constructor TBind4DComponentStringGrid.Create(aValue : TStringGrid);
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
  FComponent := aValue;
end;

destructor TBind4DComponentStringGrid.Destroy;
begin

  inherited;
end;

function TBind4DComponentStringGrid.GetValueString: String;
begin
  Result := '';
end;

class function TBind4DComponentStringGrid.New(aValue : TStringGrid) : iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;

end.
