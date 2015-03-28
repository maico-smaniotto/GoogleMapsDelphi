object FrmMain: TFrmMain
  Left = 353
  Top = 151
  Caption = 'Google Maps - Obter localiza'#231#227'o'
  ClientHeight = 574
  ClientWidth = 863
  Color = clBtnFace
  Constraints.MinHeight = 500
  Constraints.MinWidth = 879
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 863
    Height = 574
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object PanelHeader: TPanel
      Left = 5
      Top = 376
      Width = 853
      Height = 193
      Align = alBottom
      TabOrder = 0
      DesignSize = (
        853
        193)
      object LabelLatitude: TLabel
        Left = 592
        Top = 16
        Width = 39
        Height = 13
        Caption = 'Latitude'
      end
      object LabelLongitude: TLabel
        Left = 720
        Top = 16
        Width = 47
        Height = 13
        Caption = 'Longitude'
      end
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 33
        Height = 13
        Caption = 'Cidade'
      end
      object Label2: TLabel
        Left = 8
        Top = 40
        Width = 33
        Height = 13
        Caption = 'Estado'
      end
      object Label3: TLabel
        Left = 8
        Top = 64
        Width = 19
        Height = 13
        Caption = 'Rua'
      end
      object Label4: TLabel
        Left = 8
        Top = 88
        Width = 19
        Height = 13
        Caption = 'CEP'
      end
      object btLocaliza: TButton
        Left = 592
        Top = 56
        Width = 106
        Height = 25
        Caption = 'Localizar'
        TabOrder = 9
        OnClick = btLocalizaClick
      end
      object Longitude: TEdit
        Left = 720
        Top = 32
        Width = 121
        Height = 21
        TabOrder = 8
      end
      object Latitude: TEdit
        Left = 592
        Top = 32
        Width = 121
        Height = 21
        TabOrder = 7
      end
      object btLimpa: TButton
        Left = 592
        Top = 88
        Width = 106
        Height = 25
        Caption = 'Limpar marcadores'
        TabOrder = 10
        OnClick = btLimpaClick
      end
      object Lista_Localizacao: TListView
        Left = 312
        Top = 8
        Width = 273
        Height = 179
        Columns = <
          item
            Caption = 'Latitude'
            Width = 120
          end
          item
            Caption = 'Longitude'
            Width = 120
          end>
        ReadOnly = True
        RowSelect = True
        TabOrder = 6
        ViewStyle = vsReport
        OnChange = Lista_LocalizacaoChange
      end
      object LocalizaEndereco: TBitBtn
        Left = 8
        Top = 112
        Width = 129
        Height = 25
        Caption = 'Localizar endere'#231'o'
        TabOrder = 4
        OnClick = LocalizaEnderecoClick
      end
      object CEP: TEdit
        Left = 104
        Top = 80
        Width = 105
        Height = 21
        TabOrder = 3
      end
      object Rua: TEdit
        Left = 104
        Top = 56
        Width = 177
        Height = 21
        TabOrder = 2
      end
      object Estado: TEdit
        Left = 104
        Top = 32
        Width = 177
        Height = 21
        TabOrder = 1
      end
      object Cidade: TEdit
        Left = 104
        Top = 8
        Width = 177
        Height = 21
        TabOrder = 0
      end
      object chkStreetView: TCheckBox
        Left = 8
        Top = 168
        Width = 97
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'StreetView'
        Color = clWindow
        ParentColor = False
        TabOrder = 5
        OnClick = chkStreetViewClick
      end
    end
    object WebBrowser: TWebBrowser
      Left = 5
      Top = 5
      Width = 853
      Height = 371
      Align = alClient
      TabOrder = 1
      OnCommandStateChange = WebBrowserCommandStateChange
      ExplicitHeight = 372
      ControlData = {
        4C00000029580000582600000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
end
