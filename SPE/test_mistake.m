try
    t123
catch me
    disp('error')
   disp( me.identifier )
   disp( me.message )
%    disp( me.cause ); hz?
   disp( me.stack.file )
   disp( me.stack.name )
   disp( me.stack.line )
end