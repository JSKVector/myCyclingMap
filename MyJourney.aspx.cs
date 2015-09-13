using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Data.SqlClient;

using System.Web.Services;
using System.Web.Script.Services;    
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Net;
using System.IO;
using System.Text;
using System.Web.Script.Serialization;
using System.Collections; 


public partial class MyJourney : System.Web.UI.Page
{
   
    protected void Page_Load(object sender, EventArgs e)
    {
        emptyFile();
        this.DropDownList1.SelectedIndexChanged += new System.EventHandler(this.DropDownList1_SelectedIndexChanged); 
    }
   
    public void emptyFile()
    {
        string Wipe = "";
        string virtualPath = "JsonText.txt";
        string physicsPath = Server.MapPath(virtualPath);
        TextWriter tw1 = new StreamWriter(physicsPath);
        tw1.WriteLine(Wipe);
        tw1.Close();
    }

    public void creatFile(string jsonString)
    {
        string Wipe = "";
        string virtualPath = "JsonText.txt";
        string physicsPath = Server.MapPath(virtualPath);
        TextWriter tw1 = new StreamWriter(physicsPath);
        tw1.WriteLine(Wipe);
        tw1.Close();
        TextWriter tw = new StreamWriter(physicsPath);
        tw.WriteLine(jsonString);
        tw.Close();
    }
    public string ToJson(DataTable dt)
    {
        JavaScriptSerializer javaScriptSerializer = new JavaScriptSerializer();
        javaScriptSerializer.MaxJsonLength = Int32.MaxValue; 
        ArrayList arrayList = new ArrayList();
        foreach (DataRow dataRow in dt.Rows)
        {
            Dictionary<string, object> dictionary = new Dictionary<string, object>();  
            foreach (DataColumn dataColumn in dt.Columns)
            {
                dictionary.Add(dataColumn.ColumnName, dataRow[dataColumn.ColumnName].ToString());
            }
            arrayList.Add(dictionary); 
        }

        return javaScriptSerializer.Serialize(arrayList); 
    }

    public void connectDB(String sql)
    {
        //string constr = "Data Source=;Initial Catalog=Cycle;Integrated Security=True";
        string constr = "Server=tcp:l1x253hd6a.database.windows.net,1433;Database=Cycle;User ID=JSKtech201@l1x253hd6a;Password=a656691bc,./;Trusted_Connection=False;Encrypt=True;Connection Timeout=30;";
        using (SqlConnection con = new SqlConnection(constr))
        {
            con.Open();
            SqlDataAdapter sda = new SqlDataAdapter(sql, con);
            DataSet ds = new DataSet();
            con.Close();
            sda.Fill(ds);
            DataTable dt1 = new DataTable();
            //dt1.Columns.Add(new DataColumn("Latitude", typeof(double)));
            //dt1.Columns.Add(new DataColumn("Longitude", typeof(double)));
            dt1 = ds.Tables[0];
            string Passing = ToJson(dt1);
            creatFile(Passing);
        }
    }

    public void DrinkFoun()
    {
       string sql = "select Latitude,Longitude,Description from Drink ";
        connectDB(sql);    
    }
    public void ParkingPod()
    {
        string sql = "select Latitude,Longitude,Featurename,NBBikes from Bike ";
        
        connectDB(sql);
    }
    public void PublicCommode()
    {
        string sql = "select Latitude,Longitude,Male,Female,Disabled,Unisex,Babychange from Toilets "; 
        connectDB(sql);
    }
    public void NournishmentHub()
    {
        string sql = "select Latitude,Longitude,Category,What,Who,Phone,Website from Food ";
        
        connectDB(sql);
    }
    public void Blackspot()
    {
       string sql = "select Latitude,Longitude from Blackspot ";
        
        connectDB(sql);
    }
    public void Art()
    {
        string sql = "select Latitude,Longitude, [Asset Type],Artist,[Respective Author],Structure from Art ";

        connectDB(sql);
    }

    public void LandMarks()
    {
        string sql = "select Latitude,Longitude,Theme,[Sub Theme],[Feature Name] from LandMarks";

        connectDB(sql);
    }
    public void Stops()
    {
        string sql = "select Latitude,Longitude,Name,Address from Stops";
        connectDB(sql);
    }

    protected void DropDownList1_SelectedIndexChanged(object sender,EventArgs e)
    {
        string x = DropDownList1.SelectedItem.Text;
        switch(x)
        {
            case "My Journey":
                emptyFile();
                return;
            case "Drink Fountains":
                emptyFile();
                DrinkFoun();
                return;
            case "Food & Drinks venue":
                emptyFile();
                NournishmentHub();
                return;
            case "Parking Pod":
                emptyFile();
                ParkingPod();
                return;
            case "Public Toilets":
                emptyFile();
                PublicCommode();
                return;
            case "Blackspot Area":
                emptyFile();
                Blackspot();
                return;
            case "Public Art Works":
                emptyFile();
                Art();
                return;
            case "LandMarks & Places Of Interest":
                emptyFile();
                LandMarks();
                return;
            case "Visitor Shuttle Bus Stops":
                emptyFile();
                Stops();
                return;

        }
    }

}