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

//Aripa Studio 
//V1.1.2


private auto interfaceName = "";
private auto dnsCommand = "";
private  string[] selectedDNS = null;	
enum DNSServer
{
	shecan, 
	google,
	cloudflare,
	quad9,
	opendns,
	none
}


//Dns: 
// google :
private string[] DnsGoogle = ["8.8.8.8" , "8.8.4.4"];
//cloudflare : 
private string[] DnsCloudflare = [ "1.1.1.1" , "1.0.0.1" ];
//Opendns : 
private string[] DnsOpenDNS = [ "208.67.222.222" , "208.67.220.220" ];
//Quad9 : 
private string[] DnsQuad9 = [ "9.9.9.9" , "149.112.112.112" ];
//Shecan :
private string[] DnsSHecan = ["178.22.122.100" , "185.51.200.2"];

private DNSServer DNSselected = DNSServer.none;



//ANSI Colors
enum tRESET = "\033[0m";

enum tBRIGHT_BLUE = "\033[94m";

enum tBLACK = "\033[30m";
enum tRED = "\033[31m";
enum tGREEN = "\033[32m";
enum tYELLOW = "\033[33m";
enum tBLUE = "\033[34m";
enum tMAGENTA = "\033[35m";
enum tCYAN = "\033[36m";
enum tWHITE = "\033[37m";


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

string[] executeShellCommand(string command)
{
    auto pipes = pipeShell(command, Redirect.stdout | Redirect.stderr);
    string output = pipes.stdout.byLine.map!(line => line.idup).join("\n");
    string errorOutput = pipes.stderr.byLine.map!(line => line.idup).join("\n");
    int exitCode = pipes.pid.wait();
    return [to!string(exitCode), output, errorOutput];
}

void ShowMyDNS()
{
    if (!isRunningAsAdmin())
    {
        writeln("This operation requires administrative privileges.");
        return;
    }

    auto result = executeShellCommand("powershell -Command \"Get-DnsClientServerAddress | Select-Object -ExpandProperty ServerAddresses\"");
    int exitCode = to!int(result[0]);
    string output = result[1];
    string errorOutput = result[2];
    if (exitCode == 0 && !output.empty)
    {
        writeln("DNS Servers:");
        writeln(output);
    }
    else
    {
        writeln("Error executing command:");
        writeln(errorOutput);
    }
}






//__________________________________________________________________________________________________________________________________

//__________________________________________________________________________________________________________________________________

//__________________________________________________________________________________________________________________________________









void SelectServer()
{

	while(true)
	{
		writeln("please Enter DNS : (shecan , google , cloudflare , quad9 , opendns)");
		string inputUserDNSserver = strip(readln()).toLower();		
		switch(inputUserDNSserver)
		{
			case "shecan":
				DNSselected = DNSServer.shecan;
                break;
            case "google":
                DNSselected = DNSServer.google;
                break;
            case "cloudflare":
                DNSselected = DNSServer.cloudflare;
                break;
            case "quad9":
                DNSselected = DNSServer.quad9;
                break;
            case "opendns":
                DNSselected = DNSServer.opendns;
                break;
            default:
                writeln("please Enter DNS : (shecan , google , cloudflare , quad9 , opendns) ");
                continue;
        }
        break;
		
	}
	
}

void ListDNSpublic()
{
    writeln("Google DNS : " , DnsGoogle  );
    writeln("CloudFlare DNS : " , DnsCloudflare  );
    writeln("OpenDns DNS : " , DnsOpenDNS  );
    writeln("Quad9 DNS : " , DnsQuad9  );
    writeln("Shecan DNS : " , DnsSHecan , "WebSite : " , "https://shecan.ir/");

}

void AddListDns()
{
    //soon
}

void Help()
{
    EnableANSI();
	writeln( tCYAN , "Welcome to our program (Aripa Studio) - (DNS Changer)" , tRESET);    
    writeln(tGREEN ,"Program is running with administrative privileges." , tRESET);
    writeln(tYELLOW , "To see the list of public DNS servers, type this, or if you want to enter your custom DNS, type this: (soon)" , tRESET);
    writeln(tYELLOW ,"For public DNS: ViewDNS" , tRESET);
    writeln(tYELLOW ,"For change DNS: ChangeDNS" , tRESET);
    writeln(tYELLOW ,"To remove the DNS on your system, you can type this: deleteDNS" , tRESET);
    writeln(tYELLOW ,"For exit , you can type this : exit" , tRESET);
    writeln(tYELLOW ,"for Your DNS , you can type this : showMydns" , tRESET);
    
}


