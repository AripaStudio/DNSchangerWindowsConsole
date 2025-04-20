module RLs;

import std.stdio;
import SaveMangaerInterface; 
import GLV;
import core.sys.windows.windows;
import std.string;

class CRLs
{
    private SaveMangerInterFaceClass InterfaceManager; 

    this()
    {
        InterfaceManager = new SaveMangerInterFaceClass();
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
}