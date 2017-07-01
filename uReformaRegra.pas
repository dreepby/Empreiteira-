unit uReformaRegra;

interface

uses
  uReformaDto, System.SysUtils, uReformaModel, uReformaInterfaceModel,
  uClienteInterfaceModel, uClienteModel, uAmbienteReformaDto,
  uAmbienteReformaInterfaceModel, uAmbienteReformaModel, FireDAC.Comp.Client,
  uReforma;

type
  TReformaRegra = class
  public
    procedure Limpar(var AReforma: TReformaDto);
    function VerificarExcluir(const AModel: IModelReformaInterface;
      AId: Integer): Boolean;
    function Deletar(const AModel: IModelReformaInterface;
      AId: Integer): Boolean;
    function Pesquisar(const AModel: IModelReformaInterface;
      ANome: String): Boolean;
    function Salvar(const AModel: IModelReformaInterface; AReforma: TReformaDto;
      AAmbientes: Array of Integer): Boolean;
    function SalvarAmbientes(AAmbientes: Array of Integer;
      AReforma: TReformaDto): Boolean;
    function VerificarMemTableProduto(var AMemTable: TFDMemTable;
      const AIdProduto: Integer; const AIdAmbiente: Integer): Boolean;
    procedure ExcluirProduto(var AMemTable: TFDMemTable;
      const AIdAmbiente, AIdProduto: Integer);
    function VerificarCamposPedido(const AForm: TfrmReforma;
      const AReforma: TReformaDto): Boolean;
  end;

implementation

{ TReformaRegra }

function TReformaRegra.Deletar(const AModel: IModelReformaInterface;
  AId: Integer): Boolean;
begin
  Result := AModel.Deletar(AId);
end;

procedure TReformaRegra.ExcluirProduto(var AMemTable: TFDMemTable;
  const AIdAmbiente, AIdProduto: Integer);
begin
  AMemTable.Filter := 'idProduto = ' + IntToStr(AIdProduto) +
    ' AND idAmbiente = ' + IntToStr(AIdAmbiente);
  AMemTable.Filtered := True;
  AMemTable.Delete;
  AMemTable.Filter := 'idAmbiente = ' + IntToStr(AIdAmbiente);
  AMemTable.Filtered := True;
end;

procedure TReformaRegra.Limpar(var AReforma: TReformaDto);
begin
  AReforma.idReforma := 0;
  AReforma.observacao := EmptyStr;
  AReforma.dataDoPedido := 0;
  AReforma.dataDeEntrega := 0;
  AReforma.oCliente.idCliente := 0;
  AReforma.oCliente.Nome := EmptyStr;
  AReforma.oEscritor.idUsuario := 0;
  AReforma.oEscritor.Nome := EmptyStr;
  AReforma.oAtendente.idUsuario := 0;
  AReforma.oAtendente.Nome := EmptyStr;
  AReforma.total := 0;
end;

function TReformaRegra.Pesquisar(const AModel: IModelReformaInterface;
  ANome: String): Boolean;
begin

end;

function TReformaRegra.Salvar(const AModel: IModelReformaInterface;
  AReforma: TReformaDto; AAmbientes: Array of Integer): Boolean;
var
  iCodigoCPF, iCodigoCnpj: Integer;
  oClienteModel: IModelClienteInterface;
