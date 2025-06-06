module linuxV.DNCaripalinuxmain;

import std.stdio;
import std.string;
import std.conv;
import linuxV.MenuManagerLinux;


class CL_Linux_DNCaripaMainPage
{
    CL_Linux_MenuManager dnsManager;
    this()
    {
        dnsManager = new CL_Linux_MenuManager();
    }

    public void MainMenuLinuxSection()
    {
        dnsManager.MainMenuLinuxSectionManager();
    }
}