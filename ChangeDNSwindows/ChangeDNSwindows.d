module ChangeDNSwindows;

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
import ChangeDNSwindows.MainMenuDNCaripa;


//Aripa Studio 
//V1.6.1
//khashayar mobasheri(Abolfazl);




//__________________________________________________________________________________________________________________________________

//__________________________________________________________________________________________________________________________________

//__________________________________________________________________________________________________________________________________








//__________________________________________________________________________________________________________________________________

//__________________________________________________________________________________________________________________________________

//__________________________________________________________________________________________________________________________________




	


int main()
{   
	auto mainMenuDNCaripa = new CL_mainMenuDNCaripa();
	try
	{
		mainMenuDNCaripa.MainMenu();
	}catch(Exception ex)
	{
		writeln("Error in show Main Menu : ", ex.msg);
	}
	return 0;
}
