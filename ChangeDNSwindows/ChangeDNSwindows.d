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

//Aripa Studio 
//V1.4.0
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








/*
باید متد 
Main 
رو تمیز کنم خیلی کثیفه
:)
*/
	


int main()
{   
     auto dnsManager = new DNSManagerClass();
     auto networkinterface = new NetworkInterfaceClass();
	 auto consoleUI = new ConsoleUIClass();
	 auto saveManager = new SaveManagerClass();
	 auto crls = new CRLs();

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
			if(inputStart == "viewdns")//viewdns
			{
				consoleUI.listDNSPublic();
				consoleUI.waitForEnter();
			}else if(inputStart == "showallc")//showallc
			{
				saveManager.showAllDNS();
			}else if(inputStart == "showdnsinfoc")//showdnsinfoc
			{
				writeln("Enter Name DNS");
				string inputUserNameDNS = readln().strip();
				if(inputUserNameDNS.empty)
				{
					writeln("No DNS found with NameDNS:" , inputUserNameDNS);
				}else
				{
					saveManager.ShowDNS(inputUserNameDNS);
				}				
			}else if(inputStart == "adddnsc")//adddnsc
			{
				writeln("Enter Name DNS (Custom)");
				string inputUserNameDNS = readln().strip();
				writeln("Enter One DNS(Preferred DNS server" );
				string inputUserOneDNS = readln();
				writeln("Enter Two DNS(Alternate DNS Server");
				string inputUserTwoDNS = readln();
				if(inputUserNameDNS.empty && inputUserOneDNS.empty && inputUserTwoDNS.empty)
				{
					writeln("Error: DNS fields cannot be empty!");
				}else
				{
					saveManager.AddData(inputUserNameDNS , inputUserOneDNS , inputUserTwoDNS);
				}
			}else if(inputStart == "changednsc")//changednsc
			{

				writeln("Enter Name DNS");
				string inputUserNameDNS = readln().strip().toLower();
				if(inputUserNameDNS.empty)
				{
					writeln("No DNS found with NameDNS:" , inputUserNameDNS);
				}else
				{
					while(true)
					{
						writeln(GLVclass.tGREEN , "Are you sure this DNS is secure?");
						writeln("for Return , you can type : Return");
						writeln("To continue, type: Yes" , GLVclass.tRESET);
						string certitude = readln().strip().toLower();
						if(certitude == "return")
						{
							break;
						}else if(certitude == "yes")
						{
							auto DNS = saveManager.ReturnDNS(inputUserNameDNS);
							string OneDNS = DNS[0];
							string TwoDNS = DNS[1];
							string inputUserinterfaceName = consoleUI.getUserInput("First, please enter your Interface Name. To find it, you can use (Windows + R = control ncpa.cpl)");			
							if(!networkinterface.isInterfaceActive(inputUserinterfaceName))
							{
								consoleUI.printMessage(" Error : interface " ~ inputUserinterfaceName ~ " Not Connect", "\033[31m");
								break;
							}
							dnsManager.ChangeDNScustom(inputUserinterfaceName , OneDNS , TwoDNS);
							break;

						}else
						{
							writeln("please type (yes) , (return)");
						}
					}
					
				}	



			}else if(inputStart == "deletednsc")
			{
				writeln("Enter name DNS for Delete : ");
				string inputUserDelete =  readln().strip();
				if(inputUserDelete.empty)
				{
					writeln("Error , NameDNS is empty ");
					continue;
				}
				saveManager.DeleteDNSdata(inputUserDelete);


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
			}else if(inputStart == "setting")
			{
				crls.InterFaceSetting();
			}else
			{
				consoleUI.printMessage("Please Enter (exit), (ViewDNS), (ChangeDNS), (deleteDNS), (showMydns) |Custom DNS section| = (showALLc) (showDnsInfoC) , (addDNSC) , (changeDNSC) , (DeleteDNSC) ", "\033[31m");
			}
		}
		
		return 0;
	}


	
   
}
