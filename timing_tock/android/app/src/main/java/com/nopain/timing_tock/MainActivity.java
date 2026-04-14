package com.nopain.timing_tock;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okio.BufferedSink;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintStream;
import java.io.Writer;
import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.google.gson.*;
import com.google.gson.reflect.TypeToken;



public class MainActivity extends FlutterActivity {
    JsonObject jsonObject;
    JsonObject webJsonObject;
    String CHANNEL = "com.timing.tock/data";
    String CHANNEL2 = "com.timing.tock/web";
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine){
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler(
                (call,result)->{
                    ///向服务端同步数据
                    if (call.method.equals("submitData")){

                    }
                    if (call.method.equals("DeleteRecordData")){
                        System.out.println(call.arguments);
                        Map<String,Object> map=(Map<String,Object>)call.arguments;
                        ///日周月节点的引用
                        JsonObject recordRoot = null;
                        System.out.println("现在的JsonObject"+jsonObject);
                        switch ((int)map.get("recordTypeNumber")){
                            case 0:
                                recordRoot=jsonObject.getAsJsonObject("Days");
                                break;
                            case 1:
                                recordRoot=jsonObject.getAsJsonObject("Weeks");
                                break;
                            case 2:
                                recordRoot=jsonObject.getAsJsonObject("Months");
                                break;
                        }
                        System.out.println(recordRoot.get((String) map.get("TimeStamp")));
                        recordRoot.remove((String) map.get("TimeStamp"));
                        File file =new File(this.getFilesDir().toString(),"listData.json");
                        try (FileWriter writer=new FileWriter(file)){

                            new Gson().toJson(jsonObject,writer);


                        }catch (IOException e){

                        }
                        System.out.println("现在的JsonObject"+jsonObject);
                        result.success(true);


                    }
                    ///增加数据
                    if (call.method.equals("AddData")){

                        Map<String,Object> arg=(Map<String,Object>)call.arguments;

                        Map<String,Object> map= ArgToMap(
                                (String) arg.get("title"),
                                (int) arg.get("recordTypeNumber"),
                                (double) arg.get("time"),
                                (boolean)arg.get("ifDaKa"),
                                (boolean) arg.get("ifFinish"),
                                (double) arg.get("progress")


                        );
                        System.out.println("=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*");
                        System.out.println("******传进来的："+arg);

                        jsonObject.addProperty("TimeStamp",getTimeNow());

                        System.out.println("现在的JsonObject"+jsonObject);
                        File file =new File(this.getFilesDir().toString(),"listData.json");

                        ///日周月节点的引用
                        JsonObject recordRoot = null;

                        switch ((int)map.get("recordTypeNumber")){
                            case 0:
                                recordRoot=jsonObject.getAsJsonObject("Days");
                                break;
                            case 1:
                                recordRoot=jsonObject.getAsJsonObject("Weeks");
                                break;
                            case 2:
                                recordRoot=jsonObject.getAsJsonObject("Months");
                                break;
                        }
                        System.out.println("节点："+recordRoot);

                        ///内容
                        JsonObject content=new JsonObject();
                        String TimeNow=getTimeNow();

                        ///add内容的键对值
                        content.addProperty("title",(String) map.get("title"));
                        content.addProperty("recordTypeNumber",(int) map.get("recordTypeNumber"));
                        content.addProperty("time",(double) map.get("time"));
                        content.addProperty("ifDaKa",(boolean) map.get("ifDaKa"));
                        content.addProperty("ifFinish",(boolean) map.get("ifFinish"));
                        content.addProperty("progress",(double) map.get("progress"));
                        content.addProperty("recordTime",TimeNow);
                        content.addProperty("realTimeStamp",getTimeNow());


                        ///将当前时间作为每条记录的键值
                        recordRoot.add(TimeNow,content );

                        System.out.println("传出来的："+content);

                        System.out.println("现在的JsonObject"+jsonObject);

                        System.out.println("=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*");

                        Type type=new TypeToken<Map<String,Object>>(){}.getType();

                        System.out.println(recordRoot);





                        try (FileWriter fileWriter = new FileWriter(file)){
                            new Gson().toJson(jsonObject,fileWriter);


                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                        /**
                         * 我也不知道为什么要把这个节点返回去，别动
                         */
                        result.success(new Gson().fromJson(recordRoot,type));


                    }
                    ///增加数据
                    if (call.method.equals("ChangeRecordData")){

                        Map<String,Object> arg=(Map<String,Object>)call.arguments;

                        System.out.println("=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*");
                        System.out.println("******传进来的："+arg);

                        jsonObject.addProperty("TimeStamp",getTimeNow());

                        System.out.println("现在的JsonObject"+jsonObject);
                        File file =new File(this.getFilesDir().toString(),"listData.json");

                        ///日周月节点的引用
                        JsonObject recordRoot = null;

                        switch ((int)arg.get("recordTypeNumber")){
                            case 0:
                                recordRoot=jsonObject.getAsJsonObject("Days");
                                break;
                            case 1:
                                recordRoot=jsonObject.getAsJsonObject("Weeks");
                                break;
                            case 2:
                                recordRoot=jsonObject.getAsJsonObject("Months");
                                break;
                        }
                        System.out.println("节点："+recordRoot);

                        ///内容
                        JsonObject content=new JsonObject();

                        ///add内容的键对值
                        content.addProperty("title",(String) arg.get("title"));
                        content.addProperty("recordTypeNumber",(int) arg.get("recordTypeNumber"));
                        content.addProperty("time",(double) arg.get("time"));
                        content.addProperty("ifDaKa",(boolean) arg.get("ifDaKa"));
                        content.addProperty("ifFinish",(boolean) arg.get("ifFinish"));
                        content.addProperty("progress",(double) arg.get("progress"));
                        content.addProperty("recordTime",(String) arg.get("TimeStamp"));
                        content.addProperty("realTimeStamp",getTimeNow());


                        ///将当前时间作为每条记录的键值
                        recordRoot.add((String) arg.get("TimeStamp"),content );

                        System.out.println("传出来的："+content);

                        System.out.println("现在的JsonObject"+jsonObject);

                        System.out.println("=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*");

                        Type type=new TypeToken<Map<String,Object>>(){}.getType();

                        System.out.println(recordRoot);





                        try (FileWriter fileWriter = new FileWriter(file)){
                            new Gson().toJson(jsonObject,fileWriter);


                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                        /**
                         * 我也不知道为什么要把这个节点返回去，别动
                         */
                        result.success(new Gson().fromJson(recordRoot,type));


                    }
                    ///dart端询问是否第一次启动
                    if (call.method.equals("AskIfFirst")){
                        File file=new File(this.getFilesDir(),"listData.json");
                        result.success(file.exists());

                    }
                    ///从Java端同步json到dart,
                    if (call.method.equals("SyncJsonFromJavaLocal")){
                        File file=new File(this.getFilesDir(),"listData.json");

                        ///若json存在时
                        if (file.exists()){

                            try (FileReader reader=new FileReader(file)){

                                ///定义Type类型
                                Type type=new TypeToken<Map<String,Object>>(){}.getType();

                                ///从reader（Json）读取为<Map<String,Object>>端map
                                Map map= new Gson().fromJson(reader,type);

                                jsonObject = new Gson().toJsonTree(map).getAsJsonObject();
                                ///结果返回
                                result.success(map);


                            }catch (IOException e){}


                            ///若没有Json（即第一次启动）
                        }else {
                            try (FileWriter writer =new FileWriter(file)){
                                ///定义Type类型
                                Type type=new TypeToken<Map<String,Object>>(){}.getType();
                                ///定义根节点
                                JsonObject root=new JsonObject();

                                ///定义日周月节点
                                JsonObject dayRoot=new JsonObject();
                                JsonObject weekRoot=new JsonObject();
                                JsonObject monthRoot=new JsonObject();

                                root.add("Days",dayRoot);
                                root.add("Weeks",weekRoot);
                                root.add("Months",monthRoot);
                                root.addProperty("TimeStamp","1990-04-14 11:14:46");

                                ///向writer写入root
                                new Gson().toJson(root,writer);

                                jsonObject=root;
                                ///将root转为map传回
                                result.success(new Gson().fromJson(root,type));

                            }catch (IOException e){

                            }
                        }
                    }

            }
        );
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL2).setMethodCallHandler(
                (call,result)->{
                    if (call.method.equals("SyncJsonFromWeb")){
                        OkHttpClient okHttpClient =new OkHttpClient();
                        MediaType jsonType=MediaType.get("application/json; charset=utf-8");
                        RequestBody requestBody=RequestBody.create(jsonObject.toString(),jsonType);
                        Request request =new Request.Builder()
                                .url("http://frp-cup.com:39691/sync")
                                .post(requestBody)
                                .build();
                        okHttpClient.newCall(request).enqueue(new  Callback(){

                            @Override
                            public void onResponse(@NonNull Call call, @NonNull Response response) throws IOException {
                                System.out.println("Connect !!!");
                                System.out.println(response.code());
                                runOnUiThread(()->{
                                    result.success(true);
                                });
                            }

                            @Override
                            public void onFailure(@NonNull Call call, @NonNull IOException e) {
                                System.out.println("False !!!");
                                System.out.println(e);
                                System.out.println(e.getMessage());
                            }
                        });

                    }
                    if (call.method.equals("CheckLogIn")){
                        File file=new File(this.getFilesDir(),"UserInfo.json");
                        Map<String,Object> map=null;
                        if (file.exists()){

                            try (FileReader reader =new FileReader(file)){



                                Type type =new TypeToken<Map<String,String>>(){}.getType();
                                map = new Gson().fromJson(reader,type);
                                webJsonObject=new Gson().toJsonTree(map).getAsJsonObject();


                            }catch (IOException e){

                            }
                        }else {
                            try (FileWriter writer =new FileWriter(file)){
                                JsonObject accRoot =new JsonObject();
                                accRoot.addProperty("Account","null");
                                accRoot.addProperty("Password","null");
                                accRoot.addProperty("Json","null");
                                new Gson().toJson(accRoot,writer);
                                Type type =new TypeToken<Map<String,String>>(){}.getType();
                                map=new Gson().fromJson(accRoot,type);
                                webJsonObject=accRoot;

                            }catch (IOException e){

                            }
                        }
                        System.out.println(map);
                        result.success(map);
                    }
                    if (call.method.equals("TryLogIn")){
                        OkHttpClient okHttpClient=new OkHttpClient();
                        MediaType mediaType =MediaType.get("application/json; charset=utf-8");

                        JsonObject jsonObject1=new JsonObject();

                        jsonObject1.addProperty("Account", ((List<String>) call.arguments).get(0));
                        jsonObject1.addProperty("Password", ((List<String>) call.arguments).get(1));
                        RequestBody requestBody=RequestBody.create(jsonObject1.toString(),mediaType);
                        Request request =new Request.Builder()
                                .url("http://frp-cup.com:39691/login")
                                .post(requestBody)
                                .build();
                        MainActivity m= this;
                        okHttpClient.newCall(request).enqueue(new Callback() {
                            @Override
                            public void onFailure(@NonNull Call call, @NonNull IOException e) {

                                runOnUiThread(()->{
                                    result.success("网络错误");
                                });
                            }

                            @Override
                            public void onResponse(@NonNull Call call, @NonNull Response response) throws IOException {
                                if (response.isSuccessful()){
                                    String resultBody= response.body().string();

                                    System.out.println(resultBody);
                                    if (resultBody.startsWith("{")){

                                        System.out.println("登陆成功");
                                        runOnUiThread(()->{
                                            File file =new File(m.getFilesDir(),"UserInfo.json");
                                            try (FileWriter writer=new FileWriter(file)){

                                                writer.write(resultBody);
                                                //new Gson().toJson(resultBody,writer);
                                                webJsonObject=JsonParser.parseString(resultBody).getAsJsonObject();

                                            }catch (IOException e){

                                            }

                                            result.success(new Gson().fromJson(resultBody,new TypeToken<Map<String,String>>(){}.getType()));
                                        });
                                    }else {
                                        runOnUiThread(()->{
                                            //密码错误 or 没有账户
                                            result.success(resultBody);
                                        });

                                    }
                                }else {
                                    runOnUiThread(()->{
                                        //密码错误 or 没有账户
                                        result.success("网络错误");
                                    });
                                }


                            }
                        });

                    }
                    if (call.method.equals("TrySignIn")){
                        OkHttpClient okHttpClient=new OkHttpClient();
                        MediaType mediaType =MediaType.get("application/json; charset=utf-8");

                        JsonObject jsonObject1=new JsonObject();

                        jsonObject1.addProperty("Account", ((List<String>) call.arguments).get(0));
                        jsonObject1.addProperty("Password", ((List<String>) call.arguments).get(1));
                        RequestBody requestBody=RequestBody.create(jsonObject1.toString(),mediaType);
                        Request request =new Request.Builder()
                                .url("http://frp-cup.com:39691/signin")
                                .post(requestBody)
                                .build();

                        okHttpClient.newCall(request).enqueue(new Callback() {
                            @Override
                            public void onFailure(@NonNull Call call, @NonNull IOException e) {
                                runOnUiThread(()->{
                                    result.success("网络错误");
                                });
                            }

                            @Override
                            public void onResponse(@NonNull Call call, @NonNull Response response) throws IOException {
                                if (response.isSuccessful()){
                                    String resultBody= response.body().string();
                                    System.out.println(resultBody);
                                    if (resultBody.startsWith("{")){
                                        System.out.println("注册成功");
                                        Type type =new TypeToken<Map<String,String>>(){}.getType();
                                        runOnUiThread(()->{




                                            result.success(new Gson().fromJson(resultBody,type));
                                        });


                                    }else {
                                        System.out.println("账户重复");
                                        runOnUiThread(()->{
                                            result.success(resultBody);//账户重复
                                        });

                                    }
                                }else {
                                    runOnUiThread(()->{
                                        result.success("网络错误");//账户重复
                                    });
                                }
                            }
                        });

                    }
                    if (call.method.equals("ExitAccount")){
                        File file = new File(getFilesDir(),"UserInfo.json");
                        Map<String,String> map=new HashMap<>();
                        try (FileReader reader =new FileReader(file)){
                            Type type = new TypeToken<Map<String,String>>(){}.getType();
                            map=new Gson().fromJson(reader,type);
                        }catch (IOException e){

                        }
                        System.out.println("=*");
                        System.out.println(map.get("account"));
                        map.put("account","null");

                        try (FileWriter fileWriter =new FileWriter(file)){
                            new Gson().toJson(map,fileWriter);
                        }catch (IOException e){

                        }

                        File file1=new File(getFilesDir(),"listData.json");
                        try (FileWriter writer =new FileWriter(file1)){
                            JsonObject root=new JsonObject();
                            JsonObject Days=new JsonObject();
                            JsonObject Weeks=new JsonObject();
                            JsonObject Months=new JsonObject();
                            root.add("Days",Days);
                            root.add("Weeks",Weeks);
                            root.add("Months",Months);
                            root.addProperty("TimeStamp","1990-04-14 10:48:22");
                            new Gson().toJson(root,writer);

                        }catch (IOException e){

                        }


                        result.success(true);
                    }
                    if (call.method.equals("SyncData")){
                        OkHttpClient okHttpClient =new OkHttpClient();
                        MediaType mediaType =MediaType.get("application/json; charset=utf-8");

                        JsonObject jsonObject1 =new JsonObject();
                        jsonObject1.addProperty("Account",(String) call.arguments);

                        File file =new File(this.getFilesDir(),"listData.json");
                        try (FileReader fileReader = new FileReader(file)){
                            jsonObject1.add("JSON",JsonParser.parseReader(fileReader).getAsJsonObject());

                        }catch (IOException e){

                        }
                        System.out.println("=====同步时发去的=====");
                        System.out.println(jsonObject1.toString());


                        RequestBody requestBody = RequestBody.create(jsonObject1.toString(),mediaType);
                        Request request =new Request.Builder()
                                .url("http://frp-cup.com:39691/sync")
                                .post(requestBody)
                                .build();
                        okHttpClient.newCall(request).enqueue(new Callback() {
                            @Override
                            public void onFailure(@NonNull Call call, @NonNull IOException e) {
                                System.out.println("同步失败");
                            }

                            @Override
                            public void onResponse(@NonNull Call call, @NonNull Response response) throws IOException {
                                String JsonStr=response.body().string();
                                System.out.println("=====同步时传回的=====");
                                System.out.println(JsonStr);
                                final Map<String,Object> map;
                                try (FileWriter writer =new FileWriter(file)){
                                    Type type =new TypeToken<Map<String,Object>>(){}.getType();
                                    map= new Gson().fromJson(JsonStr,type);
                                    writer.write(JsonStr);
                                    jsonObject=JsonParser.parseString(JsonStr).getAsJsonObject();

                                    runOnUiThread(()->{
                                        result.success(true);
                                    });
                                }catch (IOException e){
                                }



                            }
                        });
                    }
                }
        );
    }
    public  Map<String,Object> ArgToMap(
            String title,
            int recordTypeNumber,
            double time,
            boolean ifDaKa,
            boolean ifFinish,
            double progress
    ){
        Map<String,Object> taskData=new HashMap<>();
        taskData.put("title",title);
        taskData.put("recordTypeNumber",recordTypeNumber);
        taskData.put("time",time);
        taskData.put("ifDaKa",ifDaKa);
        taskData.put("ifFinish",ifFinish);
        taskData.put("progress",progress);

        return taskData;
    }
    public String getTimeNow(){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(new Date());
    }

}
