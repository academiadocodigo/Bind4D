unit Bind4D.Types.Interfaces;

interface

uses
  System.Classes, System.JSON;

type
  iBind4DTypesInterface = interface
    ['{EA313825-7246-4171-8E8C-FCA8C5B54880}']
    function GetJsonName (aComponent : TComponent) : String;
    function TryGetJsonName(aComponent : TComponent; out aJsonName : String ) : Boolean;
    procedure TryAddJsonPair( aComponent : TComponent; var aJsonObject : TJsonObject);
  end;

implementation

end.