void EnableANSI()
{
    HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
    if(hConsole == INVALID_HANDLE_VALUE)
	{
        return;
	}
    DWORD mode = 0;
    if(!GetConsoleMode(hConsole , &mode))
	{
        return;
	}

    mode |= ENABLE_VIRTUAL_TERMINAL_PROCESSING;
    SetConsoleMode(hConsole , mode);

}



void ResetDNSserver(string interfaceNameInput)
{
    auto commandReset = `powershell -Command "Set-DnsClientServerAddress -InterfaceAlias \\"` ~ interfaceNameInput ~ `\\" -ResetServerAddresses"`;    
    auto result = executeShellCommand(commandReset);
    int exitcode = to!int(result[0]);
    string output = result[1];
    string errorOutput = result[2];

    if(exitcode == 0)
	{
        writeln("Ba mofaqeat Anjam shod ");
        writeln("out put : " , output);
	}else
	{
        writeln("Error " , errorOutput);
	}
}

void InputUser()
{
     writeln("Enter interfaceName (Windows + R = control ncpa.cpl )");
     interfaceName = strip(readln());  
	 
	 switch (DNSselected)
	 {
		 case DNSServer.shecan:
            selectedDNS = DnsSHecan;
            break;
		 case DNSServer.google:
            selectedDNS = DnsGoogle;
            break;
		 case DNSServer.cloudflare:
            selectedDNS = DnsCloudflare;
            break;
		 case DNSServer.quad9:
            selectedDNS = DnsQuad9;
            break;
		 case DNSServer.opendns:
            selectedDNS = DnsOpenDNS;
            break;
		 default:
            writeln("Error: Invalid DNS server selected.");
            return;
	 }
	 //setDnsCommand = "netsh interface ip set dns name=" ~ interfaceName ~ " static " ~ selectedDNS[0] ;        
	 //addDnsCommand = "netsh interface ip add dns name=" ~ interfaceName ~ " " ~ selectedDNS[1] ~ " index=2";

      dnsCommand = format(
								`powershell -Command "Set-DnsClientServerAddress -InterfaceAlias '%s' -ServerAddresses ('%s', '%s')"`
                                ,interfaceName , selectedDNS[0] , selectedDNS[1]
								);

    
}



void ChangeDNS(string interFaceName , string DNSCommand )
{

	auto result = executeShellCommand(DNSCommand);
	int exitCode = to!int(result[0]);
	string output = result[1];
	string errorOutput = result[2];
	if(exitCode == 0)
	{
		writeln("DNS servers set successfully for interface: ", interFaceName);
        writeln("Primary DNS: ", selectedDNS[0]);
        writeln("Secondary DNS: ", selectedDNS[1]);
	}else
	{
		writeln("Error setting DNS servers:");
        writeln(errorOutput);
	}

}



int main()
{   
     EnableANSI();
    if (!isRunningAsAdmin())
    {
       
        writeln("\033[31mError: This program must be run with administrative privileges.\033[0m");
        writeln("\033[31mPlease run the program as an administrator and try again.\033[0m");
        readln();
        return 1; 
    }else
	{
		Help();    
		while(true)
		{
			string inputStart = strip(readln()).toLower();
			if(inputStart == "viewdns")
			{
				ListDNSpublic();            
			}else if(inputStart == "changedns")
			{
				writeln("First, please enter your Interface Name. To find it, you can use (Windows + R = control ncpa.cpl)");
				InputUser();
				if(!interfaceName.empty)
				{
					SelectServer();
					if(DNSselected != DNSServer.none)
					{
						ChangeDNS(interfaceName , dnsCommand);    					
                        writeln(tYELLOW, "Press Enter to continue...", tRESET);
                        readln();
					}
				}else
				{
					writeln("Error");				
				}
			}else if(inputStart == "deletedns")
			{
				writeln("First, please enter your Interface Name. To find it, you can use (Windows + R = control ncpa.cpl)");
				InputUser();
				if(!interfaceName.empty)
				{
					ResetDNSserver(interfaceName);                
                    writeln(tYELLOW, "Press Enter to continue...", tRESET);
                    readln();
				}
			}else if(inputStart == "exit")
			{
				break;
			}else if(inputStart == "showmydns")
			{
				ShowMyDNS();
                writeln(tYELLOW, "Press Enter to continue...", tRESET);
                readln();
			}
			else
			{
				writeln("Plase Enter (exit) , (ViewDNS) , (ChangeDNS) , (deleteDNS) , (showMydns)");
			}
		}
		readln();
		return 0;
	}
   
}
