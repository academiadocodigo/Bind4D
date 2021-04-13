unit Bind4D.Component.MaskEdit;

interface

uses
  {$IFDEF HAS_FMX}
    FMX.StdCtrls,
  {$ELSE}
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
    Vcl.Mask,
  {$ENDIF}
  Bind4D.Component.Interfaces, Bind4D.Attributes;

type
  TBind4DComponentMaskEdit = class(TInterfacedObject, iBind4DComponent)
    private
      FComponent : TMaskEdit;
      FAttributes : iBind4DComponentAttributes;
    public
      constructor Create(aValue : TMaskEdit);
      destructor Destroy; override;
      class function New(aValue : TMaskEdit) : iBind4DComponent;
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
  Bind4D.Component.Attributes,
  Data.DB, System.SysUtils;

{ TBind4DComponentMaskEdit }

function TBind4DComponentMaskEdit.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentMaskEdit.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentMaskEdit.ApplyImage: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentMaskEdit.ApplyRestData: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentMaskEdit.ApplyStyles: iBind4DComponent;
begin
  Result := Self;
  FComponent.StyleElements := FAttributes.StyleSettings;
  FComponent.Color := FAttributes.Color;
  FComponent.Font.Size := FAttributes.FontSize;
  FComponent.Font.Color := FAttributes.FontColor;
  FComponent.Font.Name := FAttributes.FontName;
end;

function TBind4DComponentMaskEdit.ApplyText: iBind4DComponent;
begin
  Result := Self;
  FComponent.Text := FAttributes.Text;
end;

function TBind4DComponentMaskEdit.ApplyValue: iBind4DComponent;
begin
  Result := Self;
  case FAttributes.FieldType of
    ftFloat,
    ftCurrency :
      FComponent.Text := FloatToStr(FAttributes.ValueVariant);
    ftString,
    ftWideString :
      FComponent.Text := FAttributes.ValueVariant;
  end;
end;

function TBind4DComponentMaskEdit.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;

function TBind4DComponentMaskEdit.Clear: iBind4DComponent;
begin
  Result := Self;
  FComponent.Text := '';
end;

constructor TBind4DComponentMaskEdit.Create(aValue : TMaskEdit);
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
  FComponent := aValue;
end;

destructor TBind4DComponentMaskEdit.Destroy;
begin

  inherited;
end;

function TBind4DComponentMaskEdit.GetValueString: String;
begin
  Result := FComponent.Text;
end;

class function TBind4DComponentMaskEdit.New(aValue : TMaskEdit) : iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;

end.
