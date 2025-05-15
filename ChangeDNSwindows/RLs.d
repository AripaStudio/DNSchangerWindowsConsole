module RLs;

import std.stdio;
import SaveMangaerInterface; 
import GLV;
import DNSManager;
import core.sys.windows.windows;
import std.string;
import std.conv;
import ConsoleUI;
import std.json; 
import std.file; 
import std.algorithm;


class CRLs
{
    private SaveMangerInterFaceClass InterfaceManager; 
    
    this()
    {
        InterfaceManager = new SaveMangerInterFaceClass();
    }

    SaveMangerInterFaceClass GetInterfaceManager()
    {
        return InterfaceManager;
    }


    string AddInterFace()
    {
        writeln("Please Enter Your InterFace(Save in Software)");
        string InterFace = readln().strip();
        if (!InterFace.empty)
        {
            InterfaceManager.AddData(InterFace);
            writeln("Interface added successfully! Current saved interfaces:");
            InterfaceManager.ShowAll();
            return InterFace;
        }
        else
        {
            writeln("Error : Input is empty");
            return "";    
        }
        
    }

    string DeleteInterFace()
    {
        writeln("Please Enter Your InterFace(Delete in Software)");
        string InterFace = readln().strip();
        if (!InterFace.empty)
        {
            InterfaceManager.DeleteInterFace(InterFace);
            writeln("Interface deleted successfully! Current saved interfaces:");
            InterfaceManager.ShowAll();
            return InterFace;
        }
        else
        {
            writeln("Error : Input is empty");
            return "";    
        }

    }

    string showAllInterFace()
    {
        writeln("Current saved interfaces:");
        InterfaceManager.ShowAll();
        return "";
    }


    string SelectedInterFace()
    {
        writeln("Please Enter Your InterFace(Selected in Software)");
        string InterFace = readln().strip();
        if (!InterFace.empty)
        {
            writeln("Interface selected successfully! Current saved interfaces:");
            InterfaceManager.SelectInterface(InterFace);
            InterfaceManager.ShowAll();
            return InterFace;
        }
        else
        {
            writeln("Error : Input is empty");
            return "";    
        }
    }

    

    void InterFaceSetting()
	{
		auto consoleUI = new ConsoleUIClass();
		consoleUI.HelpSetting();
		while (true)
		{
			string inputUser = strip(readln()).toLower();
			if (inputUser == "addif")
			{
				string addedInterface = AddInterFace();
				if (addedInterface !is null)
				{
					writeln("Successfully added interface: ", addedInterface);
				}
			}
			else if (inputUser == "deleteif")
			{
				string deletedInterface = DeleteInterFace();
				if (deletedInterface !is null)
				{
					writeln("Successfully deleted interface: ", deletedInterface);
				}
			}
			else if (inputUser == "showallif")
			{
				showAllInterFace();
			}
			else if (inputUser == "selectedif")
			{
				string selectedInterface = SelectedInterFace();
				if (selectedInterface !is null)
				{
					writeln("Successfully selected interface: ", selectedInterface);
				}
			}
			else if (inputUser == "return")
			{
				break;
			}
			else 
			{
				writeln("Please type (addif), (deleteif), (showallif), (selectedif), (return)");
			}
		}
	}


    bool isValidIPv4(string dns)
	{
        string[] DNSsplit = dns.split('.');
        if(DNSsplit.length != 4)
		{
            return false;
		}

        foreach(part; DNSsplit)
		{
            try
			{
				int num = to!int(part);
                if(num < 0 || num > 255)
				{
                    return false;
				}
			}catch(ConvException)
			{
                return false;
			}
		}

        return true;
	}

}

public class CRLsPing
{   
    
		private DNSManagerClass dnsManager;
		private CRLs rls;
        private ConsoleUIClass consoleUI;
	

    this()
	{
        rls = new CRLs();
        dnsManager = new DNSManagerClass();
        consoleUI = new ConsoleUIClass();
	}
	
    void PingDNS()
	{
        writeln("Please enter the desired DNS to ping:");
        string DNSname = readln().strip();

        if(DNSname.empty)
		{
            writeln("Error , Input : empty");
            return;
		}
        
        dnsManager.PingDNS(DNSname);
		writeln("The operation was successful.");
        
		
	}

    //نوشتن و استفاده از 
    //pingMydns
    // و اپدیت جدید 
    //1.6.0
    void PingMyDNS()
	{
        

        
	}

    void PingDNSCustom()
	{
        writeln("Please enter your DNS name (the DNS name you saved in your list) to ping.");
        string DNSname = readln().strip();
        if(DNSname.empty)
		{
            writeln("Error , input : emtpy");
            return;
		}

        dnsManager.PingDNSC(DNSname);
        writeln("The operation was successful.");
	}

    void ChActiveANDinformation()
	{
        writeln("Please enter the desired DNS to see if it is active and the information.");
        string DNSname = readln().strip();
        if(DNSname.empty)
		{
            writeln("input is empty(ERROR)");
            return;
		}
        dnsManager.ChActivDNS(DNSname);
        writeln("The operation was successful.");
	}

    void ChActiveANDinformationCustom()
	{
        writeln("Please enter your DNS name (the DNS name you saved in your list) to Check Active and Information");
        string DNSname = readln().strip();
        if(DNSname.empty)
		{
            writeln("input is empty(ERROR)");
            return;
		}

        dnsManager.ChActiveDNSC(DNSname);
        writeln("The operation was successful.");

	}

    void PingMenu()
	{
        
        consoleUI.HelpPingMenu();

        while(true)
		{
            writeln(GLVclass.tGREEN , "Type:" , GLVclass.tRESET);            
            string inputUser = readln().strip().toLower();
            if(inputUser == "pingdns")
			{
                PingDNS();
			}else if(inputUser == "pingdnsc")
			{
                PingDNSCustom();
			}else if(inputUser == "chactive")
			{
                ChActiveANDinformation();
			}else if(inputUser == "chactivec")
			{
                ChActiveANDinformationCustom();
			}else if(inputUser == "return")
			{
			    break;
			}else
			{
                writeln(GLVclass.tRED , "plese Enter : (PingDNS) , (PingDNSC) , (ChActive) , (ChActiveC) For return : (return) "  , GLVclass.tRESET);
			}
		}
	}



    

    
}

public class CRLsWJson
{
    public JSONValue ReadJson(string fileName)
	{
        JSONValue empty = null;
        if(fileName.empty)
		{
            writeln("error fileName is empty");
            return empty;
		}      
        string jsonContent;
        try
		{
            jsonContent = readText(fileName);
		}catch(Exception e)
		{
            writeln("Error Read File " , e.msg);
            return empty;
		}

        JSONValue jsonData;
        try
		{
            jsonData = parseJSON(jsonContent);
		}catch(Exception e )
		{
            writeln("Error Parse Json " , e.msg);
		} 
        return jsonData;

	}
}