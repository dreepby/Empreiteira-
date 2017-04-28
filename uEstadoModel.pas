// Banco de dados
unit uEstadoModel;

interface

uses
  System.SysUtils, FireDAC.Comp.Client, Data.DB, FireDAC.DApt, FireDAC.Comp.UI,
  FireDAC.Comp.DataSet, uListaEstado,
  uEstadoDto, uClassSingletonConexao;

type
  TEstadoModel = class
  private
    oQueryListarEstados: TFDQuery;
  public

    function Inserir(var AEstado: TEstadoDto): Boolean;

    function Alterar(var AEstado: TEstadoDto): Boolean;

    function Deletar(const AIDUF: Integer): Boolean;

    function BuscarListaEstados(out ALista: TListaEstados): Boolean;

    function BuscarID: Integer;

    function Ler(var AEstado: TEstadoDto): Boolean;

    procedure ListarEstados(var DsEstado: TDataSource);

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TEstadoModel }

function TEstadoModel.Alterar(var AEstado: TEstadoDto): Boolean;
var
  sSql: String;
begin
  sSql := 'update Estado' + '   set UF = ' + QuotedStr(AEstado.UF) +
    '     , Nome = ' + QuotedStr(AEstado.Nome) + ' where idEstado = ' +
    IntToStr(AEstado.IdUF);

  Result := TSingletonConexao.GetInstancia.ExecSQL(sSql) > 0;
end;

function TEstadoModel.BuscarID: Integer;
var
  oQuery: TFDQuery;
begin
  Result := 1;
  oQuery := TFDQuery.Create(nil);
  try
    oQuery.Connection := TSingletonConexao.GetInstancia;
    oQuery.Open('select max(IdUF) as ID' + '  from UF');
    if (not(oQuery.IsEmpty)) then
      Result := oQuery.FieldByName('ID').AsInteger + 1;
  finally
    if Assigned(oQuery) then
      FreeAndNil(oQuery);
  end;
end;

function TEstadoModel.BuscarListaEstados(out ALista: TListaEstados): Boolean;
var
  oEstadoDTO: TEstadoDto;
  oQuery: TFDQuery;
begin
  Result := False;
  oQuery := TFDQuery.Create(nil);
  try
    oQuery.Connection := TSingletonConexao.GetInstancia;
    oQuery.Open('select IdEstado, UF, NOME from Estado');
    if (not(oQuery.IsEmpty)) then
    begin
      oQuery.First;
      while (not(oQuery.Eof)) do
      begin
        oEstadoDTO := TEstadoDto.Create;
        oEstadoDTO.IdUF := oQuery.FieldByName('IdEstado').AsInteger;
        oEstadoDTO.Nome := oQuery.FieldByName('Nome').AsString;
        oEstadoDTO.UF := oQuery.FieldByName('UF').AsString;

        ALista.Add(oEstadoDTO.Nome, oEstadoDTO);

        oQuery.Next;
      end;
      Result := True;
    end;
  finally
    if Assigned(oQuery) then
      FreeAndNil(oQuery);
  end;
end;

constructor TEstadoModel.Create;
begin
  oQueryListarEstados := TFDQuery.Create(nil);
end;

function TEstadoModel.Deletar(const AIDUF: Integer): Boolean;
begin
  Result := TSingletonConexao.GetInstancia.ExecSQL
    ('delete from uf where iduf = ' + IntToStr(AIDUF)) > 0;
end;

destructor TEstadoModel.Destroy;
begin
  oQueryListarEstados.Close;

  if Assigned(oQueryListarEstados) then
      FreeAndNil(oQueryListarEstados);
  inherited;
end;

function TEstadoModel.Inserir(var AEstado: TEstadoDto): Boolean;
var
  sSql: String;
begin
  sSql := 'insert into uf (idUF, Nome, UF) values (' + IntToStr(AEstado.IdUF) +
    ', ' + QuotedStr(AEstado.Nome) + ', ' + QuotedStr(AEstado.UF) + ')';

  Result := TSingletonConexao.GetInstancia.ExecSQL(sSql) > 0;
end;

function TEstadoModel.Ler(var AEstado: TEstadoDto): Boolean;
var
  oQuery: TFDQuery;
begin
  Result := False;
  oQuery := TFDQuery.Create(nil);
  try
    oQuery.Connection := TSingletonConexao.GetInstancia;
    oQuery.Open('select iduf, Nome, uf  from uf where UF = ' +
      QuotedStr(AEstado.UF));
    if (not(oQuery.IsEmpty)) then
    begin
      AEstado.IdUF := oQuery.FieldByName('iduf').AsInteger;
      AEstado.Nome := oQuery.FieldByName('Nome').AsString;
      Result := True;
    end;
  finally
    if Assigned(oQuery) then
      FreeAndNil(oQuery);
  end;
end;

procedure TEstadoModel.ListarEstados(var DsEstado: TDataSource);
begin
    oQueryListarEstados.Connection := TSingletonConexao.GetInstancia;
    oQueryListarEstados.Open('select iduf, Nome, uf  from uf');
    DsEstado.DataSet := oQueryListarEstados;
end;

end.
