unit Bind4D.Types.Delete;

interface

uses
  Bind4D.Types.Interfaces,
  System.Classes, System.JSON;

type
  TBind4DTypesDelete = class(TInterfacedObject, iBind4DTypesInterface)
    private
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iBind4DTypesInterface;
      function GetJsonName (aComponent : TComponent) : String;
      procedure TryAddJsonPair( aComponent : TComponent; var aJsonObject : TJsonObject);
  end;

implementation

uses
  Bind4D.Utils.Rtti, Bind4D.Types, Bind4D.Attributes, Bind4D.Component.Utils;

{ TBind4DTypesGet }

constructor TBind4DTypesDelete.Create;
begin

end;

destructor TBind4DTypesDelete.Destroy;
begin

  inherited;
end;

function TBind4DTypesDelete.GetJsonName(aComponent: TComponent): String;
var
  aAttrIgDelete : FbIgnoreDelete;
  aAttrFJBind : FieldJsonBind;
begin
  if not RttiUtils.TryGet<FbIgnoreDelete>(aComponent, aAttrIgDelete) then
    if RttiUtils.TryGet<FieldJsonBind>(aComponent, aAttrFJBind) then
      Result := aAttrFJBind.JsonName;
end;

class function TBind4DTypesDelete.New: iBind4DTypesInterface;
begin
  Result := Self.Create;
end;

procedure TBind4DTypesDelete.TryAddJsonPair(aComponent: TComponent;
  var aJsonObject: TJsonObject);
var
  aAttr : FbIgnoreDelete;
  aAttrJson : FieldJsonBind;
begin
  if not RttiUtils.TryGet<FbIgnoreDelete>(aComponent, aAttr) then
    if RttiUtils.TryGet<FieldJsonBind>(aComponent, aAttrJson) then
      aJsonObject.AddPair(aAttrJson.JsonName, TBind4DComponentUtils.GetValueString(aComponent));
end;

end.
