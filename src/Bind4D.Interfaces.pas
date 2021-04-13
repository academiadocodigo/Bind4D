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
  AWS4D.Interfaces,
  Bind4D.Forms.QuickRegistration;

type
  iBind4DRest = interface;

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
    function SetRestDataComponents : iBind4D;
    function ClearCacheComponents : iBind4D;
    function QuickRegistration : TPageQuickRegistration;
    function Translator : iTranslator4D;
    function AWSService : iAWS4D;
    function Rest : iBind4DRest;
  end;

  iBind4DRest = interface
    ['{DF7F5AF6-E03D-44A2-9358-CD4729741A30}']
    function AddHeader ( aKey : String; aValue : String ) : iBind4DRest;
    function AddParam ( aKey : String; aValue : String ) : iBind4DRest;
    function Accept ( aValue : String ) : iBind4DRest;
    function BaseURL ( aValue : String ) : iBind4DRest;
    function Get (aEndPoint : String = '') : iBind4DRest;
    function Post (aEndPoint : String; aBody : TJsonObject)  : iBind4DRest;
    function DataSet : TDataSet;
    function &End : iBind4D;
  end;
implementation
end.
