unit UEmailService;

interface

uses
  UEmailModel,
  IniFiles,
  IdComponent,
  IdHTTP,
  IdIOHandler,
  IdIOHandlerStack,
  IdSSL,
  IdSSLOpenSSL, System.Classes, System.Generics.Collections,
  System.SysUtils,
  UObjectHelper;

type

  TInfoIni = Class
  private
    FConfigINI : TIniFile;
    FSecoes: TDictionary<String, String>;
    function GetCampos(SecaoChave: string): Variant;
    procedure SetCampos(SecaoChave: string; const Value: Variant);
  public
    function chave(secao, nome: string): string;
    constructor Create;
    destructor destroy; override;
  End;

  TSingleton<T: class, constructor> = class
  strict private
    class var FInstance : T;
  public
    class function GetInstance(): T;
    class procedure ReleaseInstance();
  end;

  //Criado o singleton para não precisar ficar carregando as informações do INI a todo momento.
  TInfoIniSingleton = TSingleton<TInfoIni>;

  TEmailService = Class
  private
    FIniFile: TIniFile;
    FFromName: String;
    FFrom: String;
    FBccList: String;
    FHost: String;
    FPort: Integer;
    FUserName: String;
    FPassword: String;
    procedure configuraEmail;
    procedure carregarConfiguracaoEmail;
  public
    function EnviarEmail(const assunto, destino, anexo: String; corpo: TStrings): Boolean;
    /// <summary>
    ///   Realiza o envio do e-mail.
    /// </summary>
    /// <param name="email">
    ///   Refere-se ao objeto com as informações para o envio do e-mail.
    /// </param>
    /// <returns>
    ///   O retorno é True caso o envio seja realizado com sucesso.
    /// </returns>
    procedure enviar(email: TEmail);
    constructor create; overload;
  End;

const
  ConfigEmail = 'ConfigEmail.ini';

implementation

uses
  IdTCPConnection, IdTCPClient, IdBaseComponent,
  IdMessage, IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase,
  IdSMTP,  IdIOHandlerSocket,
   IdAttachmentFile, IdText;

{ TEmailService }

procedure TEmailService.carregarConfiguracaoEmail;
var
  ConfigIni: TInfoIni;
begin
  configIni:= TInfoIniSingleton.GetInstance;
  FFromName:= configIni.chave('Email' , 'FromName');
  FFrom:= configIni.chave('Email' , 'From');
  FHost:= configIni.chave('Email' , 'Host');
  FPort:= StrToIntDef(configIni.chave('Email', 'Port'), 465);
  FUserName:= configIni.chave('Email' , 'UserName');
  FPassword:= configIni.chave('Email' , 'Password');
end;

procedure TEmailService.configuraEmail;
var
  lstConfigEmail: TStringList;
begin
  //Irá criar um arquivo de configuração caso o ainda não exista um
  if not FileExists(ExtractFilePath(ParamStr(0))+ConfigEmail) then
  begin
    try
      lstConfigEmail:= TStringList.Create;
      lstConfigEmail.Add('[Email]');
      lstConfigEmail.Add('FromName=Teste - Giovanni Machado');
      lstConfigEmail.Add('From=galtec465@gmail.com');
      lstConfigEmail.Add('Host=smtp.gmail.com');
      lstConfigEmail.Add('Port=465');
      lstConfigEmail.Add('Username=galtec465@gmail.com');
      lstConfigEmail.Add('Password=galtec2810!');
      //Salva o arquivo no mesmo diretório do executável
      lstConfigEmail.SaveToFile(ExtractFilePath(ParamStr(0))+ConfigEmail);
    finally
      lstConfigEmail.Free;
    end;
  end;
end;

constructor TEmailService.create;
begin
  configuraEmail;
  carregarConfiguracaoEmail;
end;

