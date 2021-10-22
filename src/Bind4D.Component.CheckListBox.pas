unit Bind4D.Component.CheckListBox;

interface

uses
  Bind4D.Component.Interfaces,
  Bind4D.Attributes,
  Vcl.CheckLst;

Type
  TBind4DComponentCheckListBox = class(TInterfacedObject, iBind4DComponent)
  private
    FComponent : TCheckListBox;
    FAttributes : iBind4DComponentAttributes;
  public
    constructor Create(aValue : TCheckListBox);
    destructor Destroy; override;
    class function New(aValue : TCheckListBox) : iBind4DComponent;
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
  System.Classes,
  System.Variants,
  Vcl.StdCtrls,
  Bind4D.Component.Attributes,
  System.JSON;

{ TBind4DComponentCheckListBox }

function TBind4DComponentCheckListBox.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentCheckListBox.ApplyImage: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentCheckListBox.ApplyRestData: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentCheckListBox.ApplyStyles: iBind4DComponent;
begin
  Result := Self;
  FComponent.StyleElements := FAttributes.StyleSettings;
  FComponent.Color := FAttributes.Color;
  FComponent.Font.Color := FAttributes.FontColor;
  FComponent.Font.Name := FAttributes.FontName;
  FComponent.Font.Size := FAttributes.FontSize;
end;

function TBind4DComponentCheckListBox.ApplyText: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentCheckListBox.ApplyValue: iBind4DComponent;
var
  JsonArray : TJsonArray;
  ListIndex : Integer;
begin
  if VarIsNull(FAttributes.ValueVariant) then
    exit;

  JsonArray := TJSONObject.ParseJSONValue(FAttributes.ValueVariant) as TJSONArray;
  if not Assigned(JsonArray) then
    exit;

  try
    for var JsonItem in JsonArray do
    begin
      ListIndex := FComponent.Items.IndexOf(JsonItem.Value);
      if ListIndex > -1 then
        FComponent.Checked[ListIndex] := true;
    end;
  finally
    JsonArray.Free;
  end;
end;

function TBind4DComponentCheckListBox.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;

function TBind4DComponentCheckListBox.Clear: iBind4DComponent;
begin
  Result := Self;
  FComponent.CheckAll(cbUnchecked, true, true);
end;

constructor TBind4DComponentCheckListBox.Create(aValue : TCheckListBox);
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
  FComponent := aValue;
end;

destructor TBind4DComponentCheckListBox.Destroy;
begin

  inherited;
end;

function TBind4DComponentCheckListBox.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentCheckListBox.GetCaption: String;
begin
  Result := '';
end;

function TBind4DComponentCheckListBox.GetValueString: String;
var
  JsonArray : TJsonArray;
  I : Integer;
begin
  JsonArray := TJsonArray.Create;
  try
    for I := 0 to Pred(FComponent.Count) do
    begin
      if FComponent.Checked[I] then
        JsonArray.Add(FComponent.Items[I]);
    end;
    Result := JsonArray.ToString;
  finally
    JsonArray.Free;
  end;
end;

class function TBind4DComponentCheckListBox.New (aValue : TCheckListBox) : iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;

end.
