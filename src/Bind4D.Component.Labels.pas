unit Bind4D.Component.Labels;

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
  TBind4DComponentLabel = class(TInterfacedObject, iBind4DComponent)
    private
      FComponent : TLabel;
      FAttributes : iBind4DComponentAttributes;
    public
      constructor Create(aValue : TLabel);
      destructor Destroy; override;
      class function New(aValue : TLabel) : iBind4DComponent;
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

{ TBind4DComponentLabel }

function TBind4DComponentLabel.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentLabel.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentLabel.ApplyImage: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentLabel.ApplyRestData: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentLabel.ApplyStyles: iBind4DComponent;
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

function TBind4DComponentLabel.ApplyText: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
    FComponent.Text := FAttributes.Text;
  {$ELSE}
    FComponent.Caption := FAttributes.Text;
  {$ENDIF}
end;

function TBind4DComponentLabel.ApplyValue: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentLabel.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;

function TBind4DComponentLabel.Clear: iBind4DComponent;
begin
  Result := Self;
end;

constructor TBind4DComponentLabel.Create(aValue : TLabel);
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
  FComponent := aValue;
end;

destructor TBind4DComponentLabel.Destroy;
begin

  inherited;
end;

function TBind4DComponentLabel.GetCaption: String;
begin
  {$IFDEF HAS_FMX}
    Result := FComponent.Text;
  {$ELSE}
    Result := FComponent.Caption;
  {$ENDIF}
end;

function TBind4DComponentLabel.GetValueString: String;
begin
  {$IFDEF HAS_FMX}
    Result := FComponent.Text;
  {$ELSE}
    Result := FComponent.Caption;
  {$ENDIF}
end;

class function TBind4DComponentLabel.New(aValue : TLabel) : iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;

end.
