module ConsoleUI;


import std.stdio;
import std.string;
import core.sys.windows.windows;
import RLs;
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
        auto crls = new CRLs();  

        string checkSelected = crls.GetInterfaceManager().GetSelectedInterface();
       
        writeln(GLVclass.tCYAN, "Welcome to our program (Aripa Studio) - (DNCaripa)", GLVclass.tRESET);    
        //---------------
         writeln(GLVclass.tCYAN, "(DNCaripa = (DN = DNS , C = Changer , aripa = Aripa Studio ))", GLVclass.tRESET);    
        //---------------

        writeln(GLVclass.tCYAN, "V1.4.2 (Aripa Studio) - (DNS Changer)", GLVclass.tRESET);  
      
        //---------------
        writeln(GLVclass.tGREEN, "Program is running with administrative privileges.", GLVclass.tRESET);  

		//---------------		

        writeln(GLVclass.tYELLOW, "To change the current InterfaceName, add an InterfaceName, or remove other changes, you can type : ", GLVclass.tRESET,
				GLVclass.tBRIGHT_BLUE , "Setting", GLVclass.tRESET);

        //---------------		

        writeln(GLVclass.tYELLOW, "to ping a DNS and check if it's active and ... , you can type: : ", GLVclass.tRESET,
				GLVclass.tBRIGHT_BLUE , "Ping", GLVclass.tRESET);
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
		
      
		writeln(GLVclass.tYELLOW, "This section allows you to ping DNS servers, check their activity status, and view details., you can type : ", GLVclass.tRESET,
				GLVclass.tBRIGHT_BLUE , "pingMenu", GLVclass.tRESET);
        //---------------		

        writeln(GLVclass.tYELLOW, "For exit, you can type this: ", GLVclass.tRESET,
				GLVclass.tRED , "exit ", GLVclass.tRESET);


        //check if selected interface is empty
		if(checkSelected.empty)
		{
            writeln(GLVclass.tRED , "No interface selected. Please go to 'setting' and select an interface using 'selectedif'." , GLVclass.tRESET);
		}


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

    void HelpSetting()
	{
        
		writeln(GLVclass.tCYAN, "Interface Settings Menu", GLVclass.tRESET);
        writeln(GLVclass.tYELLOW, "To add a new interface, type: ", GLVclass.tBRIGHT_BLUE, "addif", GLVclass.tRESET);
        writeln(GLVclass.tYELLOW, "To delete an interface, type: ", GLVclass.tBRIGHT_BLUE, "deleteif", GLVclass.tRESET);
        writeln(GLVclass.tYELLOW, "To show all interfaces, type: ", GLVclass.tBRIGHT_BLUE, "showallif", GLVclass.tRESET);
        writeln(GLVclass.tYELLOW, "To select an interface, type: ", GLVclass.tBRIGHT_BLUE, "selectedif", GLVclass.tRESET);
        writeln(GLVclass.tYELLOW, "To return to the main menu, type: ", GLVclass.tBRIGHT_BLUE, "return", GLVclass.tRESET);
	}

    void HelpPingMenu()
	{
		writeln(GLVclass.tCYAN, "DNS Management Menu", GLVclass.tRESET);
		writeln(GLVclass.tYELLOW, "To ping a specific DNS, type: ", GLVclass.tBRIGHT_BLUE, "PingDNS", GLVclass.tRESET);
		writeln(GLVclass.tYELLOW, "To ping saved custom DNSs, type: ", GLVclass.tBRIGHT_BLUE, "PingDNSC", GLVclass.tRESET);
		writeln(GLVclass.tYELLOW, "To check details and activity of a specific DNS, type: ", GLVclass.tBRIGHT_BLUE, "ChActive", GLVclass.tRESET);
		writeln(GLVclass.tYELLOW, "To check details and activity of saved custom DNSs, type: ", GLVclass.tBRIGHT_BLUE, "ChActiveC", GLVclass.tRESET);
		writeln(GLVclass.tYELLOW, "To return to the main menu, type: ", GLVclass.tBRIGHT_BLUE, "return", GLVclass.tRESET);
	}


}
