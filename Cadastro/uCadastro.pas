{
 Autor: Gilmar Piccin
 Data : 08/07/2016
}

unit uCadastro;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, DBClient, Grids, DBGrids, Menus, ComCtrls,
  Mask;

type
  StateofCDS = (scInsert, scEdit, scBrowser);

  TfrmCadastro = class(TForm)
    pnlBotao: TPanel;
    btIncluir: TButton;
    btEditar: TButton;
    btExcluir: TButton;
    btCancelar: TButton;
    btSalvar: TButton;
    btLocalizar: TButton;
    dbg: TDBGrid;
    ds: TDataSource;
    btCalcular: TButton;
    edNOME: TEdit;
    edSOBRENOME: TEdit;
    edVALOR: TEdit;
    lblNome: TLabel;
    lblSobrenome: TLabel;
    lblValor: TLabel;
    lblNacimento: TLabel;
    edNascimento: TMaskEdit;
    cds: TClientDataSet;
    procedure btIncluirClick(Sender: TObject);
    procedure cdsAfterEdit(DataSet: TDataSet);
    procedure cdsAfterCancel(DataSet: TDataSet);
    procedure cdsAfterPost(DataSet: TDataSet);
    procedure btEditarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure cdsAfterScroll(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure cdsBeforeInsert(DataSet: TDataSet);
    procedure cdsAfterInsert(DataSet: TDataSet);
    procedure cdsBeforeDelete(DataSet: TDataSet);
    procedure btLocalizarClick(Sender: TObject);
    procedure btCalcularClick(Sender: TObject);
    procedure cdsAfterDelete(DataSet: TDataSet);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edVALORChange(Sender: TObject);
  private
    { Private declarations }
    State: StateofCDS;

    procedure EnableButtons;
    procedure EnableEdits;

    procedure ToCds;
    procedure ToEdits;
    procedure ClearEdits;

  public
    { Public declarations }
    function CalcPercentual(valor,percent:Double):Double;
    function ValData(data:string):Boolean;
    constructor CreateFrm(Owner:TComponent);
  end;

var
  frmCadastro: TfrmCadastro;

implementation

{$R *.dfm}

procedure TfrmCadastro.btIncluirClick(Sender: TObject);
begin
  ClearEdits;

  //Antes de incluir eu desabilito o evento BeforeInsert para conseguir incluir
  cds.BeforeInsert := nil;
  cds.Append;
  //Atribuo o método cdsBeforeInsert para o evento
  cds.BeforeInsert := cdsBeforeInsert;

  //Deixo os controles no estado para inclusão
  EnableEdits;
  EnableButtons;

  //Foco no edit
  edNome.SetFocus;
end;

procedure TfrmCadastro.btLocalizarClick(Sender: TObject);
var
  Nome: String;
begin
  if InputQuery('Localizar', 'Informe o nome:', Nome) then
  begin
    if AnsiSameText(Nome, EmptyStr) then
      ShowMessage('O nome precisa ser informado.')
    else
    begin
      //Localizo o registro
      if cds.Locate('NOME', Nome, [loCaseInsensitive]) then
        ToEdits
      else
        ShowMessage('Nome não localizado.');
    end;
  end;
end;

procedure TfrmCadastro.btEditarClick(Sender: TObject);
begin
  //Coloco o cds em modo de edição
  cds.Edit;
  EnableEdits;
  EnableButtons;

  edNome.SetFocus;
end;

procedure TfrmCadastro.btExcluirClick(Sender: TObject);
begin
  if (cds.RecordCount > 0) and
     (Application.MessageBox('Deseja realmente apagar o registro?', PChar(Caption), MB_YESNO + MB_ICONQUESTION) = ID_YES) then
  begin
    cds.BeforeDelete := nil;
    cds.Delete;
    cds.BeforeDelete := cdsBeforeDelete;
  end;
  EnableEdits;
  EnableButtons;
end;



procedure TfrmCadastro.btCalcularClick(Sender: TObject);
var
  Percentual: String;
  bCalcular: Integer;

  procedure Calcular;
  begin
    cds.Edit;
    //cds.FieldByName('VALOR').AsFloat := ((StrToFloat(Percentual) / 100) + 1) * cds.FieldByName('VALOR').AsFloat;
    cds.FieldByName('VALOR').AsFloat := CalcPercentual(cds.FieldByName('VALOR').AsFloat,StrToFloatDef(Percentual,0)) ;
    cds.Post;
  end;

begin
  try
    bCalcular := Application.MessageBox('Deseja calcular todos?', PChar(Caption), MB_YESNOCANCEL + MB_ICONQUESTION);

    if bCalcular <> ID_CANCEL then
    begin
      InputQuery('Localizar', 'Informe o percentual:', Percentual);

      if AnsiSameText(Percentual, EmptyStr) then
        ShowMessage('O percentual precisa ser informado.')
      else
      begin
        if bCalcular = ID_YES then
        begin
          cds.First;
          while not cds.Eof do
          begin
            Calcular;
            cds.Next;
          end;
        end
        else
          Calcular;
      end;
    end;

    ToEdits;
  except on e: Exception do
    begin
      btCancelar.Click;
      ShowMessage('Não foi possível calcular os dados.' + #13#10 + 'Mensagem: ' + E.Message);
    end;
  end;
end;

procedure TfrmCadastro.btCancelarClick(Sender: TObject);
begin
  //Cancelo a manipulação do cds
  cds.Cancel;
  EnableEdits;
  EnableButtons;
end;

procedure TfrmCadastro.btSalvarClick(Sender: TObject);
begin
  //Jogo os valores dos edits para o cds
  ToCds;
  //Salvo
  cds.Post;
  EnableEdits;
  EnableButtons;
end;

function TfrmCadastro.CalcPercentual(valor, percent: Double): Double;
begin
  Result := ((Percent / 100) + 1) * valor;
end;

procedure TfrmCadastro.cdsAfterCancel(DataSet: TDataSet);
begin
  State := scBrowser;
end;

procedure TfrmCadastro.cdsAfterDelete(DataSet: TDataSet);
begin
  cds.SaveToFile(ChangeFileExt(ParamStr(0), '.xml'), dfXMLUTF8);
end;

procedure TfrmCadastro.cdsAfterEdit(DataSet: TDataSet);
begin
  State := scEdit;
end;

procedure TfrmCadastro.cdsAfterInsert(DataSet: TDataSet);
begin
  State := scInsert;
end;

procedure TfrmCadastro.cdsAfterPost(DataSet: TDataSet);
begin
  //Salvo no arquivo XML
  cds.SaveToFile(ChangeFileExt(ParamStr(0), '.xml'), dfXMLUTF8);
  State := scBrowser;
end;

procedure TfrmCadastro.cdsAfterScroll(DataSet: TDataSet);
begin
  ToEdits;
end;

procedure TfrmCadastro.cdsBeforeDelete(DataSet: TDataSet);
begin
  Abort;
end;

procedure TfrmCadastro.cdsBeforeInsert(DataSet: TDataSet);
begin
  Abort;
end;

procedure TfrmCadastro.ClearEdits;
var
  iCount: Integer;
begin
  for iCount := 0 to ComponentCount - 1 do
    if (Components[iCount] is TEdit) then
      (Components[iCount] as TEdit).Clear;
end;

constructor TfrmCadastro.CreateFrm(Owner: TComponent);
begin
  inherited Create(Owner);

  //Verifico se existe o arquivo XML, se não existir eu crio o cds
  if FileExists(ChangeFileExt(ParamStr(0), '.xml')) then
    cds.LoadFromFile(ChangeFileExt(ParamStr(0), '.xml'))
  else
  begin
    cds.FieldDefs.Add('NOME', ftString, 25);
    cds.FieldDefs.Add('SOBRENOME', ftString, 30);
    cds.FieldDefs.Add('VALOR', ftFloat);
    cds.FieldDefs.Add('NASCIMENTO', ftDate);
    cds.CreateDataSet;
  end;

  Show;
end;

procedure TfrmCadastro.edVALORChange(Sender: TObject);

  function FiltraNumeros(S: String): string;
  var
  i: integer;
  begin
    Result := '';
    for i := 1 to Length(S) do
    if S[i] in ['0'..'9',',','-'] then
    Result := Result + S[i];
  end;
begin
   TEdit(Sender).Text := FiltraNumeros(TEdit(Sender).Text);
end;

procedure TfrmCadastro.EnableButtons;
begin
  btIncluir.Enabled   := State = scBrowser;
  btEditar.Enabled    := (State = scBrowser) and (cds.RecordCount > 0);
  btExcluir.Enabled   := (State = scBrowser) and (cds.RecordCount > 0);
  btCancelar.Enabled  := State in [scInsert, scEdit];
  btSalvar.Enabled    := State in [scInsert, scEdit];
  btLocalizar.Enabled := (State = scBrowser) and (cds.RecordCount > 0);
  btCalcular.Enabled  := (State = scBrowser) and (cds.RecordCount > 0);
end;

procedure TfrmCadastro.EnableEdits;
begin
  edNome.Enabled        := State in [scInsert, scEdit];
  edSobrenome.Enabled   := State in [scInsert, scEdit];
  edValor.Enabled       := State in [scInsert, scEdit];
  edNascimento.Enabled  := State in [scInsert, scEdit];
  dbg.Enabled           := State = scBrowser;

end;

procedure TfrmCadastro.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Destroy;
end;

procedure TfrmCadastro.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    btCancelar.Click;
end;

procedure TfrmCadastro.FormShow(Sender: TObject);
begin
  State := scBrowser;
  EnableButtons;
  EnableEdits;

end;

procedure TfrmCadastro.ToCds;
var
 I:integer;
begin
  //Carrega os dados no cds
  cds.FieldByName('NOME').AsString         := edNome.Text;
  cds.FieldByName('SOBRENOME').AsString    := edSobrenome.Text;
  cds.FieldByName('VALOR').AsString        := edValor.Text;
  if not ValData(edNascimento.EditText) then
  begin
    MessageDlg('Data Inválida',mtError,[mbOK],0);
    edNascimento.SetFocus;
    Abort;
  end;
  cds.FieldByName('NASCIMENTO').AsDateTime := StrToDate(edNascimento.EditText);


end;

procedure TfrmCadastro.ToEdits;
var
  iCount: Integer;
begin
  //Carrega os dados nos componentes da tela
  for iCount := 0 to cds.Fields.Count - 1 do
  begin
    //FindComponent recebe uma string e retorna um component, uso para localizar meus edits
    TEdit    (FindComponent('ed' + cds.Fields.Fields[iCount].FieldName)).Text := cds.FieldByName(cds.Fields.Fields[iCount].FieldName).AsString;
    TMaskEdit(FindComponent('ed' + cds.Fields.Fields[iCount].FieldName)).Text := StringReplace(cds.FieldByName(cds.Fields.Fields[iCount].FieldName).AsString,'/','',[rfReplaceAll]);
  end
end;

function TfrmCadastro.ValData(data: string): Boolean;
begin
  //tenta converter a string em uma data se não conseguir, a data é inválida
  try
    StrToDate(data);
    Result := True;
  except
    Result := False;
  end;
end;

end.
