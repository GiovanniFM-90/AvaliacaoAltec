unit UObjectHelper;

interface

type

  TObjectHelper = class helper for TObject
    /// <summary>
    ///   Verifica se um objeto está nulo
    /// </summary>
    /// <returns>
    ///   Retorna True caso o object esteja nulo.
    /// </returns>
    function isNil: Boolean;
  end;

implementation

{ TObjectHelper }

function TObjectHelper.isNil: Boolean;
begin
  result:= Self = nil;
end;

end.
