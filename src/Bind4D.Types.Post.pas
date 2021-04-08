unit Bind4D.Types.Post;

interface

uses
  Bind4D.Types.Interfaces,
  System.Classes, System.JSON;

type
  TBind4DTypesPost = class(TInterfacedObject, iBind4DTypesInterface)
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

constructor TBind4DTypesPost.Create;
begin

end;

destructor TBind4DTypesPost.Destroy;
begin

  inherited;
end;

function TBind4DTypesPost.GetJsonName(aComponent: TComponent): String;
var
  aAttrIgPost : FbIgnorePost;
  aAttrFJBind : FieldJsonBind;
begin
  if not RttiUtils.TryGet<FbIgnorePost>(aComponent, aAttrIgPost) then
    if RttiUtils.TryGet<FieldJsonBind>(aComponent, aAttrFJBind) then
      Result := aAttrFJBind.JsonName;
end;

class function TBind4DTypesPost.New: iBind4DTypesInterface;
begin
  Result := Self.Create;
end;

procedure TBind4DTypesPost.TryAddJsonPair(aComponent: TComponent;
  var aJsonObject: TJsonObject);
var
  aAttr : FbIgnorePost;
  aAttrJson : FieldJsonBind;
begin
  if not RttiUtils.TryGet<FbIgnorePost>(aComponent, aAttr) then
    if RttiUtils.TryGet<FieldJsonBind>(aComponent, aAttrJson) then
      aJsonObject.AddPair(aAttrJson.JsonName, TBind4DComponentUtils.GetValueString(aComponent));
end;

end.
