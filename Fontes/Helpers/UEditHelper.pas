unit UEditHelper;

interface
uses
  Vcl.StdCtrls, SysUtils;
type

  TEditHelper = class helper for TEdit
    /// <summary>
    /// Verifica se a propriedade Text está vazia.
    /// </summary>
    /// <returns>
    ///   Retorna True caso a propriedade Text esteja vazia.
    /// </returns>
    function IsEmpty: boolean;
  end;

implementation

{ TEditHelper }

function TEditHelper.IsEmpty: boolean;
begin
  result := Trim(Self.Text) = '';
end;

end.
