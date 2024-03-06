unit uGallery;

interface

uses
   System.Classes ,Vcl.ExtCtrls, Vcl.Graphics, Vcl.Imaging.GIFImg, jpeg;


type

  pRGBQuadArray = ^TRGBQuadArray;
  //TRGBQuadArray = array [0 .. 0] of TRGBQuad;

  TGalleryImage = class(TImage)
    public
      filename: string;
      selected: boolean;
      Alpha: byte;
      procedure SetImageAlpha();
      procedure galleryImageClick(Sender: TObject);
      constructor Create(AOwner: TComponent); override;
  end;

implementation

constructor TGalleryImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Alpha:= 80;
  selected:= false;
  OnClick:= galleryImageClick;
end;

procedure TGalleryImage.galleryImageClick(Sender: TObject);
begin
   selected:= not selected;
   if selected then
   begin
      SetImageAlpha();
   end;
end;

procedure TGalleryImage.SetImageAlpha();
var
  pscanLine32, pscanLine32_src: pRGBQuadArray;
  nScanLineCount, nPixelCount : Integer;
  BMP1,BMP2:TBitMap;
  WasBitMap:Boolean;
begin
  if assigned(Picture) then
  begin
    WasBitMap := Not Assigned(Picture.Graphic);
    if not WasBitMap then
    begin   // let's create a new bitmap from the graphic
      BMP1 := TBitMap.Create;
      BMP1.Assign(Picture.Graphic);
    end else
    begin
      BMP1 := Picture.Bitmap;  // take the bitmap
    end;
    BMP1.PixelFormat := pf32Bit;
    BMP2 := TBitMap.Create;
    BMP2.Assign(BMP1);
    BMP1.Alphaformat := afDefined;
  end;
  for nScanLineCount := 0 to BMP1.Height - 1 do
  begin
    pscanLine32 := BMP1.Scanline[nScanLineCount];
    pscanLine32_src := BMP2.ScanLine[nScanLineCount];
    for nPixelCount := 0 to BMP1.Width - 1 do
    begin
      pscanLine32[nPixelCount].rgbReserved := pscanLine32_src[nPixelCount].rgbBlue; //Alpha;
      pscanLine32[nPixelCount].rgbBlue := pscanLine32_src[nPixelCount].rgbBlue;
      pscanLine32[nPixelCount].rgbRed  := pscanLine32_src[nPixelCount].rgbRed;
      pscanLine32[nPixelCount].rgbGreen:= pscanLine32_src[nPixelCount].rgbGreen;
    end;
  end;
  If not WasBitMap then
  begin  // assign and free Bitmap if we had to create it
    Picture.Assign(BMP1);
    BMP1.Free;
  end;
  BMP2.Free; // free the copy
end;

end.
