inherited frmBairro: TfrmBairro
  Caption = 'frmBairro'
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel2: TPanel
    ExplicitTop = 56
    inherited PageControl1: TPageControl
      inherited tsTabela: TTabSheet
        ExplicitLeft = 4
        ExplicitTop = 24
        ExplicitWidth = 746
        ExplicitHeight = 239
        inherited DBGrid1: TDBGrid
          Columns = <
            item
              Expanded = False
              FieldName = 'idBairro'
              Title.Caption = 'C'#243'digo'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'nome'
              Title.Caption = 'Nome'
              Width = 307
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'nomeMunicipio'
              Title.Caption = 'Municipio'
              Width = 331
              Visible = True
            end>
        end
      end
      inherited tsDados: TTabSheet
        ExplicitLeft = 4
        ExplicitTop = 24
        ExplicitWidth = 746
        ExplicitHeight = 239
        object Label2: TLabel
          Left = 203
          Top = 103
          Width = 43
          Height = 13
          Caption = 'Municipio'
        end
        object edtNome: TLabeledEdit
          Left = 203
          Top = 68
          Width = 329
          Height = 27
          EditLabel.Width = 27
          EditLabel.Height = 13
          EditLabel.Caption = 'Nome'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnKeyPress = edtNomeKeyPress
        end
        object cbMunicipio: TComboBox
          Left = 203
          Top = 122
          Width = 329
          Height = 27
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnKeyPress = cbMunicipioKeyPress
        end
      end
    end
  end
end
