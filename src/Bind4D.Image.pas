unit Bind4D.Image;

interface

uses
  System.Classes,
  {$IFDEF HAS_FMX}
    FMX.Objects,
  {$ELSE}
    Vcl.ExtCtrls,
  {$ENDIF}
  System.Types;


type
  iBind4DImage = interface
    ['{EB7D7727-1B37-4264-8165-D8BA714B6416}']
    function LoadResource( aResourceName : String; aImage : TImage) : iBind4DImage;
  end;


  TBind4DImage = class(TInterfacedObject, iBind4DImage)
    private
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iBind4DImage;
      function LoadResource( aResourceName : String; aImage : TImage) : iBind4DImage;
  end;

implementation

{ TBind4DImage }

constructor TBind4DImage.Create;
begin

end;

destructor TBind4DImage.Destroy;
begin

  inherited;
end;

function TBind4DImage.LoadResource(aResourceName: String;
  aImage: TImage): iBind4DImage;
var
  aResource : TResourceStream;
begin
  aResource := TResourceStream.Create(HInstance, aResourceName, RT_RCDATA);
  try
    {$IFDEF HAS_FMX}
      aImage.Bitmap.LoadFromStream(aResource);
    {$ELSE}
      aImage.Picture.LoadFromStream(aResource);
    {$ENDIF}
  finally
    aResource.DisposeOf;
  end;
end;

class function TBind4DImage.New: iBind4DImage;
begin
  Result := Self.Create;
end;

end.
