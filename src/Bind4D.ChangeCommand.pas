unit Bind4D.ChangeCommand;

interface

uses
  System.Generics.Collections, System.SysUtils;

type

  TChangeProc = procedure (Sender : TObject ) of Object;

  iCommandMaster = interface
    function Add ( aKey : TObject; aValue : TProc<TObject> ) : iCommandMaster;
    function Execute( aKey : TObject ) : iCommandMaster;
  end;

  TCommandMaster = class(TInterfacedObject, iCommandMaster)
    private
      FList : TDictionary<TObject, TList<TProc<TObject>>>;
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iCommandMaster;
      function Add ( aKey : TObject; aValue : TProc<TObject> ) : iCommandMaster;
      function Execute( aKey : TObject ) : iCommandMaster;
  end;

var
  CommandMaster : iCommandMaster;


implementation


{ TCommandMaster }

function TCommandMaster.Add(aKey: TObject; aValue: TProc<TObject>): iCommandMaster;
var
  aList : TList<TProc<TObject>>;
begin
  if FList.TryGetValue(aKey, aList) then
  begin
    aList.Add(aValue);
  end
  else
  begin
    aList := TList<TProc<TObject>>.Create;
    aList.Add(aValue);
    FList.Add(aKey, aList);
  end;
end;

constructor TCommandMaster.Create;
begin
  FList := TDictionary<TObject, TList<TProc<TObject>>>.Create;
end;

destructor TCommandMaster.Destroy;
begin
  for var List in FList do
    List.Value.Free;

  FList.Free;

  inherited;
end;

function TCommandMaster.Execute( aKey : TObject ): iCommandMaster;
var
  aList : TList<TProc<TObject>>;
  I: Integer;
begin
  if FList.TryGetValue(aKey, aList) then
  begin
    for I := 0 to Pred(aList.Count) do
      aList[I](aKey);
  end;
end;

class function TCommandMaster.New: iCommandMaster;
begin
  if not Assigned(CommandMaster) then
    CommandMaster := Self.Create;

  Result := CommandMaster;

end;

end.
