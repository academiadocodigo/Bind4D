unit Bind4D.Component.Attributes;
interface
uses
  Bind4D.Component.Interfaces,
  {$IFDEF HAS_FMX}
    FMX.Types,
    FMX.Forms,
  {$ELSE}
    Vcl.Controls,
    Vcl.Forms,
  {$ENDIF}
  Data.DB,
  System.UITypes,
  System.SysUtils,
  Bind4D.Types,
  System.Classes, System.Rtti;
type
  TBind4DComponentAttributes = class(TInterfacedObject, iBind4DComponentAttributes)
    private
      [weak]
      FParent : iBind4DComponent;
      {$IFDEF HAS_FMX}
        FStyleSettings : TStyledSetting;
      {$ELSE}
        FStyleSettings : TStyleElements;
      {$ENDIF}
      FFontColor : TAlphaColor;
      FFontName : String;
      FFontSize : Integer;
      FOnChange : TProc<TObject>;
      FEspecialType : TEspecialType;
      FParentBackground : Boolean;
      FColor : TAlphaColor;
      FText : String;
      FImageStream : TMemoryStream;
      FWidth : Integer;
      FHeigth : Integer;
      FResourceImage : String;
      FFieldType : TFieldType;
      FValueVariant : Variant;
      FField : TField;
      FRttiField : TRttiField;
      FForm : TForm;
      FEndPoint : String;
      FFieldKey : String;
      FFieldValue : String;
      FComponentNameBind : String;
      FFieldBind : String;
      FTitle : String;
    public
      constructor Create(aValue : iBind4DComponent);
      destructor Destroy; override;
      class function New(aValue : iBind4DComponent) : iBind4DComponentAttributes;
      function Form ( aForm : TForm ) : iBind4DComponentAttributes; overload;
      function Form : TForm; overload;
      function Color ( aValue : TAlphaColor ) : iBind4DComponentAttributes; overload;
      function Color : TAlphaColor; overload;
      function FontColor ( aValue : TAlphaColor ) : iBind4DComponentAttributes; overload;
      function FontColor : TAlphaColor; overload;
      function FontName ( aValue : String ) : iBind4DComponentAttributes; overload;
      function FontName : String; overload;
      function FontSize ( aValue : Integer ) : iBind4DComponentAttributes; overload;
      function FontSize : Integer; overload;
      {$IFDEF HAS_FMX}
      function StyleSettings ( aValue : TStyledSetting ) : iBind4DComponentAttributes; overload;
      function StyleSettings : TStyledSetting; overload;
      {$ELSE}
      function StyleSettings ( aValue : TStyleElements) : iBind4DComponentAttributes; overload;
      function StyleSettings : TStyleElements; overload;
      {$ENDIF}
      function OnChange ( aValue : TProc<TObject> ) : iBind4DComponentAttributes; overload;
      function OnChange : TProc<TObject>; overload;
      function EspecialType ( aValue : TEspecialType) : iBind4DComponentAttributes; overload;
      function EspecialType : TEspecialType; overload;
      function ParentBackground ( aValue : Boolean ) : iBind4DComponentAttributes; overload;
      function ParentBackground : Boolean; overload;
      function Text ( aValue : String) : iBind4DComponentAttributes; overload;
      function Text : String; overload;
      function ImageStream ( aValue : TMemoryStream) : iBind4DComponentAttributes; overload;
      function ImageStream : TMemoryStream; overload;
      function Width ( aValue : Integer ) : iBind4DComponentAttributes; overload;
      function Width : Integer; overload;
      function Heigth ( aValue : Integer ) : iBind4DComponentAttributes; overload;
      function Heigth : Integer; overload;
      function ResourceImage ( aValue : String ) : iBind4DComponentAttributes; overload;
      function ResourceImage : String; overload;
      function FieldType ( aValue : TFieldType ) : iBind4DComponentAttributes; overload;
      function FieldType : TFieldType; overload;
      function ValueVariant ( aValue : Variant) : iBind4DComponentAttributes; overload;
      function ValueVariant : Variant; overload;
      function Field ( aValue : TField ) : iBind4DComponentAttributes; overload;
      function Field : TField; overload;
      function RttiField : TRttiField; overload;
      function RttiField ( aValue : TRttiField) : iBind4DComponentAttributes; overload;
      function EndPoint ( aValue : String ) : iBind4DComponentAttributes; overload;
      function EndPoint : String; overload;
      function FieldKey ( aValue : String ) : iBind4DComponentAttributes; overload;
      function FieldKey : String; overload;
      function FieldValue ( aValue : String ) : iBind4DComponentAttributes; overload;
      function FieldValue : String; overload;
      function ComponentNameBind ( aValue : String ) : iBind4DComponentAttributes; overload;
      function ComponentNameBind : String; overload;
      function FieldBind ( aValue : String ) : iBind4DComponentAttributes; overload;
      function FieldBind : String; overload;
      function Title ( aValue : String ) : iBind4DComponentAttributes; overload;
      function Title : String; overload;
      function &End : iBind4DComponent;
  end;
