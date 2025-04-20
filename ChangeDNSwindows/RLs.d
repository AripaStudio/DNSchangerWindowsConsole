module RLs;

import std.stdio;
import SaveMangaerInterface; 
import GLV;
import core.sys.windows.windows;
import std.string;
import std.conv;
import ConsoleUI;

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
            return null;    
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
            return null;    
        }

    }

    string showAllInterFace()
    {
        writeln("Current saved interfaces:");
        InterfaceManager.ShowAll();
        return null;
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
            return null;    
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