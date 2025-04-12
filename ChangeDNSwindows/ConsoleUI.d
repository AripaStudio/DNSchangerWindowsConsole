module ConsoleUI;


import std.stdio;
import std.string;
import core.sys.windows.windows;

public class ConsoleUIClass
{
	// ANSI Colors
    private enum tRESET = "\033[0m";
    private enum tBRIGHT_BLUE = "\033[94m";
    private enum tBLACK = "\033[30m";
    private enum tRED = "\033[31m";
    private enum tGREEN = "\033[32m";
    private enum tYELLOW = "\033[33m";
    private enum tBLUE = "\033[34m";
    private enum tMAGENTA = "\033[35m";
    private enum tCYAN = "\033[36m";
    private enum tWHITE = "\033[37m";

	this()
    {
        enableANSI();
    }

	void enableANSI()
    {
        HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
        if (hConsole == INVALID_HANDLE_VALUE)
        {
            return;
        }
        DWORD mode = 0;
        if (!GetConsoleMode(hConsole, &mode))
        {
            return;
        }

        mode |= ENABLE_VIRTUAL_TERMINAL_PROCESSING;
        SetConsoleMode(hConsole, mode);
    }

    // Display help message
    void showHelp()
    {
        writeln(tCYAN, "Welcome to our program (Aripa Studio) - (DNS Changer)", tRESET);    
        writeln(tCYAN, "V1.2.0 (Aripa Studio) - (DNS Changer)", tRESET);  
        writeln(tGREEN, "Program is running with administrative privileges.", tRESET);
        writeln(tYELLOW, "To see the list of public DNS servers, type this, or if you want to enter your custom DNS, type this: (soon)", tRESET);
        writeln(tYELLOW, "For public DNS: ViewDNS", tRESET);
        writeln(tYELLOW, "For change DNS: ChangeDNS", tRESET);
        writeln(tYELLOW, "To remove the DNS on your system, you can type this: deleteDNS", tRESET);
        writeln(tYELLOW, "For exit, you can type this: exit", tRESET);
        writeln(tYELLOW, "For your DNS, you can type this: showMydns", tRESET);
    }

    // Display list of public DNS servers
    void listDNSPublic()
    {
        writeln(tCYAN, "Google DNS: ", tRESET, ["8.8.8.8", "8.8.4.4"]);
        writeln(tCYAN, "CloudFlare DNS: ", tRESET, ["1.1.1.1", "1.0.0.1"]);
        writeln(tCYAN, "OpenDns DNS: ", tRESET, ["208.67.222.222", "208.67.220.220"]);
        writeln(tCYAN, "Quad9 DNS: ", tRESET, ["9.9.9.9", "149.112.112.112"]);
        writeln(tCYAN, "Shecan DNS: ", tRESET, ["178.22.122.100", "185.51.200.2"], tCYAN, " Website: ", tRESET, "https://shecan.ir/");
    }

	string getUserInput(string prompt)
    {
        writeln(tCYAN, prompt, tRESET);
        return strip(readln());
    }

    // Print a message with a specified color
    void printMessage(string message, string color = tWHITE)
    {
        writeln(color, message, tRESET);
    }

    // Wait for the user to press Enter
    void waitForEnter()
    {
        printMessage("Press Enter to continue...", tYELLOW);
        readln();
    }


}
