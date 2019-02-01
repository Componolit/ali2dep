with Ada.Command_Line;
with Ada.Directories;
with Ada.Direct_IO;

with ALI;
with Namet;
with Types;

procedure Main
is
   ALI_Id : ALI.ALI_Id;
   Name : Namet.File_Name_Type := Namet.Name_Enter ("test.ali");

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

begin
   ALI.Initialize_ALI;

   for Arg in 1 .. Ada.Command_Line.Argument_Count
   loop
      declare
         Buffer : aliased Types.Text_Buffer := Read_File (Ada.Command_Line.Argument (Arg));
      begin
         ALI_Id := ALI.Scan_ALI (F         => Name,
                                 T         => Buffer'Unchecked_Access,
                                 Ignore_ED => False,
                                 Err       => False);
      end;
   end loop;

end Main;
