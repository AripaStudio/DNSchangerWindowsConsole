module linuxV.MenuManagerLinux;

import std.stdio;
import std.string;
import std.conv;
import GLV;

public class CL_Linux_MenuManager
{

    public void MainMenuLinuxSectionManager()
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
            }else if(inputUser == "exit")
            {
               break;
            }else
            {
                writeln("please enter (changedns)or(cngd) & (showmydns)or(view) & (deletemydns)or(del)");
                writeln("for help : help and for exit : exit");
            }
        }
    }

    public void helpLinuxSectionManager()
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
        writeln("for Help : help");

        
    }
}
