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

   ----------------
   -- Handle_ALI --
   ----------------

   procedure Handle_ALI (Path : String)
   is
      ALI_Id : ALI.ALI_Id;
      Name : Namet.File_Name_Type := Namet.Name_Enter (Path);
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
         D_File : constant String := Path (Path'First .. Path'Last - 3) & "d";
      begin
         Put_Line (D_File & ": " & Namet.Get_Name_String (A.Sfile));
         Put (Namet.Get_Name_String (A.Sfile) & ":");
         for Dep in A.First_Sdep .. A.Last_Sdep
         loop
            declare
               D : ALI.SDep_Record := ALI.Sdep.Table (Dep);
               use type Namet.File_Name_Type;
            begin
               if not D.Dummy_Entry and A.Sfile /= D.Sfile
               then
                  Put (" " & Namet.Get_Name_String (D.Sfile));
               end if;
            end;
         end loop;
         New_Line;
      end;

   end Handle_ALI;

end ALI2Dep;
