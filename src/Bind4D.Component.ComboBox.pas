unit Bind4D.Component.ComboBox;
interface
uses
  {$IFDEF HAS_FMX}
    FMX.StdCtrls,
    FMX.ListBox,
  {$ELSE}
    Vcl.ExtCtrls,
    Vcl.StdCtrls,
  {$ENDIF}
  Bind4D.Component.Interfaces, Bind4D.Attributes;
type
  TStringObject = class(TObject)
    private
      FStringValue : String;
    procedure SetStringValue(const Value: String);
    public
      constructor Create (aString : String);
      property StringValue : String read FStringValue write SetStringValue;
  end;
  TBind4DComponentComboBox = class(TInterfacedObject, iBind4DComponent)
    private
      FComponent : TComboBox;
      FAttributes : iBind4DComponentAttributes;
      function IndexOfObjectText(const S: String): Integer;
    public
      constructor Create(aValue : TComboBox);
      destructor Destroy; override;
      class function New(aValue : TComboBox) : iBind4DComponent;
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
  Bind4D,
  Bind4D.Rest,
  Bind4D.Interfaces,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Bind4D.Utils,
  Bind4D.Utils.Rtti,
  Bind4D.ChangeCommand,
  LocalCache4D;

{ TBind4DComboBox }
function TBind4DComponentComboBox.FormatFieldGrid(
  aAttr: FieldDataSetBind): iBind4DComponent;
begin
  Result := Self;
end;
function TBind4DComponentComboBox.AdjusteResponsivity: iBind4DComponent;
begin
  Result := Self;
end;
function TBind4DComponentComboBox.ApplyImage: iBind4DComponent;
begin
  Result := Self;
end;
function TBind4DComponentComboBox.ApplyRestData: iBind4DComponent;
var
  Rest : iBind4DRest;
  Index: Integer;
  FComponentBind : TComponent;
begin
  Result := Self;
  Rest := TBind4D.New.Rest;

  if FAttributes.ComponentNameBind <> '' then
  begin
    FComponentBind := FAttributes.Form.FindComponent(FAttributes.ComponentNameBind);
    TCommandMaster.New.AddAssociation(TComboBox(FComponentBind), FComponent);

    TComboBox(FComponentBind).OnChange :=
      TBind4DUtils
        .AnonProc2NotifyEvent(
          FComponent,
          procedure (Sender : TObject)
          begin
            TCommandMaster.New.Execute((Sender as TComboBox));
          end);


    TCommandMaster.New.Add(TComboBox(FComponentBind),
    procedure (Sender : TObject)
    var
      aBindValue : String;
      Index : Integer;
      aRestData : RestData;
      aComboComponent : TObject;
    begin
      if TComboBox(Sender).ItemIndex <> -1 then
      begin
        aBindValue := TStringObject(TComboBox(Sender)
                .Items.Objects[
                    TComboBox(Sender).ItemIndex
                ]).StringValue;

        if TCommandMaster.New.TryGetAssociation(TComboBox(Sender), aComboComponent) then
          if RttiUtils.TryGet<RestData>(TComboBox(aComboComponent), aRestData) then
          begin
            Rest
              .AddParam('searchfields', aRestData.FieldBind)
              .AddParam('searchvalue', aBindValue)
            .Get(aRestData.EndPoint);

            for Index := 0 to Pred(TComboBox(aComboComponent).Items.Count) do
            begin
              if Assigned(TComboBox(aComboComponent).Items.Objects[Index]) then
              begin
                TComboBox(aComboComponent).Items.Objects[Index].Free;
                TComboBox(aComboComponent).Items.Objects[Index]:=nil;
              end;
            end;
            TComboBox(aComboComponent).Items.Clear;

            if Rest.DataSet.Active then
            begin
              Rest.DataSet.First;
              while not Rest.DataSet.Eof do
              begin
                TComboBox(aComboComponent)
                  .Items
                    .AddObject(
                      Rest.DataSet.FieldByName(
                        aRestData.FieldValue
                      ).AsString,
                      TStringObject.Create(Rest.DataSet.FieldByName(
                        aRestData.FieldKey
                      ).AsString)
                    );
                Rest.DataSet.Next;
              end;
            end;
        end;
      end;
    end);

  end
  else
  begin
    Rest.Get(FAttributes.EndPoint);
    for Index := 0 to Pred(FComponent.Items.Count) do
    begin
      if Assigned(FComponent.Items.Objects[Index]) then
      begin
        FComponent.Items.Objects[Index].Free;
        FComponent.Items.Objects[Index]:=nil;
      end;
    end;
    FComponent.Items.Clear;
    if Rest.DataSet.Active then
    begin
      Rest.DataSet.First;
      while not Rest.DataSet.Eof do
      begin
        FComponent
          .Items
            .AddObject(
              Rest.DataSet.FieldByName(FAttributes.FieldValue).AsString,
              TStringObject.Create(Rest.DataSet.FieldByName(FAttributes.FieldKey).AsString)
            );
        Rest.DataSet.Next;
      end;
    end;
  end;
end;

function TBind4DComponentComboBox.ApplyStyles: iBind4DComponent;
begin
  Result := Self;
  {$IFDEF HAS_FMX}
  {$ELSE}
    FComponent.StyleElements := FAttributes.StyleSettings;
    FComponent.Color := FAttributes.Color;
    FComponent.Font.Color := FAttributes.FontColor;
    FComponent.Font.Name := FAttributes.FontName;
    FComponent.Font.Size := FAttributes.FontSize;
  {$ENDIF}
end;
function TBind4DComponentComboBox.ApplyText: iBind4DComponent;
begin
  Result := Self;
end;
function TBind4DComponentComboBox.ApplyValue: iBind4DComponent;
begin
  Result := Self;
  FComponent.ItemIndex := -1;
  FComponent.Text := '';
  if not VarIsNull(FAttributes.ValueVariant) then
    FComponent.ItemIndex := IndexOfObjectText(FAttributes.ValueVariant);
end;
function TBind4DComponentComboBox.Attributes: iBind4DComponentAttributes;
begin
  Result := FAttributes;
end;
function TBind4DComponentComboBox.Clear: iBind4DComponent;
begin
  Result := Self;
  FComponent.ItemIndex := -1;
end;
constructor TBind4DComponentComboBox.Create(aValue : TComboBox);
begin
  FAttributes := TBind4DComponentAttributes.Create(Self);
  FComponent := aValue;
end;
destructor TBind4DComponentComboBox.Destroy;
begin

  inherited;
end;
function TBind4DComponentComboBox.GetValueString: String;
begin
  Result := '';
  if FComponent.ItemIndex <> -1 then
  begin
    FComponent.ItemIndex := FComponent.Items.IndexOf(FComponent.Text);
    Result := TStringObject(FComponent.Items.Objects[FComponent.ItemIndex]).StringValue;
  end;
end;
function TBind4DComponentComboBox.IndexOfObjectText(const S: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Pred(FComponent.Items.Count) do
    if TStringObject(FComponent.Items.Objects[I]).StringValue = S then
    begin
      Result := I;
      exit;
    end;
end;

class function TBind4DComponentComboBox.New(aValue : TComboBox) : iBind4DComponent;
begin
  Result := Self.Create(aValue);
end;
{ TStringObject }

constructor TStringObject.Create(aString: String);
begin
  StringValue := aString;
end;


procedure TStringObject.SetStringValue(const Value: String);
begin
  FStringValue := Value;
end;

end.
