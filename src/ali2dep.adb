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
with Ada.Directories;
with Ada.Direct_IO;
with Ada.Text_IO; use Ada.Text_IO;

with ALI;
with Namet;
with Types;

package body ALI2Dep is

   ---------------
   -- Read_File --
   ---------------

   function Read_File (File_Name : String) return Types.Text_Buffer
   is
      File_Size : Types.Text_Ptr := Types.Text_Ptr (Ada.Directories.Size (File_Name));
      subtype File_String is Types.Text_Buffer (1 .. File_Size);
      package File_String_IO is new Ada.Direct_IO (File_String);

      File     : File_String_IO.File_Type;
      Contents : File_String;
   begin
      File_String_IO.Open (File, File_String_IO.In_File, File_Name);
      File_String_IO.Read (File, Contents);
      File_String_IO.Close (File);
      return Contents;
   end Read_File;

   ----------
   -- Find --
   ----------

   function Find (File : String) return String
   is
      use Ada.Command_Line;
      use Ada.Directories;
   begin
      if File(File'First) = '/'
      then
         return File;
      end if;

      for A in 1 .. Argument_Count - 1
      loop
         declare
            P : constant String := Argument (A) & "/" & File;
         begin
            if Exists (P)
            then
               return P;
            end if;
         end;
      end loop;
      raise File_Not_Found with "File " & File & " not found";
   end Find;

   ----------------
   -- Handle_ALI --
   ----------------

   procedure Handle_ALIs
   is
      use Ada.Command_Line;
      use type Namet.File_Name_Type;
      ALI_Id : ALI.ALI_Id;
      Path   : String := Argument (Argument_Count);
      Name   : Namet.File_Name_Type := Namet.Name_Enter (Path);
      Buffer : aliased Types.Text_Buffer := Read_File (Path);
   begin

      if Path'Length < 5 or Path (Path'Last - 3 .. Path'Last) /= ".ali"
      then
         raise Invalid_ALI_File with "Invalid ALI file name: " & Path;
      end if;

      ALI.Initialize_ALI;
      ALI_Id := ALI.Scan_ALI (F         => Name,
                              T         => Buffer'Unchecked_Access,
                              Ignore_ED => False,
                              Err       => False);

      -- Iterate over all units
      declare
         A : ALI.ALIs_Record := ALI.ALIs.Table (ALI_Id);
         D : ALI.SDep_Record;
         D_File : constant String := Path (Path'First .. Path'Last - 3) & "d";
         Output : File_Type;
      begin
         Create (Output, Out_File, D_File);
         Put_Line (Output, Find (D_File) & ": " & Find (Namet.Get_Name_String (A.Sfile)));
         Put_Line (Output, Find (Namet.Get_Name_String (A.Sfile)) & ": \");
         for Dep in A.First_Sdep .. A.Last_Sdep
         loop
            D := ALI.Sdep.Table (Dep);
            if not D.Dummy_Entry and A.Sfile /= D.Sfile
            then
               declare
                  File : constant String := Namet.Get_Name_String (D.Sfile);
                  Path : constant String := Find (File);
               begin
                  Put_Line (Output, "    " & Path & " \");
               end;
            end if;
         end loop;
         New_Line (Output);
      end;

   end Handle_ALIs;

end ALI2Dep;
