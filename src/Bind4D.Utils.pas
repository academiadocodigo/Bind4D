unit Bind4D.Utils;
interface
uses
  System.Classes,
  System.SysUtils,
  {$IFDEF HAS_FMX}
    FMX.Objects,
  {$ELSE}
    Vcl.ExtCtrls,
  {$ENDIF}
  System.RTTI, Bind4D.Attributes;
type
  TNotifyEventWrapper = class(TComponent)
  private
    FProc: TProc<TObject>;
  public
    constructor Create(Owner: TComponent; Proc: TProc<TObject>); reintroduce;
  published
    procedure Event(Sender: TObject);
  end;
  TBind4DUtils = class
    private
    public
      class function AnonProc2NotifyEvent(Owner: TComponent; Proc: TProc<TObject>): TNotifyEvent;
      class function FormatarCPF(valor : string) : string;
      class function FormatarCNPJ(valor : string) : string;
      class function ExtrairMoeda(aValue : String) : String;
      class function FormatDateTime(aValue : String) : String;
      class function FormatDateTimeToJson (aValue : TDateTime) : String;
      class function FormatStrJsonToDateTime(aValue : String) : TDateTime;
      class function FormatStrJsonToTime(aValue : String) : TDateTime;
      class function FormatDateDataSet(aValue : String) : String;
      class function FormatDateTimeDataSet(aValue : String) : String;
      class function FormatTimeDataSet(aValue : String) : String;
      class function FormatarMoeda(valor: string): string;
      class function FormatarCelular(valor : string) : string;
      class function ApenasNumeros(valor : String) : String;
      class function SendImageS3Storage( var aImage : TImage; aAttr : S3Storage) : String;
      class procedure GetImageS3Storage (aImage : TImage; aName : String);
      class function SendGuuidPrepare ( aGuuid : String ) : String;
      class procedure LoadDefaultResourceImage( aImage : TImage; aDefaultResource : String);
  end;
implementation
uses
  System.StrUtils,
  AWS4D,
  Bind4D,
  System.Types,
  Bind4D.Helpers;
{ TBind4DUtils }
class function TBind4DUtils.AnonProc2NotifyEvent(Owner: TComponent;
  Proc: TProc<TObject>): TNotifyEvent;
begin
  Result := TNotifyEventWrapper.Create(Owner, Proc).Event;
end;
class function TBind4DUtils.ApenasNumeros(valor: String): String;
var
  i: Integer;
begin
  for i := 0 to Length(valor) - 1 do
    if not CharInSet(valor[i], ['0' .. '9']) then
      delete(valor, i, 1);
  valor := StringReplace(valor, ' ', '', [rfReplaceAll]);
  Result := valor;
end;
class function TBind4DUtils.ExtrairMoeda(aValue: String): String;
begin
  Result := StringReplace(aValue, ',', '.', [rfReplaceAll]);
  Result := StringReplace(aValue, '.', '', [rfReplaceAll]);
end;
class function TBind4DUtils.FormatarCelular(valor: string): string;
var
  i: Integer;
