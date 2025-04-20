module SaveMangaerInterface;


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
	public string NameInterFace;
	
	//public string Lang;
	

	JSONValue toJson()
	{
		return JSONValue([
		"NameInterFace" : JSONValue(NameInterFace)
		

		]);
	}

	static JsonDataFileManager fromJson(JSONValue json)
	{
		auto result = new JsonDataFileManager();
		if("NameInterFace" in json)
		{
			result.NameInterFace = json["NameInterFace"].str;			
		}
		
		return result;
	}

}

public class SaveMangerInterFaceClass
{
	private string fileName = "dns_data_user.json";
	private JsonDataFileManager[] ManagerData;
	private string selectedInterface;


	string GetSelectedInterface()
    {
        return selectedInterface;
    }

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

	void AddData(string NameInterface)
	{
		NameInterface = NameInterface.strip();
		if(NameInterface.empty)
		{
			writeln("Error: Name fields cannot be empty!");
			return;
		}
		if(ManagerData.any!(data => data.NameInterFace == NameInterface))
		{

			writeln("Error: InterFace with this name already exists!");
			return;
		}

		auto Data = new JsonDataFileManager();
		Data.NameInterFace = NameInterface;
		ManagerData ~= Data;
		saveData();
		writeln("Data added successfully");
		writeln("Name InterFace : " , NameInterface);
	}

	void DeleteInterFace(string NameInterface)
	{
		if(NameInterface.empty)
		{
			writeln("Error , Name InterFace is empty");
			return;
		}
		auto existingData = ManagerData.filter!(c => c.NameInterFace == NameInterface).array;
		if(existingData.empty)
		{
			writeln("Error: No NameInterFace found with Name InterFace : ", NameInterface);
			return;
		}

		ManagerData = ManagerData.filter!(c => c.NameInterFace != NameInterface).array;


		saveData();
		writeln(NameInterface , " deleted successfully!");
	}


	void ShowAll()
	{
		if(ManagerData.empty)
		{
			writeln("No Data found!");
            return;
		}

		foreach(Data; ManagerData)
		{
			writeln("Name InterFace  :  ", Data.NameInterFace);			
			writeln(GLVclass.tBLUE , "-----------" , GLVclass.tRESET);			
		}
		if(selectedInterface.empty)
		{
			writeln(GLVclass.tBLUE, "No Interface selected.", GLVclass.tRESET);
        }
        else
        {
            writeln(GLVclass.tBLUE, "Selected Interface: ", selectedInterface, GLVclass.tRESET);
        }
		
		
	}

	void SelectInterface(string selectedInterface)
    {
        selectedInterface = selectedInterface.strip();
        if (selectedInterface.empty)
        {
            writeln("Error: Name fields cannot be empty!");
            return;
        }

        auto existingData = ManagerData.filter!(c => c.NameInterFace == selectedInterface).array;
        if (existingData.empty)
        {
            writeln("Error: No Interface found with Name Interface: ", selectedInterface);
            return;
        }

        this.selectedInterface = selectedInterface;
        writeln("Interface selected successfully");
        writeln("Selected Interface: ", selectedInterface);
    }


}
