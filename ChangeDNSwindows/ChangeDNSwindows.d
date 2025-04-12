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

//Aripa Studio 
//V1.2.0
//khashayar mobasheri



//__________________________________________________________________________________________________________________________________

//__________________________________________________________________________________________________________________________________

//__________________________________________________________________________________________________________________________________




struct TOKEN_ELEVATION
{
    uint TokenIsElevated; 
}

enum TOKEN_QUERY = 0x0008;

bool isRunningAsAdmin()
{
    BOOL isAdmin = FALSE;
    HANDLE token;

    if (OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, &token))
    {
        TOKEN_ELEVATION elevation;
        DWORD size;
        if (GetTokenInformation(token, TOKEN_INFORMATION_CLASS.TokenElevation, &elevation, cast(DWORD)TOKEN_ELEVATION.sizeof, &size))
        {
            isAdmin = elevation.TokenIsElevated;
        }
        CloseHandle(token);
    }
    return isAdmin != 0;
}





//__________________________________________________________________________________________________________________________________

//__________________________________________________________________________________________________________________________________

//__________________________________________________________________________________________________________________________________











int main()
{   
     auto dnsManager = new DNSManagerClass();
     auto networkinterface = new NetworkInterfaceClass();
	 auto consoleUI = new ConsoleUIClass();

	 consoleUI.enableANSI();

	 consoleUI.showHelp();


    if (!isRunningAsAdmin())
    {
       
        writeln("\033[31mError: This program must be run with administrative privileges.\033[0m");
        writeln("\033[31mPlease run the program as an administrator and try again.\033[0m");
        readln();
        return 1; 
    }else
	{
		 
		while(true)
		{
			string inputStart = strip(readln()).toLower();
			if(inputStart == "viewdns")
			{
				consoleUI.listDNSPublic();
				consoleUI.waitForEnter();
			}else if(inputStart == "changedns")
			{
				string interfaceName = consoleUI.getUserInput("First, please enter your Interface Name. To find it, you can use (Windows + R = control ncpa.cpl)");			

				if(!interfaceName.empty)
				{
					if(!networkinterface.isInterfaceActive(interfaceName))
					{
						consoleUI.printMessage(" Error : interface " ~ interfaceName ~ " Not Connect", "\033[31m");
						continue;
					}

					string dnsName = consoleUI.getUserInput("Please Enter DNS: (shecan, google, cloudflare, quad9, opendns)");
					dnsManager.selectDNS(dnsName);

					if(dnsManager.getSelectedDNSServer() != DNSServer.none)
					{
						dnsManager.changeDNS(interfaceName);

					}else
					{
						consoleUI.printMessage("Error: Invalid DNS server selected.", "\033[31m");

					}


				}else
				{
					consoleUI.printMessage("Error: Interface name cannot be empty.", "\033[31m");			
				}
			}else if(inputStart == "deletedns")
			{
				string interfaceName = consoleUI.getUserInput("First, please enter your Interface Name. To find it, you can use (Windows + R = control ncpa.cpl)");				

				if(!interfaceName.empty)
				{
					if(!networkinterface.isInterfaceActive(interfaceName))
					{
						consoleUI.printMessage(" Error : interface " ~ interfaceName ~ " Not Connect", "\033[31m");
						continue;
					}

					dnsManager.resetDNS(interfaceName);
					consoleUI.waitForEnter();


				}else
				{
					consoleUI.printMessage("Error: Interface name cannot be empty.", "\033[31m");
				}
			}else if(inputStart == "exit")
			{
				break;
			}else if(inputStart == "showmydns")
			{
				dnsManager.showDNS();
				consoleUI.waitForEnter();
			}
			else
			{
				consoleUI.printMessage("Please Enter (exit), (ViewDNS), (ChangeDNS), (deleteDNS), (showMydns)", "\033[31m");
			}
		}
		
		return 0;
	}
   
}
