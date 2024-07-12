package com.example.demo.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.pojo.Response;
import com.example.demo.pojo.Score;
import com.example.demo.mapper.AppMapper;
import com.example.demo.pojo.App;

@Service
public class AppService {
    @Autowired
    AppMapper appMapper;

    // 查询app
    public Response appSearch(String appName) {
        List<App> t_app = appMapper.searchApp(appName);
        Response response = new Response();
        if (t_app == null) {
            response.setCode(400);
            response.setMessage("查询失败！");
        } else {
            response.setCode(200);
            response.setMessage("查询成功！");
            response.setData(t_app);
        }
        return response;
    }

    public Response appAll() {
        List<App> t_app = appMapper.allApp();
        Response response = new Response();
        if (t_app == null || t_app.isEmpty()) {
            response.setCode(400);
            response.setMessage("查询失败！");
        } else {
            response.setCode(200);
            response.setMessage("查询成功！");
            response.setData(t_app);
        }
        return response;
    }

    // 精确搜索应用内容

    public Response appIdFind(int appId) {
        Response res = new Response();
        App app = appMapper.appIdFind(appId);
        if (app == null) {
            res.setCode(400);
            res.setMessage("应用不存在");
        } else {
            res.setCode(200);
            res.setMessage("搜索成功");
            res.setData(app);
        }
        return res;
    }

    public App appById(int id) {
        return appMapper.appIdFind(id);
    }

    public Response SearchCoprByTel(String tel)
    {
        Response res = new Response();
        String corp = appMapper.findCoprByTel(tel);
        if (corp == null) {
            res.setCode(400);
            res.setMessage("公司不存在");  
        }
        else {
            res.setCode(200);
            res.setMessage("搜索成功");
            res.setData(corp);
        }
        return res;
    }

    // 添加应用
    public Response addApp(App app, Score score, String tel) {
        Response response = new Response();
        String corp = appMapper.findCoprByTel(tel);
        app.setCorp(corp);
        appMapper.addApp(app);
        appMapper.addScore(score);
        response.setCode(200);
        response.setMessage("添加成功");
        return response;
    }

    public Response updateApp(App app) {
        Response response = new Response();
        appMapper.updateApp(app);
        response.setCode(200);
        response.setMessage("更新成功");
        return response;
    }

    public Response splByTag(int tag) {
        Response response = new Response();
        List<App> apps = appMapper.splByTag(tag);
        response.setCode(200);
        response.setMessage("分类成功");
        response.setData(apps);
        return response;
    }

    public Response splByTel(String tel) {
        Response response = new Response();
        String corp = appMapper.findCoprByTel(tel);
        System.out.println(corp);
        List<App> apps = appMapper.splByCorp(corp);
        response.setCode(200);
        response.setMessage("分类成功");
        response.setData(apps);
        return response;
    }

    public Response delById(int id) {
        Response res = new Response();
        appMapper.delById(id);
        appMapper.delByIdScore(id);
        res.setCode(200);
        res.setMessage("删除成功");
        return res;
    }

    public Response getAppScore(int appID) {
        Response response = new Response();
        String score = appMapper.getAppScore(appID);
        response.setCode(200);
        response.setMessage("获取成功");
        response.setData(score);
        return response;
    }

    public Response getAppScoreNum(int appID) {
        Response res = new Response();
        int scoreNum = appMapper.getAppScoreNum(appID);
        res.setCode(200);
        res.setMessage("获取成功");
        res.setData(scoreNum);
        return res;
    }

    public Response updateScore(Score score) {
        Response response = new Response();
        String oldScore = appMapper.getAppScore(score.getAppID());
        int num = appMapper.getAppScoreNum(score.getAppID());
        double oldScoreDouble;
        try {
            oldScoreDouble = Double.parseDouble(oldScore);
        } catch (NumberFormatException e) {
            // 处理转换失败的情况
            oldScoreDouble = 0.0; // 或者其他适当的默认值
            System.err.println("无法将oldScore转换为double: " + e.getMessage());
        }
        double allScore = num * oldScoreDouble;

        double scoreDouble;
        try {
            scoreDouble = Double.parseDouble(score.getScore());
        } catch (NumberFormatException e) {
            // 处理转换失败的情况
            scoreDouble = 0.0; // 或者其他适当的默认值
            System.err.println("无法将scoreDouble转换为double: " + e.getMessage());
        }
        double newScore = (allScore + scoreDouble) / (num + 1);
        score.setScore(String.valueOf(newScore));
        num++;
        score.setNum(num);
        int result = appMapper.updateScore(score);
        response.setCode(200);
        response.setMessage("更新成功");
        response.setData(result);
        return response;
    }
}
