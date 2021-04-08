unit Bind4D.Helpers;
interface
uses
  System.Rtti,
  System.Classes,
  Bind4D.Component.Interfaces,
  Bind4D.Component.Attributes;

type

  TComponentHelper = class helper for TComponent
  public
    function TryGet<T : TComponent> : Boolean;
    function Get<T : TComponent> : T;
  end;

  TRttiFieldHelper = class helper for TRttiField
  public
    function Tem<T: TCustomAttribute>: Boolean;
    function GetAttribute<T: TCustomAttribute>: T;
  end;

  TRttiTypeHelper = class helper for TRttiType
  public
    function Tem<T: TCustomAttribute>: Boolean;
    function GetAttribute<T: TCustomAttribute>: T;
  end;

  TComponentBindStyleHelper = class helper for TCustomAttribute
  public
    function Component : TComponent; overload;
  end;


implementation
{ TRttiFieldHelper }

uses
  Bind4D.Utils.Rtti;


function TRttiFieldHelper.GetAttribute<T>: T;
var
  oAtributo: TCustomAttribute;
begin
  Result := nil;
  for oAtributo in GetAttributes do
    if oAtributo is T then
      Exit((oAtributo as T));
end;
function TRttiFieldHelper.Tem<T>: Boolean;
begin
  Result := GetAttribute<T> <> nil;
end;
{ TRttiTypeHelper }
function TRttiTypeHelper.GetAttribute<T>: T;
var
  oAtributo: TCustomAttribute;
begin
  Result := nil;
  for oAtributo in GetAttributes do
    if oAtributo is T then
      Exit((oAtributo as T));
end;
function TRttiTypeHelper.Tem<T>: Boolean;
begin
   Result := GetAttribute<T> <> nil;
end;
{ TComponentHelper }

function TComponentHelper.Get<T>: T;
begin
  Result := (Self as T);
end;

function TComponentHelper.TryGet<T>: Boolean;
begin
  Result := (Self is T);
end;

{ TComponentBindStyleHelper }

function TComponentBindStyleHelper.Component: TComponent;
begin
  Result := RttiUtils.GetComponent(Self);
end;



end.
