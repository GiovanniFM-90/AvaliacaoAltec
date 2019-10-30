unit UCEPModel;

interface


type

  TCEP = Class
  private

    Fcep: String;
    Flogradouro: string;
    Fcomplemento: string;
    Fbairro: string;
    Flocalidade: string;
    Fuf: String;
    Fpais: String;
    Fnumero: String;
    procedure SetCep(Value: String);
  public
    class function create(cepJson: WideString): TCEP; overload;
    constructor create; overload;
  published

    property cep: String read FCep write SetCep;
    property logradouro: string read Flogradouro write Flogradouro;
    property complemento: string read Fcomplemento write Fcomplemento;
    property numero: String read Fnumero write Fnumero;
    property bairro: string read Fbairro write Fbairro;

    property localidade: string read Flocalidade write Flocalidade;
    property uf: String read Fuf write Fuf;
    property pais: String read Fpais write Fpais;
  End;

const
  erroCEP = 'Necessário informar 8 números para o CEP.';
  ConstPais = 'Brasil';
implementation

uses
  StrUtils, SysUtils, Rest.Json, XmlIntf, XmlDoc;

{ TCEP }

class function TCEP.create(cepJson: WideString): TCEP;
begin
  result := TJson.JsonToObject<TCEP>(cepJson);
  result.cep := result.cep;//Força o SetCEP
  result.pais:= ConstPais;
end;

constructor TCEP.create;
begin
  self.pais:= ConstPais;
end;

procedure TCEP.SetCep(Value: String);
begin
  Value := StringReplace(Value, '-', '', [rfReplaceAll]);
  FCep:= Value;

end;


end.
