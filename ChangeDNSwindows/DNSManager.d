module DNSManager;

import std.stdio;
import std.process;
import std.string;
import std.format;
import std.conv : to;
import std.array : join, array;
import std.algorithm : map;


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

	public void selectDNS(string dnsName)
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

    public void changeDNS(string interfaceName)
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







}
