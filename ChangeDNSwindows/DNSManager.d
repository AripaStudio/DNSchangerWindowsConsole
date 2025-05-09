module DNSManager;

import std.stdio;
import std.process;
import std.string;
import std.format;
import std.conv;
import std.array;
import GLV;
import RLs;
import SaveManager;
import std.algorithm;
import std.json;


enum DNSServer
{
    shecan, 
    google,
    cloudflare,
    quad9,
    opendns,
    none
}



public class DNSManagerClass
{

	
		private CRLs crls;
			
	

	this()
	{
		crls = new CRLs();
	}

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

	//Dns: 
	// google :
	public string[] DnsGoogle = ["8.8.8.8" , "8.8.4.4"];
	//cloudflare : 
	public string[] DnsCloudflare = [ "1.1.1.1" , "1.0.0.1" ];
	//Opendns : 
	public string[] DnsOpenDNS = [ "208.67.222.222" , "208.67.220.220" ];
	//Quad9 : 
	public string[] DnsQuad9 = [ "9.9.9.9" , "149.112.112.112" ];
	//Shecan :
	public string[] DnsSHecan = ["178.22.122.100" , "185.51.200.2"];

	public DNSServer selectedDNSServer = DNSServer.none;

	private  string[] selectedDNS = null;	


	string[] executeShellCommand(string command)
	{
		auto pipes = pipeShell(command, Redirect.stdout | Redirect.stderr);		
		string output = pipes.stdout.byLine.map!(line => line.idup).join("\n");
		string errorOutput = pipes.stderr.byLine.map!(line => line.idup).join("\n");
		int exitCode = pipes.pid.wait();
		return [to!string(exitCode), output, errorOutput];
	}

	string[] executeShellCommandPowerShell(string command)
	{
		
		auto pipes = pipeShell(`powershell -Command "` ~ command ~ `"`, Redirect.stdout | Redirect.stderr);
		string output = pipes.stdout.byLine.map!(line => line.idup).join("\n");
		string errorOutput = pipes.stderr.byLine.map!(line => line.idup).join("\n");
		int exitCode = pipes.pid.wait();
		return [to!string(exitCode), output, errorOutput];
	}


	 void selectDNS(string dnsName)
    {
        switch (dnsName.toLower())
        {
            case "shecan":
                selectedDNSServer = DNSServer.shecan;
                selectedDNS = DnsSHecan;				
                break;
            case "google":
                selectedDNSServer = DNSServer.google;
                selectedDNS = DnsGoogle;
                break;
            case "cloudflare":
                selectedDNSServer = DNSServer.cloudflare;
                selectedDNS = DnsCloudflare;
                break;
            case "quad9":
                selectedDNSServer = DNSServer.quad9;
                selectedDNS = DnsQuad9;
                break;
            case "opendns":
                selectedDNSServer = DNSServer.opendns;
                selectedDNS = DnsOpenDNS;
                break;
            default:
                selectedDNSServer = DNSServer.none;
                selectedDNS = null;
                break;
        }		
    }
	 
	

     void changeDNS(string interfaceName)
    {
        if (selectedDNSServer == DNSServer.none || selectedDNS is null)
        {
            writeln("Error: No DNS server selected.");
            return;
        }

        auto dnsCommand = format(
								 `powershell -ExecutionPolicy Bypass -Command "Set-DnsClientServerAddress -InterfaceAlias '%s' -ServerAddresses ('%s', '%s')"`,
								 interfaceName, selectedDNS[0], selectedDNS[1]
								 );

        auto result = executeShellCommand(dnsCommand);
        int exitCode = to!int(result[0]);
        string output = result[1];
        string errorOutput = result[2];

        if (exitCode == 0)
        {
            writeln("DNS servers set successfully for interface: ", interfaceName);
            writeln("Primary DNS: ", selectedDNS[0]);
            writeln("Secondary DNS: ", selectedDNS[1]);
        }
        else
        {
            writeln("Error setting DNS servers:");
            writeln(errorOutput);
        }
    }


	


