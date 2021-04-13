unit Bind4D.Rest;

interface

uses
    Bind4D.Interfaces,
    RESTRequest4D,
    DataSet.Serialize,
    Data.DB,
    FireDAC.Stan.Intf,
    FireDAC.Stan.Option,
    FireDAC.Stan.Param,
    FireDAC.Stan.Error,
    FireDAC.DatS,
    FireDAC.Phys.Intf,
    FireDAC.DApt.Intf,
    FireDAC.Comp.DataSet,
    FireDAC.Comp.Client,
    System.Generics.Collections,
    System.JSON;

type
  TBind4DRest = class(TInterfacedObject, iBind4DRest)
    private
      [weak]
      FParent : iBind4D;
      FResquest : IRequest;
      FBaseURL : String;
      FDataSet : TFDMemTable;
      FParam : TDictionary<string, string>;
    public
      constructor Create(aParent : iBind4D);
      destructor Destroy; override;
      class function New(aParent : iBind4D) : iBind4DRest;
      function &End : iBind4D;
      function BaseURL ( aValue : String ) : iBind4DRest;
      function AddHeader ( aKey : String; aValue : String ) : iBind4DRest;
      function AddParam ( aKey : String; aValue : String ) : iBind4DRest;
      function Accept ( aValue : String ) : iBind4DRest;
      function Get (aEndPoint : String = '') : iBind4DRest;
      function Post (aEndPoint : String; aBody : TJsonObject)  : iBind4DRest;
      function DataSet : TDataSet;
  end;

implementation

uses
  StrUtils;

{ TBind4DRest }

function TBind4DRest.&end : iBind4D;
begin
    Result := FParent;
end;

function TBind4DRest.Get(aEndPoint: String): iBind4DRest;
var
  aURL: string;
begin
  if aEndPoint = '' then exit;

  if Assigned(FDataSet) then
    FDataSet.DisposeOf;

  FDataSet := TFDMemTable.Create(nil);

  aURL := FBaseURL + aEndPoint;
  if not ContainsText(aURL, '?') then aURL := aURL + '?';

  if FParam.Count > 0 then
    for var Param in FParam do
      aURL := aURL + Param.Key + '=' + Param.Value + '&';

  TRequest.New
  .BaseURL(aURL)
   .Accept('application/json')
   .DataSetAdapter(FDataSet)
  .Get;

  FParam.Clear;
end;

function TBind4DRest.Accept(aValue: String): iBind4DRest;
begin
  Result := Self;
  FResquest.Accept(aValue);
end;

function TBind4DRest.AddHeader(aKey, aValue: String): iBind4DRest;
begin
  Result := Self;
  FResquest.AddHeader(aKey, aValue);
end;

function TBind4DRest.AddParam(aKey, aValue: String): iBind4DRest;
begin
  Result := Self;
  FParam.Add(aKey, aValue);
end;

function TBind4DRest.BaseURL(aValue: String): iBind4DRest;
begin
  Result := Self;
  FBaseURL := aValue;
end;

constructor TBind4DRest.Create(aParent : iBind4D);
begin
  FParent := aParent;
  FResquest := TRequest.New;
  FParam := TDictionary<string, string>.Create;
  //FDataSet := TFDMemTable.Create(nil);
end;

function TBind4DRest.DataSet: TDataSet;
begin
  Result := FDataSet;
end;

destructor TBind4DRest.Destroy;
begin
  if Assigned(FDataSet) then
    FDataSet.DisposeOf;

  FParam.DisposeOf;
  inherited;
end;

class function TBind4DRest.New(aParent : iBind4D): iBind4DRest;
begin
  Result := Self.Create(aParent);
end;

function TBind4DRest.Post(aEndPoint: String; aBody: TJsonObject): iBind4DRest;
begin
   TRequest.New
  .BaseURL(FBaseURL + aEndPoint)
   .Accept('application/json')
   .AddBody(aBody.ToString)
  .Post;
end;

end.
