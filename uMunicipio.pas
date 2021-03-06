unit uMunicipio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uCadastroBase, Data.DB, Vcl.Buttons,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmMunicipio = class(TfrmCadastroBase)
    edtNome: TLabeledEdit;
    Label2: TLabel;
    cbEstado: TComboBox;
    procedure edtNomeKeyPress(Sender: TObject; var Key: Char);
    procedure cbEstadoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmMunicipio.cbEstadoKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
    BtnSalvar.Click;
end;

procedure TfrmMunicipio.edtNomeKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
    cbEstado.SetFocus;
end;

end.
