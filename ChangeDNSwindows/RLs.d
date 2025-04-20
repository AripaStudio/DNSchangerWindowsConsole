module RLs;

import std.stdio;
import SaveMangaerInterface;
import GLV;
import std.string;


class CRLs
{
	 private auto InterFaceMangaer = new SaveMangerInterFaceClass();

	void AddInterFace(string NameInterface)
	{
		writeln("Please Enter Your InterFace(Save in Software)");
		string InterFace = readln().strip();
		if(!InterFace.empty)
		{
			
		}else
		{
			writeln("Error : Input is empty");
		}
	}
}