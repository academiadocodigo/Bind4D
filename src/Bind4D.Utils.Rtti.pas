unit Bind4D.Utils.Rtti;

interface

uses
  {$IFDEF HAS_FMX}
    FMX.Forms,
  {$ElSE}
    Vcl.Forms,
  {$ENDIF}
  System.Classes,
  System.Rtti,
  System.Generics.Collections;

type

  TBind4DUtilsRtti = class
    private
      FComponentList : TDictionary<TCustomAttribute, TComponent>;
      FprpRttiList : TDictionary<TComponent, TRttiField>;
    public
      constructor Create; 
      destructor Destroy; override;
      function Get<T : TCustomAttribute>(aForm : TForm) : TArray<T>;
      function GetAttClass<T : TCustomAttribute>(aForm : TForm) : TArray<T>;
      function GetComponent(aAttribute : TCustomAttribute) : TComponent;
      function TryGet<T : TCustomAttribute>(aComponent : TComponent; out Attribute : T) : Boolean;
      function GetComponents(aForm : TForm) : TArray<TComponent>;
    end;

var
  RttiUtils : TBind4DUtilsRtti;
  
implementation

uses
  Bind4D.Helpers;

{ TBind4DUtilsRtti }

constructor TBind4DUtilsRtti.Create;
begin
  FComponentList := TDictionary<TCustomAttribute, TComponent>.Create;
  FprpRttiList := TDictionary<TComponent, TRttiField>.Create;
end;

destructor TBind4DUtilsRtti.Destroy;
begin
  FprpRttiList.Free;
  FComponentList.Free;
  inherited;
end;

function TBind4DUtilsRtti.Get<T>(aForm : TForm) : TArray<T>;
var
  ctxRtti : TRttiContext;
  typRtti : TRttiType;
  prpRtti : TRttiField;
  vprpRtti : TRttiField;
  dec : Integer;
  aComponent : TComponent;
begin
  ctxRtti := TRttiContext.Create;
  dec := 0;
  try
    typRtti := ctxRtti.GetType(aForm.ClassInfo);
    for prpRtti in typRtti.GetFields do
    begin
      aComponent := aForm.FindComponent(prpRtti.Name);

      if not FprpRttiList.TryGetValue(aComponent, vprpRtti) then
        FprpRttiList.Add(aComponent, prpRtti);

      if prpRtti.Tem<T> then
      begin
        Inc(dec);
        SetLength(Result, dec);
        Result[dec-1] := prpRtti.GetAttribute<T>;
        if not FComponentList.TryGetValue(Result[dec-1], aComponent) then
          FComponentList.Add(Result[dec-1], aForm.FindComponent(prpRtti.Name));
      end;
    end;
  finally
    ctxRtti.Free;
  end;
end;

function TBind4DUtilsRtti.GetAttClass<T>(aForm: TForm): TArray<T>;
var
  vCtxRtti: TRttiContext;
  vTypRtti: TRttiType;
  dec : Integer;
begin
  dec := 0;
  vCtxRtti := TRttiContext.Create;
  try
    vTypRtti := vCtxRtti.GetType(aForm.ClassInfo);
    if vTypRtti.Tem<T> then
    begin
      Inc(dec);
      SetLength(Result, dec);
      Result[dec-1] := vTypRtti.GetAttribute<T>;
    end;
  finally
    vCtxRtti.Free;
  end;
end;

function TBind4DUtilsRtti.GetComponent(
  aAttribute: TCustomAttribute): TComponent;
begin
  FComponentList.TryGetValue(aAttribute, Result);
end;

function TBind4DUtilsRtti.GetComponents(aForm: TForm): TArray<TComponent>;
var
  ctxRtti : TRttiContext;
  typRtti : TRttiType;
  prpRtti : TRttiField;
  dec : Integer;
begin
  ctxRtti := TRttiContext.Create;
  dec := 0;
  try
    typRtti := ctxRtti.GetType(aForm.ClassInfo);
    for prpRtti in typRtti.GetFields do
    begin
      Inc(dec);
      SetLength(Result, dec);
      Result[dec-1] := aForm.FindComponent(prpRtti.Name);
    end;
  finally
    ctxRtti.Free;
  end;
end;

function TBind4DUtilsRtti.TryGet<T>(aComponent : TComponent; out Attribute : T) : Boolean;
var
  prpRtti: TRttiField;
begin
  Result := False;
  if FprpRttiList.TryGetValue(aComponent, prpRtti) then
    if prpRtti.Tem<T> then
    begin
      Attribute := prpRtti.GetAttribute<T>;
      Result := not (Attribute = nil);
    end;
end;

initialization
  RttiUtils := TBind4DUtilsRtti.Create;

finalization
  RttiUtils.Free;

end.
