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
with Ada.Text_IO;
with ALI2Dep;

procedure Main
is
begin
   if Ada.Command_Line.Argument_Count = 0
   then
      Ada.Text_IO.Put_Line ("ali2dep (version " & ALI2Dep.Version & ")");
      Ada.Command_Line.Set_Exit_Status (1);
      return;
   end if;

   ALI2Dep.Handle_ALIs;
end Main;