implementation
uses
  Translator4D,
  Translator4D.Interfaces;

{ TBind4DComponentAttributes }
function TBind4DComponentAttributes.&End: iBind4DComponent;
begin
  Result := FParent;
end;
function TBind4DComponentAttributes.EndPoint: String;
begin
  Result := FEndPoint;
end;

function TBind4DComponentAttributes.EndPoint(
  aValue: String): iBind4DComponentAttributes;
begin
  Result := Self;
  FEndPoint := aValue;
end;

function TBind4DComponentAttributes.Color: TAlphaColor;
begin
  Result := FColor;
end;
function TBind4DComponentAttributes.ComponentNameBind: String;
begin
  Result := FComponentNameBind;
end;

function TBind4DComponentAttributes.ComponentNameBind(
  aValue: String): iBind4DComponentAttributes;
begin
  Result := Self;
  FComponentNameBind := aValue;
end;

function TBind4DComponentAttributes.Color(
  aValue: TAlphaColor): iBind4DComponentAttributes;
begin
  Result := Self;
  FColor := aValue;
end;
constructor TBind4DComponentAttributes.Create(aValue : iBind4DComponent);
begin
  FParent := aValue;
end;
destructor TBind4DComponentAttributes.Destroy;
begin
  inherited;
end;
function TBind4DComponentAttributes.EspecialType: TEspecialType;
begin
  Result := FEspecialType;
end;
function TBind4DComponentAttributes.EspecialType(
  aValue: TEspecialType): iBind4DComponentAttributes;
begin
  Result := Self;
  FEspecialType := aValue;
end;
function TBind4DComponentAttributes.FontColor(
  aValue: TAlphaColor): iBind4DComponentAttributes;
begin
  Result := Self;
  FFontColor := aValue;
end;
function TBind4DComponentAttributes.Field(
  aValue: TField): iBind4DComponentAttributes;
begin
  Result := Self;
  FField := aValue;
end;
function TBind4DComponentAttributes.Field: TField;
begin
  Result := FField;
end;
function TBind4DComponentAttributes.FieldBind: String;
begin
  Result := FFieldBind;
end;

function TBind4DComponentAttributes.FieldBind(
  aValue: String): iBind4DComponentAttributes;
begin
  Result := Self;
  FFieldBind := aValue;
end;

function TBind4DComponentAttributes.FieldKey(
  aValue: String): iBind4DComponentAttributes;
begin
  Result := Self;
  FFieldKey := aValue;
end;

function TBind4DComponentAttributes.FieldKey: String;
begin
  Result := FFieldKey;
end;

function TBind4DComponentAttributes.FieldType: TFieldType;
begin
  Result := FFieldType;
end;
function TBind4DComponentAttributes.FieldValue: String;
begin
  Result := FFieldValue;
end;

function TBind4DComponentAttributes.FieldValue(
  aValue: String): iBind4DComponentAttributes;
begin
  Result := Self;
  FFieldValue := aValue;
end;

function TBind4DComponentAttributes.FieldType(
  aValue: TFieldType): iBind4DComponentAttributes;
begin
  Result := Self;
  FFieldType := aValue;
end;
function TBind4DComponentAttributes.FontColor: TAlphaColor;
begin
  Result := FFontColor;
end;
function TBind4DComponentAttributes.FontName(
  aValue: String): iBind4DComponentAttributes;
begin
  Result := Self;
  FFontName := aValue;
end;
function TBind4DComponentAttributes.FontName: String;
begin
  Result := FFontName;
