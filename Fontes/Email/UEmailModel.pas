unit UEmailModel;

interface
uses
  UCadastroModel;

Type
  TEmail = Class
  private
    Fcorpo: String;
    Fassunto: String;
    FpathAnexo: String;
    Fdestino: String;
  public
    property corpo: String read Fcorpo write Fcorpo;
    property assunto: String read Fassunto write Fassunto;
    property pathAnexo: String read FpathAnexo write FpathAnexo;
    property destino: String read Fdestino write Fdestino;
  End;

implementation

end.
