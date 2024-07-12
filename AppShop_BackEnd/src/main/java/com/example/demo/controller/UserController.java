package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.service.IconService;
import com.example.demo.service.UserService;

import jakarta.servlet.http.HttpServletResponse;

import com.example.demo.jwt.JwtUtil;
import com.example.demo.pojo.Response;
import com.example.demo.pojo.User;
import com.example.demo.pojo.Corp;

import java.sql.Date;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
public class UserController {
    @Autowired
    UserService userService;

    @PostMapping("/register")
    public Response register(@RequestBody User user) throws SQLException {
        // 获取当前时间
        LocalDateTime currentTime = LocalDateTime.now();
        // 设置创建时间到 user 对象
        //user.setCreate_time(currentTime);
        System.out.println(user);
        Response response = userService.register(user);
        return response;
    }

    @PostMapping("/login")
    public Response login(@RequestBody User user, HttpServletResponse response) throws SQLException {
        System.out.println(user);
        Response res = userService.login(user);
        Object u = res.getData();
        String token = JwtUtil.createToken(user);
        Map data = new HashMap<String, Object>() {
            {
                put("User", u);
                put("token", token);
            }
        };
        res.setData(data);
        return res;
    }


    
    

    @PostMapping("/userInfo")
    public Response getInfo(@RequestParam String telephone) {
        return userService.getInfo(telephone);
    }

    @PostMapping("/updateUser")
    public Response updateInfo(@RequestBody User user) {
        return userService.updateInfo(user);
    }

    @PostMapping("/updatePw")
    public Response updatePw(@RequestBody User user) {
        return userService.updatePw(user);
    }

    @PostMapping("/searchUser")
    public Response searchUser() throws SQLException {
        Response res = userService.searchUser();
        return res;
    }

    @PostMapping("/searchUserByTag")
    public Response splAppByTag(@RequestParam int tag) {
        Response res = userService.searchUserByTag(tag);
        return res;
    }

    @PostMapping("/delUser")
    public Response delUser(@RequestParam String telephone) {
        Response res = userService.delUser(telephone);
        return res;
    }

    @PostMapping("/commitManager")
    public Response commitManager(@RequestBody Corp corp) {
        Response res = userService.commitManager(corp);
        return res;
    }

    
    @PostMapping("/commitUser")
    public Response commitUser(@RequestBody Corp corp) {
        Response res = userService.commitUser(corp);
        return res;
    }

    @PostMapping("/agreeManager")
    public Response agreeManager(@RequestBody Corp corp) {
        Response res = userService.agreeManager(corp);
        return res;
    }

    @PostMapping("/disagreeManager")
    public Response disagreeManager(@RequestBody Corp corp) {
        Response res = userService.disagreeManager(corp);
        return res;
    }
    
    @PostMapping("/allCommit")
    public Response allCommit()throws SQLException {
        Response res = userService.allCommit();
        return res;
    }
}