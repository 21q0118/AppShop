package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.pojo.App;

import com.example.demo.pojo.Score;

import jakarta.annotation.Resource;

@Mapper
@Resource
public interface AppMapper {
    // App����
    int addApp(App app);
    int addScore(Score Score);

    // ????
    List<App> searchApp(String appName);

    List<App> allApp();

    App appIdFind(int appId);

    int updateApp(App app);

    String findCoprByTel(String telephone);

    List<App> splByTag(int tag);

    List<App> splByCorp(String corp);

    int delById(int id);

    int delByIdScore(int id);

    String getAppScore(int appID);

    int getAppScoreNum(int appID);

    int updateScore(Score score);
}