begin {
    if AReforma.dataDoPedido > AReforma.dataDeEntrega then
    raise Exception.Create
    ('A data do pedido n�o pode ser depois da data de entrega.')
    else
    begin
    oClienteModel := TClienteModel.Create;
    iCodigoCPF := oClienteModel.BuscarRegistroIdCpf(AReforma.oCliente.Cpf);
    iCodigoCnpj := oClienteModel.BuscarRegistroIdCnpj(AReforma.oCliente.Cnpj);
    if (iCodigoCPF > 0) and (iCodigoCnpj > 0) then
    begin
    if iCodigoCPF = iCodigoCnpj then
    begin
    AReforma.oCliente.idCliente := iCodigoCPF;
    if AReforma.idReforma > 0 then
    begin
    if AModel.Alterar(AReforma) then
    Result := True
    else
    raise Exception.Create('Ocorreu algum erro.');
    end
    else
    begin
    AReforma.idReforma := AModel.BuscarID;
    if AModel.Inserir(AReforma) then
    begin
    if SalvarAmbientes(AAmbientes, AReforma) then
    Result := True
    else
    raise Exception.Create('Ocorreu algum erro!')
    end
    else
    raise Exception.Create('Ocorreu algum erro.');
    end;
    end
    else
    raise Exception.Create('CPF e CNPJ n�o correspondem ao mesmo cliente.');
    end
    else
    begin
    if iCodigoCPF > 0 then
    AReforma.oCliente.idCliente := iCodigoCPF
    else
    AReforma.oCliente.idCliente := iCodigoCnpj;
    if AReforma.idReforma > 0 then
    begin
    if AModel.Alterar(AReforma) then
    Result := True
    else
    raise Exception.Create('Ocorreu algum erro.');
    end
    else
    begin
    AReforma.idReforma := AModel.BuscarID;
    if AModel.Inserir(AReforma) then
    begin
    if SalvarAmbientes(AAmbientes, AReforma) then
    Result := True
    else
    raise Exception.Create('Ocorreu algum erro!')
    end
    else
    raise Exception.Create('Ocorreu algum erro.');
    end;

    end;
    end; }
end;

function TReformaRegra.SalvarAmbientes(AAmbientes: array of Integer;
  AReforma: TReformaDto): Boolean;
var
  i, count: Integer;
  oAmbienteReformaModel: IModelAmbienteReformaInterface;
  oAmbienteReformaDto: TAmbienteReformaDto;
begin
  oAmbienteReformaDto := TAmbienteReformaDto.Create;
  count := Length(AAmbientes) - 2;
  oAmbienteReformaModel := TAmbienteReformaModel.Create;
  oAmbienteReformaDto.oReforma.idReforma := AReforma.idReforma;
  for i := 0 to count do
  begin
    oAmbienteReformaDto.IdAmbienteReforma := oAmbienteReformaModel.BuscarID;
    oAmbienteReformaDto.oAmbiente.idAmbiente := AAmbientes[i];
    if oAmbienteReformaModel.Inserir(oAmbienteReformaDto) then
      Result := True
    else
    begin
      Result := False;
      exit;
    end;
  end;
  if Assigned(oAmbienteReformaDto) then
    FreeAndNil(oAmbienteReformaDto);
end;

function TReformaRegra.VerificarCamposPedido(const AForm: TfrmReforma;
  const AReforma: TReformaDto): Boolean;
begin
  Result := False;
  if AReforma.dataDoPedido > AReforma.dataDeEntrega then
    raise Exception.Create
      ('A data do pedido n�o pode ser depois da data de entrega.')
  else
  begin
    if AForm.cbAtendente.ItemIndex > -1 then
    begin
      if not(AForm.cbUsuario.ItemIndex > -1) then
      begin
        AForm.cbUsuario.SetFocus;
        raise Exception.Create('Selecione um usuario.');
      end
      else
        Result := True;
    end
    else
      raise Exception.Create('Selecione um atendente.');
  end;
end;

function TReformaRegra.VerificarExcluir(const AModel: IModelReformaInterface;
  AId: Integer): Boolean;
begin
  Result := AModel.VerificarExcluir(AId);
end;

function TReformaRegra.VerificarMemTableProduto(var AMemTable: TFDMemTable;
  const AIdProduto, AIdAmbiente: Integer): Boolean;
begin
  try
    Result := False;
    AMemTable.Filter := 'idProduto = ' + IntToStr(AIdProduto) +
      ' AND idAmbiente = ' + IntToStr(AIdAmbiente);
    AMemTable.Filtered := True;
    if AMemTable.IsEmpty then
      Result := True
    else
      raise Exception.Create('Produto j� cadastrado.');
  finally
    AMemTable.Filter := 'idAmbiente = ' + IntToStr(AIdAmbiente);
  end;

end;

end.
