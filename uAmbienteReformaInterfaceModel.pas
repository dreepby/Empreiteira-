unit uAmbienteReformaInterfaceModel;

interface

uses
  Data.DB, System.Generics.Collections, uAmbienteReformaDto, uAmbienteDto;

type
  IModelAmbienteReformaInterface = interface
    function BuscarID: Integer;
    function Inserir(var AAmbienteReforma: TAmbienteReformaDto): Boolean;
    function Deletar(const AidReforma: Integer): Boolean;
    function VerificarAmbienteReforma(AAmbienteReforma: TAmbienteReformaDto;
      out AId: Integer): Boolean;
    function VerificarExcluir(AId: Integer): Boolean;
    function BuscarRegistrosReforma(var oLista
      : TObjectDictionary<string, TAmbienteDto>; AidReforma: Integer): Boolean;
  end;

implementation

end.