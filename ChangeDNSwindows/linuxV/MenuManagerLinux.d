module linuxV.MenuManagerLinux;

import std.stdio;
import std.string;
import std.conv;
import GLV;

class CL_Linux_MenuManager
{

    public void MainMenuLinuxSection()
    {
        helpLinuxSection();
        while(true)
        {
            string inputUser = readln().strip().toLower();
            if(inputUser == "changedns" || inputUser == "cngd")
            {

            }else if(inputUser == "showmydns" || inputUser == "view")
            {

            }else if(inputUser == "deletemydns" || inputUser == "del")
            {

            }else if(inputUser == "help")
            {
               helpLinuxSection(); 
            }else
            {
                writeln("please enter (changedns)or(cngd) & (showmydns)or(view) & (deletemydns)or(del)");
                writeln("for help : help");
            }
        }
    }

    public void helpLinuxSection()
    {
        writeln(GLVClass.tGREEN , "welcome to Linux Section" , GLVClass.tRESET);
        writeln("");
        writeln("Commnads : ");
        writeln("changeDNS : for change dns");
        writeln("ShowMyDNS : for view your current dns");
        writeln("DeleteMyDNS : for delete your current dns");
        writeln("");
        writeln("short commands : ");
        writeln("cngd : for change your dns ");
        writeln("view : for view your current dns ");
        writeln("del : for delte your current dns ");

        
    }
}
