unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus;

type
  TfrmPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    Cadastro1: TMenuItem;
    mmuPessoa: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    procedure mmuPessoaClick(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses uCadastro;

{$R *.dfm}

procedure TfrmPrincipal.mmuPessoaClick(Sender: TObject);
begin
   TfrmCadastro.CreateFrm(Self);
end;

procedure TfrmPrincipal.Sair1Click(Sender: TObject);
begin
  Close;
end;

end.
