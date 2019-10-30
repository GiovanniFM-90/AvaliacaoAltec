unit UFrmCadastroAltec;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, StrUtils, UCadastroModel, UCadastroService, UEmailService,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UCEPModel,
  UCEPService,
  IniFiles,
  IdComponent,
  IdHTTP,
  IdIOHandler,
  IdIOHandlerStack,
  IdSSL,
  IdSSLOpenSSL,
  System.Generics.Collections, Vcl.ExtCtrls,
  UObjectHelper,UEditHelper;

type
  TfrmCadastroAltec = class(TForm)
    Label1: TLabel;
    edtNome: TEdit;
    edtIdentidade: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtCPF: TEdit;
    gbCadastro: TGroupBox;
    gbContato: TGroupBox;
    Label4: TLabel;
    edtTelefone: TEdit;
    Label5: TLabel;
    edtEmail: TEdit;
    gbEndereco: TGroupBox;
    Label6: TLabel;
    edtCEP: TEdit;
    Label7: TLabel;
    edtLogradouroCEP: TEdit;
    Label8: TLabel;
    edtNumeroCEP: TEdit;
    Label9: TLabel;
    edtComplementoCEP: TEdit;
    Label10: TLabel;
    edtBairroCEP: TEdit;
    Label11: TLabel;
    edtCidadeCEP: TEdit;
    edtUFCEP: TEdit;
    Label12: TLabel;
    edtPaisCEP: TEdit;
    Label13: TLabel;
    btnSalvarCadastro: TButton;
    gbGerenciar: TGroupBox;
    btnNovoCadastro: TButton;
    pnlCadastro: TPanel;
    pnlCadastros: TPanel;
    lstbCadastros: TListBox;
    gbListaCadastros: TGroupBox;
    btnRemoverCadastro: TButton;
    
    procedure edtCEPExit(Sender: TObject);

    procedure btnSalvarCadastroClick(Sender: TObject);
    procedure edtCPFExit(Sender: TObject);
    procedure edtEmailExit(Sender: TObject);
    procedure btnNovoCadastroClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lstbCadastrosClick(Sender: TObject);
    procedure btnRemoverCadastroClick(Sender: TObject);
  private
    FCadastros: TObjectList<TCadastro>;
    FCadastro: TCadastro;
    function validaCPF(cpf:String):Boolean;
    procedure validaCEP(cep: String);
    procedure limparCamposCEP;
    procedure limparFormulario;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCadastroAltec: TfrmCadastroAltec;

implementation

uses
  IdTCPConnection, IdTCPClient, IdBaseComponent,
  IdMessage, IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase,
  IdSMTP,  IdIOHandlerSocket,
  IdAttachmentFile, IdText;

{$R *.dfm}

procedure TfrmCadastroAltec.btnNovoCadastroClick(Sender: TObject);
begin
  limparFormulario;
  

end;

procedure TfrmCadastroAltec.btnRemoverCadastroClick(Sender: TObject);
begin
  if lstbCadastros.ItemIndex <> -1 then
    lstbCadastros.Items.Delete(lstbCadastros.ItemIndex)
  else
    raise Exception.Create('Selecione um cadastro na lista para a remoção. CodErro: 10');
end;

procedure TfrmCadastroAltec.btnSalvarCadastroClick(Sender: TObject);
var
  cadastro: TCadastro;
  cadastroService: TCadastroService;
  bCadastroExiste: Boolean;
  EmailService: TEmailService;
