package com.example.demo.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.Random;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.pojo.Response;
import com.example.demo.pojo.App;
import com.example.demo.pojo.Score;
import com.example.demo.service.AppService;
import com.example.demo.service.FileService;
import com.example.demo.service.IconService;
import com.example.demo.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
// @RequestMapping("/secure")
public class AppController {
    @Autowired
    AppService appService;
    @Autowired
    FileService fileService;
    @Autowired
    IconService iconService;

    @PostMapping("/addApp")
    public Response addApp(@RequestBody App app, @RequestParam String telephone,
            HttpServletRequest request,
            HttpServletResponse response)
            throws SQLException {
        Score score = new Score();

        Date d = fileService.getCurTime();
        // String size = fileService.getFileSize(app.getApk());
        Random random = new Random();
        Integer number = random.nextInt(900000) + 100000;

        // app.setSize(size);
        app.setUpdateTime(d);
        app.setCreate_time(d);
        app.setId(Integer.valueOf(number));

        score.setAppID(Integer.valueOf(number));
        score.setScore("5.0");
        score.setNum(0);
        // String telephone = "11";
        Response res = appService.addApp(app, score, telephone);
        // try {
        // fileService.upload(request, response);
        // } catch (Exception e) {
        // e.printStackTrace();
        // }

        return res;
    }

    @PostMapping("/appAll")
    public Response appAll() throws SQLException {
        Response res = appService.appAll();
        return res;
    }

    @PostMapping("/appSearch")
    public Response appSearch(@RequestParam String appName) throws SQLException {
        // 调用服务处理请求
        Response response = appService.appSearch(appName);
        return response;
    }

    @GetMapping("/downloadApp")
    public void downloadApp(@RequestParam int id, HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        System.out.println(id);
        App app = appService.appById(id);
        String apkName = app.getApk();
        fileService.download(apkName, request, response);
    }

    @PostMapping("/updateApp")
    public Response updateApp(@RequestBody App app) {
        System.out.println(app);
        // String size = fileService.getFileSize(app.getApk());
        // app.setSize(size);
        Date d = fileService.getCurTime();
        app.setUpdateTime(d);
        Response res = appService.updateApp(app);
        return res;
    }

    @PostMapping("/searchAppByTag")
    public Response splAppByTag(@RequestParam int tag) {
        Response res = appService.splByTag(tag);
        return res;
    }

    @PostMapping("/searchAppByMan")
    public Response sqlAppByMan(@RequestParam String telephone) {
        Response res = appService.splByTel(telephone);
        return res;
    }

    @PostMapping("/searchAppByID")
    public Response appIdFind(@RequestParam int appId) {
        return appService.appIdFind(appId);
    }

    @PostMapping("/delAppById")
    public Response delAppById(@RequestParam int id) {
        return appService.delById(id);
    }

    @PostMapping("/getAppScore")
    public Response getAppScore(@RequestParam int appId) {
        return appService.getAppScore(appId);
    }

    @PostMapping("/getAppScoreNum")
    public Response getAppScoreNum(@RequestParam int appId) {
        return appService.getAppScoreNum(appId);
    }

    @PostMapping("/updateScore")
    public Response updateScore(@RequestBody Score score) {
        System.out.println(score);
        Response res = appService.updateScore(score);
        return res;
    }


    @PostMapping("/SearchCoprByTel")
    public Response SearchCoprByTel(@RequestParam String telephone) {
        return appService.SearchCoprByTel(telephone);
    }
}
