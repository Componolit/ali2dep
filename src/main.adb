with ALI;
with Namet;
with Types;
with Ada.Command_Line;

procedure Main
is
   ALI_Id : ALI.ALI_Id;
   Name : Namet.File_Name_Type := Namet.Name_Enter ("test.ali");
   Buffer : aliased Types.Text_Buffer := "Foobar";
begin
   ALI.Initialize_ALI;


   ALI_Id := ALI.Scan_ALI (F => Name,
                           T => Buffer'Unchecked_Access,
                           Ignore_ED => False,
                           Err       => False);
end Main;
