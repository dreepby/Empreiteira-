unit uEstadoController;

interface

uses
  System.SysUtils, Data.DB, uEstadoDto, uEstadoModel, uEstado, uEstadoRegra,
  Dialogs, System.UITypes, System.Classes, Winapi.Windows;

type
  TEstadoControler = class
  private
    oModelEstado: TEstadoModel;
    oEstadoDto: TEstadoDto;
    oRegraEstado: TEstadoRegra;
    frmEstados: TfrmEstados;

    procedure Excluir(Sender: TObject);
    procedure Salvar(Sender: TObject);
    procedure Inserir(Sender: TObject);
    procedure Cancelar(Sender: TObject);
    procedure ListarEstados;
    procedure Alterar(Sender: TObject);
    procedure fecharEstado(Sender: TObject);
    procedure Pesquisar(Sender: TObject);
    procedure OnKeyPressEdtPesquisa(Sender: TObject; var Key: Char);
    procedure OnKeyDownForm(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    procedure abrirForm;

    constructor Create;
    destructor Destroy; override;
  end;

var
  oEstadoControler: TEstadoControler;

implementation

{ TEstadoControler }

procedure TEstadoControler.abrirForm;
begin
  if (not(Assigned(frmEstados))) then
    frmEstados := TfrmEstados.Create(nil);

  frmEstados.tsDados.Enabled := False;
  frmEstados.BtnSalvar.Enabled := False;
  frmEstados.BtnCancelar.Enabled := False;
  frmEstados.BtnFechar.OnClick := fecharEstado;
  frmEstados.BtnSalvar.OnClick := Salvar;
  frmEstados.btnInserir.OnClick := Inserir;
  frmEstados.BtnAlterar.OnClick := Alterar;
  frmEstados.BtnCancelar.OnClick := Cancelar;
  frmEstados.btnExcluir.OnClick := Excluir;
  ListarEstados;
  frmEstados.btnPesquisa.OnClick := Pesquisar;
  frmEstados.edtPesquisa.OnKeyPress := OnKeyPressEdtPesquisa;
  frmEstados.OnKeyDown := OnKeyDownForm;
  frmEstados.Show;
end;

procedure TEstadoControler.Alterar(Sender: TObject);
begin

  oEstadoDto.IdUF := frmEstados.DBGrid1.Fields[0].AsInteger;

  frmEstados.tsDados.Enabled := True;
  frmEstados.Caption := 'Altera��o de Estado';
  frmEstados.edtNome.Text := frmEstados.DBGrid1.Fields[2].AsString;
  frmEstados.edtUF.Text := frmEstados.DBGrid1.Fields[1].AsString;
  frmEstados.PageControl1.ActivePage := frmEstados.tsDados;
  frmEstados.tsTabela.Enabled := False;
  frmEstados.btnInserir.Enabled := False;
  frmEstados.BtnAlterar.Enabled := False;
  frmEstados.btnExcluir.Enabled := False;
  frmEstados.BtnSalvar.Enabled := True;
  frmEstados.BtnCancelar.Enabled := True;

end;

procedure TEstadoControler.Cancelar(Sender: TObject);
begin
  frmEstados.tsTabela.Enabled := True;
  frmEstados.PageControl1.ActivePage := frmEstados.tsTabela;
  frmEstados.tsDados.Enabled := False;
  frmEstados.btnInserir.Enabled := True;
  frmEstados.BtnAlterar.Enabled := True;
  frmEstados.btnExcluir.Enabled := True;
  frmEstados.BtnSalvar.Enabled := False;
  frmEstados.BtnCancelar.Enabled := False;
  frmEstados.edtNome.Text := EmptyStr;
  frmEstados.edtUF.Text := EmptyStr;
  frmEstados.Caption := 'Listagem de Estados';
  oRegraEstado.Limpar(oEstadoDto);
end;

constructor TEstadoControler.Create;
begin
  oModelEstado := TEstadoModel.Create;
  oRegraEstado := TEstadoRegra.Create;
  oEstadoDto := TEstadoDto.Create;
end;

destructor TEstadoControler.Destroy;
begin
  if Assigned(oEstadoDto) then
    FreeAndNil(oEstadoDto);

  if Assigned(oRegraEstado) then
    FreeAndNil(oRegraEstado);

  if Assigned(oModelEstado) then
    FreeAndNil(oModelEstado);

  if Assigned(frmEstados) then
  begin
    frmEstados.Close;
    FreeAndNil(frmEstados);
  end;
  inherited;
end;

procedure TEstadoControler.Excluir(Sender: TObject);
begin
  if MessageDlg('Voc� deseja realmente excluir o registro?', mtinformation,
    [mbyes, mbno], 0) = mryes then
  begin
    if oRegraEstado.VerificarExcluir(oModelEstado,
      frmEstados.DBGrid1.Fields[0].AsInteger) then
    begin
      if oRegraEstado.Deletar(oModelEstado, frmEstados.DBGrid1.Fields[0]
        .AsInteger) then
      begin
        ShowMessage('Excluido com sucesso.');
        ListarEstados;
      end
      else
        ShowMessage('Houve algum erro!!');
    end
    else
      ShowMessage
        ('Imposs�vel excluir, pois existe um ou mais registros vinculados com esse!');
  end;
end;

procedure TEstadoControler.fecharEstado(Sender: TObject);
begin
  if (not(Assigned(frmEstados))) then
    exit;

  oRegraEstado.Limpar(oEstadoDto);
  frmEstados.Close;
  FreeAndNil(frmEstados);
end;

procedure TEstadoControler.Inserir(Sender: TObject);
begin
  frmEstados.tsDados.Enabled := True;
  frmEstados.Caption := 'Cadastro de Estado';
  frmEstados.PageControl1.ActivePage := frmEstados.tsDados;
  frmEstados.tsTabela.Enabled := False;
  frmEstados.btnInserir.Enabled := False;
  frmEstados.BtnAlterar.Enabled := False;
  frmEstados.btnExcluir.Enabled := False;
  frmEstados.BtnSalvar.Enabled := True;
  frmEstados.BtnCancelar.Enabled := True;
  frmEstados.edtUF.SetFocus;
end;

procedure TEstadoControler.ListarEstados;
begin
  oModelEstado.ListarEstados(frmEstados.dsTabela);
end;

procedure TEstadoControler.OnKeyDownForm(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F2 then
    frmEstados.edtPesquisa.SetFocus;

  if Key = VK_F5 then
    ListarEstados;
end;

procedure TEstadoControler.OnKeyPressEdtPesquisa(Sender: TObject;
  var Key: Char);
begin
  if Key = #8 then
  begin
    if Length(Trim(frmEstados.edtPesquisa.Text)) = 1 then
      ListarEstados;
  end;

  if Key = #13 then
    frmEstados.btnPesquisa.Click;
end;

procedure TEstadoControler.Pesquisar(Sender: TObject);
begin
  if (Trim(frmEstados.edtPesquisa.Text) <> EmptyStr) then
  begin
    if (oRegraEstado.Pesquisar(oModelEstado, frmEstados.edtPesquisa.Text)
      = False) then
      ShowMessage('Nenhum registro encontrado.');
  end
  else
    ShowMessage('Campo pesquisa vazio.');
end;

procedure TEstadoControler.Salvar(Sender: TObject);
begin
  oEstadoDto.UF := Trim(frmEstados.edtUF.Text);
  oEstadoDto.Nome := Trim(frmEstados.edtNome.Text);

  if (oEstadoDto.UF <> EmptyStr) and (oEstadoDto.Nome <> EmptyStr) then
  begin

    ShowMessage(oRegraEstado.Salvar(oModelEstado, oEstadoDto));

    oRegraEstado.Limpar(oEstadoDto);
    frmEstados.edtNome.Text := EmptyStr;
    frmEstados.edtUF.Text := EmptyStr;
    frmEstados.PageControl1.ActivePage := frmEstados.tsTabela;
    frmEstados.tsTabela.Enabled := True;
    frmEstados.btnInserir.Enabled := True;
    frmEstados.BtnAlterar.Enabled := True;
    frmEstados.btnExcluir.Enabled := True;
    frmEstados.BtnSalvar.Enabled := False;
    frmEstados.BtnCancelar.Enabled := False;
    frmEstados.Caption := 'Listagem de Estados';
    ListarEstados;
  end
  else
    ShowMessage('Prencha todos os campos');

end;

initialization

finalization

if Assigned(oEstadoControler) then
  FreeAndNil(oEstadoControler);

end.