	void resetDNS(string interfaceName)
	{
		int ErrorPowerShellTry = 0;
		// بررسی خالی نبودن interfaceName
		interfaceName = interfaceName.strip();
		if (interfaceName.empty)
		{
			writeln(tRED, "Error: Interface name cannot be empty.", tRESET);
			return;
		}

	

		// روش اول: ریست DNS با PowerShell
		writeln(tCYAN, "Resetting DNS for interface '", interfaceName, "' using PowerShell...", tRESET);
		auto commandReset = format(
								   `powershell -Command "Set-DnsClientServerAddress -InterfaceAlias '%s' -ResetServerAddresses"`,
								   interfaceName
								   );

		writeln(tCYAN, "Executing command: ", commandReset, tRESET);
		auto result = executeShellCommand(commandReset);
		int exitCode = to!int(result[0]);
		string output = result[1];
		string errorOutput = result[2];

		if (exitCode == 0)
		{
			writeln(tGREEN, "Successfully reset DNS for interface '", interfaceName, "' to DHCP using PowerShell.", tRESET);
			writeln(tGREEN, "Output: ", output, tRESET);
			ErrorPowerShellTry = 0;
		}
		else
		{
			writeln(tRED, "Error resetting DNS for interface '", interfaceName, "' using PowerShell:", tRESET);
			writeln(tRED, "Exit code: ", exitCode, tRESET);
			writeln(tRED, "Output: ", output, tRESET);
			writeln(tRED, "Error output: ", errorOutput, tRESET);
			ErrorPowerShellTry = 1;
		}

		if(ErrorPowerShellTry == 1)
		{

			// روش دوم: ریست DNS با netsh
			writeln(tCYAN, "Trying alternative method with netsh...", tRESET);
			auto netshCommand = format(
									   `netsh interface ip set dns name="%s" source=dhcp`,
									   interfaceName
									   );

			result = executeShellCommand(netshCommand);
			exitCode = to!int(result[0]);
			output = result[1];
			errorOutput = result[2];

			if (exitCode == 0)
			{
				writeln(tGREEN, "Successfully reset DNS for interface '", interfaceName, "' to DHCP using netsh.", tRESET);
				writeln(tGREEN, "Output: ", output, tRESET);
			}
			else
			{
				writeln(tRED, "Error resetting DNS for interface '", interfaceName, "' using netsh:", tRESET);
				writeln(tRED, "Exit code: ", exitCode, tRESET);
				writeln(tRED, "Output: ", output, tRESET);
				writeln(tRED, "Error output: ", errorOutput, tRESET);
			}
		}

	}

