unit Bind4D.Component.Helpers;

interface

uses
  {$IFDEF HAS_FMX}
    FMX.StdCtrls,
    FMX.DateTimeCtrls,
    FMX.Objects,
    FMX.ComboEdit,
    FMX.Grid,
    FMX.ListBox,
    FMX.Edit,
  {$ELSE}
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
    Vcl.Grids,
    Vcl.Mask,
    Vcl.DBGrids,
    Vcl.ComCtrls,
    Vcl.Buttons,
  {$ENDIF}
  System.Classes,
  Bind4D.Component.Interfaces;

type

  TImageHelper = class helper for TImage
  public
    function asIBind4DComponent : iBind4DComponent;
  end;

  TEditHelper = class helper for TEdit
  public
    function asIBind4DComponent : iBind4DComponent;
  end;

  TSpeedButtonHelper = class helper for TSpeedButton
  public
    function asIBind4DComponent : iBind4DComponent;
  end;

  TComboBoxHelper = class helper for TComboBox
  public
    function asIBind4DComponent : iBind4DComponent;
  end;

  TCheckBoxHelper = class helper for TCheckBox
  public
    function asIBind4DComponent : iBind4DComponent;
  end;

  TStringGridHelper = class helper for TStringGrid
  public
    function asIBind4DComponent : iBind4DComponent;
  end;

  TLabelHelper = class helper for TLabel
  public
    function asIBind4DComponent : iBind4DComponent;
  end;

  TPanelHelper = class helper for TPanel
  public
    function asIBind4DComponent : iBind4DComponent;
  end;

  {$IFDEF HAS_FMX}

  TComboEditHelper = class helper for TComboEdit
  public
    function asIBind4DComponent : iBind4DComponent;
  end;

  TRectangleHelper = class helper for TRectangle
  public
    function asIBind4DComponent : iBind4DComponent;
  end;

  TDateEditHelper = class helper for TDateEdit
  public
    function asIBind4DComponent : iBind4DComponent;
  end;

  {$ELSE}

  TDateTimePickerHelper = class helper for TDateTimePicker
  public
    function asIBind4DComponent : iBind4DComponent;
  end;

  TDBGridHelper = class helper for TDBGrid
  public
    function asIBind4DComponent : iBind4DComponent;
  end;

  TMaskEditHelper = class helper for TMaskEdit
  public
    function asIBind4DComponent : iBind4DComponent;
  end;

  {$ENDIF}

implementation

uses
  Bind4D.Component.Edit,
  Bind4D.Component.SpeedButton,
  Bind4D.Component.ComboBox,
  Bind4D.Component.CheckBox,
  Bind4D.Component.StringGrid,
  Bind4D.Component.Labels,
  Bind4D.Component.Panel,
  Bind4D.Component.DateTimePicker,
  Bind4D.Component.DBGrid,
  Bind4D.Component.MaskEdit,
  Bind4D.Component.ComboEdit,
  Bind4D.Component.Rectangle,
  Bind4D.Component.DateEdit,
  Bind4D.Utils.Rtti,
  Bind4D.Component.Image;

{ TEditHelper }

function TEditHelper.asIBind4DComponent: iBind4DComponent;
begin
  Result := TBind4DComponentEdit.New(Self);
end;

{ TSpeedButtonHelper }

function TSpeedButtonHelper.asIBind4DComponent: iBind4DComponent;
begin
  Result := TBind4DComponentSpeedButton.New(Self);
end;

{ TComboBoxHelper }

function TComboBoxHelper.asIBind4DComponent: iBind4DComponent;
begin
  Result := TBind4DComponentComboBox.New(Self);
end;

{ TCheckBoxHelper }

function TCheckBoxHelper.asIBind4DComponent: iBind4DComponent;
begin
  Result := TBind4DComponentCheckBox.New(Self);
end;

{ TStringGridHelper }

function TStringGridHelper.asIBind4DComponent: iBind4DComponent;
begin
  Result := TBind4DComponentStringGrid.New(Self);
end;

{ TLabelHelper }

function TLabelHelper.asIBind4DComponent: iBind4DComponent;
begin
  Result := TBind4DComponentLabel.New(Self);
end;

{ TPanelHelper }

function TPanelHelper.asIBind4DComponent: iBind4DComponent;
begin
  Result := TBind4DComponentPanel.New(Self);
end;


{$IFDEF HAS_FMX}

{ TComboEditHelper }

function TComboEditHelper.asIBind4DComponent: iBind4DComponent;
begin
  Result := TBind4DComponentComboEdit.New(Self);
end;

{ TRectangleHelper }

function TRectangleHelper.asIBind4DComponent: iBind4DComponent;
begin
  Result := TBind4DComponentRectangle.New(Self);
end;

{ TDateEditHelper }

function TDateEditHelper.asIBind4DComponent: iBind4DComponent;
begin
  Result := TBind4DComponentDateEdit.New(Self);
end;

{$ELSE}

{ TDateTimePickerHelper }

function TDateTimePickerHelper.asIBind4DComponent: iBind4DComponent;
begin
  Result := TBind4DComponentDateTimePicker.New(Self);
end;

{ TDBGridHelper }

function TDBGridHelper.asIBind4DComponent: iBind4DComponent;
begin
  Result := TBind4DComponentDBGrid.New(Self);
end;

{ TMaskEditHelper }

function TMaskEditHelper.asIBind4DComponent: iBind4DComponent;
begin
  Result := TBind4DComponentMaskEdit.New(Self);
end;

{$ENDIF}

{ TImageHelper }

function TImageHelper.asIBind4DComponent: iBind4DComponent;
begin
  Result := TBind4DComponentImage.New(Self);
end;

end.