begin
  if edtNome.IsEmpty then
    raise Exception.Create('Informe o Nome do Cadastro. CodErro: 600');
  if edtCPF.IsEmpty then
    raise Exception.Create('Informe o CPF do cadastro. CodErro: 610');

  bCadastroExiste:= False;
  for cadastro in FCadastros do
    if cadastro.cpf = edtCPF.Text then
    begin
      cadastro.isCadastroNovo:= False;
      bCadastroExiste:= True;
      break;
    end;

  if not bCadastroExiste then
    cadastro:= FCadastro;
  cadastro.nome:= edtnome.Text;
  cadastro.identidade:= edtIdentidade.Text;
  cadastro.cpf:= edtcpf.Text;
  cadastro.telefone:= edttelefone.Text;
  cadastro.email:= edtemail.Text;
  if cadastro.endereco <> nil then
  begin
    cadastro.endereco.numero:= edtNumeroCEP.Text;
    cadastro.endereco.complemento:= edtComplementoCEP.Text;
  end;


  cadastroService:= TCadastroService.Create(cadastro);
  try
    cadastroService.enviarEmailCadastro;
  finally
    cadastroService.Free;
  end;


  if not bCadastroExiste then
  begin
    FCadastros.Add(Cadastro);
    FCadastro:= TCadastro.create;
    lstbCadastros.AddItem(cadastro.nome + ' | '+cadastro.cpf, Cadastro);
    limparFormulario;
    lstbCadastros.ItemIndex:= -1;
    
  end;
end;


procedure TfrmCadastroAltec.edtCEPExit(Sender: TObject);
var
  cepService: TCEPService;
  tempCep: TCEP;
begin  
  tempCep:= nil;
  cepService:= nil;
  edtComplementoCEP.Enabled:= false;
  edtNumeroCEP.Enabled:= false;
  limparCamposCEP;
  if not edtCEP.IsEmpty then
  begin
    try

      validaCEP(edtCEP.Text);
      cepService:= TCEPService.create;      
      tempCep:= cepService.getCEP(edtCEP.Text);

      //Infelizmente não tive tempo suficiente para corrigir um problema de referencia e precisei fazer desta forma :(
      FCadastro.endereco:= TCEP.create;
      FCadastro.endereco.cep:= tempCEP.cep;
      FCadastro.endereco.logradouro:= tempCEP.logradouro;
      FCadastro.endereco.bairro:= tempCEP.bairro;
      FCadastro.endereco.localidade:= tempCEP.localidade;
      FCadastro.endereco.uf:= tempCEP.uf;

      edtLogradouroCEP.Text:= FCadastro.endereco.logradouro;
      edtBairroCEP.Text:= FCadastro.endereco.bairro;
      edtCidadeCEP.Text:= FCadastro.endereco.localidade;
      edtUFCEP.Text:= FCadastro.endereco.uf;
      edtPaisCEP.Text:= FCadastro.endereco.pais;
      edtComplementoCEP.Enabled:= True;
      edtNumeroCEP.Enabled:= True;
      edtNumerocep.SetFocus;

    finally
      if not tempCep.isNil then
        freeAndNil(tempCep);
      if not cepService.isNil then      
        cepService.Free;
    end;
  end;
      
end;

procedure TfrmCadastroAltec.edtCPFExit(Sender: TObject);
var
  cadastro: TCadastro;
begin
  if not edtCPF.IsEmpty then
    if not validaCPF(edtCPF.Text)then
      raise Exception.Create('CPF inválido. CodErro: 700');

  for cadastro in FCadastros do
  begin
    if cadastro.cpf = edtCPF.Text then
      if TCadastro(lstbCadastros.Items.Objects[lstbCadastros.ItemIndex]).cpf <> cadastro.cpf then
        raise Exception.Create('Existe um outro cadastro com este CPF, favor informar outro CPF. CodErro: 45');
      
  end;

    
end;

procedure TfrmCadastroAltec.edtEmailExit(Sender: TObject);
begin
  if not edtEmail.IsEmpty then
    if not ContainsStr(edtEmail.Text, '@') then
      raise Exception.Create('E-mail inválido');
    
end;



procedure TfrmCadastroAltec.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FCadastro.Free;
  FCadastros.Free;
end;

procedure TfrmCadastroAltec.FormCreate(Sender: TObject);
var
  lstConfigEmail: TStringList;
begin

  FCadastros:= TObjectList<TCadastro>.Create;
  FCadastro:= TCadastro.create;
end;

