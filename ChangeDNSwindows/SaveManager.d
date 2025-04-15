module SaveManager;

import std.stdio;
import std.file;
import std.json;
import std.conv;
import std.string;
import std.algorithm;
import std.range;
import GLV;
import std.array;

public class JsonDataFileManager
{

	public string NameDNS;
	public string OneDNS;
	public string TwoDNS;

	JSONValue toJson()
	{
		return JSONValue([
		"NameDNS" : JSONValue(NameDNS),
		"OneDNS" : JSONValue(OneDNS),
		"TwoDNS" : JSONValue(TwoDNS)
		]);
	}


	static JsonDataFileManager fromJson(JSONValue json)
	{
		auto result = new JsonDataFileManager();
		result.NameDNS = json["NameDNS"].str;
		result.OneDNS = json["OneDNS"].str;
		result.TwoDNS = json["TwoDNS"].str;
		return result;
	}
}

public class SaveManagerClass
{

	private string fileName = "SaveDNSjsonDNCaripa.json";
	private JsonDataFileManager[] ManagerData;

	this()
	{
		loadData();
	}

	private void loadData()
	{

		if(exists(fileName))
		{
			string JsonString = readText(fileName);
			JSONValue json = parseJSON(JsonString);
			ManagerData = json.array.map!(j => JsonDataFileManager.fromJson(j)).array;
		}else
		{
			ManagerData = [];
		}

	}

	private void saveData()
	{
		JSONValue json = JSONValue(ManagerData.map!(c => c.toJson()).array);
		std.file.write(fileName , json.toPrettyString());
	}

	void AddData(string Namedns , string onedns, string twodns)
	{
		auto Data = new JsonDataFileManager();
		Data.NameDNS = Namedns;
		Data.OneDNS = onedns;
		Data.TwoDNS = twodns;
		ManagerData ~= Data;
		saveData();
		writeln("Data added successfully");
		writeln("Name DNS : " , Namedns , " DNS : " , onedns , " " , twodns);
	}

	void  DeleteDNSdata(string nameDNS)
	{
		ManagerData = ManagerData.filter!(c => c.NameDNS != nameDNS).array;
		saveData();
		writeln( nameDNS , " deleted successfully!");
	}

	void showAllDNS()
	{
		if(ManagerData.empty)
		{
			writeln("No Data found!");
            return;
		}

		foreach(Data; ManagerData)
		{
			writeln("Name DNS :  ", Data.NameDNS);
            writeln("One DNS : ", Data.OneDNS);
            writeln("Two DNS : ", Data.TwoDNS);
            writeln(GLVclass.tBLUE , "-----------" , GLVclass.tRESET);
		}
	}

	void ShowDNS(string namedns)
	{
		auto result = ManagerData.find!(data => data.NameDNS == namedns);

		if(result.empty)
		{
			writeln("No DNS found with NameDNS: ", namedns);
			return;
		}

		auto data = result[0];
		writeln("Name DNS : ", data.NameDNS);
		writeln("One DNS  : ", data.OneDNS);
		writeln("Two DNS  : ", data.TwoDNS);
		writeln(GLVclass.tGREEN, "-----------", GLVclass.tRESET);

	}



}
