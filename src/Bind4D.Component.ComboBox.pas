unit Bind4D.Component.ComboBox;

interface

uses
  {$IFDEF HAS_FMX}
    FMX.StdCtrls,
    FMX.ListBox,
  {$ELSE}
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
  {$ENDIF}
  Bind4D.Component.Interfaces, Bind4D.Attributes;

type
  TBind4DComponentComboBox = class(TInterfacedObject, iBind4DComponent)
    private
      FComponent : TComboBox;
      FAttributes : iBind4DComponentAttributes;
    public
      constructor Create(aValue : TComboBox);
      destructor Destroy; override;
      class function New(aValue : TComboBox) : iBind4DComponent;
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

{ TBind4DComboBox }

function TBind4DComponentComboBox.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentComboBox.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentComboBox.ApplyImage: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentComboBox.ApplyStyles: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
  {$ELSE}
    FComponent.StyleElements := FAttributes.StyleSettings;
    FComponent.Color := FAttributes.Color;
    FComponent.Font.Color := FAttributes.FontColor;
    FComponent.Font.Name := FAttributes.FontName;
    FComponent.Font.Size := FAttributes.FontSize;
  {$ENDIF}
end;

function TBind4DComponentComboBox.ApplyText: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentComboBox.ApplyValue: iBind4DComponent;
begin
  Result := Self;
  FComponent.ItemIndex := FComponent.Items.IndexOf(FAttributes.ValueVariant);
end;

function TBind4DComponentComboBox.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;

function TBind4DComponentComboBox.Clear: iBind4DComponent;
begin
  Result := Self;
  FComponent.ItemIndex := -1;
end;

constructor TBind4DComponentComboBox.Create(aValue : TComboBox);
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
  FComponent := aValue;
end;

destructor TBind4DComponentComboBox.Destroy;
begin

  inherited;
end;

function TBind4DComponentComboBox.GetValueString: String;
begin
  Result := FComponent.Items[FComponent.ItemIndex];
end;

class function TBind4DComponentComboBox.New(aValue : TComboBox) : iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;

end.
