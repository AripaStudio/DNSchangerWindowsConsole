module ConsoleUI;


import std.stdio;
import std.string;
import core.sys.windows.windows;
import GLV;

public class ConsoleUIClass
{


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
        writeln(GLVclass.tCYAN, "Welcome to our program (Aripa Studio) - (DNCaripa)", GLVclass.tRESET);    
        //---------------
         writeln(GLVclass.tCYAN, "(DNCaripa = (DN = DNS , C = Changer , aripa = Aripa Studio ))", GLVclass.tRESET);    
        //---------------

        writeln(GLVclass.tCYAN, "V1.2.0 (Aripa Studio) - (DNS Changer)", GLVclass.tRESET);  
        //---------------

        writeln(GLVclass.tGREEN, "Program is running with administrative privileges.", GLVclass.tRESET);  
        //---------------

        writeln(GLVclass.tYELLOW, "For public DNS: ", GLVclass.tRESET , 
				GLVclass.tBRIGHT_BLUE , "ViewDNS ", GLVclass.tRESET);
        //---------------

        writeln(GLVclass.tYELLOW, "For change DNS: ", GLVclass.tRESET , 
				GLVclass.tBRIGHT_BLUE , "ChangeDNS ", GLVclass.tRESET);
        //---------------

        writeln(GLVclass.tYELLOW, "To remove the DNS on your system, you can type this: ", GLVclass.tRESET,
				GLVclass.tBRIGHT_BLUE , "deleteDNS ", GLVclass.tRESET);
        
        //---------------

        writeln(GLVclass.tYELLOW, "For your DNS, you can type this: ", GLVclass.tRESET , 
				GLVclass.tBRIGHT_BLUE , "showMydns ", GLVclass.tRESET);
        //---------------

        writeln(GLVclass.tBLUE , "------------Custom DNS section ------------ " , GLVclass.tRESET);
        //---------------

		writeln(GLVclass.tYELLOW, "To display the list of all added DNS servers, you can type: " , GLVclass.tRESET ,
				GLVclass.tBRIGHT_BLUE ,  "showALLc", GLVclass.tRESET);
        //---------------

		writeln(GLVclass.tYELLOW, "To display a specific DNS in your added list, you can type: " , GLVclass.tRESET ,
				GLVclass.tBRIGHT_BLUE ,  "showDnsInfoC" , GLVclass.tRESET);
        //---------------

		writeln(GLVclass.tYELLOW, "To add a DNS server to your list, you can type: " , GLVclass.tRESET ,
				GLVclass.tBRIGHT_BLUE , "addDNSC", GLVclass.tRESET);

        //---------------

		writeln(GLVclass.tYELLOW, "To Delete a DNS server to your list, you can type: " , GLVclass.tRESET ,
				GLVclass.tBRIGHT_BLUE , "DeleteDNSC", GLVclass.tRESET);
        //---------------
        writeln(GLVclass.tYELLOW, "To set a DNS from your added DNS list, you can type: ", GLVclass.tRESET,
				GLVclass.tBRIGHT_BLUE , "changeDNSC ", GLVclass.tRESET);


        //---------------

        writeln(GLVclass.tYELLOW, "For exit, you can type this: ", GLVclass.tRESET,
				GLVclass.tRED , "exit ", GLVclass.tRESET);
    }

    // Display list of public DNS servers
    void listDNSPublic()
    {
        writeln(GLVclass.tCYAN, "Google DNS: ", GLVclass.tRESET, ["8.8.8.8", "8.8.4.4"]);
        writeln(GLVclass.tCYAN, "CloudFlare DNS: ", GLVclass.tRESET, ["1.1.1.1", "1.0.0.1"]);
        writeln(GLVclass.tCYAN, "OpenDns DNS: ", GLVclass.tRESET, ["208.67.222.222", "208.67.220.220"]);
        writeln(GLVclass.tCYAN, "Quad9 DNS: ", GLVclass.tRESET, ["9.9.9.9", "149.112.112.112"]);
        writeln(GLVclass.tCYAN, "Shecan DNS: ", GLVclass.tRESET, ["178.22.122.100", "185.51.200.2"], GLVclass.tCYAN, " Website: ", GLVclass.tRESET, "https://shecan.ir/" );
        writeln(GLVclass.tMAGENTA , "A DNS breaker is a tool or service that bypasses DNS restrictions to access blocked websites, commonly used by Iranians; I'm unsure about its security." , GLVclass.tRESET);
    }

	string getUserInput(string prompt)
    {
        writeln(GLVclass.tCYAN, prompt, GLVclass.tRESET);
        return strip(readln());
    }

    // Print a message with a specified color
    void printMessage(string message, string color = GLVclass.tWHITE)
    {
        writeln(color, message, GLVclass.tRESET);
    }

    // Wait for the user to press Enter
    void waitForEnter()
    {
        printMessage("Press Enter to continue...", GLVclass.tYELLOW);
        readln();
    }


}
