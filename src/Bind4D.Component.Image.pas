unit Bind4D.Component.Image;
interface
uses
  System.Classes,
  {$IFDEF HAS_FMX}
    FMX.Objects,
  {$ELSE}
    Vcl.ExtCtrls,
    EncdDecd,
    NetEncoding,
    Vcl.Dialogs,
  {$ENDIF}
  System.Types,
  Bind4D.Component.Interfaces, Bind4D.Attributes;
type
  TBind4DComponentImage = class(TInterfacedObject, iBind4DComponent)
    private
      FComponent : TImage;
      FAttributes : iBind4DComponentAttributes;
      procedure __LoadFromResource(aResourceName : String);
    public
      constructor Create(aValue : TImage);
      destructor Destroy; override;
      class function New(aValue : TImage) : iBind4DComponent;
      function Attributes : iBind4DComponentAttributes;
      function AdjusteResponsivity : iBind4DComponent;
      function FormatFieldGrid (aAttr : FieldDataSetBind) : iBind4DComponent;
      function ApplyStyles : iBind4DComponent;
      function ApplyText : iBind4DComponent;
      function ApplyImage : iBind4DComponent;
      function ApplyRestData : iBind4DComponent;
      function ApplyValue : iBind4DComponent;
      function GetValueString : String;
      function Clear : iBind4DComponent;
  end;
implementation
uses
  Bind4D.Component.Attributes,
  Bind4D.ChangeCommand,
  Bind4D.Utils.Rtti,
  Bind4D.Utils,
  StrUtils,
  System.Variants, System.SysUtils, Data.DB;
{ TBind4DImage }
function TBind4DComponentImage.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;
function TBind4DComponentImage.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;
function TBind4DComponentImage.ApplyImage: iBind4DComponent;
begin
   __LoadFromResource(FAttributes.ResourceImage);
end;
function TBind4DComponentImage.ApplyRestData: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentImage.ApplyStyles: iBind4DComponent;
begin
   Result := Self;
   {$IFDEF HAS_FMX}
   {$ELSE}
    FComponent.OnDblClick :=
    TBind4DUtils.AnonProc2NotifyEvent(
      FComponent,
      procedure (Sender : TObject)
      begin
        with TOpenDialog.Create(TImage(Sender)) do
          try
            //Caption := 'Escolher Imagem';
            Options := [ofPathMustExist, ofFileMustExist];
            if Execute then
              TImage(Sender).Picture.LoadFromFile(FileName);
          finally
            Free;
          end;
      end
    )
   {$ENDIF}
end;
function TBind4DComponentImage.ApplyText: iBind4DComponent;
begin
  Result := Self;
end;
function TBind4DComponentImage.ApplyValue: iBind4DComponent;
var
  Attribute : S3Storage;
  HorseAttribute : HorseStorage;
  AttImage : ImageAttribute;
  lStream : TStringStream;
  lImagem : TMemoryStream;
begin
  Result := Self;
  try
    if VarIsNull(FAttributes.ValueVariant) then
    begin
      if RttiUtils.TryGet<ImageAttribute>(FComponent, AttImage)  then
        __LoadFromResource(AttImage.DefaultResourceImage);
      exit;
    end;
    if RttiUtils.TryGet<S3Storage>(FComponent, Attribute) and
    (ContainsText(FAttributes.ValueVariant, 'http')) and
    (ContainsText(FAttributes.ValueVariant, 's3'))
    then
    begin
      TBind4DUtils
        .GetImageS3Storage(
          FComponent,
          FAttributes.ValueVariant
        );
      {$IFDEF HAS_FMX}
        FComponent.Hint := FAttributes.ValueVariant;
      {$ELSE}
        FComponent.HelpKeyword := FAttributes.ValueVariant;
      {$ENDIF}
    end else
    if RttiUtils.TryGet<HorseStorage>(FComponent, HorseAttribute) then
     begin
      TBind4DUtils
        .GetImageHS4DStorage(
          FComponent,
          FAttributes.ValueVariant
        );
      {$IFDEF HAS_FMX}
        FComponent.Hint := FAttributes.ValueVariant;
      {$ELSE}
        FComponent.HelpKeyword := FAttributes.ValueVariant;
      {$ENDIF}
     end;
  except
    if RttiUtils.TryGet<ImageAttribute>(FComponent, AttImage)  then
      __LoadFromResource(AttImage.DefaultResourceImage);
  end;
end;
function TBind4DComponentImage.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;
function TBind4DComponentImage.Clear: iBind4DComponent;
var
  AttImage : ImageAttribute;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
    FComponent.Bitmap.Assign(nil);
  {$ELSE}
    FComponent.Picture.Assign(nil);
  {$ENDIF}
  if RttiUtils.TryGet<ImageAttribute>(FComponent, AttImage)  then
      __LoadFromResource(AttImage.DefaultResourceImage);
end;
constructor TBind4DComponentImage.Create(aValue : TImage);
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
  FComponent := aValue;
end;
destructor TBind4DComponentImage.Destroy;
begin
  inherited;
end;
function TBind4DComponentImage.GetValueString: String;
var
  Attribute : S3Storage;
  HorseAttribute : HorseStorage;
  lStream: TMemoryStream;
  lImagem : TStringStream;
begin
  try
    if RttiUtils.TryGet<HorseStorage>(FComponent, HorseAttribute) then
    begin
       Result := TBind4DUtils
        .SendImageHS4DStorage(
          FComponent,
          HorseAttribute
        );
        exit;
    end;
    if RttiUtils.TryGet<S3Storage>(FComponent, Attribute) then
    begin
       Result := TBind4DUtils
        .SendImageS3Storage(
          FComponent,
          Attribute
        );
       exit;
    end;
  except
    //
  end;
  //TODO: Implementar Retorno Base64Image;
end;

class function TBind4DComponentImage.New(aValue : TImage): iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;
procedure TBind4DComponentImage.__LoadFromResource(aResourceName: String);
var
  aResource : TResourceStream;
begin
  aResource := TResourceStream.Create(HInstance, aResourceName, RT_RCDATA);
  try
    {$IFDEF HAS_FMX}
      FComponent.Bitmap.LoadFromStream(aResource);
      FComponent.Hint := '';
    {$ELSE}
      FComponent.Picture.LoadFromStream(aResource);
      FComponent.HelpKeyword := '';
    {$ENDIF}
  finally
    aResource.DisposeOf;
  end;
end;
end.