unit UCEPService;

interface

uses
  UCEPModel;

type

  TCEPService = Class
  const
    urlCep = 'https://viacep.com.br/ws/';
  public
    /// <summary>
    ///   Realiza uma consulta de CEP no site viacep.com.br.
    /// </summary>
    /// <param name="Cep">
    ///   Refere-se ao objeto com a informa��o do CEP a ser consultado.
    /// </param>
    /// <returns>
    ///   retorna o objeto do tipo TCEP preenchido conforme resultado da consulta do webservice
    /// </returns>
    function getCEP(Cep: String): TCEP; overload;
  end;

implementation

uses
  System.Classes, System.JSON, SysUtils,
  IdHTTP, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL;


{ TCEPServico }


function TCEPService.getCEP(Cep: String): TCEP;
var
   HTTP: TIdHTTP;
   IDSSLHandler : TIdSSLIOHandlerSocketOpenSSL;
   Response: TStringStream;
   LJsonObj: TJSONObject;
   jsonResponse: WideString;
begin
  try
    HTTP := TIdHTTP.Create;
    Response := TStringStream.Create('');
    //Consome o servi�o de CEP, utilizando padr�o JSON como resultado
    HTTP.Get(urlCep + Cep + '/json', Response);
    //Valida se obteve retorno com sucesso, verificando o c�digo do resultado e o conte�do do resultado.
    if (HTTP.ResponseCode = 200) and not(Utf8ToAnsi(Response.DataString) = '{'#$A'  "erro": true'#$A'}') then
    begin
      jsonResponse:= Utf8ToAnsi(Response.DataString);
      result:= TCEP.create(jsonResponse);
    end
    else
      raise Exception.Create('CEP n�o encontrado. CodErro: 900');
  finally
    FreeAndNil(HTTP);
    if Response <> nil then
      Response.Destroy;
  end;

end;

end.
