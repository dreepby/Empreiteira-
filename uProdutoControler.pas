unit uProdutoControler;

interface

uses
  System.SysUtils, Data.DB, System.Generics.Collections, uProdutoDto,
  uProdutoModel, uProduto, uProdutoRegra,
  Dialogs, System.UITypes, System.Classes, Winapi.Windows,
  uInterfaceControler, uProdutoInterfaceModel, uAmbienteModel, uAmbienteDto,
  uAmbienteInterfaceModel;

type
  TProdutoControler = class(TInterfacedObject, IControlerInterface)

  private

    oProdutoModel: IModelProdutoInterface;
    oProdutoDto: TProdutoDto;
    oProdutoRegra: TProdutoRegra;
    AmbientesReforma: Array of Integer;
    oListaAmbientes: TObjectDictionary<string, TAmbienteDto>;

    procedure Excluir(Sender: TObject);
    procedure Salvar(Sender: TObject);
    procedure Inserir(Sender: TObject);
    procedure Cancelar(Sender: TObject);
    procedure ListarProdutos;
    procedure Alterar(Sender: TObject);
    procedure fecharProduto(Sender: TObject);
    procedure Pesquisar(Sender: TObject);
    procedure OnKeyPressEdtPesquisa(Sender: TObject; var Key: Char);
    procedure OnKeyDownForm(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure popularCheckListBox;
  public
    procedure abrirForm;

    constructor Create;
    destructor Destroy; override;
  end;

var
  oProdutoControler: TProdutoControler;

implementation

{ TProdutoControler }

procedure TProdutoControler.abrirForm;
begin
  if (not(Assigned(frmProduto))) then
    frmProduto := TfrmProduto.Create(nil);

  frmProduto.tsDados.Enabled := False;
  frmProduto.BtnSalvar.Enabled := False;
  frmProduto.BtnCancelar.Enabled := False;
  frmProduto.BtnFechar.OnClick := fecharProduto;
  frmProduto.BtnSalvar.OnClick := Salvar;
  frmProduto.btnInserir.OnClick := Inserir;
  frmProduto.BtnAlterar.OnClick := Alterar;
  frmProduto.BtnCancelar.OnClick := Cancelar;
  frmProduto.btnExcluir.OnClick := Excluir;
  ListarProdutos;
  frmProduto.btnPesquisa.OnClick := Pesquisar;
  frmProduto.edtPesquisa.OnKeyPress := OnKeyPressEdtPesquisa;
  frmProduto.OnKeyDown := OnKeyDownForm;
  frmProduto.Show;
end;

procedure TProdutoControler.Alterar(Sender: TObject);
begin
  popularCheckListBox;
  oProdutoDto.idProduto := frmProduto.DBGrid1.Fields[0].AsInteger;

  if oProdutoRegra.BuscarProduto(oProdutoModel, oProdutoDto) then
  begin
    frmProduto.tsDados.Enabled := True;
    frmProduto.Caption := 'Altera��o de Produto';
    frmProduto.PageControl1.ActivePage := frmProduto.tsDados;
    frmProduto.tsTabela.Enabled := False;
    frmProduto.btnInserir.Enabled := False;
    frmProduto.BtnAlterar.Enabled := False;
    frmProduto.btnExcluir.Enabled := False;
    frmProduto.BtnSalvar.Enabled := True;
    frmProduto.BtnCancelar.Enabled := True;
    frmProduto.edtDescricao.Text := oProdutoDto.Descricao;
    frmProduto.edtPreco.Text := (oProdutoDto.Preco)
  end
  else
    ShowMessage('Nenhum registro encontrado');

end;

procedure TProdutoControler.Cancelar(Sender: TObject);
begin
  frmProduto.tsTabela.Enabled := True;
  frmProduto.PageControl1.ActivePage := frmProduto.tsTabela;
  frmProduto.tsDados.Enabled := False;
  frmProduto.btnInserir.Enabled := True;
  frmProduto.BtnAlterar.Enabled := True;
  frmProduto.btnExcluir.Enabled := True;
  frmProduto.BtnSalvar.Enabled := False;
  frmProduto.BtnCancelar.Enabled := False;
  frmProduto.edtDescricao.Text := EmptyStr;
  frmProduto.edtPreco.Text := EmptyStr;
  frmProduto.Caption := 'Listagem de Produtos';
end;

constructor TProdutoControler.Create;
begin
  oProdutoModel := TProdutoModel.Create;
  oProdutoRegra := TProdutoRegra.Create;
  oProdutoDto := TProdutoDto.Create;
  oListaAmbientes := TObjectDictionary<string, TAmbienteDto>.Create
    ([doOwnsValues]);
end;

destructor TProdutoControler.Destroy;
begin
  if Assigned(oProdutoDto) then
    FreeAndNil(oProdutoDto);

  if Assigned(oProdutoRegra) then
    FreeAndNil(oProdutoRegra);

  if (Assigned(frmProduto)) then
  begin
    frmProduto.Close;
    FreeAndNil(frmProduto);
  end;

  if Assigned(oListaAmbientes) then
  begin
    oListaAmbientes.Clear;
    FreeAndNil(oListaAmbientes);
  end;
  inherited;
end;

procedure TProdutoControler.Excluir(Sender: TObject);
begin
  if MessageDlg('Voc� deseja realmente excluir o registro?', mtinformation,
    [mbyes, mbno], 0) = mryes then
  begin
    if oProdutoRegra.VerificarExcluir(oProdutoModel,
      frmProduto.DBGrid1.Fields[0].AsInteger) then
    begin
      if oProdutoRegra.Deletar(oProdutoModel,
        frmProduto.DBGrid1.Fields[0].AsInteger) then
      begin
        ShowMessage('Excluido com sucesso.');
        ListarProdutos;
      end
      else
        ShowMessage('Houve algum erro!!');
    end
    else
      ShowMessage
        ('Imposs�vel excluir, pois existe um ou mais registros vinculados com esse!');
  end;
end;

procedure TProdutoControler.fecharProduto(Sender: TObject);
begin
  if (not(Assigned(frmProduto))) then
    exit;

  oProdutoRegra.Limpar(oProdutoDto);
  frmProduto.Close;
  FreeAndNil(frmProduto);
end;

procedure TProdutoControler.Inserir(Sender: TObject);
begin
  popularCheckListBox;
  frmProduto.tsDados.Enabled := True;
  frmProduto.Caption := 'Cadastro de Produto';
  frmProduto.PageControl1.ActivePage := frmProduto.tsDados;
  frmProduto.tsTabela.Enabled := False;
  frmProduto.btnInserir.Enabled := False;
  frmProduto.BtnAlterar.Enabled := False;
  frmProduto.btnExcluir.Enabled := False;
  frmProduto.BtnSalvar.Enabled := True;
  frmProduto.BtnCancelar.Enabled := True;
  frmProduto.edtDescricao.SetFocus;
end;

procedure TProdutoControler.ListarProdutos;
begin
  oProdutoModel.ListarProdutos(frmProduto.dsTabela);
end;

procedure TProdutoControler.OnKeyDownForm(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

end;

procedure TProdutoControler.OnKeyPressEdtPesquisa(Sender: TObject;
  var Key: Char);
begin

end;

procedure TProdutoControler.Pesquisar(Sender: TObject);
begin

end;

procedure TProdutoControler.popularCheckListBox;
var
  oAmbienteModel: IModelAmbienteInterface;
  sIndice: String;
begin
  oAmbienteModel := TAmbienteModel.Create;
  oListaAmbientes.Clear;
  frmProduto.clbAmbientes.Clear;
  if (oAmbienteModel.ADDListaHash(oListaAmbientes)) then
  begin
    for sIndice in oListaAmbientes.Keys do
      frmProduto.clbAmbientes.AddItem(sIndice, oListaAmbientes);
  end;
end;

procedure TProdutoControler.Salvar(Sender: TObject);
var
  sTeste: String;
  i: Integer;
  iCount: Integer;
  iCountArray: Integer;
begin
  iCount := frmProduto.clbAmbientes.Items.count - 1;
  iCountArray := 0;
  SetLength(AmbientesReforma, 0);

  for i := 0 to iCount do
  begin
    if frmProduto.clbAmbientes.Checked[i] = True then
    begin
      sTeste := sTeste + frmProduto.clbAmbientes.Items[i];
      SetLength(AmbientesReforma, iCountArray + 2);
      AmbientesReforma[iCountArray] := oListaAmbientes.Items
        [frmProduto.clbAmbientes.Items[i]].idAmbiente;
      iCountArray := iCountArray + 1;
    end;
  end;
  if sTeste = EmptyStr then
    ShowMessage('Selecione um ambiente.')
  else
  begin
    oProdutoDto.Descricao := frmProduto.edtDescricao.Text;
    oProdutoDto.Preco := StringReplace((frmProduto.edtPreco.Text), ',', '.',
      [rfReplaceAll]);
    if (frmProduto.edtDescricao.Text <> EmptyStr) then
      if not(StrToCurr(frmProduto.edtPreco.Text) <= 0) then

      begin
        try
          if (oProdutoRegra.Salvar(oProdutoModel, oProdutoDto, AmbientesReforma)) then
          begin
            oProdutoRegra.Limpar(oProdutoDto);
            frmProduto.edtDescricao.Text := EmptyStr;
            frmProduto.PageControl1.ActivePage := frmProduto.tsTabela;
            frmProduto.tsTabela.Enabled := True;
            frmProduto.btnInserir.Enabled := True;
            frmProduto.BtnAlterar.Enabled := True;
            frmProduto.btnExcluir.Enabled := True;
            oProdutoRegra.Limpar(oProdutoDto);
            frmProduto.BtnSalvar.Enabled := False;
            frmProduto.BtnCancelar.Enabled := False;
            frmProduto.Caption := 'Listagem de Produtos';
            ListarProdutos;
          end;
        except
          on E: Exception do
            ShowMessage(E.Message);

        end
      end
      else
        ShowMessage('Insira um valor v�lido.')
    else
      ShowMessage('Prencha o campo Descri��o.');
  end;
end;

initialization

finalization

if Assigned(oProdutoControler) then
  FreeAndNil(oProdutoControler);

end.