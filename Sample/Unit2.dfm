object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 311
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 24
    Top = 56
    Width = 186
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
  end
  object Memo1: TMemo
    Left = 456
    Top = 32
    Width = 345
    Height = 233
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 456
    Top = 271
    Width = 81
    Height = 25
    Caption = 'GET'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Edit2: TEdit
    Left = 24
    Top = 83
    Width = 186
    Height = 21
    TabOrder = 3
    Text = 'Edit2'
  end
  object ComboBox1: TComboBox
    Left = 24
    Top = 110
    Width = 186
    Height = 21
    ItemIndex = 0
    TabOrder = 4
    Text = 'Masculino'
    Items.Strings = (
      'Masculino'
      'Feminino')
  end
  object CheckBox1: TCheckBox
    Left = 232
    Top = 33
    Width = 97
    Height = 17
    Caption = 'Ativo'
    TabOrder = 5
  end
  object RadioGroup1: TRadioGroup
    Left = 232
    Top = 56
    Width = 185
    Height = 77
    Caption = 'RadioGroup1'
    ItemIndex = 0
    Items.Strings = (
      'Atacado'
      'Varejo')
    TabOrder = 6
  end
  object DateTimePicker1: TDateTimePicker
    Left = 24
    Top = 137
    Width = 186
    Height = 21
    Date = 44265.000000000000000000
    Time = 0.771203449075983400
    TabOrder = 7
  end
  object edtId: TEdit
    Left = 24
    Top = 29
    Width = 186
    Height = 21
    TabOrder = 8
    Text = 'ID'
  end
  object Button2: TButton
    Left = 543
    Top = 271
    Width = 81
    Height = 25
    Caption = 'POST'
    TabOrder = 9
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 630
    Top = 271
    Width = 81
    Height = 25
    Caption = 'PUT'
    TabOrder = 10
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 717
    Top = 271
    Width = 81
    Height = 25
    Caption = 'DELETE'
    TabOrder = 11
    OnClick = Button4Click
  end
  object FDMemTable1: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 368
    Top = 160
  end
end
