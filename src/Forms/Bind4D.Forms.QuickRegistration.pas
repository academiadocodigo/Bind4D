unit Bind4D.Forms.QuickRegistration;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ExtCtrls;
  //Bind4D.Interfaces;

type
  iPageQuick = interface
    ['{DFDA3380-21C2-4FE9-AF40-EF076918B7CF}']
    function EndPoint ( aValue : String ) : iPageQuick;
    function Field ( aValue : String ) : iPageQuick;
    function Title ( aValue : String ) : iPageQuick;
    function Execute : iPageQuick;
  end;

  TPageQuickRegistration = class(TForm, iPageQuick)
    Panel1: TPanel;
    Label1: TLabel;
    btnFechar: TSpeedButton;
    btnSalvar: TSpeedButton;
    Edit1: TEdit;
    procedure btnSalvarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
  private
    { Private declarations }
    FEndPoint : String;
    FField : String;
    function SetBordelessShadow: Boolean;
  public
    { Public declarations }
    class function New(aform : TForm) : iPageQuick;
    procedure CreateParams(var AParams: TCreateParams); override;
    procedure CreateWindowHandle(const AParams: TCreateParams); override;
    procedure WndProc(var AMessage: TMessage); override;
    function EndPoint ( aValue : String ) : iPageQuick;
    function Field ( aValue : String ) : iPageQuick;
    function Title ( aValue : String ) : iPageQuick;
    function BackgroundColor ( aValue : TColor ) : TPageQuickRegistration;
    function FontColor ( aValue : TColor )  : TPageQuickRegistration;
    function FontSize ( aValue : Integer ) : TPageQuickRegistration;
    //function Parent ( aParent : iBind4D ) : TPageQuickRegistration;
    //function &End : iBind4D;
    function Execute : iPageQuick;
  end;

var
  PageQuickRegistration: TPageQuickRegistration;

implementation

uses
   Winapi.DwmApi,
   Winapi.UxTheme,
   System.Json,
   Bind4D;

{$R *.dfm}

{ TPageQuickRegistration }

function TPageQuickRegistration.BackgroundColor(
  aValue: TColor): TPageQuickRegistration;
begin
  Result := Self;
  Panel1.Color := aValue;
end;

procedure TPageQuickRegistration.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TPageQuickRegistration.btnSalvarClick(Sender: TObject);
var
  aJson : TJsonObject;
begin
  if Trim(Edit1.Text) = '' then exit;
  aJson := TJSONObject.Create;
  try
    aJson.AddPair(FField, Edit1.Text);
    TBind4D.New.Rest.Post(FEndPoint, aJson);
  finally
    aJson.Free;
    TBind4D.New.SetRestDataComponents;
  end;
  Close;
end;

procedure TPageQuickRegistration.CreateParams(var AParams: TCreateParams);
begin
  inherited CreateParams(AParams);
  if TOSVersion.Major < 6 then
  begin
    AParams.Style := WS_POPUP;
    AParams.WindowClass.Style := AParams.WindowClass.Style or CS_DROPSHADOW;
  end;
end;

procedure TPageQuickRegistration.CreateWindowHandle(
  const AParams: TCreateParams);
begin
  inherited;
  if TOSVersion.Major >= 6 then
    SetBordelessShadow;
end;

function TPageQuickRegistration.EndPoint(aValue: String): iPageQuick;
begin
  Result := Self;
  FEndPoint := aValue;
end;

function TPageQuickRegistration.Execute: iPageQuick;
var
  pt: TPoint;
begin
  Result := Self;
  GetCursorPos(pt);
  Self.Left := pt.x + 25;
  Self.Top := pt.y - 85;
  ShowModal;
end;

function TPageQuickRegistration.Field(aValue: String): iPageQuick;
begin
  Result := Self;
  FField := aValue;
end;

function TPageQuickRegistration.FontColor(
  aValue: TColor): TPageQuickRegistration;
begin
  Result := Self;
  Label1.Font.Color := aValue;
  Edit1.Font.Color := aValue;
  btnSalvar.Font.Color := aValue;
  btnFechar.Font.Color := aValue;
end;

function TPageQuickRegistration.FontSize(
  aValue: Integer): TPageQuickRegistration;
begin
  Result := Self;
  Label1.Font.Size := aValue;
  Edit1.Font.Size := aValue;
  btnSalvar.Font.Size := aValue;
  btnFechar.Font.Size := aValue;
end;

class function TPageQuickRegistration.New(aform: TForm): iPageQuick;
begin
  Result := Self.Create(aForm);
end;

function TPageQuickRegistration.SetBordelessShadow: Boolean;
var
  LMargins: TMargins;
  LPolicy: Integer;
begin
  if TOSVersion.Major < 6 then
    Exit(False);
  LPolicy := DWMNCRP_ENABLED;
  Result := Succeeded(DwmSetWindowAttribute(Handle, DWMWA_NCRENDERING_POLICY, @LPolicy, SizeOf(Integer))) and DwmCompositionEnabled;
  if Result then
  begin
    LMargins.cxLeftWidth := 1;
    LMargins.cxRightWidth := 1;
    LMargins.cyTopHeight := 1;
    LMargins.cyBottomHeight := 1;
    Result := Succeeded(DwmExtendFrameIntoClientArea(Handle, LMargins));
  end;
end;

function TPageQuickRegistration.Title(aValue: String): iPageQuick;
begin
  Result := Self;
  Label1.Caption := TBind4D.New.Translator.Google.Params.Query(aValue).&End.Execute;
end;

procedure TPageQuickRegistration.WndProc(var AMessage: TMessage);
begin
 case AMessage.Msg of
    WM_DWMCOMPOSITIONCHANGED,
    WM_DWMNCRENDERINGCHANGED:
      if SetBordelessShadow then
      begin
        AMessage.Result := 0;
        Exit;
      end;
  else
  end;
  inherited;
end;

initialization
  PageQuickRegistration := TPageQuickRegistration.Create(nil);

finalization
  PageQuickRegistration.DisposeOf;

end.