begin
  for i := 0 to Length(valor) - 1 do
    if not CharInSet(valor[i], ['0' .. '9']) then
      delete(valor, i, 1);
  valor := StringReplace(valor, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  if copy(valor, 1, 1) = '0' then
    valor := copy(valor, 2, Length(valor));
  case Length(valor) of
  0 : valor := '00000000000';
  1 : valor := '0000000000' + valor;
  2 : valor := '000000000' + valor;
  3 : valor := '00000000' + valor;
  4 : valor := '0000000' + valor;
  5 : valor := '000000' + valor;
  6 : valor := '00000' + valor;
  7 : valor := '0000' + valor;
  8 : valor := '000' + valor;
  9 : valor := '00' + valor;
  10 : valor := '0' + valor;
  end;
  Result := '(' + Copy(valor, 1, 2) + ') ' + Copy(valor, 3, 5) + '-' + Copy(valor, 8, Length(valor));
end;

class function TBind4DUtils.FormatarCNPJ(valor: string): string;
var
  i: Integer;
begin
  for i := 0 to Length(valor) - 1 do
    if not CharInSet(valor[i], ['0' .. '9']) then
      delete(valor, i, 1);
  valor := StringReplace(valor, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  if Length(valor) = 15 then
    valor := copy(valor, 2, Length(valor));
  case Length(valor) of
  0 : valor := '00000000000000';
  1 : valor := '0000000000000' + valor;
  2 : valor := '000000000000' + valor;
  3 : valor := '00000000000' + valor;
  4 : valor := '0000000000' + valor;
  5 : valor := '000000000' + valor;
  6 : valor := '00000000' + valor;
  7 : valor := '0000000' + valor;
  8 : valor := '000000' + valor;
  9 : valor := '00000' + valor;
  10 : valor:= '0000' + valor;
  11 : valor:= '000' + valor;
  12 : valor:= '00' + valor;
  13 : valor:= '0' + valor;
  end;
  Result := Copy(valor, 1, 2) + '.' + Copy(valor, 3, 3) + '.' + Copy(valor, 6, 3) + '/' + Copy(valor, 9, 4) + '-' + Copy(valor, 13, 2);
end;

class function TBind4DUtils.FormatarCPF(valor: string): string;
var
  i: Integer;
begin
  for i := 0 to Length(valor) - 1 do
    if not CharInSet(valor[i], ['0' .. '9']) then
      delete(valor, i, 1);
  valor := StringReplace(valor, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  if Length(valor) = 12 then
    valor := copy(valor, 2, Length(valor));
  case Length(valor) of
  0 : valor := '00000000000';
  1 : valor := '0000000000' + valor;
  2 : valor := '000000000' + valor;
  3 : valor := '00000000' + valor;
  4 : valor := '0000000' + valor;
  5 : valor := '000000' + valor;
  6 : valor := '00000' + valor;
  7 : valor := '0000' + valor;
  8 : valor := '000' + valor;
  9 : valor := '00' + valor;
  10 : valor:= '0' + valor;
  end;
  Result := Copy(valor, 1, 3) + '.' + Copy(valor, 4, 3) + '.' + Copy(valor, 7, 3) + '-' + Copy(valor, 10, 2);
end;

class function TBind4DUtils.FormatarMoeda(valor: string): string;
var
  decimais,
  centena,
  milhar,
  milhoes,
  bilhoes,
  trilhoes,
  quadrilhoes,
  aux: string;
  i: Integer;
begin
  Result := EmptyStr;
  i := Pos(',', valor);
  aux := Copy(valor, i+1, 2);
  if Length(aux) = 1 then valor := valor + '0';
  for i := 0 to Length(valor) - 1 do
    if not CharInSet(valor[i], ['0' .. '9']) then
      delete(valor, i, 1);
  if copy(valor, 1, 1) = '0' then
    valor := copy(valor, 2, Length(valor));
  decimais := RightStr(valor, 2);
  centena := copy(RightStr(valor, 5), 1, 3);
  milhar := copy(RightStr(valor, 8), 1, 3);
  milhoes := copy(RightStr(valor, 11), 1, 3);
  bilhoes := copy(RightStr(valor, 14), 1, 3);
  trilhoes := copy(RightStr(valor, 17), 1, 3);
  quadrilhoes := LeftStr(valor, Length(valor) - 17);
  case Length(valor) of
    1:
      Result := '0,0' + valor;
    2:
      Result := '0,' + valor;
    6 .. 8:
      begin
        milhar := LeftStr(valor, Length(valor) - 5);
        Result := milhar + '.' + centena + ',' + decimais;
      end;
    9 .. 11:
      begin
        milhoes := LeftStr(valor, Length(valor) - 8);
        Result := milhoes + '.' + milhar + '.' + centena + ',' + decimais;
      end;
    12 .. 14:
      begin
        bilhoes := LeftStr(valor, Length(valor) - 11);
        Result := bilhoes + '.' + milhoes + '.' + milhar + '.' + centena + ',' + decimais;
      end;
    15 .. 17:
      begin
        trilhoes := LeftStr(valor, Length(valor) - 14);
        Result := trilhoes + '.' + bilhoes + '.' + milhoes + '.' + milhar + '.' + centena + ','
          + decimais;
      end;
    18 .. 20:
      begin
        quadrilhoes := LeftStr(valor, Length(valor) - 17);
        Result := quadrilhoes + '.' + trilhoes + '.' + bilhoes + '.' + milhoes + '.' + milhar + '.'
          + centena + ',' + decimais;
      end
  else
    Result := LeftStr(valor, Length(valor) - 2) + ',' + decimais;
  end;
end;

class function TBind4DUtils.FormatDateDataSet(aValue: String): String;
var
  i: Integer;
  dia,
  mes,
  ano,
  hora,
  minuto,
  segundo : String;
begin
  for i := 0 to Length(aValue) - 1 do
    if not CharInSet(aValue[i], ['0' .. '9']) then
      delete(aValue, i, 1);
//    if not(aValue[i] in ['0' .. '9']) then
//      delete(aValue, i, 1);
  dia := Copy(aValue, 7, 2);
  mes := Copy(aValue, 5, 2);
  ano := Copy(aValue, 1, 4);
  hora := Copy(aValue, 9, 2);
  minuto := Copy(aValue, 11, 2);
  segundo := Copy(aValue, 13, 2);
  Result := dia + mes + ano;
end;

class function TBind4DUtils.FormatDateTime(aValue: String): String;
var
  i: Integer;
  dia,
  mes,
  ano,
  hora,
  minuto,
  segundo : String;
begin
  Result := EmptyStr;
  for i := 0 to Length(aValue) - 1 do
    if not CharInSet(aValue[i], ['0' .. '9']) then
      delete(aValue, i, 1);
  case Length(aValue) of
    0 : aValue := '00000000000000';
    1 : aValue := '0000000000000' + aValue;
    2 : aValue := '000000000000' + aValue;
    3 : aValue := '00000000000' + aValue;
    4 : aValue := '0000000000' + aValue;
    5 : aValue := '000000000' + aValue;
    6 : aValue := '00000000' + aValue;
    7 : aValue := '0000000' + aValue;
    8 : aValue := '000000' + aValue;
    9 : aValue := '00000' + aValue;
    10 : aValue :='0000' + aValue;
    11 : aValue :='000' + aValue;
    12 : aValue :='00' + aValue;
    13 : aValue :='0' + aValue;
  end;
  dia := Copy(aValue, 7, 2);
  mes := Copy(aValue, 5, 2);
  ano := Copy(aValue, 1, 4);
  hora := Copy(aValue, 9, 2);
  minuto := Copy(aValue, 11, 2);
  segundo := Copy(aValue, 13, 2);
  Result := dia + '/' + mes + '/' + ano + ' ' + hora + ':' + minuto + ':' + segundo;
end;

class function TBind4DUtils.FormatDateTimeDataSet(aValue: String): String;
var
  i: Integer;
  dia,
  mes,
  ano,
  hora,
  minuto,
  segundo : String;
begin
   for i := 0 to Length(aValue) - 1 do
    if not CharInSet(aValue[i], ['0' .. '9']) then
      delete(aValue, i, 1);
  dia := Copy(aValue, 7, 2);
  mes := Copy(aValue, 5, 2);
  ano := Copy(aValue, 1, 4);
  hora := Copy(aValue, 9, 2);
  minuto := Copy(aValue, 11, 2);
  segundo := Copy(aValue, 13, 2);
  Result := dia + mes + ano + ' ' + hora + ':' + minuto + ':' + segundo;
end;

class function TBind4DUtils.FormatDateTimeToJson(aValue: TDateTime): String;
var
  i: Integer;
  dia,
  mes,
  ano,
  hora,
  minuto,
  segundo : String;
begin
  Result := DateTimeToStr(aValue);
  for i := 0 to Length(Result) - 1 do
    if not CharInSet(Result[i], ['0' .. '9']) then
      delete(Result, i, 1);
  dia := Copy(Result, 1, 2);
  mes := Copy(Result, 3, 2);
  ano := Copy(Result, 5, 4);
  hora := Copy(Result, 9, 2);
  minuto := Copy(Result, 11, 2);
  segundo := Copy(Result, 13, 2);
  Result := ano + '-' + mes + '-' + dia + ' ' + hora + ':' + minuto + ':' + segundo +'.000';
end;

class function TBind4DUtils.FormatStrJsonToDateTime(aValue: String): TDateTime;
var
  i: Integer;
  dia,
  mes,
  ano,
  hora,
  minuto,
  segundo : String;
begin
  for i := 0 to Length(aValue) - 1 do
    if not CharInSet(aValue[i], ['0' .. '9']) then
      delete(aValue, i, 1);
  dia := Copy(aValue, 1, 2);
  mes := Copy(aValue, 3, 2);
  ano := Copy(aValue, 5, 4);
  hora := Copy(aValue, 9, 2);
  minuto := Copy(aValue, 11, 2);
  segundo := Copy(aValue, 13, 2);
  Result := StrToDateTime(dia + '/' + mes + '/' + ano + ' ' + hora + ':' + minuto + ':' + segundo);
end;

class function TBind4DUtils.FormatStrJsonToTime(aValue: String): TDateTime;
var
  i: Integer;
  hora,
  minuto,
  segundo : String;
begin
  for i := 0 to Length(aValue) - 1 do
    if not CharInSet(aValue[i], ['0' .. '9']) then
      delete(aValue, i, 1);
  hora := Copy(aValue, 1, 2);
  minuto := Copy(aValue, 3, 2);
  segundo := Copy(aValue, 5, 2);
  Result := StrToDateTime('01/01/1989 ' + hora + ':' + minuto + ':' + segundo);
end;

class function TBind4DUtils.FormatTimeDataSet(aValue: String): String;
var
  i: Integer;
  hora,
  minuto,
  segundo : String;
begin
  for i := 0 to Length(aValue) - 1 do
    if not CharInSet(aValue[i], ['0' .. '9']) then
      delete(aValue, i, 1);
  hora := Copy(aValue, 9, 2);
  minuto := Copy(aValue, 11, 2);
  segundo := Copy(aValue, 13, 2);
  Result := hora + minuto + segundo;
end;

class procedure TBind4DUtils.GetImageS3Storage(aImage : TImage; aName : String);
begin
  if Trim(aName) <> '' then
  begin
    TBind4D.New
     .AWSService
      .S3
        .GetFile
          .FileName(aName)
        .Get
      .FromImage(aImage);
  end;
end;

class procedure TBind4DUtils.LoadDefaultResourceImage(aImage: TImage;
  aDefaultResource: String);
var
  InStream: TResourceStream;
begin
  {$IFDEF HAS_FMX}
    aImage.Hint := '';
  {$ELSE}
    aImage.HelpKeyword := '';
  {$ENDIF}
  InStream := TResourceStream.Create(HInstance, aDefaultResource, RT_RCDATA);
  try
    {$IFDEF HAS_FMX}
      aImage.Bitmap.LoadFromStream(InStream);
    {$ELSE}
      aImage.Picture.LoadFromStream(InStream);
    {$ENDIF}
  finally
    InStream.Free;
  end;
end;

class function TBind4DUtils.SendGuuidPrepare(aGuuid: String): String;
begin
  Result := StringReplace(aGuuid, '{', '', [rfReplaceAll]);
  Result := StringReplace(Result, '}', '', [rfReplaceAll]);
end;

class function TBind4DUtils.SendImageS3Storage( var aImage : TImage; aAttr : S3Storage) : String;
var
  aImageName: string;
begin
  Result := '';
  try
    aImageName := TBind4DUtils.SendGuuidPrepare(TGuid.NewGuid.ToString) + '.' + aAttr.FileExtension;
    {$IFDEF HAS_FMX}
      if Trim(aImage.Hint) <> '' then aImageName := aImage.Hint;
    {$ELSE}
      if Trim(aImage.HelpKeyword) <> '' then aImageName := aImage.HelpKeyword;
    {$ENDIF}
    if Length(aImageName) > 40 then
    begin
      aImageName := ReverseString(aImageName);
      aImageName := Copy(aImageName, 0, Pos('/', aImageName)-1);
      aImageName := ReverseString(aImageName);
    end;
    Result :=
      TBind4D.New
       .AWSService
        .S3
          .SendFile
            .FileName(aImageName)
            .ContentType(aAttr.ContentType)
            .FileStream(aImage)
          .Send
        .ToString;
  finally
    {$IFDEF HAS_FMX}
      aImage.Hint := '';
    {$ELSE}
      aImage.HelpKeyword := '';
    {$ENDIF}
  end;
end;
{ TNotifyEventWrapper }
constructor TNotifyEventWrapper.Create(Owner: TComponent; Proc: TProc<TObject>);
begin
  inherited Create(Owner);
  FProc := Proc;
end;
procedure TNotifyEventWrapper.Event(Sender: TObject);
begin
  FProc(Sender);
end;
end.

