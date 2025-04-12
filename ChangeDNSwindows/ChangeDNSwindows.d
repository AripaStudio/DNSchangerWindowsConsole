module ChangeDNSwindows;

import std.stdio;
import std.process;
import std.string;
import std.format;

//Aripa Studio 
//V1.0.0


private auto interfaceName = "";
private auto setDnsCommand = "";
private auto addDnsCommand = "";

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

int main()
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
					ChangeDNS(interfaceName , setDnsCommand , addDnsCommand);    					
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
			}
		}else if(inputStart == "exit")
		{
            break;
		}else
		{
            writeln("Plase Enter (exit) , (ViewDNS) , (ChangeDNS) , (deleteDNS)");
		}
	}
    readln();
    return 0;
}

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
	writeln("Welcome to our program (Aripa Studio) - (DNS Changer)");    
    writeln("please Run Admin ");
    writeln("To see the list of public DNS servers, type this, or if you want to enter your custom DNS, type this: (soon) ");
    writeln("For public DNS: ViewDNS");
    writeln("For change DNS: ChangeDNS");
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
	 string[] selectedDNS = null;	 
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
     setDnsCommand = "netsh interface ip set dns name=" ~ interfaceName ~ " static " ~ selectedDNS[0] ;        
	 addDnsCommand = "netsh interface ip add dns name=" ~ interfaceName ~ " " ~ selectedDNS[1] ~ " index=2";
    
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
