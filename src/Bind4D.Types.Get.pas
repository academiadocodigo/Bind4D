unit Bind4D.Types.Get;

interface

uses
  Bind4D.Types.Interfaces,
  System.Classes, System.JSON;

type
  TBind4DTypesGet = class(TInterfacedObject, iBind4DTypesInterface)
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

constructor TBind4DTypesGet.Create;
begin

end;

destructor TBind4DTypesGet.Destroy;
begin

  inherited;
end;

function TBind4DTypesGet.GetJsonName(aComponent: TComponent): String;
var
  aAttrIgGet : FbIgnoreGet;
  aAttrFJBind : FieldJsonBind;
begin
  if not RttiUtils.TryGet<FbIgnoreGet>(aComponent, aAttrIgGet) then
    if RttiUtils.TryGet<FieldJsonBind>(aComponent, aAttrFJBind) then
      Result := aAttrFJBind.JsonName;
end;

class function TBind4DTypesGet.New: iBind4DTypesInterface;
begin
  Result := Self.Create;
end;

procedure TBind4DTypesGet.TryAddJsonPair(aComponent: TComponent;
  var aJsonObject: TJsonObject);
var
  aAttrFJBind : FieldJsonBind;
begin
  if RttiUtils.TryGet<FieldJsonBind>(aComponent, aAttrFJBind) then
    aJsonObject.AddPair(aAttrFJBind.JsonName, TBind4DComponentUtils.GetValueString(aComponent));
end;

end.
