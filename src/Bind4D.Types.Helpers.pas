unit Bind4D.Types.Helpers;

interface

uses 
  System.Classes,
  Bind4D.Types.Interfaces, 
  Bind4D.Types;

type
  TTypeBindFormJsonHelper = record helper for TTypeBindFormJson
    function This : iBind4DTypesInterface;
  end;

implementation

uses
  Bind4D.Types.Get, 
  Bind4D.Types.Post, 
  Bind4D.Types.Put, 
  Bind4D.Types.Delete;

{ TTypeBindFormJsonHelper }

function TTypeBindFormJsonHelper.This: iBind4DTypesInterface;
begin
  case Self of
    fbGet: Result := TBind4DTypesGet.New;
    fbPost: Result := TBind4DTypesPost.New;
    fbPut: Result := TBind4DTypesPut.New;
    fbDelete: Result := TBind4DTypesDelete.New;
  end;
end;

end.
