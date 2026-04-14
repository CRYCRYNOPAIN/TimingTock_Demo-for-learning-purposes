
using  MySqlConnector;
using System;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Xml;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace Timing_tock
{
    public record RecordItem(
        string title,
        double recordTypeNumber,
        double time,
        bool ifDaKa,
        bool ifFinish,
        double progress,
        string recordTime,
        string realTimeStamp
    );
    public record RootData(
        Dictionary<string, RecordItem> Days,
        Dictionary<string, RecordItem> Weeks,
        Dictionary<string, RecordItem> Months,
        string TimeStamp
    );
    //账户对象
    public record AccountInfo(string Account,string Password);

    public record SyncData(string Account,RootData JSON);
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);
            
            builder.Services.ConfigureHttpJsonOptions(options =>
            {
                options.SerializerOptions.PropertyNamingPolicy = null;
            });
            var app = builder.Build();

            app.MapPost("/login",async (AccountInfo accountInfo) => {
                Console.WriteLine("登录:"+accountInfo.Account+"  -  "+accountInfo.Password);
                string connectString = "Server=localhost;User ID=root;Password=UnRd1221;Database=TimingTock";
                using MySqlConnection mySqlConnection = new MySqlConnection(connectString);
                string sqlString = "SELECT * FROM AccPwJSON WHERE Account = @Account";
                await mySqlConnection.OpenAsync();

                using MySqlCommand cmd =new MySqlCommand( sqlString,mySqlConnection);

                cmd.Parameters.AddWithValue("@Account",accountInfo.Account);
                using var reader = await cmd.ExecuteReaderAsync();
                int count = 0;
                while (await reader.ReadAsync())
                {
                    count++;
                    if (accountInfo.Password.Equals(reader.GetString("UserPW")))
                    {
                        string account = reader.GetString("Account");
                        string password = reader.GetString("UserPW");
                        string Json = File.ReadAllText(reader.GetString("JsonPath"));
                        Console.WriteLine("密码正确");
                        Console.WriteLine(account+"   "+password+"   "+Json);
                        
                        return Results.Ok(new { Account=account,Password=password,Json=Json });
                    }
                    else
                    {
                        Console.WriteLine("密码错误");
                        return Results.Text("密码错误");
                    }
                    
                    
                }
                
                return Results.Text("没有账户");
                



            });
            app.MapPost("/signin", async (AccountInfo accountInfo) => {

                Console.WriteLine("注册:" + accountInfo.Account + "  -  " + accountInfo.Password);
                
                string connectString = "Server=localhost;User ID=root;Password=UnRd1221;Database=TimingTock";
                using MySqlConnection mySqlConnection = new MySqlConnection(connectString);
                await mySqlConnection.OpenAsync();

                string sqlCMD = "INSERT INTO AccPwJSON (Account , UserPW,JsonPath) VALUES(@Account , @UserPW,@JsonPath)";
                string sqlString = "SELECT * FROM AccPwJSON WHERE Account = @Account";



                MySqlCommand mySqlCommand = new MySqlCommand(sqlCMD,mySqlConnection);
                MySqlCommand mySqlCommand2 = new MySqlCommand(sqlString, mySqlConnection);

                mySqlCommand2.Parameters.AddWithValue("@Account",accountInfo.Account);

                using (var reader = await mySqlCommand2.ExecuteReaderAsync())
                {
                    int count= 0;
                    while(await reader.ReadAsync())
                    {
                        count++;
                    }
                    if (count>0)
                    {
                        Console.WriteLine("账户重复");
                        return Results.Text("账户重复");
                    }
                }
                
                mySqlCommand.Parameters.AddWithValue("@Account", accountInfo.Account);
                mySqlCommand.Parameters.AddWithValue("@UserPW", accountInfo.Password);

                JsonObject root= new JsonObject();
                JsonObject Days= new JsonObject();
                JsonObject Weeks= new JsonObject();
                JsonObject Months= new JsonObject();
                root.Add("Days",Days);
                root.Add("Weeks", Weeks);
                root.Add("Months", Months);
                root.Add("TimeStamp",GetTimeNow());
                Directory.CreateDirectory(Path.GetDirectoryName("UserData/"+ accountInfo.Account+".json")!);
                File.WriteAllText("UserData/" + accountInfo.Account + ".json", root.ToString());


                mySqlCommand.Parameters.AddWithValue("@JsonPath", "UserData/" + accountInfo.Account + ".json");
                await mySqlCommand.ExecuteNonQueryAsync();
                return Results.Ok(new { Account = accountInfo.Account, UserPw = accountInfo.Password });



            });
            app.MapPost("/sync", async (SyncData SyncData) =>
            {
                string connectString = "Server=localhost;User ID=root;Password=UnRd1221;Database=TimingTock";
                MySqlConnection mySqlConnection =  new MySqlConnection(connectString);
                await mySqlConnection.OpenAsync();
                string sqlString = "SELECT JsonPath FROM AccPwJSON WHERE Account = @Account";
                MySqlCommand mySqlCommand =new MySqlCommand(sqlString,mySqlConnection);

                mySqlCommand.Parameters.AddWithValue("@Account",SyncData.Account);

                string json= (string)(await mySqlCommand.ExecuteScalarAsync());

                Console.WriteLine(File.ReadAllText(json));
                using JsonDocument doc = JsonDocument.Parse(File.ReadAllText(json));

                JsonElement root = doc.RootElement;
                string timeStamp = root.GetProperty("TimeStamp").GetString();

                DateTime local =DateTime.Parse(SyncData.JSON.TimeStamp);
                DateTime cloud = DateTime.Parse(timeStamp);

                Console.WriteLine("本地时间戳"+SyncData.JSON.TimeStamp);
                Console.WriteLine("云端时间戳"+timeStamp);


                if (local<cloud)
                {
                    return Results.Content(File.ReadAllText(json), "application/json");
                }
                else
                {
                    File.WriteAllText(json, JsonSerializer.Serialize(SyncData.JSON));
                    return Results.Ok(SyncData.JSON);
                }


                

            });



            app.Run("http://127.0.0.1:9178");
        }
        public static string GetTimeNow()
        {
            return DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
        }
    }

}