procedure TEmailService.enviar(email: TEmail);
var
  idMsg: TIdMessage;
  IdText: TIdText;
  idSMTP: TIdSMTP;
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    try
      //Carrega a SSL
      IdSSLIOHandlerSocket:= TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
      IdSSLIOHandlerSocket.SSLOptions.Mode  := sslmClient;

    except
      on e: Exception do
      begin
        raise Exception.Create('Falha ao carregar SSL. Msg: '+ e.Message + ' CodErro: 40');
      end;
    end;
    //Variável referente a mensagem
    idMsg:= TIdMessage.Create(nil);
    idMsg.CharSet:= 'utf-8';
    idMsg.Encoding:= meMIME;
    idMsg.From.Name:= FFromName;
    idMsg.From.Address:= FFrom;
    idMsg.Priority:= mpNormal;
    idMsg.Subject:= email.assunto;

    //Add Destinatário(s)
    idMsg.Recipients.Add;
    idMsg.Recipients.EMailAddresses:= email.destino;

    //Variável do texto
    idText:= TIdText.Create(idMsg.MessageParts);
    idText.Body.Add(email.corpo);
    idText.ContentType := 'text/html; text/plain; charset=iso-8859-1';

    //Prepara o Servidor
    IdSMTP:= TIdSMTP.Create(nil);
    IdSMTP.IOHandler:= IdSSLIOHandlerSocket;
    IdSMTP.UseTLS:= utUseImplicitTLS;
    IdSMTP.AuthType:= satDefault;
    IdSMTP.Host:= FHost;
    IdSMTP.AuthType:= satDefault;
    IdSMTP.Port:= FPort;
    IdSMTP.Username:= FUserName;
    IdSMTP.Password:= FPassword;

    //Conecta e Autentica
    IdSMTP.Connect;
    IdSMTP.Authenticate;

    if not email.pathAnexo.IsEmpty then
      if FileExists(email.pathAnexo) then
        TIdAttachmentFile.Create(idMsg.MessageParts, email.pathAnexo);

    //Se a conexão foi bem sucedida, envia a mensagem
    if IdSMTP.Connected then
    begin
      try
        IdSMTP.Send(idMsg);
      except on E:Exception do
        begin
          raise Exception.Create('Erro ao tentar enviar: ' + E.Message+ ' CodErro: 50');
        end;
      end;
    end;

    //desconecta do servidor SMTP
    if IdSMTP.Connected then
      IdSMTP.Disconnect;

  finally
    UnLoadOpenSSLLibrary;
    if not idMsg.isnil then
      FreeAndNil(idMsg);
    if not IdSSLIOHandlerSocket.isNil then
      FreeAndNil(IdSSLIOHandlerSocket);
    if not idSMTP.isNil then
      FreeAndNil(idSMTP);
  end;

end;

function TEmailService.EnviarEmail(const assunto, destino, anexo: String; corpo: TStrings): Boolean;
var
  idMsg                : TIdMessage;
  IdText               : TIdText;
  idSMTP               : TIdSMTP;
  IdSSLIOHandlerSocket : TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    try
      //Criação e leitura do arquivo INI com as configurações
