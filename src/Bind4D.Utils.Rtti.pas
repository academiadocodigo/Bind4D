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
      FComponentList : TDictionary<TForm, TDictionary<TCustomAttribute, TComponent>>;
      FprpRttiList : TDictionary<TForm, TDictionary<TComponent, TRttiField>>;
    public
      constructor Create;
      destructor Destroy; override;
      function Get<T : TCustomAttribute>(aForm : TForm) : TArray<T>;
      function GetAttClass<T : TCustomAttribute>(aForm : TForm) : TArray<T>;
      function GetComponent(aForm: TForm; aAttribute : TCustomAttribute) : TComponent;
      function TryGet<T : TCustomAttribute>(aComponent : TComponent; out Attribute : T) : Boolean;
      function GetComponents(aForm : TForm) : TArray<TComponent>;
      function ClearCache : TBind4DUtilsRtti;
      procedure CollectionNotifyEventComponent(Sender: TObject; const Item: TDictionary<TCustomAttribute, TComponent>;
          Action: TCollectionNotification);
      procedure CollectionNotifyEventPrpRtti(Sender: TObject; const Item: TDictionary<TComponent, TRttiField>;
          Action: TCollectionNotification);
    end;
var
  RttiUtils : TBind4DUtilsRtti;
implementation
uses
  Bind4D.Helpers;
{ TBind4DUtilsRtti }
function TBind4DUtilsRtti.ClearCache: TBind4DUtilsRtti;
begin
  Result := Self;
  FComponentList.Clear;
  FprpRttiList.Clear;
end;

procedure TBind4DUtilsRtti.CollectionNotifyEventComponent(Sender: TObject;
  const Item: TDictionary<TCustomAttribute, TComponent>; Action: TCollectionNotification);
begin
  if Action = cnRemoved then
    Item.Free;
end;

procedure TBind4DUtilsRtti.CollectionNotifyEventPrpRtti(Sender: TObject;
  const Item: TDictionary<TComponent, TRttiField>;
  Action: TCollectionNotification);
begin
  if Action = cnRemoved then
    Item.Free;
end;

constructor TBind4DUtilsRtti.Create;
begin
  FComponentList := TDictionary<TForm, TDictionary<TCustomAttribute, TComponent>>.Create;
  FComponentList.OnValueNotify := CollectionNotifyEventComponent;
  FprpRttiList := TDictionary<TForm, TDictionary<TComponent, TRttiField>>.Create;
  FprpRttiList.OnValueNotify := CollectionNotifyEventPrpRtti;
end;

destructor TBind4DUtilsRtti.Destroy;
begin
  FprpRttiList.Clear;
  FprpRttiList.Free;
  FComponentList.Clear;
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
  LprpRttiList : TDictionary<TComponent, TRttiField>;
  LComponentList : TDictionary<TCustomAttribute, TComponent>;
begin
  ctxRtti := TRttiContext.Create;
  dec := 0;
  try
    typRtti := ctxRtti.GetType(aForm.ClassInfo);
    for prpRtti in typRtti.GetFields do
    begin
      aComponent := aForm.FindComponent(prpRtti.Name);
      if not FprpRttiList.TryGetValue(aForm, LprpRttiList) then
      begin
        LprpRttiList := TDictionary<TComponent, TRttiField>.Create;
        FprpRttiList.Add(aForm, LprpRttiList);
      end;
      if not LprpRttiList.TryGetValue(aComponent, vprpRtti) then
        lprpRttiList.Add(aComponent, prpRtti);
      if prpRtti.Tem<T> then
      begin
        Inc(dec);
        SetLength(Result, dec);
        Result[dec-1] := prpRtti.GetAttribute<T>;
        if not FComponentList.TryGetValue(aForm, LComponentList) then
        begin
          LComponentList := TDictionary<TCustomAttribute, TComponent>.Create;
          FComponentList.Add(aForm, LComponentList);
        end;
        if not LComponentList.TryGetValue(Result[dec-1], aComponent) then
          LComponentList.Add(Result[dec-1], aForm.FindComponent(prpRtti.Name));
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
  Attrib : TCustomAttribute;
  dec : Integer;
begin
  dec := 0;
  vCtxRtti := TRttiContext.Create;
  try
    vTypRtti := vCtxRtti.GetType(aForm.ClassInfo);
    for Attrib in vTypRtti.GetAttributes do
    begin
      if Attrib.ClassName = T.ClassName then
      begin
        Inc(dec);
        SetLength(Result, dec);
        Result[dec-1] := T(Attrib);
      end;
    end;
  finally
    vCtxRtti.Free;
  end;
end;
function TBind4DUtilsRtti.GetComponent(aForm: TForm;
  aAttribute: TCustomAttribute): TComponent;
var
  LComponentList : TDictionary<TCustomAttribute, TComponent>;
begin
  if FComponentList.TryGetValue(aForm, LComponentList) then
    LComponentList.TryGetValue(aAttribute, Result);
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
  Lform : TForm;
  LprpRttiList : TDictionary<TComponent, TRttiField>;
begin
  Result := False;
  LForm := aComponent.Owner as TForm;
  if FprpRttiList.TryGetValue(LForm, LprpRttiList) then
    if LprpRttiList.TryGetValue(aComponent, prpRtti) then
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
