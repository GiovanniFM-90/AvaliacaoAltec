unit UCadastroModel;

interface
uses
  UCepModel;

type
  TCadastro = Class
  private
    Fnome: String;
    Fidentidade: String;
    Fcpf: String;
    Ftelefone: String;
    Femail: String;
    Fendereco: TCEP;
    FisCadastroNovo: Boolean;
    function Getendereco: TCEP;
    procedure Setendereco(const Value: TCEP);
  public
    property isCadastroNovo: Boolean read FisCadastroNovo write FisCadastroNovo;
    constructor create;
    destructor destroy; override;
  published
    property nome: String read Fnome write Fnome;
    property identidade: String read Fidentidade write Fidentidade;
    property cpf: String read Fcpf write Fcpf;
    property telefone: String read Ftelefone write Ftelefone;
    property email: String read Femail write Femail;
    property endereco: TCEP read Getendereco write Setendereco;

  End;


implementation

uses
  UObjectHelper;

{ TCadastro }

constructor TCadastro.create;
begin
  FisCadastroNovo:= True;
end;

destructor TCadastro.destroy;
begin
  if not endereco.isNil then
    endereco.Free;
  inherited;
end;

function TCadastro.Getendereco: TCEP;
begin
  result:= Fendereco;
end;

procedure TCadastro.Setendereco(const Value: TCEP);
begin
  Fendereco:= Value;
end;

end.
