module RLs;

import std.stdio;
import SaveMangaerInterface;
import GLV;
import core.sys.windows.windows;
import std.string;

class CRLs
{
    private SaveMangerInterFaceClass InterFaceMangaer; 
    this()
    {
        InterFaceMangaer = new SaveMangerInterFaceClass();
    }

    void AddInterFace(string NameInterface)
    {
        writeln("Please Enter Your InterFace(Save in Software)");
        string InterFace = readln().strip();
        if (!InterFace.empty)
        {
            // ...
        }
        else
        {
            writeln("Error : Input is empty");
        }
    }
}