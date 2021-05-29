object PageQuickRegistration: TPageQuickRegistration
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'PageQuickRegistration'
  ClientHeight = 174
  ClientWidth = 409
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 409
    Height = 174
    Align = alClient
    Padding.Left = 25
    Padding.Top = 50
    Padding.Right = 25
    Padding.Bottom = 50
    ParentBackground = False
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 26
      Width = 80
      Height = 13
      Caption = 'Cadastro R'#225'pido'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object btnFechar: TSpeedButton
      Left = 279
      Top = 100
      Width = 106
      Height = 57
      Caption = 'Fechar'
      Flat = True
      OnClick = btnFecharClick
    end
    object btnSalvar: TSpeedButton
      Left = 167
      Top = 100
      Width = 106
      Height = 57
      Caption = 'Salvar'
      Flat = True
      OnClick = btnSalvarClick
    end
    object Edit1: TEdit
      Left = 24
      Top = 63
      Width = 361
      Height = 21
      TabOrder = 0
    end
  end
end
