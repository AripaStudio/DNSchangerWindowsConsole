module NetworkInterface;


import std.stdio;
import std.process;
import std.string;
import std.conv;
import std.array ;
import std.algorithm;


enum tRESET = "\033[0m";
enum tRED = "\033[31m";
enum tCYAN = "\033[36m";

public class NetworkInterfaceClass
{
	
	private string[] executeShellCommand(string command)
    {
        auto pipes = pipeShell(command, Redirect.stdout | Redirect.stderr);
        string output = pipes.stdout.byLine.map!(line => line.idup).join("\n");
        string errorOutput = pipes.stderr.byLine.map!(line => line.idup).join("\n");
        int exitCode = pipes.pid.wait();
        return [to!string(exitCode), output, errorOutput];
    }

	// گرفتن لیست رابط‌های فعال
    string[] getActiveInterfaces()
    {       

        auto command = `powershell -Command "Get-NetAdapter | Where-Object { $_.Status -eq 'Up' } | Select-Object -ExpandProperty Name"`;
        auto result = executeShellCommand(command);
        int exitCode = to!int(result[0]);
        string output = result[1];
        string errorOutput = result[2];

        if (exitCode != 0)
        {
            writeln(tRED, "Error retrieving list of active interfaces:", tRESET);
            writeln(tRED, errorOutput, tRESET);
            return [];
        }

        auto interfaces = output.splitLines().filter!(line => !line.empty).array;
        if (interfaces.empty)
        {
            writeln(tCYAN, "No active network interfaces found.", tRESET);
            return [];
        }

        return interfaces;
    }

	// بررسی وضعیت رابط
    bool isInterfaceActive(string interfaceName)
    {
        // بررسی خالی نبودن interfaceName
        interfaceName = interfaceName.strip();
        if (interfaceName.empty)
        {
            writeln(tRED, "Error: Interface name cannot be empty.", tRESET);
            return false;
        }
      

        auto command = format(
							  `powershell -Command "if (Get-NetAdapter -Name '%s' | Where-Object { $_.Status -eq 'Up' }) { Write-Output 'Active' }"`,
							  interfaceName
							  );
        auto result = executeShellCommand(command);
        int exitCode = to!int(result[0]);
        string output = result[1].strip();
        string errorOutput = result[2];

        if (exitCode != 0)
        {
            writeln(tRED, "Error checking status of interface '", interfaceName, "':", tRESET);
            writeln(tRED, errorOutput, tRESET);
            return false;
        }

        return output == "Active";
    }


}
