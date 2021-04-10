unit Bind4D.Types.Put;

interface

uses
  Bind4D.Types.Interfaces,
  System.Classes, System.JSON;

type
  TBind4DTypesPut = class(TInterfacedObject, iBind4DTypesInterface)
    private
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iBind4DTypesInterface;
      function TryGetJsonName(aComponent : TComponent; out aJsonName : String ) : Boolean;
      function GetJsonName (aComponent : TComponent) : String;
      procedure TryAddJsonPair( aComponent : TComponent; var aJsonObject : TJsonObject);
  end;

implementation

uses
  Bind4D.Utils.Rtti, Bind4D.Types, Bind4D.Attributes, Bind4D.Component.Utils;

{ TBind4DTypesGet }

constructor TBind4DTypesPut.Create;
begin

end;

destructor TBind4DTypesPut.Destroy;
begin

  inherited;
end;

function TBind4DTypesPut.GetJsonName(aComponent: TComponent): String;
var
  aAttrIgPut : FbIgnorePut;
  aAttrFJBind : FieldJsonBind;
begin
  if not RttiUtils.TryGet<FbIgnorePut>(aComponent, aAttrIgPut) then
    if RttiUtils.TryGet<FieldJsonBind>(aComponent, aAttrFJBind) then
      Result := aAttrFJBind.JsonName;
end;

class function TBind4DTypesPut.New: iBind4DTypesInterface;
begin
  Result := Self.Create;
end;

procedure TBind4DTypesPut.TryAddJsonPair(aComponent: TComponent;
  var aJsonObject: TJsonObject);
var
  aAttr : FbIgnorePut;
  aAttrJson : FieldJsonBind;
begin
  if not RttiUtils.TryGet<FbIgnorePut>(aComponent, aAttr) then
    if RttiUtils.TryGet<FieldJsonBind>(aComponent, aAttrJson) then
      aJsonObject.AddPair(aAttrJson.JsonName, TBind4DComponentUtils.GetValueString(aComponent));
end;

function TBind4DTypesPut.TryGetJsonName(aComponent: TComponent;
  out aJsonName: String): Boolean;
var
  aAttrIg : FbIgnorePut;
  aAttrFJBind : FieldJsonBind;
begin
  Result := False;
  if not RttiUtils.TryGet<FbIgnorePut>(aComponent, aAttrIg) then
    if RttiUtils.TryGet<FieldJsonBind>(aComponent, aAttrFJBind) then
    begin
      Result := True;
      aJsonName := aAttrFJBind.JsonName;
    end;
end;

end.
