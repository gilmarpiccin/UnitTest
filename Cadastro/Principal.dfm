object frmPrincipal: TfrmPrincipal
  Left = 416
  Top = 255
  Caption = 'Principal'
  ClientHeight = 389
  ClientWidth = 612
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 104
    Top = 31
    object Cadastro1: TMenuItem
      Caption = '&Cadastro'
      object mmuPessoa: TMenuItem
        Caption = 'Pessoa'
        OnClick = mmuPessoaClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Sair1: TMenuItem
        Caption = '&Sair'
        OnClick = Sair1Click
      end
    end
  end
end
