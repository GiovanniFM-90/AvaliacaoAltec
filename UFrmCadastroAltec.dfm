object frmCadastroAltec: TfrmCadastroAltec
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Cadastro Altec'
  ClientHeight = 389
  ClientWidth = 873
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlCadastro: TPanel
    Left = 185
    Top = 0
    Width = 688
    Height = 389
    Align = alClient
    TabOrder = 0
    object gbCadastro: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 680
      Height = 61
      Align = alTop
      Caption = 'Cadastro'
      TabOrder = 0
      object Label1: TLabel
        Left = 16
        Top = 28
        Width = 37
        Height = 13
        Caption = 'Nome*:'
      end
      object Label2: TLabel
        Left = 200
        Top = 28
        Width = 56
        Height = 13
        Caption = 'Identidade:'
      end
      object Label3: TLabel
        Left = 400
        Top = 28
        Width = 29
        Height = 13
        Caption = 'CPF*:'
      end
      object edtCPF: TEdit
        Left = 429
        Top = 25
        Width = 121
        Height = 21
        MaxLength = 11
        NumbersOnly = True
        TabOrder = 2
        OnExit = edtCPFExit
      end
      object edtIdentidade: TEdit
        Left = 262
        Top = 25
        Width = 121
        Height = 21
        TabOrder = 1
      end
      object edtNome: TEdit
        Left = 53
        Top = 25
        Width = 121
        Height = 21
        TabOrder = 0
      end
    end
    object gbContato: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 71
      Width = 680
      Height = 58
      Align = alTop
      Caption = 'Contato'
      TabOrder = 1
      object Label4: TLabel
        Left = 11
        Top = 23
        Width = 49
        Height = 13
        Caption = 'Telefone: '
      end
      object Label5: TLabel
        Left = 195
        Top = 23
        Width = 34
        Height = 13
        Caption = 'Email*:'
      end
      object edtTelefone: TEdit
        Left = 66
        Top = 20
        Width = 103
        Height = 21
        NumbersOnly = True
        TabOrder = 0
      end
      object edtEmail: TEdit
        Left = 229
        Top = 20
        Width = 121
        Height = 21
        TabOrder = 1
        OnExit = edtEmailExit
      end
    end
    object gbEndereco: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 135
      Width = 680
      Height = 151
      Align = alTop
      Caption = 'Endere'#231'o'
      TabOrder = 2
      object Label6: TLabel
        Left = 11
        Top = 24
        Width = 19
        Height = 13
        Caption = 'CEP'
      end
      object Label7: TLabel
        Left = 16
        Top = 56
        Width = 59
        Height = 13
        Caption = 'Logradouro:'
      end
      object Label8: TLabel
        Left = 18
        Top = 84
        Width = 41
        Height = 13
        Caption = 'N'#250'mero:'
      end
      object Label9: TLabel
        Left = 194
        Top = 84
        Width = 69
        Height = 13
        Caption = 'Complemento:'
      end
      object Label10: TLabel
        Left = 16
        Top = 123
        Width = 32
        Height = 13
        Caption = 'Bairro:'
      end
      object Label11: TLabel
        Left = 219
        Top = 120
        Width = 37
        Height = 13
        Caption = 'Cidade:'
      end
      object Label12: TLabel
        Left = 411
        Top = 120
        Width = 17
        Height = 13
        Caption = 'UF:'
      end
      object Label13: TLabel
        Left = 499
        Top = 120
        Width = 23
        Height = 13
        Caption = 'Pais:'
      end
      object edtCEP: TEdit
        Left = 36
        Top = 23
        Width = 121
        Height = 21
        MaxLength = 8
        NumbersOnly = True
        TabOrder = 0
        OnExit = edtCEPExit
      end
      object edtLogradouroCEP: TEdit
        Left = 81
        Top = 50
        Width = 576
        Height = 21
        Enabled = False
        TabOrder = 1
      end
      object edtNumeroCEP: TEdit
        Left = 65
        Top = 81
        Width = 121
        Height = 21
        Enabled = False
        TabOrder = 2
      end
      object edtComplementoCEP: TEdit
        Left = 269
        Top = 81
        Width = 164
        Height = 21
        Enabled = False
        TabOrder = 3
      end
      object edtBairroCEP: TEdit
        Left = 54
        Top = 120
        Width = 159
        Height = 21
        Enabled = False
        TabOrder = 4
      end
      object edtCidadeCEP: TEdit
        Left = 262
        Top = 117
        Width = 143
        Height = 21
        Enabled = False
        TabOrder = 5
      end
      object edtUFCEP: TEdit
        Left = 434
        Top = 117
        Width = 51
        Height = 21
        Enabled = False
        TabOrder = 6
      end
      object edtPaisCEP: TEdit
        Left = 528
        Top = 117
        Width = 51
        Height = 21
        Enabled = False
        TabOrder = 7
      end
    end
    object gbGerenciar: TGroupBox
      AlignWithMargins = True
      Left = 4
      Top = 292
      Width = 680
      Height = 79
      Align = alTop
      TabOrder = 3
      object btnSalvarCadastro: TButton
        Left = 133
        Top = 23
        Width = 148
        Height = 26
        Caption = 'Salvar Cadastro'
        TabOrder = 0
        OnClick = btnSalvarCadastroClick
      end
      object btnNovoCadastro: TButton
        Left = 25
        Top = 24
        Width = 102
        Height = 25
        Caption = 'Novo Cadastro'
        TabOrder = 1
        OnClick = btnNovoCadastroClick
      end
      object btnRemoverCadastro: TButton
        Left = 287
        Top = 24
        Width = 125
        Height = 25
        Caption = 'Remover Cadastro'
        TabOrder = 2
        OnClick = btnRemoverCadastroClick
      end
    end
  end
  object pnlCadastros: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 389
    Align = alLeft
    Caption = 'pnlCadastros'
    TabOrder = 1
    object gbListaCadastros: TGroupBox
      Left = 1
      Top = 1
      Width = 183
      Height = 387
      Align = alClient
      Caption = 'Lista de Cadastros'
      TabOrder = 0
      object lstbCadastros: TListBox
        AlignWithMargins = True
        Left = 5
        Top = 18
        Width = 173
        Height = 364
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnClick = lstbCadastrosClick
      end
    end
  end
end
