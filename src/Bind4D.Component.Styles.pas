unit Bind4D.Component.Styles;

interface

uses
    Bind4D.Attributes,
    Bind4D.Interfaces,
    System.Generics.Collections;

type
  TBind4DComponentStyles = class(TInterfacedObject, iBind4DComponentStyles)
    private
      [weak]
      FParent : iBind4D;
      FListStyles : TObjectDictionary<string, ComponentBindStyle>;
    public
      constructor Create(aParent : iBind4D);
      destructor Destroy; override;
      class function New(aParent : iBind4D) : iBind4DComponentStyles;
      function Add ( aKey : String; aStyle : ComponentBindStyle) : iBind4DComponentStyles;
      function Get ( aKey : String ) : ComponentBindStyle;
      function &End : iBind4D;
  end;

implementation

{ TBind4DComponentStyles }

function TBind4DComponentStyles.&End: iBind4D;
begin
  Result := FParent;
end;

function TBind4DComponentStyles.Add(aKey: String;
  aStyle: ComponentBindStyle): iBind4DComponentStyles;
begin
  Result := Self;
  FListStyles.AddOrSetValue(aKey, aStyle);
end;

constructor TBind4DComponentStyles.Create(aParent : iBind4D);
begin
  FParent := aParent;
  FListStyles := TObjectDictionary<string, ComponentBindStyle>.Create;
end;

destructor TBind4DComponentStyles.Destroy;
begin
  for var Attr in FListStyles.Values do
    Attr.DisposeOf;

  FListStyles.DisposeOf;
  inherited;
end;

function TBind4DComponentStyles.Get(aKey: String): ComponentBindStyle;
begin
  Result := nil;
  FListStyles.TryGetValue(aKey, Result);
end;

class function TBind4DComponentStyles.New(aParent : iBind4D) : iBind4DComponentStyles;
begin
  Result := Self.Create(aParent);
end;

end.
