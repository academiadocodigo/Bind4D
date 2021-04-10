unit Bind4D.Interfaces;

interface

uses

  System.JSON,
  Data.DB,
  {$IFDEF HAS_FMX}
    FMX.Forms,
    FMX.Grid.Style,
    FMX.Controls.Presentation,
    FMX.ScrollBox,
    FMX.Grid,
  {$ELSE}
    Vcl.Forms,
    Vcl.DBGrids,
  {$ENDIF}
  Bind4D.Types,
  Bind4D.Attributes,
  Translator4D.Interfaces,
  AWS4D.Interfaces;

type
   iBind4D = interface
    ['{2846B843-7533-4987-B7B4-72F7B5654D1A}']
    function Form( aValue : TForm) : iBind4D;
    function FormToJson(aType : TTypeBindFormJson) : TJsonObject;
    function ClearFieldForm : iBind4D;
    function BindDataSetToForm(aDataSet : TDataSet) : iBind4D;
    {$IFDEF HAS_FMX}
      function BindFormatListDataSet(aDataSet : TDataSet; aDBGrid : TStringGrid) : iBind4D;
    {$ELSE}
      function BindFormatListDataSet(aDataSet : TDataSet; aDBGrid : TDBGrid) : iBind4D;
    {$ENDIF}
    function BindFormRest (var aEndPoint : String; var aPK : String; var aSort : String; var aOrder : String) : iBind4D;
    function BindFormDefault (var aTitle : String) : iBind4D;
    function ResponsiveAdjustment : iBind4D;
    function GetFieldsByType (aType : TTypeBindFormJson) : String;
    function SetStyleComponents : iBind4D;
    function SetCaptionComponents : iBind4D;
    function SetImageComponents : iBind4D;
    function ClearCacheComponents : iBind4D;
    function Translator : iTranslator4D;
    function AWSService : iAWS4D;
  end;

implementation

end.