	//show DNS: 
	public void showDNS()
    {
        auto result = executeShellCommand(`powershell -ExecutionPolicy Bypass -Command "Get-DnsClientServerAddress | Select-Object -ExpandProperty ServerAddresses"`);
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


    public DNSServer getSelectedDNSServer()
    {
        return selectedDNSServer;
    }


	// DNS Custom Func : 
	public void ChangeDNScustom(string interfaceName , string OneDNS , string TwoDNS)
	{

		if(interfaceName.empty && OneDNS.empty && TwoDNS.empty)
		{
			writeln("Error : interfaceName or OneDNS or TwoDNS is empty ");
			return;
		}
        auto dnsCommand = format(
								 `powershell -ExecutionPolicy Bypass -Command "Set-DnsClientServerAddress -InterfaceAlias '%s' -ServerAddresses ('%s', '%s')"`,
								 interfaceName, OneDNS, TwoDNS
								 );

        auto result = executeShellCommand(dnsCommand);
        int exitCode = to!int(result[0]);
        string output = result[1];
        string errorOutput = result[2];

        if (exitCode == 0)
        {
            writeln("DNS servers set successfully for interface: ", interfaceName);
            writeln("Primary DNS: ", OneDNS);
            writeln("Secondary DNS: ", TwoDNS);
        }
        else
        {
            writeln("Error setting DNS servers:");
            writeln(errorOutput);
        }
	}

	










	//------------------------------------------------------------------------
	//------------------------------------------------------------------------
	//------------------------------------------------------------------------

	


	//Ping DNS 
	 void PingDNS(string DNSname)
	 {			
			
			
			DNSname = DNSname.strip();

			int CheckError = 0;
			
			if(DNSname.empty)
			{
				writeln(" Error : DNS name : empty");
				CheckError = 0;
				
			}else
			{
				CheckError++;
			}
			if(!crls.isValidIPv4(DNSname))
			{
				writeln("this dns is not Valid");				
				CheckError = 0;
			}else
			{
				CheckError++;
			}
			if(CheckError == 2)
			{

				try
				{

					auto dnsCommand = "Test-Connection -ComputerName "~ DNSname ~" -Count 4";
					auto result = executeShellCommandPowerShell(dnsCommand);
					int exitCode = to!int(result[0]);
					string output = result[1];
					string errorOutput = result[2];
					if(exitCode == 0)
					{
						writeln("Ping DNS : ");
						writeln(output);

					}else
					{
						writeln("Error : ");
						writeln(errorOutput);
					}
				}catch(Exception e)
				{
					writeln("ERROR executing command " , e.msg);

				}
			}
			
	 }
	 //ping dns Custom
	 public void PingDNSC(string DNSname)
	 {	
		if(DNSname.empty)
		{
			writeln("Error : DNS name is empty");
			return;
		}

		auto saveManager = new  SaveManagerClass();
		auto crls = new CRLs();
		auto crlsPing = new CRLsPing();
		auto crlsJson = new CRLsWJson();
		string DNSOne;
		string DNSTwo;

		


		auto JsonData = crlsJson.ReadJson(saveManager.fileName);

		if(JsonData.type != JSONType.array)
		{
			writeln("Error: JSON data is not an array");
			return;
		}

		auto matchingObjects = JsonData.array
			.filter!(f => f.type == JSONType.object &&
					 "NameDNS" in f &&
						 f["NameDNS"].str == DNSname)
			.array;

		if (matchingObjects.length == 0) 
		{			
			writeln("No objects found with NameDNS: ", DNSname);
			return;
		}
		
		auto firstObject = matchingObjects[0];

		if ("OneDNS" in firstObject && "TwoDNS" in firstObject)
		{
			try
			{
				DNSOne = firstObject["OneDNS"].str;
				DNSTwo = firstObject["TwoDNS"].str;
			}catch(Exception e)
			{
				writeln("Error : " , e.msg);
			}
		}
		else
		{
			writeln("Error: DNSOne or DNSTwo not found in JSON object");
			return;
		}
	
		bool CheckDNSone = !DNSOne.empty && crls.isValidIPv4(DNSOne);
		bool CheckDNStwo = !DNSTwo.empty && crls.isValidIPv4(DNSTwo);

	


		if(!CheckDNSone && !CheckDNStwo)
		{
			writeln("this dns is not valid");
			writeln("DNS ONE :" , DNSOne);
			writeln("DNS Two :" , DNSTwo);
			return;
		}

		try
		{
			auto dnsCommandOne = "Test-Connection -ComputerName "~ DNSOne ~" -Count 4";
			auto dnsCommandTwo = "Test-Connection -ComputerName "~ DNSTwo ~" -Count 4";
			auto result = executeShellCommandPowerShell(dnsCommandOne);
			int exitCodeOne = to!int(result[0]);
			string outputOne = result[1];
			string ErrorOne = result[2];
			if(exitCodeOne == 0)
			{
				auto resultTwo = executeShellCommandPowerShell(dnsCommandTwo);
				int exitCodeTwo = to!int(resultTwo[0]);
				string outputTwo = resultTwo[1];
				string ErrorTwo = resultTwo[2];
				if(exitCodeTwo == 0)
				{
					writeln("ping : " , DNSname , " " , DNSOne , " " , DNSTwo);
					writeln(outputOne);
					writeln(outputTwo);
				}else
				{

					writeln("Error : ");
					writeln(ErrorTwo);
				}
				

				
			}else
			{
				writeln("Error : ");
				writeln(ErrorOne);
			}
		}catch(Exception e )
		{
			writeln("ERROR executing command " , e.msg);
		}
		
		

		

		
				

	 }
	 // Ping my dns:
	 void PingMyDNS()
	 {
		string[] Currentdns = CurrentDNS();
		string OneDNS;
		string TwoDNS;
		if(Currentdns !is null)
		{
						
			if(Currentdns.length >= 2)
			{
				OneDNS = Currentdns[0];		
				TwoDNS = Currentdns[1];
				try
				{
					PingDNS(OneDNS);					
				}catch(Exception e)
				{
					writeln("Error in Run PingDNS " , "(DNS server :) " , OneDNS , "Error : "  , e.msg);
					return;
				}
 				try
				{
					PingDNS(TwoDNS);
				}catch(Exception e )
				{
					writeln("Error in Run PingDNS " , "(DNS server :) " , TwoDNS , "Error : "  , e.msg);
					return;
				}
			}else if(Currentdns.length == 1)
			{
				OneDNS = Currentdns[0];		
				try
				{
					PingDNS(OneDNS);					
				}catch(Exception e)
				{
					writeln("Error in Run PingDNS " , "(DNS server :) " , OneDNS , "Error : "  , e.msg);
					return;
				}
			}else
			{
				writeln("DNS not Valid ");
				return;
			}
			
		}else
		{
			writeln(GLVclass.tRED , " Error , DNS in empty!" , GLVclass.tRESET);
			return;
		}
		
	 }

	 string[] CurrentDNS()
	 {
		try
		{
			auto result = executeShellCommand(`powershell -ExecutionPolicy Bypass -Command "Get-DnsClientServerAddress | Select-Object -ExpandProperty ServerAddresses"`);

			var rls = new CRLs();

			int exitCode = to!int(result[0]);
			string output = result[1];
			string errorOutput = result[2];

			if (exitCode == 0 && !output.empty)
			{
				writeln("DNS Servers:");
				writeln(output);


				auto dnsServers = output
					.splitLines
					.filter!(line => !line.strip.empty)
					.filter!(line => !line.canFind(":"))
					.array;

				if (dnsServers.length == 0) {
					writeln("No valid IPv4 DNS found.");
					return null;
				}

				//check Is Valid DNS:
				foreach(d; dnsServers) {
					if(!rls.isValidIPv4(d)) {
						writeln("DNS not Valid: ", d);
						return null;
					}
				}

				//return CurrentDNS:
				return dnsServers;


			} else
			{
				writeln("Error executing command:");
				writeln(errorOutput);
				return null;
			}

		}catch(Exception e)
		{
			writeln("Error in Save CurrentDNS? : " , e.msg);
			return null;
		}
	 }


		
	 //Check activ DNS
	 public void ChActivDNS(string DNSname)
	 {
		auto crls = new CRLs();

		DNSname = DNSname.strip();

		int CheckError = 0;

		if(DNSname.empty)
		{
			writeln("Error : DNS name is empty");
			CheckError = 0;
			return;
		}else 
		{
			CheckError++;
		}
		if(!crls.isValidIPv4(DNSname))
		{
			writeln("this dns is not valid ");
			CheckError = 0;
			return;
		}else
		{
			CheckError++;
		}

		if(CheckError == 2)
		{
			try
			{
				auto dnsCommandforInformation = "Resolve-DnsName -Name google.com -Server "~ DNSname ~" -Type A";
				auto dnsCommandforActive = "Test-Connection -ComputerName "~ DNSname ~" -Quiet";
				auto resultOne = executeShellCommandPowerShell(dnsCommandforInformation);
				int exitCodeOne = to!int(resultOne[0]);
				string outputOne = resultOne[1];
				string errorOutputOne = resultOne[2];
				if(exitCodeOne == 0)
				{
					auto resultTwo = executeShellCommandPowerShell(dnsCommandforActive);
					int exitCodeTwo = to!int(resultTwo[0]);
					auto outputTwo = resultTwo[1];
					string ErrorOutPutTwo = resultTwo[2];
					if(exitCodeTwo == 0)
					{
						writeln("Active And information: ");
						writeln(GLVclass.tGREEN , "Active : " , outputTwo , GLVclass.tRESET);
						writeln("Information : ");
						writeln(outputOne);
					}else
					{
						writeln("Error : ");
						writeln(ErrorOutPutTwo);
					}
				}else
				{
					writeln("Error : ");
					writeln(errorOutputOne);
				}


			}catch(Exception e)
			{
				writeln("ERROR executing command" , e.msg);
				return;
			}
		}
		
	 }
	 //check activ  DNS custom
	  void ChActiveDNSC(string DNSname)
	 {
		if(DNSname.empty)
		{
			writeln("Error : DNS name is empty");
			return;
		}

		auto saveManager = new  SaveManagerClass();
		auto crls = new CRLs();
		auto crlsPing = new CRLsPing();
		auto crlsJson = new CRLsWJson();
		string DNSOne;
		string DNSTwo;

		DNSOne = DNSOne.strip();
		DNSTwo = DNSTwo.strip();

		bool IsValidInt = true;

		auto JsonData = crlsJson.ReadJson(saveManager.fileName);

		if(JsonData.type != JSONType.array)
		{
			writeln("Error: JSON data is not an array");
			return;
		}

		auto matchingObjects = JsonData.array
			.filter!(f => f.type == JSONType.object &&
					 "NameDNS" in f &&
						 f["NameDNS"].str == DNSname)
			.array;

		if (matchingObjects.length == 0) {
			writeln("No objects found with NameDNS: ", DNSname);
			return;
		}

		auto firstObject = matchingObjects[0];
		if ("OneDNS" in firstObject && "TwoDNS" in firstObject)
		{
			try
			{
				DNSOne = firstObject["OneDNS"].str;
				DNSTwo = firstObject["TwoDNS"].str;
			}catch(Exception e)
			{
				writeln("Error : " , e.msg);
			}
		}
		else
		{
			writeln("Error: DNSOne or DNSTwo not found in JSON object");
			return;
		}


		bool CheckDNSone = crls.isValidIPv4(DNSOne);
		bool CheckDNStwo = crls.isValidIPv4(DNSTwo);
		if(!CheckDNSone && !CheckDNStwo)
		{
			writeln("this dns is not valid");
			writeln("DNS ONE :" , DNSOne);
			writeln("DNS Two :" , DNSTwo);
			IsValidInt = false;
			return;
		}

		string[] Commands;
		if(IsValidInt)
		{

			 Commands ~= "Resolve-DnsName -Name google.com -Server "~ DNSOne ~" -Type A";
			 Commands ~= "Test-Connection -ComputerName "~ DNSOne ~" -Quiet";

			 Commands ~= "Resolve-DnsName -Name google.com -Server "~ DNSTwo ~" -Type A";
			 Commands ~= "Test-Connection -ComputerName "~ DNSTwo ~" -Quiet";
		}

		foreach(cmd ; Commands)
		{
			try
			{
				auto result = executeShellCommandPowerShell(cmd);
				int exitcode = to!int(result[0]);
				string output = result[1];
				string error = result[2];
				if(exitcode == 0)
				{
					writeln("Command executed successfully: ", cmd);
					writeln("OutPut : ");
					writeln(GLVclass.tGREEN , output , GLVclass.tRESET);
				}else
				{
					writeln("Error : ");
					writeln(error);
				}
				

			}catch(Exception e)
			{
				writeln("ERROR executing command" , e.msg);
				return;
			}
		}
	 }
	
	




}
