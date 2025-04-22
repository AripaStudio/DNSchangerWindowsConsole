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

    JSONValue toJson()
    {
        return JSONValue([
            "NameInterFace": JSONValue(NameInterFace)
			]);
    }

    static JsonDataFileManager fromJson(JSONValue json)
    {
        auto result = new JsonDataFileManager();
        if ("NameInterFace" in json)
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
				if(json.type != JSONType.object)
				{
					writeln(GLVclass.tRED, "Error: JSON root is not an object!", GLVclass.tRESET);
                    ManagerData = [];
                    selectedInterface = null;
                    return;
				}
				if("Interfaces" in json && json["Interfaces"].type == JSONType.array)
				{
					ManagerData = json["Interfaces"].array.map!(j => JsonDataFileManager.fromJson(j)).array;
				}else
				{
					ManagerData = [];
				}

				if("SelectedInterFace" in json && json["SelectedInterFace"].type == JSONType.string)
                {
                    selectedInterface = json["SelectedInterFace"].str;
                }
                else
                {
                    selectedInterface = null;
                }
				
			}catch(JSONException e)
			{
				writeln(GLVclass.tRED, "Error parsing JSON file: ", e.msg, GLVclass.tRESET);
                ManagerData = [];
                selectedInterface = null;
			}
		}else
		{
			ManagerData = [];
			selectedInterface = null;
			saveData();
		}
	}

	private void saveData()
	{
		JSONValue json ;
		json["Interfaces"]= JSONValue(ManagerData.map!(c => c.toJson()).array);
		json["SelectedInterFace"] = JSONValue(selectedInterface);		
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
        try
        {
            saveData();
            writeln("Interface selected successfully");
            writeln("Selected Interface: ", selectedInterface);
        }
        catch (Exception e)
        {
            writeln("Error saving data: ", e.msg);
        }
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
		if(selectedInterface == NameInterface)
		{
			selectedInterface = null;
		}

		saveData();
		writeln(NameInterface , " deleted successfully!");
	}


	void ShowAll()
	{
		if (ManagerData.empty)
        {
            writeln("No Data found!");
            return;
        }

        foreach (Data; ManagerData)
        {
            writeln("Name InterFace: ", Data.NameInterFace);
            writeln(GLVclass.tBLUE, "-----------", GLVclass.tRESET);
        }

        if (selectedInterface is null || selectedInterface.empty)
        {
            writeln(GLVclass.tBLUE, "No Interface selected.", GLVclass.tRESET);
        }
        else
        {
            writeln(GLVclass.tBLUE, "Selected Interface: ", selectedInterface, GLVclass.tRESET);
        }
		
		
	}



}
