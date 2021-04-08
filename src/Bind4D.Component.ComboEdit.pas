unit Bind4D.Component.ComboEdit;

interface

uses
  {$IFDEF HAS_FMX}
    FMX.StdCtrls,
    FMX.Objects,
    FMX.ComboEdit,
  {$ELSE}
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
  {$ENDIF}
  Bind4D.Component.Interfaces, Bind4D.Attributes;

type
  TBind4DComponentComboEdit = class(TInterfacedObject, iBind4DComponent)
    private
      {$IFDEF HAS_FMX}
      FComponent : TComboEdit;
      {$ENDIF}
      FAttributes : iBind4DComponentAttributes;
    public
      {$IFDEF HAS_FMX}
      constructor Create(aValue : TComboEdit);
      class function New(aValue : TComboEdit) : iBind4DComponent;
      {$ENDIF}
      destructor Destroy; override;
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

{ TBind4DComponentComboEdit }

function TBind4DComponentComboEdit.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentComboEdit.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentComboEdit.ApplyImage: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentComboEdit.ApplyStyles: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
   FComponent.StyledSettings := FAttributes.StyledSettings;
   FComponent.TextSettings.FontColor := FAttributes.FontColor;
   FComponent.TextSettings.Font.Family := FAttributes.FontName;
  {$ENDIF}
end;

function TBind4DComponentComboEdit.ApplyText: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentComboEdit.ApplyValue: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentComboEdit.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;

function TBind4DComponentComboEdit.Clear: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
  FComponent.ItemIndex := -1;
  {$ENDIF}
end;

{$IFDEF HAS_FMX}
constructor TBind4DComponentComboEdit.Create(aValue : TComboEdit);
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
  FComponent := aValue;
end;

class function TBind4DComponentComboEdit.New(aValue : TComboEdit) : iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;
{$ENDIF}

destructor TBind4DComponentComboEdit.Destroy;
begin

  inherited;
end;

function TBind4DComponentComboEdit.GetValueString: String;
begin
  Result := '';
  //TODO: Implementar Retorno ComboEdit no FMX;
end;

end.
