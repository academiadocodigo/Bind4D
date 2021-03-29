unit Bind4D.Interfaces;

interface

uses
  Vcl.Forms,
  System.JSON,
  Data.DB,
  Translator4D.Interfaces,
  Bind4D.Types,
  Bind4D.Attributes,
  Vcl.DBGrids,
  AWS4D.Interfaces;

type
   iBind4D = interface
    ['{2846B843-7533-4987-B7B4-72F7B5654D1A}']
    function Form( aValue : TForm) : iBind4D;
    function FormToJson(aType : TTypeBindFormJson) : TJsonObject;
    function ClearFieldForm : iBind4D;
    function BindDataSetToForm(aDataSet : TDataSet) : iBind4D;
    function BindFormatListDataSet(aDataSet : TDataSet; aDBGrid : TDBGrid) : iBind4D;
    function BindFormRest (var aEndPoint : String; var aPK : String; var aSort : String; var aOrder : String) : iBind4D;
    function BindFormDefault (var aTitle : String) : iBind4D;
    function GetFieldsByType (aType : TTypeBindFormJson) : String;
    function SetStyleComponents : iBind4D;
    function Translator : iTranslator4D;
    function AWSService : iAWS4D;
  end;

implementation

end.
