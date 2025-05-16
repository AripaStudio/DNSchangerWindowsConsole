module ChangeDNSwindows.MainMenuDNCaripa;

import std.stdio;
import std.process;
import std.string;
import std.format;
import std.conv : to;
import std.array : join, array;
import std.algorithm : map;
import core.stdc.stdio;
import core.sys.windows.windows;
import core.sys.windows.winnt;
import core.sys.windows.shlobj;
import core.sys.windows.winbase;
import DNSManager;
import ConsoleUI;
import NetworkInterface;
import SaveManager;
import GLV;
import RLs;

class CL_mainMenuDNCaripa
{
    void MainMenu()
    {
      
        
    }

    string Chap_help()
    {
        writeln(GLVclass.tGREEN , "please enter your OS for Using this program");
        writeln("this software Sopport of Windows and Linux (I test On Void Linux)" , GLVclass.tRESET);
        string inputUser = readln.strip().toLower();
    }
}
