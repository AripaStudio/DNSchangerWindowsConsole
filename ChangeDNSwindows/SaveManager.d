module SaveManager;

import std.stdio;
import std.file;
import std.json;
import std.conv;
import std.string;
import std.algorithm;
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

	void AddData(string NameDNS , string OneDNS , string TwoDNS)
	{

	}

	void  DeleteDNSdata(string NameDNS)
	{

	}

	void showAllDNS()
	{

	}

	void ShowDNS(string NameDNS)
	{

	}



}
