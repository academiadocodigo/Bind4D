unit Bind4D.Component.Factory;

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
  Bind4D.Component.Interfaces,
  System.Classes;

type
  TBind4DComponentFactory = class(TInterfacedObject, iBind4DComponentFactory)
    private
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iBind4DComponentFactory;
      function Component (aValue : TComponent ) : iBind4DComponent;
  end;

implementation

uses
  Bind4D.Component.Panel,
  Bind4D.Component.Labels,
  Bind4D.Component.DateEdit,
  Bind4D.Component.Rectangle,
  Bind4D.Component.ComboEdit,
  Bind4D.Component.StringGrid,
  Bind4D.Component.CheckBox,
  Bind4D.Component.MaskEdit,
  Bind4D.Component.DBGrid,
  Bind4D.Component.DateTimePicker,
  Bind4D.Component.ComboBox,
  Bind4D.Component.SpeedButton,
  Bind4D.Component.Edit,
  Bind4D.Helpers, Bind4D.Component.Helpers, Bind4D.Component.Mock;

{ TBind4DComponentFactory }

function TBind4DComponentFactory.Component(aValue: TComponent): iBind4DComponent;
begin
  {$IFDEF HAS_FMX}
  if aValue.TryGet<TDateEdit> then Result := aValue.Get<TDateEdit>.asIBind4DComponent;
  if aValue.TryGet<TRectangle> then Result := aValue.Get<TRectangle>.asIBind4DComponent;
  if aValue.TryGet<TComboEdit> then Result := aValue.Get<TComboEdit>.asIBind4DComponent;
  {$ELSE}
  if aValue.TryGet<TMaskEdit> then Result := aValue.Get<TMaskEdit>.asIBind4DComponent;
  if aValue.TryGet<TDBGrid> then Result := aValue.Get<TDBGrid>.asIBind4DComponent;
  if aValue.TryGet<TDateTimePicker> then Result := aValue.Get<TDateTimePicker>.asIBind4DComponent;
  {$ENDIF}
  if aValue.TryGet<TPanel> then Result := aValue.Get<TPanel>.asIBind4DComponent;
  if aValue.TryGet<TLabel> then Result := aValue.Get<TLabel>.asIBind4DComponent;
  if aValue.TryGet<TStringGrid> then Result := aValue.Get<TStringGrid>.asIBind4DComponent;
  if aValue.TryGet<TCheckBox> then Result := aValue.Get<TCheckBox>.asIBind4DComponent;
  if aValue.TryGet<TComboBox> then Result := aValue.Get<TComboBox>.asIBind4DComponent;
  if aValue.TryGet<TSpeedButton> then Result := aValue.Get<TSpeedButton>.asIBind4DComponent;
  if aValue.TryGet<TEdit> then Result := aValue.Get<TEdit>.asIBind4DComponent;
  if aValue.TryGet<TImage> then Result := aValue.Get<TImage>.asIBind4DComponent;
  if not Assigned(Result) then Result := TBind4DComponentMock.New;

end;

constructor TBind4DComponentFactory.Create;
begin

end;

destructor TBind4DComponentFactory.Destroy;
begin

  inherited;
end;

class function TBind4DComponentFactory.New: iBind4DComponentFactory;
begin
  Result := Self.Create;
end;

end.
