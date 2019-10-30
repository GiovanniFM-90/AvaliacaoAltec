unit UCadastroService;

interface

uses
  UCadastroModel;

type

  TLinha = record
    Titulo, Valor: WideString;
    constructor Create(Titulo, Valor: WideString);
  end;

  TCadastroService = Class
  private
    FCadastro: TCadastro;
    function saveCadastroToXml: String;
    function CorpoEmail: String;
    function AssuntoEmail: String;
    function MontaTabelaEmail(ConteudoTabela: array of TLinha): String;
  public
    /// <summary>
    ///   Realiza o envio dos dados do cadastro para o e-mail informado em seu registro
    /// </summary>
    procedure enviarEmailCadastro;
    constructor create(cadastro: TCadastro); overload;
  End;


implementation

uses
  UEmailModel, UEmailService, SysUtils,
  XmlIntf, XmlDoc, UObjectHelper, StrUtils;

{ TCadastroService }

function TCadastroService.AssuntoEmail: String;
begin
  if FCadastro.isCadastroNovo then
    result:= FCadastro.nome + ' registrado com sucesso!'
  else
    result:= FCadastro.nome + ' alterado com sucesso!'

end;

function TCadastroService.CorpoEmail: String;
var
  arlinha: array[0..11] of TLinha;
begin

  with fCadastro do
  begin
    arlinha[0]:= TLinha.Create('nome:', nome);
    arlinha[1]:= TLinha.Create('Identidade:', identidade);
    arlinha[2]:=TLinha.Create('Cpf:', cpf);
    arlinha[3]:=TLinha.Create('Telefone:', telefone);
    arlinha[4]:=TLinha.Create('E-mail:', email);
    if not endereco.isNil then
    begin
      arlinha[5]:=TLinha.Create('Logradouro:', endereco.logradouro);
      arlinha[6]:=TLinha.Create('Número:', endereco.numero);
      arlinha[7]:=TLinha.Create('Complemento:', endereco.complemento);
      arlinha[8]:=TLinha.Create('Bairro:', endereco.bairro);
      arlinha[9]:=TLinha.Create('Cidade:', endereco.localidade);
      arlinha[10]:=TLinha.Create('Estado:', endereco.uf);
      arlinha[11]:=TLinha.Create('Pais:', endereco.pais);
    end;
  end;
  result:= MontaTabelaEmail(arlinha);
end;

constructor TCadastroService.create(cadastro: TCadastro);
begin
  FCadastro:= Cadastro;
end;

procedure TCadastroService.enviarEmailCadastro;
var
  email: TEmail;
  emailService: TEMailService;

begin
  email:= nil;
  emailService:= nil;
  try
    try
      email:= TEmail.Create;
      email.pathAnexo:= saveCadastroToXml;
      email.corpo:= CorpoEmail;
      email.assunto:= AssuntoEmail;
      email.destino:= FCadastro.email;
      emailService:= TEmailService.create;
      emailService.Enviar(email);

      DeleteFile(email.pathAnexo);
    except
      on e: Exception do
      begin

      end;

    end;
  finally
    if not email.isNil then
      email.Free;
    if not emailService.isNil then
      emailService.Free;
  end;

end;

function TCadastroService.MontaTabelaEmail(
  ConteudoTabela: array of TLinha): String;
const
  cssTitulo: string = 'background-color: #efefef; color: #333; font-family: ''Segoe UI'', ''Arial'', ''Tahoma'', ''Courier New''; padding: 2px; width: 140px; padding-left: 12px;';
  cssConteudo: string = 'background-color: #fafafa; font-family: ''Segoe UI'', ''Arial'', ''Tahoma'', ''Courier New''; padding: 2px; text-align: left; padding-left: 8px; padding-right: 8px;';
var
  i: integer;
  cssTabela: string;
begin
  try
    cssTabela:= 'border-collapse: collapse;';

    Result:=
      '<div style="clear: both; display: inline-block; width: 100%; margin-top: 6px; margin-bottom: 6px;">' +
        '<table style="' + cssTabela + '">';

    for i:= 0 to Length(ConteudoTabela) - 1 do
      Result:= Result +
          '<tr>' +
            '<td style="' + cssTitulo + '">' + ConteudoTabela[i].Titulo + '</td>' +
            '<td style="' + cssConteudo + '">' + ConteudoTabela[i].Valor + '</td>' +
          '</tr>' ;

    Result:= Result +
        '</table>' +
      '</div>';

  except on e: Exception do
    raise Exception.Create('Erro ao criar tabela HTML do email. MSG: ' + e.Message + ' CodErro: 2019');
  end;

end;

function TCadastroService.saveCadastroToXml: String;
var
  ixml: IXmlDocument;
  fileName: string;
begin
  ixml:= NewXMLDocument;
  ixml.AddChild('cadastro');
  with ixml.DocumentElement, Fcadastro do
  begin
    AddChild('nome').Text:= nome;
    AddChild('identidade').Text:= identidade;
    AddChild('cpf').Text:= cpf;
    AddChild('telefone').Text:= telefone;
    AddChild('email').Text:= email;
    with AddChild('endereco') do
      if not endereco.isNil then
      begin
        AddChild('cep').Text:= Fcadastro.endereco.cep;
        AddChild('logradouro').Text:= endereco.logradouro;
        AddChild('complemento').Text:= endereco.complemento;
        AddChild('numero').Text:= endereco.numero;
        AddChild('cidade').Text:= endereco.localidade;
        AddChild('uf').Text:= endereco.uf;
        AddChild('pais').Text:= endereco.pais;
      end;
  end;
  fileName:=Fcadastro.cpf+'.xml';
  ixml.SaveToFile(fileName);
  result:= ExtractFilePath(ParamStr(0))+fileName;

end;

{ TLinha }

constructor TLinha.Create(Titulo, Valor: WideString);
begin
  Self.Titulo:= Titulo;
  Self.Valor:= Valor;
end;

end.
