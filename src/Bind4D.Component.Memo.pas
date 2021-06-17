unit Bind4D.Component.Memo;

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
  TBind4DComponentMemo = class(TInterfacedObject, iBind4DComponent)
    private
      FComponent : TMemo;
      FAttributes : iBind4DComponentAttributes;
    public
      constructor Create(aValue : TMemo);
      destructor Destroy; override;
      class function New(aValue : TMemo) : iBind4DComponent;
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

{ TBind4DComponentMemo }

function TBind4DComponentMemo.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentMemo.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentMemo.ApplyImage: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentMemo.ApplyRestData: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentMemo.ApplyStyles: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
    FComponent.StyledSettings := FAttributes.StyleSettings;
    FComponent.TextSettings.FontColor := FAttributes.FontColor;
    FComponent.TextSettings.Font.Family := FAttributes.FontName;
    FComponent.TextSettings.Font.Size := FAttributes.FontSize;
  {$ELSE}
    FComponent.StyleElements := FAttributes.StyleSettings;
    FComponent.Color := FAttributes.Color;
    FComponent.Font.Color := FAttributes.FontColor;
    FComponent.Font.Name := FAttributes.FontName;
    FComponent.Font.Size := FAttributes.FontSize;
  {$ENDIF}
end;

function TBind4DComponentMemo.ApplyText: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
    FComponent.Text := FAttributes.Text;
  {$ELSE}
    FComponent.Lines.Text := FAttributes.Text;
  {$ENDIF}
end;

function TBind4DComponentMemo.ApplyValue: iBind4DComponent;
begin
  Result := Self;
  FComponent.Lines.Text := FAttributes.ValueVariant;
end;

function TBind4DComponentMemo.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;

function TBind4DComponentMemo.Clear: iBind4DComponent;
begin
  Result := Self;
  FComponent.Lines.Text := '';
end;

constructor TBind4DComponentMemo.Create(aValue : TMemo);
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
  FComponent := aValue;
end;

destructor TBind4DComponentMemo.Destroy;
begin

  inherited;
end;

function TBind4DComponentMemo.GetCaption: String;
begin
  {$IFDEF HAS_FMX}
    Result := FComponent.Text;
  {$ELSE}
    Result := FComponent.Lines.Text;
  {$ENDIF}
end;

function TBind4DComponentMemo.GetValueString: String;
begin
  {$IFDEF HAS_FMX}
    Result := FComponent.Text;
  {$ELSE}
    Result := FComponent.Lines.Text;
  {$ENDIF}
end;

class function TBind4DComponentMemo.New(aValue : TMemo) : iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;

end.