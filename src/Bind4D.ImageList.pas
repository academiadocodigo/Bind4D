unit Bind4D.ImageList;

interface

uses
  System.Classes,
   {$IFDEF HAS_FMX}
    FMX.ImgList,
    FMX.Graphics,
   {$ELSE}
    Vcl.ImgList,
    VCL.Controls,
    PngImage,
    Vcl.Graphics,
   {$ENDIF}
   System.Types;

type
  iBind4DImageList = interface
    ['{84BEE4A8-3F99-4842-B5E6-2A8FB32021EF}']
    function LoadImageResource( aResourceName : String; aBitmap : TBitmap) : iBind4DImageList;
  end;

  TBind4DImageList = class(TInterfacedObject, iBind4DImageList)
    private
      FImageList: TImageList;
    public
      constructor Create(aWidth, aHeight : Integer);
      destructor Destroy; override;
      class function New(aWidth, aHeight : Integer) : iBind4DImageList;
      function LoadImageResource( aResourceName : String; aBitmap : TBitmap) : iBind4DImageList;
  end;

implementation

{ TBind4DImageList }

constructor TBind4DImageList.Create(aWidth, aHeight: Integer);
begin
  {$IFDEF HAS_FMX}
  {$ELSE}
    FImageList := TImageList.CreateSize(aWidth, aHeight);
    FImageList.ColorDepth := cd32Bit;
    FImageList.Masked := True;
    FImageList.DrawingStyle := dsNormal;
  {$ENDIF}

end;

destructor TBind4DImageList.Destroy;
begin
  FImageList.DisposeOf;
  inherited;
end;

function TBind4DImageList.LoadImageResource(aResourceName: String;
  aBitmap: TBitmap): iBind4DImageList;
var
  aResource : TResourceStream;
  {$IFDEF HAS_FMX}
  {$ELSE}
  aPng : TPngImage;
  {$ENDIF}
  aBmp :TBitmap;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
  {$ELSE}
    aResource := TResourceStream.Create(HInstance, aResourceName, RT_RCDATA);
    aPng := TPngImage.Create;
    aBmp := TBitmap.Create;
    try
      aPng.LoadFromStream(aResource);
      aPng.AssignTo(aBmp);
      aBmp.AlphaFormat := afIgnored;
      FImageList.Add(aBmp, nil);
      FImageList.GetBitmap(Pred(FImageList.Count), aBitmap);
    finally
      aBmp.DisposeOf;
      aPng.DisposeOf;
      aResource.DisposeOf;
    end;
  {$ENDIF}

end;

class function TBind4DImageList.New(aWidth, aHeight : Integer) : iBind4DImageList;
begin
  Result := Self.Create(aWidth, aHeight);
end;

end.