end;
function TBind4DComponentAttributes.FontSize: Integer;
begin
  Result := FFontSize;
end;
function TBind4DComponentAttributes.Form: TForm;
begin
  Result := FForm;
end;
function TBind4DComponentAttributes.Form(
  aForm: TForm): iBind4DComponentAttributes;
begin
  Result := Self;
  FForm := aForm;
end;
function TBind4DComponentAttributes.Heigth(
  aValue: Integer): iBind4DComponentAttributes;
begin
  Result := Self;
  FHeigth := aValue;
end;
function TBind4DComponentAttributes.Heigth: Integer;
begin
  Result := FHeigth;
end;
function TBind4DComponentAttributes.ImageStream: TMemoryStream;
begin
  Result := FImageStream;
end;
function TBind4DComponentAttributes.ImageStream(
  aValue: TMemoryStream): iBind4DComponentAttributes;
begin
  Result := Self;
  FImageStream := aValue;
end;
function TBind4DComponentAttributes.FontSize(
  aValue: Integer): iBind4DComponentAttributes;
begin
  Result := Self;
  FFontSize := aValue;
end;
class function TBind4DComponentAttributes.New(aValue : iBind4DComponent) : iBind4DComponentAttributes;
begin
  Result := Self.Create(AValue);
end;
function TBind4DComponentAttributes.OnChange(
  aValue: TProc<TObject>): iBind4DComponentAttributes;
begin
  Result := Self;
  FOnChange := aValue;
end;
function TBind4DComponentAttributes.OnChange: TProc<TObject>;
begin
  Result := FOnChange;
end;
function TBind4DComponentAttributes.ParentBackground: Boolean;
begin
  Result := FParentBackground;
end;
function TBind4DComponentAttributes.ResourceImage: String;
begin
  Result := FResourceImage;
end;
function TBind4DComponentAttributes.RttiField(
  aValue: TRttiField): iBind4DComponentAttributes;
begin
  Result  := Self;
  FRttiField := aValue;
end;
function TBind4DComponentAttributes.RttiField: TRttiField;
begin
  Result := FRttiField;
end;
function TBind4DComponentAttributes.ResourceImage(
  aValue: String): iBind4DComponentAttributes;
begin
  Result := Self;
  FResourceImage := aValue;
end;
function TBind4DComponentAttributes.ParentBackground(
  aValue: Boolean): iBind4DComponentAttributes;
begin
  Result := Self;
  FParentBackground := aValue;
end;
{$IFDEF HAS_FMX}
function TBind4DComponentAttributes.StyleSettings: TStyledSetting;
begin
  Result := FStyleSettings;
end;
function TBind4DComponentAttributes.StyleSettings(
  aValue: TStyledSetting): iBind4DComponentAttributes;
begin
  Result := Self;
  FStyleSettings := aValue;
end;
{$ELSE}
function TBind4DComponentAttributes.StyleSettings: TStyleElements;
begin
  Result := FStyleSettings;
end;
function TBind4DComponentAttributes.Text: String;
begin
  Result := FText;
end;
function TBind4DComponentAttributes.Title: String;
begin
  Result := FTitle;
end;

function TBind4DComponentAttributes.Title(
  aValue: String): iBind4DComponentAttributes;
begin
  Result := Self;
  FTitle := aValue;
end;

function TBind4DComponentAttributes.ValueVariant(
  aValue: Variant): iBind4DComponentAttributes;
begin
  Result := Self;
  FValueVariant := aValue;
end;
function TBind4DComponentAttributes.ValueVariant: Variant;
begin
  Result := FValueVariant;
end;
function TBind4DComponentAttributes.Width(
  aValue: Integer): iBind4DComponentAttributes;
begin
  Result := Self;
  FWidth := aValue;
end;
function TBind4DComponentAttributes.Width: Integer;
begin
  Result := FWidth;
end;
function TBind4DComponentAttributes.Text(
  aValue: String): iBind4DComponentAttributes;
begin
  Result := Self;
  FText :=
  TTranslator4D
    .New
      .Google
        .Params
          .Query(aValue)
        .&End
      .Execute;
end;
function TBind4DComponentAttributes.StyleSettings(
  aValue: TStyleElements): iBind4DComponentAttributes;
begin
  Result := Self;
  FStyleSettings := aValue;
end;
{$ENDIF}
end.