procedure TfrmCadastroAltec.limparCamposCEP;
begin
  edtLogradouroCEP.Clear;
  edtBairroCEP.Clear;
  edtCidadeCEP.Clear;
  edtUFCEP.Clear;
  edtPaisCEP.Clear;
end;

procedure TfrmCadastroAltec.limparFormulario;
var
  i: byte;
begin
  for i := 0 to self.ComponentCount - 1 do
    if self.Components[i] is TEdit then
      TEdit(self.Components[i]).Clear;
end;

procedure TfrmCadastroAltec.lstbCadastrosClick(Sender: TObject);
begin
  with TCadastro(lstbCadastros.Items.Objects[lstbCadastros.ItemIndex]) do
  begin
    edtNome.Text:= nome;
    edtIdentidade.Text:= identidade;
    edtCpf.Text:= cpf;
    edtTelefone.Text:= telefone;
    edtEmail.Text:= email;
    if endereco <> nil then
    begin
      edtCEP.Text:= endereco.cep;
      edtLogradouroCEP.Text:= endereco.logradouro;
      edtNumeroCEP.Text:= endereco.numero;
      edtComplementoCEP.Text:= endereco.complemento;
      edtBairroCEP.Text:= endereco.bairro;
      edtCidadeCEP.Text:= endereco.localidade;
      edtUFCEP.Text:= endereco.uf;
      edtPaisCEP.Text:= endereco.pais;
    end;

  end;
end;

procedure TfrmCadastroAltec.validaCEP(cep: String);
begin
  cep := StringReplace(cep, '-', '', [rfReplaceAll]);
  if StrToIntDef(cep, 0) = 0 then
    raise Exception.Create(erroCEP + ' CodErro: 803');
  if cep.Length <> 8 then
    raise Exception.Create(erroCEP + ' CodErro: 804');
end;

function TfrmCadastroAltec.validaCPF(cpf:String):Boolean;
var 
  i:integer;
  Want:char;
  Wvalid:boolean;
  Wdigit1, Wdigit2:integer;
begin
  Wdigit1:=0;
  Wdigit2:=0;
  Want:=cpf[1];//variavel para testar se o cpf é repetido como 111.111.111-11
  Delete(cpf,ansipos('.',cpf),1);  //retira as mascaras se houver
  Delete(cpf,ansipos('.',cpf),1);
  Delete(cpf,ansipos('-',cpf),1);

  //testar se o cpf é repetido como 111.111.111-11
  for i:=1 to length(cpf) do
  begin
    if cpf[i] <> Want then
    begin
      Wvalid:=true;  // se o cpf possui um digito diferente ele passou no primeiro teste
      break
    end;
  end;

  // se o cpf é composto por numeros repetido retorna falso
  if not Wvalid then
  begin
    result:=false;
    exit;
  end;

  //executa o calculo para o primeiro verificador
  for i:=1 to 9 do
  begin
    wdigit1:=Wdigit1+(strtoint(cpf[10-i])*(I+1));
  end;
  Wdigit1:= ((11 - (Wdigit1 mod 11))mod 11) mod 10;
  {formula do primeiro verificador
      soma=1°*2+2°*3+3°*4.. até 9°*10
      digito1 = 11 - soma mod 11
      se digito > 10 digito1 =0
    }

   //verifica se o 1° digito confere
  if IntToStr(Wdigit1) <> cpf[10] then
  begin
    result:=false;
    exit;
  end;


  for i:=1 to 10 do
  begin
    wdigit2:=Wdigit2+(strtoint(cpf[11-i])*(I+1));
  end;
  Wdigit2:= ((11 - (Wdigit2 mod 11))mod 11) mod 10;
   {formula do segundo verificador
      soma=1°*2+2°*3+3°*4.. até 10°*11
      digito1 = 11 - soma mod 11
      se digito > 10 digito1 =0
    }

  // confere o 2° digito verificador
  if IntToStr(Wdigit2) <> cpf[11] then
  begin
    result:=false;
    exit;
  end;

  //se chegar até aqui o cpf é valido
  result:=true;
end;


end.
