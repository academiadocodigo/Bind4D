unit Bind4D.Component.ListBox;

interface
uses
  Bind4D.Component.Interfaces,
  Bind4D.Attributes,
  Vcl.StdCtrls;
Type
  TBind4DComponentListBox = class(TInterfacedObject, iBind4DComponent)
  private
    FComponent : TListBox;
    FAttributes : iBind4DComponentAttributes;
  public
    constructor Create(aValue : TListBox);
    destructor Destroy; override;
    class function New(aValue : TListBox) : iBind4DComponent;
    function Attributes : iBind4DComponentAttributes;
    function AdjusteResponsivity : iBind4DComponent;
    function ApplyStyles : iBind4DComponent;
    function ApplyText : iBind4DComponent;
    function ApplyImage : iBind4DComponent;
    function ApplyValue : iBind4DComponent;
    function ApplyRestData : iBind4DComponent;
    function Clear : iBind4DComponent;
    function FormatFieldGrid (aAttr : FieldDataSetBind) : iBind4DComponent;
    function GetValueString : String;
    function GetCaption : String;
  end;

implementation

uses
  Bind4D.Component.Attributes;

{ TBind4DComponentListBox }

function TBind4DComponentListBox.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentListBox.ApplyImage: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentListBox.ApplyRestData: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentListBox.ApplyStyles: iBind4DComponent;
begin
  Result := Self;
  FComponent.StyleElements := FAttributes.StyleSettings;
  FComponent.Color := FAttributes.Color;
  FComponent.Font.Color := FAttributes.FontColor;
  FComponent.Font.Name := FAttributes.FontName;
  FComponent.Font.Size := FAttributes.FontSize;
end;

function TBind4DComponentListBox.ApplyText: iBind4DComponent;
begin
  Result := Self;
  FComponent.Items.Text := FAttributes.Text;
end;

function TBind4DComponentListBox.ApplyValue: iBind4DComponent;
begin
  Result := Self;
  FComponent.Items.Text := FAttributes.ValueVariant;
end;

function TBind4DComponentListBox.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;

function TBind4DComponentListBox.Clear: iBind4DComponent;
begin
  Result := Self;
  FComponent.Items.Clear;
end;

constructor TBind4DComponentListBox.Create(aValue : TListBox);
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
  FComponent := aValue;
end;

destructor TBind4DComponentListBox.Destroy;
begin

  inherited;
end;

function TBind4DComponentListBox.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentListBox.GetCaption: String;
begin
  Result := FComponent.Items.Text;
end;

function TBind4DComponentListBox.GetValueString: String;
begin
  Result := FComponent.Items.Text;
end;

class function TBind4DComponentListBox.New (aValue : TListBox) : iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;

end.
