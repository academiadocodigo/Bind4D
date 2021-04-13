unit Bind4D.Component.Panel;

interface

uses
  {$IFDEF HAS_FMX}
    FMX.StdCtrls,
  {$ELSE}
    Vcl.ExtCtrls,
  {$ENDIF}
    Bind4D.Component.Interfaces, Bind4D.Attributes;

type
  TBind4DComponentPanel = class(TInterfacedObject, iBind4DComponent)
    private
      FComponent : TPanel;
      FAttributes : iBind4DComponentAttributes;
    public
      constructor Create(aValue : TPanel);
      destructor Destroy; override;
      class function New(aValue : TPanel) : iBind4DComponent;
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

{ TBind4DComponentPanel }

function TBind4DComponentPanel.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentPanel.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentPanel.ApplyImage: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentPanel.ApplyRestData: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentPanel.ApplyStyles: iBind4DComponent;
begin
  Result := Self;
  FComponent.ParentBackground := FAttributes.ParentBackground;
  FComponent.Color := FAttributes.Color;
  FComponent.Font.Size := FAttributes.FontSize;
  FComponent.Font.Color := FAttributes.FontColor;
  FComponent.Font.Name := FAttributes.FontName;
end;

function TBind4DComponentPanel.ApplyText: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
    FComponent.Text := FAttributes.Text;
  {$ELSE}
    FComponent.Caption := FAttributes.Text;
  {$ENDIF}
end;

function TBind4DComponentPanel.ApplyValue: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentPanel.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;

function TBind4DComponentPanel.Clear: iBind4DComponent;
begin
  Result := Self;
end;

constructor TBind4DComponentPanel.Create(aValue : TPanel);
begin
  FComponent := aValue;
  FAttributes := TBind4DComponentAttributes.Create(Self);
end;

destructor TBind4DComponentPanel.Destroy;
begin

  inherited;
end;

function TBind4DComponentPanel.GetValueString: String;
begin
  {$IFDEF HAS_FMX}
    Result := FComponent.Text;
  {$ELSE}
    Result := FComponent.Caption;
  {$ENDIF}
end;

class function TBind4DComponentPanel.New(aValue : TPanel) : iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;

end.
