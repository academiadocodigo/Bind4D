unit Bind4D.Component.Interfaces;

interface

uses
  {$IFDEF HAS_FMX}
    FMX.Types,
    FMX.StdCtrls,
    FMX.Forms,
  {$ELSE}
    Vcl.Controls,
    Vcl.ExtCtrls,
    Vcl.Forms,
  {$ENDIF}
  Data.DB,
  System.UITypes,
  System.SysUtils,
  Bind4D.Types,
  System.Classes, System.Rtti, Bind4D.Attributes;


type
  iBind4DComponentAttributes = interface;
  iBind4DComponent = interface;

  iBind4DComponentFactory = interface
    ['{F1059E3A-A67B-4C98-B812-AE3E094419FD}']
    function Component (aValue : TComponent ) : iBind4DComponent;
  end;

  iBind4DComponent = interface
    ['{06B66E87-44CB-4390-A64F-DF34EADF1AA4}']
    function Attributes : iBind4DComponentAttributes;
    function AdjusteResponsivity : iBind4DComponent;
    function ApplyStyles : iBind4DComponent;
    function ApplyText : iBind4DComponent;
    function ApplyImage : iBind4DComponent;
    function ApplyValue : iBind4DComponent;
    function ApplyRestData : iBind4DComponent;
    function Clear : iBind4DComponent;
    function FormatFieldGrid (aAttr : FieldDataSetBind) : iBind4DComponent;
    function GetValueString : String;
    function GetCaption : String;
  end;

  iBind4DComponentAttributes = interface
    ['{10567C17-6D8C-48D3-BBC9-0CF0FBA69AEE}']
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
    function FieldBind ( aValue : String ) : iBind4DComponentAttributes; overload;
    function FieldBind : String; overload;
    function ComponentNameBind ( aValue : String ) : iBind4DComponentAttributes; overload;
    function ComponentNameBind : String; overload;
    function Title ( aValue : String ) : iBind4DComponentAttributes; overload;
    function Title : String; overload;
    function &End : iBind4DComponent;
  end;

  iBind4DComponentUtils = interface
    ['{2C5B65D2-3543-4909-B01D-C97F84A1EE5B}']
  end;

implementation

end.