//      IniFile:= TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'ConfigEmail.ini');
//      sFrom:= IniFile.ReadString('Email' , 'From'     , sFrom);
//      sHost:= IniFile.ReadString('Email' , 'Host'     , sHost);
//      iPort:= IniFile.ReadInteger('Email', 'Port'     , iPort);
//      sUserName:= IniFile.ReadString('Email' , 'UserName' , sUserName);
//      sPassword:= IniFile.ReadString('Email' , 'Password' , sPassword);

      //Configura os parâmetros necessários para SSL
      IdSSLIOHandlerSocket                   := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
      IdSSLIOHandlerSocket.SSLOptions.Mode  := sslmClient;

      //Variável referente a mensagem
      idMsg:= TIdMessage.Create(nil);
      idMsg.CharSet:= 'utf-8';
      idMsg.Encoding:= meMIME;
      idMsg.From.Name:= 'Giovanni Machado';
      idMsg.From.Address:= FFrom;
      idMsg.Priority:= mpNormal;
      idMsg.Subject:= assunto;

      //Add Destinatário(s)
      idMsg.Recipients.Add;
      idMsg.Recipients.EMailAddresses:= destino;

      //Variável do texto
      idText:= TIdText.Create(idMsg.MessageParts);
      idText.Body.Add(corpo.Text);
      idText.ContentType := 'text/html; text/plain; charset=iso-8859-1';

      //Prepara o Servidor
      IdSMTP:= TIdSMTP.Create(nil);
      IdSMTP.IOHandler:= IdSSLIOHandlerSocket;
      IdSMTP.UseTLS:= utUseImplicitTLS;
      IdSMTP.AuthType:= satDefault;
      IdSMTP.Host:= FHost;
      IdSMTP.AuthType:= satDefault;
      IdSMTP.Port:= FPort;
      IdSMTP.Username:= FUserName;
      IdSMTP.Password:= FPassword;

      //Conecta e Autentica
      IdSMTP.Connect;
      IdSMTP.Authenticate;

      if anexo <> EmptyStr then
        if FileExists(anexo) then
          TIdAttachmentFile.Create(idMsg.MessageParts, anexo);

      //Se a conexão foi bem sucedida, envia a mensagem
      if IdSMTP.Connected then
      begin
        try
          IdSMTP.Send(idMsg);
        except on E:Exception do
          begin
            raise Exception.Create('Erro ao tentar enviar: ' + E.Message+ ' CodErro: 50');
          end;
        end;
      end;

      //desconecta do servidor SMTP
      if IdSMTP.Connected then
        IdSMTP.Disconnect;

      Result := True;
    finally
      UnLoadOpenSSLLibrary;

      FreeAndNil(idMsg);
      FreeAndNil(IdSSLIOHandlerSocket);
      FreeAndNil(idSMTP);
    end;
  except on e:Exception do
    begin
      Result := False;
    end;
  end;

end;

{ TInfoIni }

function TInfoIni.chave(secao, nome: string): string;
var
  ini: TIniFile;
begin
  //Se a Secao+Chave não estiver no Dictionary então devemos buscar no INI
  if not FSecoes.ContainsKey(Secao+Nome) then
  begin
    if (not FConfigINI.SectionExists(secao)) or
       (not FConfigINI.ValueExists(secao, nome)) then
      raise Exception.Create(format('Chave %s não encontrada na seção %s', [nome, secao]));
    result:= FConfigINI.ReadString(secao, nome, '');
    SetCampos(secao+nome, result);
  end
  else
  begin
    result:= GetCampos(Secao+Nome);
  end;

end;

constructor TInfoIni.Create;
begin
  if not FileExists(ConfigEmail) then
    raise Exception.Create('O caminho do arquivo de configuração não existe. Path: '+ConfigEmail);

  FConfigINI:= TIniFile.Create(ExtractFilePath(ParamStr(0))+ ConfigEmail );

  FSecoes:= TDictionary<String, String>.Create;
end;

destructor TInfoIni.destroy;
begin
  FConfigINI.Free;
  FSecoes.Free;
  inherited;
end;

function TInfoIni.GetCampos(SecaoChave: string): Variant;
begin
  Result:= FSecoes[SecaoChave];
end;

procedure TInfoIni.SetCampos(SecaoChave: string; const Value: Variant);
begin
  SecaoChave:= SecaoChave;
  if FSecoes.ContainsKey(SecaoChave) then
    FSecoes[SecaoChave]:= Value
  else
    FSecoes.Add(SecaoChave, Value);
end;

{ TSingleton<T> }

class function TSingleton<T>.GetInstance: T;
begin
  if not Assigned(Self.FInstance) then
    Self.FInstance := T.Create();
  Result := Self.FInstance;
end;

class procedure TSingleton<T>.ReleaseInstance;
begin
  if Assigned(Self.FInstance) then
    Self.FInstance.Free;
end;

initialization
finalization
  TInfoIniSingleton.ReleaseInstance();

end.
