with Ada.Command_Line;
with ALI2Dep;

procedure Main
is
begin
   for Arg in 1 .. Ada.Command_Line.Argument_Count
   loop
      ALI2Dep.Handle_ALI (Ada.Command_Line.Argument (Arg));
   end loop;

end Main;
