module ChangeDNSwindows;

import std.stdio;
import std.process;
import std.string;
import std.format;

private auto interfaceName = "";
private auto setDnsCommand = "";
private auto addDnsCommand = "";

//Dns: 
// google :
private string[] DnsGoogle = ["8.8.8.8" , "8.8.4.4"];
private string[] DnsCloudflare = [ "1.1.1.1" , "1.0.0.1" ];
private string[] DnsOpenDNS = [ "208.67.222.222" , "208.67.220.220" ];
private string[] DnsQuad9 = [ "9.9.9.9" , "149.112.112.112" ];

int main()
{   
    Help();
    
    while(true)
	{
        string inputStart = strip(readln());
		if(inputStart == "ViewDNS")
		{
            ListDNSpublic();
            break;
		}else if(inputStart == "addDNS")
		{
            writeln("First, please enter your Interface Name. To find it, you can use (Windows + R = control ncpa.cpl)");
            InputUser();
            if(!interfaceName.empty)
			{
				ChangeDNS(interfaceName , setDnsCommand , addDnsCommand);    
                break;
			}
		}else if(inputStart == "deleteDNS")
		{
            writeln("First, please enter your Interface Name. To find it, you can use (Windows + R = control ncpa.cpl)");
            InputUser();
            if(!interfaceName.empty)
			{
                ResetDNSserver(interfaceName);
                break;
			}
		}else if(inputStart == "exit")
		{
            break;
		}else
		{
            writeln("Plase Enter (exit) , (ViewDNS) , (addDNS) , (deleteDNS)");
		}
	}
    readln();
    return 0;
}

void ListDNSpublic()
{
    writeln("Google DNS : " , DnsGoogle  );
    writeln("CloudFlare DNS : " , DnsCloudflare  );
    writeln("OpenDns DNS : " , DnsOpenDNS  );
    writeln("Quad9 DNS : " , DnsQuad9  );

}

void AddListDns()
{
    
}

void Help()
{
	writeln("Welcome to our program (Aripa Studio) - (DNS Changer)");    
    writeln("To see the list of public DNS servers, type this, or if you want to enter your custom DNS, type this:");
    writeln("For public DNS: ViewDNS");
    writeln("For custom DNS: addDNS");
    writeln("To remove the DNS on your system, you can type this: deleteDNS");
    writeln("For exit , you can type this : exit");
    
}



void ResetDNSserver(string interfaceNameInput)
{
    
    auto CommandReset = "netsh interface ip set dns name=\"" ~ interfaceNameInput ~ "\" source=dhcp";
    auto result = executeShell(CommandReset);
    int ResultCmd = result[0];
    if(ResultCmd == 0)
	{
        writeln("Ba mofaqeat Anjam shod ");
	}
}

void InputUser()
{
     writeln("Enter interfaceName (Windows + R = control ncpa.cpl )");
     interfaceName = strip(readln());     
     setDnsCommand = "netsh interface ip set dns name=" ~ interfaceName ~ " static " ~ DnsGoogle[0] ;        
	 addDnsCommand = "netsh interface ip add dns name=" ~ interfaceName ~ " " ~ DnsGoogle[1] ~ " index=2";
    
}



void ChangeDNS(string interFaceName , string setDnsCommand , string addDnsCommand)
{
    auto result = executeShell(setDnsCommand);
    int exitCodeSet = result[0];
    if(exitCodeSet == 0)
	{	
        writeln("Ba mofaqaeat Set shod");
        auto resultDnsTwo = executeShell(addDnsCommand);
        int AddCodeSet = resultDnsTwo[0];      
        if(AddCodeSet == 0)
		{
			
			writeln("Ba mofaqaeat Set shod");			
           
		}else
		{
            writeln("Error " , resultDnsTwo);
		}
	}else
	{
        writeln("Error" , result);
	}

}
