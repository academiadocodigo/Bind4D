unit Bind4D.Component.SpeedButton;

interface

uses
  {$IFDEF HAS_FMX}
    FMX.StdCtrls,
  {$ELSE}
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
    Vcl.Buttons,
  {$ENDIF}
  Bind4D.Component.Interfaces, Bind4D.Attributes;

type
  TBind4DComponentSpeedButton = class(TInterfacedObject, iBind4DComponent)
    private
      FComponent : TSpeedButton;
      FAttributes : iBind4DComponentAttributes;
    public
      constructor Create(aValue : TSpeedButton);
      destructor Destroy; override;
      class function New(aValue : TSpeedButton) : iBind4DComponent;
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
  Bind4D.Component.Attributes,
  Bind4D.Component.ImageList;

{ TBind4DComponentSpeedButton }

function TBind4DComponentSpeedButton.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentSpeedButton.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentSpeedButton.ApplyImage: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
  {$ELSE}
    TBind4DImageList
      .New(
        FAttributes.Width,
        FAttributes.Heigth)
      .LoadImageResource(
        FAttributes.ResourceImage,
        FComponent.Glyph
      );
  {$ENDIF}
end;

function TBind4DComponentSpeedButton.ApplyStyles: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
    FComponent.StyledSettings := FAttributes.StyleSettings;
    FComponent.TextSettings.FontColor := FAttributes.Color;
    FComponent.TextSettings.Font.Family := FAttributes.FontName;
  {$ELSE}
    FComponent.StyleElements := FAttributes.StyleSettings;
    FComponent.Font.Size := FAttributes.FontSize;
    FComponent.Font.Color := FAttributes.FontColor;
    FComponent.Font.Name := FAttributes.FontName;
  {$ENDIF}
end;

function TBind4DComponentSpeedButton.ApplyText: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
    FComponent.Text := FAttributes.Text;
  {$ELSE}
    FComponent.Caption := FAttributes.Text;
  {$ENDIF}
end;

function TBind4DComponentSpeedButton.ApplyValue: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentSpeedButton.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;

function TBind4DComponentSpeedButton.Clear: iBind4DComponent;
begin
  Result := Self;
end;

constructor TBind4DComponentSpeedButton.Create(aValue : TSpeedButton);
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
  FComponent := aValue;
end;

destructor TBind4DComponentSpeedButton.Destroy;
begin

  inherited;
end;

function TBind4DComponentSpeedButton.GetValueString: String;
begin
  {$IFDEF HAS_FMX}
    Result := FComponent.Text;
  {$ELSE}
    Result := FComponent.Caption;
  {$ENDIF}
end;

class function TBind4DComponentSpeedButton.New(aValue : TSpeedButton) : iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;

end.
