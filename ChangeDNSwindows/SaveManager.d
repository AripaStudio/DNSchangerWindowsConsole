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
import std.typecons : Tuple;

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
		if("NameDNS" in json && "OneDNS" in json && "TwoDNS" in json ) 
		{
			result.NameDNS = json["NameDNS"].str;
			result.OneDNS = json["OneDNS"].str;
			result.TwoDNS = json["TwoDNS"].str;
		}
		return result;
	}
}
/// Manages DNS data storage and retrieval in JSON format.
public class SaveManagerClass
{

	private string fileName = "dns_data_json.json";
	private JsonDataFileManager[] ManagerData;

	this()
	{
		loadData();
	}



	private void loadData()
	{

		if(exists(fileName))
		{
			try
			{
				string JsonString = readText(fileName);
				JSONValue json = parseJSON(JsonString);
				ManagerData = json.array.map!(j => JsonDataFileManager.fromJson(j)).array;
			}catch(JSONException e)
			{
				writeln( GLVclass.tRED ,"Error parsing JSON file: ", e.msg , GLVclass.tRESET);
			}
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

		Namedns = Namedns.strip();
		onedns = onedns.strip();
		twodns = twodns.strip();

		if(Namedns.empty || onedns.empty || twodns.empty )
		{
			writeln("Error: DNS fields cannot be empty!");
			return;
		}

		if(ManagerData.any!(data => data.NameDNS == Namedns))
		{
			writeln("Error: DNS with this name already exists!");
			return;
		}

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
		if(nameDNS.empty)
		{
			writeln("Error  , NameDNS is empty");
			return;
		}
		auto existingData = ManagerData.filter!(c => c.NameDNS == nameDNS).array;

		if(existingData.empty)
		{
			writeln("Error: No DNS found with NameDNS: ", nameDNS);
			return;
		}

		
		ManagerData = ManagerData.filter!(c => c.NameDNS != nameDNS).array;

		
		saveData();
		writeln(nameDNS, " deleted successfully!");
			
		
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

	
	Tuple!(string, string) ReturnDNS(string nameDNS)
	{
		auto result = ManagerData.find!(d => d.NameDNS.toLower() == nameDNS.toLower());
		if (result.empty)
		{
			writeln("No DNS found with NAME_DNS: ", nameDNS);
			return Tuple!(string, string)("", ""); 
		}

		auto dns = result[0];		
		writeln("One DNS: ", dns.OneDNS);
		writeln("Two DNS: ", dns.TwoDNS);
    

		return Tuple!(string, string)(dns.OneDNS, dns.TwoDNS);
	}

	



}
