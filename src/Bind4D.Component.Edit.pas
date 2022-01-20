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
  Bind4D.Component.Interfaces,
  Bind4D.Attributes, System.JSON;
type
  TBind4DComponentEdit = class(TInterfacedObject, iBind4DComponent)
    private
      FComponent : TEdit;
      FAttributes : iBind4DComponentAttributes;
      function onChangeAttribute : TBind4DComponentEdit;
      //function onExitAttribute : TBind4DComponentEdit;
      function especialValidate : TBind4DComponentEdit;
      procedure TryValidations;
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
      function GetCaption : String;
      function Clear : iBind4DComponent;
  end;
implementation
uses
  Bind4D.Component.Attributes,
  Bind4D.Utils,
  Bind4D.ChangeCommand,
  Bind4D.Types,
  Data.DB,
  System.SysUtils,
  Bind4D.Utils.Rtti,
  Vcl.Graphics,
  System.Variants,
  ZC4B.Interfaces,
  ZC4B;

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

  TCommandMaster.New.Add(
    FComponent,
    procedure (Sender : TObject)
    begin
      if Trim((Sender as TEdit).Text) <> '' then
        if Trim((Sender as TEdit).HelpKeyword) <> '' then
          (Sender as TEdit).Color := StringToColor((Sender as TEdit).HelpKeyword);
    end);

  onChangeAttribute;
  //onExitAttribute;
  especialValidate;
end;
function TBind4DComponentEdit.ApplyText: iBind4DComponent;
begin
  Result := Self;
  FComponent.Text := FAttributes.ValueVariant;
end;
function TBind4DComponentEdit.ApplyValue: iBind4DComponent;
var
  VariantD : Double;
begin
  Result := Self;
  if VarIsNull(FAttributes.ValueVariant) then exit;
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
        VariantD := FAttributes.ValueVariant;
        FComponent.Text := format('%n', [VariantD]);
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

procedure TBind4DComponentEdit.TryValidations;
var
  aAttrNotNull: fvNotNull;
begin
  if RttiUtils.TryGet<fvNotNull>(FComponent, aAttrNotNull) then
    if Trim(FComponent.Text) = '' then
    begin
      if FComponent.Enabled then
      begin
        FComponent.SetFocus;
        FComponent.HelpKeyword := ColorToString(FComponent.Color);
        FComponent.Color := aAttrNotNull.ErrorColor;
        raise Exception.Create(aAttrNotNull.Msg);
      end;
    end;
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
var
  AttrBindFormat : ComponentBindFormat;
begin
  Result := Self;
  if RttiUtils.TryGet<ComponentBindFormat>(FComponent, AttrBindFormat) then
  begin
    case AttrBindFormat.EspecialType of
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
      teCEP :
      begin
        TCommandMaster
          .New
            .Add(
              FComponent,
              procedure (Sender : TObject)
              begin
                (Sender as TEdit).Text := TBind4DUtils.FormatarCEP((Sender as TEdit).Text);
                (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
              end)
      end;
      tePhone :
      begin
        TCommandMaster
          .New
            .Add(
              FComponent,
              procedure (Sender : TObject)
              begin
                (Sender as TEdit).Text := TBind4DUtils.FormatarPhone((Sender as TEdit).Text);
                (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
              end)
      end;
      tePercent :
      begin
        TCommandMaster
          .New
            .Add(
              FComponent,
              procedure (Sender : TObject)
              begin
                (Sender as TEdit).Text := TBind4DUtils.FormataPercentual((Sender as TEdit).Text);
                (Sender as TEdit).SelStart := Length((Sender as TEdit).Text);
              end)
      end;
      teNull : ;
    end;
  end;

end;
function TBind4DComponentEdit.GetCaption: String;
begin
  Result := '';
end;

function TBind4DComponentEdit.GetValueString: String;
var
  aAttr : ComponentBindFormat;
begin
  Result := FComponent.Text;
  TryValidations;
  if RttiUtils.TryGet<ComponentBindFormat>(FComponent, aAttr) then
  begin
    case aAttr.EspecialType of
      teNull : Result := FComponent.Text;
      teCoin : Result := TBind4DUtils.ExtrairMoeda(FComponent.Text);
      else
        Result := TBind4DUtils.ApenasNumeros(FComponent.Text);
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

//function TBind4DComponentEdit.onExitAttribute: TBind4DComponentEdit;
//begin
//  Result := Self;
//  FComponent.OnExit :=
//  TBind4DUtils
//    .AnonProc2NotifyEvent(
//      FComponent,
//      procedure (Sender : TObject)
//      begin
//        TCommandMaster.New.Execute((Sender as TEdit));
//      end);
//end;

end.
