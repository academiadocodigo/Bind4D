unit Bind4D.Attributes;
interface
uses
  Bind4D.Types,
  System.UITypes,
  Vcl.Graphics,
  Data.DB,
  System.Classes;
type
  {$region 'Validation Attributes'}
  fvNotNull = class(TCustomAttribute)
  private
    FMsg: String;
    procedure SetMsg(const Value: String);
  public
    constructor Create(aMsg : String);
    property Msg : String read FMsg write SetMsg;
  end;
  {$endregion}

  {$region 'Form Attributes'}
  FormDefault = class(TCustomAttribute)
    private
    FTitle: String;
    procedure SetTitle(const Value: String);
    public
      constructor Create ( aTitle : String = '' );
      property Title : String read FTitle write SetTitle;
  end;
  FormRest = class(TCustomAttribute)
    private
    FPK: String;
    FEndPoint: String;
    FOrder: String;
    FSort: String;
    procedure SetEndPoint(const Value: String);
    procedure SetPK(const Value: String);
    procedure SetOrderBy(const Value: String);
    procedure SetSort(const Value: String);
    public
      constructor Create(aEndPoint : String = ''; aPK : String = ''; aSort : String = ''; aOrder : String = 'asc');
      property EndPoint : String read FEndPoint write SetEndPoint;
      property PK : String read FPK write SetPK;
      property Order : String read FOrder write SetOrderBy;
      property Sort : String read FSort write SetSort;
  end;
  {$endregion}

   {$region 'Services Attributes'}
  S3Storage = class(TCustomAttribute)
    private
    FFileExtension: String;
    FContentType: String;
    procedure SetContentType(const Value: String);
    procedure SetFileExtension(const Value: String);
    public
      constructor Create(aFileExtension : String; aContentType : String);
      property ContentType : String read FContentType write SetContentType;
      property FileExtension : String read FFileExtension write SetFileExtension;
  end;

  HorseStorage = class(TCustomAttribute)
    private
    FFileExtension: String;
    FContentType: String;
    FEndPoint : string;
    FPath: string;
    procedure SetContentType(const Value: String);
    procedure SetFileExtension(const Value: String);
    procedure SetEndPoint(const Value: string);
    procedure SetPath(const Value: string);
    public
      constructor Create(aFileExtension : String; aContentType : String; aEndPoint : string; aPath : string);
      property ContentType : String read FContentType write SetContentType;
      property FileExtension : String read FFileExtension write SetFileExtension;
      property EndPoint : string read FEndPoint write SetEndPoint;
      property Path : string read FPath write SetPath;
  end;

  Translation = class(TCustomAttribute)
    private
      FQuery: String;
    procedure SetQuery(const Value: String);
    public
      constructor Create(aQuery : String);
      property Query : String read FQuery write SetQuery;
  end;
  {$endregion}


  {$region 'Components Attributes'}
  AdjustResponsive = class(TCustomAttribute)
  end;
  ImageAttribute = class(TCustomAttribute)
    private
      FDefaultResourceImage: String;
      FWidth: Integer;
      FHeigth: Integer;
      procedure SetDefaultResourceImage(const Value: String);
      procedure SetHeigth(const Value: Integer);
      procedure SetWidth(const Value: Integer);
    public
      constructor Create( aDefaultResourceImage : String; aWidth : Integer = 32; aHeigth : Integer = 32);
      property DefaultResourceImage : String read FDefaultResourceImage write SetDefaultResourceImage;
      property Width : Integer read FWidth write SetWidth;
      property Heigth : Integer read FHeigth write SetHeigth;
    end;
  ComponentBindStyle = class(TCustomAttribute)
    private
    FFontSize: Integer;
    FColor: TColor;
    FFontColor: TColor;
    FFontName: String;
    FEspecialType: TEspecialType;
    procedure SetColor(const Value: TColor);
    procedure SetFontColor(const Value: TColor);
    procedure SetFontSize(const Value: Integer);
    procedure SetFontName(const Value: String);
    procedure SetEspecialType(const Value: TEspecialType);
    public
      constructor Create(aColor : TColor = clBtnFace; aFontSize : Integer = 12; aFontColor : TColor = clBtnFace; aFontName : String = 'Tahoma'; aEspecialType : TEspecialType = teNull);
      property Color : TColor read FColor write SetColor;
      property FontSize : Integer read FFontSize write SetFontSize;
      property FontColor : TColor read FFontColor write SetFontColor;
      property FontName : String read FFontName write SetFontName;
      property EspecialType : TEspecialType read FEspecialType write SetEspecialType;
  end;
  ComponentBindFormat = class(TCustomAttribute)
    private
    FEspecialType: TEspecialType;
    procedure SetEspecialType(const Value: TEspecialType);
    public
      constructor Create(aEspecialType : TEspecialType = teNull);
      property EspecialType : TEspecialType read FEspecialType write SetEspecialType;
  end;
  {$endregion}

  {$region 'Json Attributes'}
  FieldJsonBind = class(TCustomAttribute)
  private
    FJsonName: string;
    procedure SetJsonName(const Value: string);
  public
    constructor Create(aJsonName: string);
    property JsonName : string read FJsonName write SetJsonName;
  end;
  FbIgnorePut = class(TCustomAttribute)
  end;
  FbIgnorePost = class(TCustomAttribute)
  end;
  FbIgnoreDelete = class(TCustomAttribute)
  end;
  FbIgnoreGet = class(TCustomAttribute)
  end;
  {$endregion}

   {$region 'DataSet Attributes'}
  FieldDataSetBind = class(TCustomAttribute)
    private
    FFieldName: String;
    FFDType: TFieldType;
    FDisplayName: String;
    FWidth: Integer;
    FVisible: Boolean;
    FAlignment: TAlignment;
    FEditMask: String;
    FFLimitWidth: Integer;
    procedure SetFieldName(const Value: String);
    procedure SetDisplayName(const Value: String);
    procedure SetWidth(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
    procedure SetAlignment(const Value: TAlignment);
    procedure SetEditMask(const Value: String);
    procedure SetFieldType(const Value: TFieldType);
    procedure SetFLimitWidth(const Value: Integer);
    public
      constructor Create(aFieldName : String; aFdType : TFieldType; aVisible : Boolean = True; aWidth : Integer = 0; aDisplayName : String = ''; aEditMask : String = ''; aAlignment : TAlignment = taLeftJustify; aLimitWidth : Integer = 0);
      property FieldName : String read FFieldName write SetFieldName;
      property Width : Integer read FWidth write SetWidth;
      property DisplayName : String read FDisplayName write SetDisplayName;
      property Visible : Boolean read FVisible write SetVisible;
      property Alignment : TAlignment read FAlignment write SetAlignment;
      property EditMask : String read FEditMask write SetEditMask;
      property FDType : TFieldType read FFDType write SetFieldType;
      property FLimitWidth : Integer read FFLimitWidth write SetFLimitWidth;
  end;
  {$endregion}
  
  {$region 'REST Attributes'}
  RestData = class(TCustomAttribute)
    private
    FFieldValue: String;
    FFieldKey: String;
    FEndPoint: String;
    FComponentName: string;
    FOtherChange: Boolean;
    FFieldBind: String;
    procedure SetEndPoint(const Value: String);
    procedure SetFieldKey(const Value: String);
    procedure SetFieldValue(const Value: String);
    procedure SetComponentName(const Value: string);
    procedure SetOtherChange(const Value: Boolean);
    procedure SetFieldBind(const Value: String);
    public
      constructor Create(aEndPoint, aFieldKey, aFieldValue : String); overload;
      constructor Create(aEndPoint, aFieldKey, aFieldValue : String; aComponentName : string; aFieldBind : String); overload;
      property EndPoint : String read FEndPoint write SetEndPoint;
      property FieldKey : String read FFieldKey write SetFieldKey;
      property FieldValue : String read FFieldValue write SetFieldValue;
      property FieldBind : String read FFieldBind write SetFieldBind;
      property ComponentName : string read FComponentName write SetComponentName;
      property OtherChange : Boolean read FOtherChange write SetOtherChange;
  end;

  
  RestQuickRegistration = class(TCustomAttribute)
    private
    FField: String;
    FTitle: String;
    FEndPoint: String;
    procedure SetEndPoint(const Value: String);
    procedure SetField(const Value: String);
    procedure SetTitle(const Value: String);
    public
      constructor Create(aEndPoint, aField, aTitle : String);
      property EndPoint : String read FEndPoint write SetEndPoint;
      property Field : String read FField write SetField;
      property Title : String read FTitle write SetTitle;
  end;
  {$endregion}

implementation
{ fvNotNull }
constructor fvNotNull.Create(aMsg: String);
begin
  FMsg := aMsg;
end;
procedure fvNotNull.SetMsg(const Value: String);
begin
  FMsg := Value;
end;
{ FormDefault }
constructor FormDefault.Create(aTitle: String);
begin
  FTitle := aTitle;
end;
procedure FormDefault.SetTitle(const Value: String);
begin
  FTitle := Value;
end;
{ FormRest }
constructor FormRest.Create(aEndPoint, aPK, aSort, aOrder: String);
begin
  FEndPoint := aEndPoint;
  FPK := aPK;
  FOrder := aOrder;
  FSort := aSort;
end;
procedure FormRest.SetEndPoint(const Value: String);
begin
  FEndPoint := Value;
end;
procedure FormRest.SetOrderBy(const Value: String);
begin
  FOrder := Value;
end;
procedure FormRest.SetPK(const Value: String);
begin
  FPK := Value;
end;
procedure FormRest.SetSort(const Value: String);
begin
  FSort := Value;
end;
{ Translation }
constructor Translation.Create(aQuery : String);
begin
  FQuery := aQuery;
end;
procedure Translation.SetQuery(const Value: String);
begin
  FQuery := Value;
end;
{ S3Storage }
constructor S3Storage.Create(aFileExtension : String; aContentType : String);
begin
  FFileExtension := aFileExtension;
  FContentType := aContentType;
end;
procedure S3Storage.SetContentType(const Value: String);
begin
  FContentType := Value;
end;
procedure S3Storage.SetFileExtension(const Value: String);
begin
  FFileExtension := Value;
end;
{ ComponentBindFormat }
constructor ComponentBindFormat.Create(aEspecialType: TEspecialType);
begin
  FEspecialType := aEspecialType;
end;
procedure ComponentBindFormat.SetEspecialType(const Value: TEspecialType);
begin
  FEspecialType := Value;
end;
{ ComponentBindStyle }
constructor ComponentBindStyle.Create(aColor: TColor; aFontSize: Integer;
  aFontColor: TColor; aFontName: String; aEspecialType: TEspecialType);
begin
  FColor := aColor;
  FFontSize := aFontSize;
  FFontColor := aFontColor;
  FFontName := aFontName;
  FEspecialType := aEspecialType;
end;
procedure ComponentBindStyle.SetColor(const Value: TColor);
begin
  FColor := Value;
end;
procedure ComponentBindStyle.SetEspecialType(const Value: TEspecialType);
begin
  FEspecialType := Value;
end;
procedure ComponentBindStyle.SetFontColor(const Value: TColor);
begin
  FFontColor := Value;
end;
procedure ComponentBindStyle.SetFontName(const Value: String);
begin
  FFontName := Value;
end;
procedure ComponentBindStyle.SetFontSize(const Value: Integer);
begin
  FFontSize := Value;
end;
{ ImageAttribute }
constructor ImageAttribute.Create( aDefaultResourceImage : String; aWidth : Integer = 32; aHeigth : Integer = 32);
begin
  FDefaultResourceImage := aDefaultResourceImage;
  FWidth := aWidth;
  FHeigth := aHeigth;
end;
procedure ImageAttribute.SetDefaultResourceImage(const Value: String);
begin
  FDefaultResourceImage := Value;
end;
procedure ImageAttribute.SetHeigth(const Value: Integer);
begin
  FHeigth := Value;
end;
procedure ImageAttribute.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;
{ FieldJsonBind }
constructor FieldJsonBind.Create(aJsonName: string);
begin
  FJsonName := aJsonName;
end;
procedure FieldJsonBind.SetJsonName(const Value: string);
begin
  FJsonName := Value;
end;
{ FieldDataSetBind }
constructor FieldDataSetBind.Create(aFieldName: String; aFdType: TFieldType;
  aVisible: Boolean; aWidth: Integer; aDisplayName, aEditMask: String;
  aAlignment: TAlignment; aLimitWidth: Integer);
begin
  FFieldName := aFieldName;
  FWidth := aWidth;
  FDisplayName := aDisplayName;
  FVisible := aVisible;
  FAlignment := aAlignment;
  FEditMask := aEditMask;
  FFdType := aFdType;
  FLimitWidth := aLimitWidth;
end;
procedure FieldDataSetBind.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
end;
procedure FieldDataSetBind.SetDisplayName(const Value: String);
begin
  FDisplayName := Value;
end;
procedure FieldDataSetBind.SetEditMask(const Value: String);
begin
  FEditMask := Value;
end;
procedure FieldDataSetBind.SetFieldName(const Value: String);
begin
  FFieldName := Value;
end;
procedure FieldDataSetBind.SetFieldType(const Value: TFieldType);
begin
  FFDType := Value;
end;
procedure FieldDataSetBind.SetFLimitWidth(const Value: Integer);
begin
  FFLimitWidth := Value;
end;
procedure FieldDataSetBind.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
end;
procedure FieldDataSetBind.SetWidth(const Value: Integer);
begin
  FWidth := Value;
end;

{ HorseStorage }

constructor HorseStorage.Create(aFileExtension : String; aContentType : String; aEndPoint : string; aPath : string);
begin
  FFileExtension := aFileExtension;
  FContentType := aContentType;
  FEndPoint:= aEndPoint;
  FPath:= aPath;
end;


procedure HorseStorage.SetContentType(const Value: String);
begin
  FContentType:= Value;
end;

procedure HorseStorage.SetEndPoint(const Value: string);
begin
  FEndPoint := Value;
end;

procedure HorseStorage.SetFileExtension(const Value: String);
begin
  FFileExtension:= Value;
end;

procedure HorseStorage.SetPath(const Value: string);
begin
  FPath := Value;
end;



{ RestData }

constructor RestData.Create(aEndPoint, aFieldKey, aFieldValue : String);
begin
  FEndPoint := aEndPoint;
  FFieldKey := aFieldKey;
  FFieldValue := aFieldValue;
  FOtherChange := False;
end;

constructor RestData.Create(aEndPoint, aFieldKey, aFieldValue, aComponentName, aFieldBind : string);
begin
  FEndPoint := aEndPoint;
  FFieldKey := aFieldKey;
  FFieldValue := aFieldValue;
  FComponentName := aComponentName;
  FFieldBind := aFieldBind;
  FOtherChange := True;
end;

procedure RestData.SetComponentName(const Value: string);
begin
  FComponentName := Value;
end;

procedure RestData.SetEndPoint(const Value: String);
begin
  FEndPoint := Value;
end;

procedure RestData.SetFieldBind(const Value: String);
begin
  FFieldBind := Value;
end;

procedure RestData.SetFieldKey(const Value: String);
begin
  FFieldKey := Value;
end;

procedure RestData.SetFieldValue(const Value: String);
begin
  FFieldValue := Value;
end;

procedure RestData.SetOtherChange(const Value: Boolean);
begin
  FOtherChange := Value;
end;

{ RestQuickRegistration }

constructor RestQuickRegistration.Create(aEndPoint, aField, aTitle: String);
begin
  FEndPoint := aEndPoint;
  FField := aField;
  FTitle := aTitle;
end;

procedure RestQuickRegistration.SetEndPoint(const Value: String);
begin
  FEndPoint := Value;
end;

procedure RestQuickRegistration.SetField(const Value: String);
begin
  FField := Value;
end;

procedure RestQuickRegistration.SetTitle(const Value: String);
begin
  FTitle := Value;
end;


end.
