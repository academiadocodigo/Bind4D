unit Bind4D.Attributes;

interface

uses
  Bind4D.Types, System.UITypes, Vcl.Graphics, Data.DB, System.Classes;

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
    FStorageEndPoint: String;
    FAccountKey: String;
    FAccountName: String;
    FBucket: String;
    FFileExtension: String;
    FContentType: String;
    procedure SetAccountKey(const Value: String);
    procedure SetAccountName(const Value: String);
    procedure SetStorageEndPoint(const Value: String);
    procedure SetBucket(const Value: String);
    procedure SetContentType(const Value: String);
    procedure SetFileExtension(const Value: String);
    public
      constructor Create(aFileExtension : String; aContentType : String; aBucket: String; aAccounKey : String; aAccountName : String; aStorageEndPoint : String);
      property AccountKey : String read FAccountKey write SetAccountKey;
      property AccountName : String read FAccountName write SetAccountName;
      property StorageEndPoint : String read FStorageEndPoint write SetStorageEndPoint;
      property Bucket : String read FBucket write SetBucket;
      property ContentType : String read FContentType write SetContentType;
      property FileExtension : String read FFileExtension write SetFileExtension;
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
  ImageAttribute = class(TCustomAttribute)
    private
    FDefaultResourceImage: String;
    procedure SetDefaultResourceImage(const Value: String);
    public
      constructor Create( aDefaultResourceImage : String);
      property DefaultResourceImage : String read FDefaultResourceImage write SetDefaultResourceImage;
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

constructor S3Storage.Create(aFileExtension, aContentType, aBucket, aAccounKey,
  aAccountName, aStorageEndPoint: String);
begin
  FAccountKey := aAccounKey;
  FAccountName := aAccountName;
  FStorageEndPoint := aStorageEndPoint;
  FBucket := aBucket;
  FFileExtension := aFileExtension;
  FContentType := aContentType;
end;

procedure S3Storage.SetAccountKey(const Value: String);
begin
  FAccountKey := Value;
end;

procedure S3Storage.SetAccountName(const Value: String);
begin
  FAccountName := Value;
end;

procedure S3Storage.SetBucket(const Value: String);
begin
  FBucket := Value;
end;

procedure S3Storage.SetContentType(const Value: String);
begin
  FContentType := Value;
end;

procedure S3Storage.SetFileExtension(const Value: String);
begin
  FFileExtension := Value;
end;

procedure S3Storage.SetStorageEndPoint(const Value: String);
begin
  FStorageEndPoint := Value;
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

constructor ImageAttribute.Create(aDefaultResourceImage: String);
begin
  FDefaultResourceImage := aDefaultResourceImage;
end;

procedure ImageAttribute.SetDefaultResourceImage(const Value: String);
begin
  FDefaultResourceImage := Value;
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

end.
