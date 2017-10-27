object frmCadastro: TfrmCadastro
  Left = 0
  Top = 0
  Caption = 'Pessoa'
  ClientHeight = 324
  ClientWidth = 526
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  Visible = True
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  DesignSize = (
    526
    324)
  PixelsPerInch = 96
  TextHeight = 13
  object lblValor: TLabel
    Left = 8
    Top = 141
    Width = 24
    Height = 13
    Caption = 'Valor'
  end
  object lblSobrenome: TLabel
    Left = 8
    Top = 93
    Width = 54
    Height = 13
    Caption = 'Sobrenome'
  end
  object lblNome: TLabel
    Left = 8
    Top = 45
    Width = 27
    Height = 13
    Caption = 'Nome'
  end
  object lblNacimento: TLabel
    Left = 168
    Top = 141
    Width = 50
    Height = 13
    Caption = 'Nacimento'
  end
  object dbg: TDBGrid
    Left = 0
    Top = 195
    Width = 526
    Height = 129
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    DataSource = ds
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object edVALOR: TEdit
    Left = 8
    Top = 160
    Width = 121
    Height = 21
    TabOrder = 3
    OnChange = edVALORChange
  end
  object edSOBRENOME: TEdit
    Left = 8
    Top = 112
    Width = 233
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object edNOME: TEdit
    Left = 8
    Top = 64
    Width = 233
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object pnlBotao: TPanel
    Left = 0
    Top = 0
    Width = 526
    Height = 41
    Align = alTop
    TabOrder = 0
    object btIncluir: TButton
      Left = 0
      Top = 1
      Width = 75
      Height = 39
      Align = alRight
      Cancel = True
      Caption = '&Incluir'
      TabOrder = 0
      OnClick = btIncluirClick
    end
    object btEditar: TButton
      Left = 75
      Top = 1
      Width = 75
      Height = 39
      Align = alRight
      Caption = '&Editar'
      TabOrder = 1
      OnClick = btEditarClick
    end
    object btExcluir: TButton
      Left = 150
      Top = 1
      Width = 75
      Height = 39
      Align = alRight
      Caption = 'E&xcluir'
      TabOrder = 2
      OnClick = btExcluirClick
    end
    object btCancelar: TButton
      Left = 225
      Top = 1
      Width = 75
      Height = 39
      Align = alRight
      Caption = '&Cancelar'
      Enabled = False
      TabOrder = 3
      OnClick = btCancelarClick
    end
    object btSalvar: TButton
      Left = 300
      Top = 1
      Width = 75
      Height = 39
      Align = alRight
      Caption = '&Salvar'
      Enabled = False
      TabOrder = 4
      OnClick = btSalvarClick
    end
    object btLocalizar: TButton
      Left = 375
      Top = 1
      Width = 75
      Height = 39
      Align = alRight
      Caption = '&Localizar'
      TabOrder = 5
      OnClick = btLocalizarClick
    end
    object btCalcular: TButton
      Left = 450
      Top = 1
      Width = 75
      Height = 39
      Align = alRight
      Caption = 'C&alcular'
      TabOrder = 6
      OnClick = btCalcularClick
    end
  end
  object edNascimento: TMaskEdit
    Left = 168
    Top = 160
    Width = 64
    Height = 21
    EditMask = '!99/99/9999;0; '
    MaxLength = 10
    TabOrder = 5
  end
  object ds: TDataSource
    DataSet = cds
    Left = 320
    Top = 152
  end
  object cds: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforeInsert = cdsBeforeInsert
    AfterInsert = cdsAfterInsert
    AfterEdit = cdsAfterEdit
    AfterPost = cdsAfterPost
    AfterCancel = cdsAfterCancel
    BeforeDelete = cdsBeforeDelete
    AfterDelete = cdsAfterDelete
    AfterScroll = cdsAfterScroll
    Left = 272
    Top = 152
  end
end
