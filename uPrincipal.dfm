object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Tela Principal'
  ClientHeight = 492
  ClientWidth = 687
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  Visible = True
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 232
    Top = 48
    object Cadastros1: TMenuItem
      Caption = 'Cadastros'
      object Estados1: TMenuItem
        Action = actEstados
      end
      object Municipios1: TMenuItem
        Action = actMunicipio
      end
      object Bairros1: TMenuItem
        Action = actBairro
      end
      object Usuarios1: TMenuItem
        Action = actUsuario
      end
      object Clientes1: TMenuItem
        Action = actCliente
      end
      object Ambientes1: TMenuItem
        Action = actAmbiente
      end
      object Produtos1: TMenuItem
        Action = actProduto
      end
      object Reformas1: TMenuItem
        Action = actReforma
      end
    end
    object Sobre1: TMenuItem
      Caption = 'Sobre'
    end
  end
  object ActionList1: TActionList
    Left = 232
    Top = 112
    object actEstados: TAction
      Caption = 'Estados'
      OnExecute = actEstadosExecute
    end
    object actMunicipio: TAction
      Caption = 'Municipios'
      OnExecute = actMunicipioExecute
    end
    object actBairro: TAction
      Caption = 'Bairros'
      OnExecute = actBairroExecute
    end
    object actUsuario: TAction
      Caption = 'Usuarios'
      OnExecute = actUsuarioExecute
    end
    object actCliente: TAction
      Caption = 'Clientes'
      OnExecute = actClienteExecute
    end
    object actAmbiente: TAction
      Caption = 'Ambientes'
      OnExecute = actAmbienteExecute
    end
    object actProduto: TAction
      Caption = 'Produtos'
    end
    object actReforma: TAction
      Caption = 'Reformas'
      OnExecute = actReformaExecute
    end
  end
end
