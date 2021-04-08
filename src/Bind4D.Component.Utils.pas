unit Bind4D.Component.Utils;

interface

uses
  Bind4D.Component.Interfaces, System.Classes;

type
  TBind4DComponentUtils = class(TInterfacedObject, iBind4DComponentUtils)
    private
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iBind4DComponentUtils;
      class function GetValueString ( aComponent : TComponent ) : String;
  end;

implementation

{ TBind4DComponentUtils }

uses Bind4D.Helpers, Bind4D.Component.Factory;

constructor TBind4DComponentUtils.Create;
begin

end;

destructor TBind4DComponentUtils.Destroy;
begin

  inherited;
end;

class function TBind4DComponentUtils.GetValueString(
  aComponent: TComponent): String;
begin
  Result := TBind4DComponentFactory.New.Component(aComponent).GetValueString;
end;

class function TBind4DComponentUtils.New: iBind4DComponentUtils;
begin
  Result := Self.Create;
end;

end.
