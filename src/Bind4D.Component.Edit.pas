unit Bind4D.Component.Edit;
interface
uses
  {$IFDEF HAS_FMX}
    FMX.StdCtrls,
    FMX.Edit,
  {$ELSE}
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
  {$ENDIF}
  Bind4D.Component.Interfaces, Bind4D.Attributes;
type
  TBind4DComponentEdit = class(TInterfacedObject, iBind4DComponent)
    private
      FComponent : TEdit;
      FAttributes : iBind4DComponentAttributes;
      function onChangeAttribute : TBind4DComponentEdit;
      function especialValidate : TBind4DComponentEdit;
    public
      constructor Create(var aValue : TEdit);
      destructor Destroy; override;
      class function New(var aValue : TEdit) : iBind4DComponent;
      function Attributes : iBind4DComponentAttributes;
      function AdjusteResponsivity : iBind4DComponent;
      function FormatFieldGrid (aAttr : FieldDataSetBind) : iBind4DComponent;
      function ApplyStyles : iBind4DComponent;
      function ApplyText : iBind4DComponent;
      function ApplyImage : iBind4DComponent;
      function ApplyValue : iBind4DComponent;
      function ApplyRestData : iBind4DComponent;
      function GetValueString : String;
      function Clear : iBind4DComponent;
  end;
implementation
uses
  Bind4D.Component.Attributes,
  Bind4D.Utils,
  Bind4D.ChangeCommand,
  Bind4D.Types, Data.DB, System.SysUtils, Bind4D.Utils.Rtti;
{ TBind4DComponentEdit }
function TBind4DComponentEdit.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;
function TBind4DComponentEdit.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;
function TBind4DComponentEdit.ApplyImage: iBind4DComponent;
begin
  Result := Self;
end;
function TBind4DComponentEdit.ApplyRestData: iBind4DComponent;
begin
  Result := Self;
end;

function TBind4DComponentEdit.ApplyStyles: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
    FComponent.StyledSettings := FAttributes.StyleSettings;
    FComponent.TextSettings.FontColor := FAttributes.FontColor;
    FComponent.TextSettings.Font.Family := FAttributes.FontName;
  {$ELSE}
    FComponent.StyleElements := FAttributes.StyleSettings;
    FComponent.Color := FAttributes.Color;
    FComponent.Font.Color := FAttributes.FontColor;
    FComponent.Font.Name := FAttributes.FontName;
  {$ENDIF}
  FComponent.Font.Size := FAttributes.FontSize;
  onChangeAttribute;
  especialValidate;
end;
function TBind4DComponentEdit.ApplyText: iBind4DComponent;
begin
  Result := Self;
  FComponent.Text := FAttributes.Text;
end;
function TBind4DComponentEdit.ApplyValue: iBind4DComponent;
begin
  Result := Self;
  case FAttributes.FieldType of
      ftMemo,
      ftFmtMemo,
      ftFixedChar,
      ftWideString,
      ftFixedWideChar,
      ftWideMemo,
      ftLongWord,
      ftString :
      begin
        FComponent.Text := FAttributes.ValueVariant;
      end;
      ftLargeint,
      ftSmallint,
      ftShortint,
      ftInteger:
      begin
        FComponent.Text := IntToStr(FAttributes.ValueVariant);
      end;
      ftBoolean:
      begin
        FComponent.Text := FAttributes.ValueVariant.ToString;
      end;
      ftFloat,
      ftCurrency:
      begin
        FComponent.Text := FloatToStr(FAttributes.ValueVariant);
      end;
    end;
end;
function TBind4DComponentEdit.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;
function TBind4DComponentEdit.Clear: iBind4DComponent;
begin
  Result := Self;
  FComponent.Text := '';
end;
constructor TBind4DComponentEdit.Create(var aValue : TEdit);
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
  FComponent := aValue;
end;
destructor TBind4DComponentEdit.Destroy;
begin
  inherited;
end;
function TBind4DComponentEdit.especialValidate: TBind4DComponentEdit;
begin
  Result := Self;
  case FAttributes.EspecialType of
    teCoin :
    begin
      TCommandMaster.New.Add(
          FComponent,
          procedure (Sender : TObject)
          begin
            (Sender as TEdit).Text := TBind4DUtils.FormatarMoeda((Sender as TEdit).Text);
            (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
          end
      )
    end;
    teCell :
    begin
        TCommandMaster.New.Add(
            FComponent,
            procedure (Sender : TObject)
            begin
              (Sender as TEdit).Text := TBind4DUtils.FormatarCelular((Sender as TEdit).Text);
              (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
            end
        )
    end;
    teCPF :
    begin
      TCommandMaster.New.Add(
            FComponent,
            procedure (Sender : TObject)
            begin
              (Sender as TEdit).Text := TBind4DUtils.FormatarCPF((Sender as TEdit).Text);
              (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
            end
        )
    end;
    teCNPJ :
    begin
      TCommandMaster
        .New
          .Add(
            FComponent,
            procedure (Sender : TObject)
            begin
              (Sender as TEdit).Text := TBind4DUtils.FormatarCNPJ((Sender as TEdit).Text);
              (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
            end)
    end;
    teNull : ;
  end;
end;
function TBind4DComponentEdit.GetValueString: String;
var
  aAttr : ComponentBindStyle;
begin
  //TODO: Tratar a Validação NotNull
  {*if pRtti.Tem<fvNotNull> then
    begin
      if Trim((aComponent as TEdit).Text) = '' then
        if pRtti.Tem<FieldDataSetBind> then
        begin
          (aComponent as TEdit).SetFocus;
          raise Exception.Create(pRtti.GetAttribute<fvNotNull>.Msg);
        end;
    end;*}
  Result := FComponent.Text;
  if RttiUtils.TryGet<ComponentBindStyle>(FComponent, aAttr) then
  begin
    case aAttr.EspecialType of
      teNull : Result := FComponent.Text;
      teCoin : Result := TBind4DUtils.ExtrairMoeda(FComponent.Text);
      teCell : Result := TBind4DUtils.ApenasNumeros(FComponent.Text);
      teCPF  : Result := TBind4DUtils.ApenasNumeros(FComponent.Text);
      teCNPJ  : Result := TBind4DUtils.ApenasNumeros(FComponent.Text);
    end;
  end;
end;
class function TBind4DComponentEdit.New(var aValue : TEdit) : iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;
function TBind4DComponentEdit.onChangeAttribute : TBind4DComponentEdit;
begin
  Result := Self;
  FComponent.OnChange :=
  TBind4DUtils
    .AnonProc2NotifyEvent(
      FComponent,
      procedure (Sender : TObject)
      begin
        TCommandMaster.New.Execute((Sender as TEdit));
      end);
end;
end.
