unit Bind4D.Component.CheckBox;
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
  TBind4DComponentCheckBox = class(TInterfacedObject, iBind4DComponent)
    private
      FComponent : TCheckBox;
      FAttributes : iBind4DComponentAttributes;
    public
      constructor Create(aValue : TCheckBox);
      destructor Destroy; override;
      class function New(aValue : TCheckBox) : iBind4DComponent;
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
  Bind4D.Component.Attributes, System.SysUtils;
{ TBind4DComponentCheckBox }
function TBind4DComponentCheckBox.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;
function TBind4DComponentCheckBox.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;
function TBind4DComponentCheckBox.ApplyImage: iBind4DComponent;
begin
  Result := Self;
end;
function TBind4DComponentCheckBox.ApplyRestData: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentCheckBox.ApplyStyles: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
    FComponent.StyledSettings := FAttributes.StyleSettings;
    FComponent.TextSettings.FontColor := FAttributes.FontColor;
    FComponent.TextSettings.Font.Family := FAttributes.FontName;
    FComponent.TextSettings.Font.Size := FAttributes.FontSize;
  {$ELSE}
  {$ENDIF}
end;
function TBind4DComponentCheckBox.ApplyText: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
    FComponent.Text := FAttributes.Text;
  {$ELSE}
    FComponent.Caption := FAttributes.Text;
  {$ENDIF}
end;
function TBind4DComponentCheckBox.ApplyValue: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
    FComponent.IsChecked := FAttributes.ValueVariant;
  {$ELSE}
    FComponent.Checked := FAttributes.ValueVariant;
  {$ENDIF}
end;
function TBind4DComponentCheckBox.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;
function TBind4DComponentCheckBox.Clear: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
    FComponent.IsChecked := False;
  {$ELSE}
    FComponent.Checked := False;
  {$ENDIF}
end;
constructor TBind4DComponentCheckBox.Create(aValue : TCheckBox);
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
  FComponent := aValue;
end;
destructor TBind4DComponentCheckBox.Destroy;
begin
  inherited;
end;
function TBind4DComponentCheckBox.GetCaption: String;
begin
  Result := FComponent.Caption;
end;

function TBind4DComponentCheckBox.GetValueString: String;
begin
  {$IFDEF HAS_FMX}
    Result := BoolToStr(FComponent.IsChecked);
  {$ELSE}
    Result := BoolToStr(FComponent.Checked);
  {$ENDIF}
end;
class function TBind4DComponentCheckBox.New(aValue : TCheckBox) : iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;
end.
