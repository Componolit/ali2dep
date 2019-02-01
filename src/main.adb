--
--  @summary ALI to make dependency generator
--  @author  Alexander Senier
--  @date    2019-02-01
--
--  Copyright (C) 2019 Componolit GmbH
--
--  This file is part of ali2dep, which is distributed under the terms of the
--  GNU Affero General Public License version 3.
--

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
