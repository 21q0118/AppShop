package com.example.demo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.AppMapper;
import com.example.demo.mapper.UserMapper;
import com.example.demo.pojo.App;
import com.example.demo.pojo.Corp;
import com.example.demo.pojo.Response;
import com.example.demo.pojo.User;

@Service
public class UserService {
    @Autowired
    UserMapper userMapper;

    // 登录
    public Response login(User user) {
        User t_user = userMapper.queryTwo(user);
        Response response = new Response();
        if (t_user != null) {
            response.setCode(200);
            response.setMessage("登录成功！");
            response.setData(t_user);
        } else {
            response.setCode(400);
            response.setMessage("用户名或密码错误！");
        }
        return response;
    }

    // 注册
    public Response register(User user) {
        User t_user = userMapper.queryOne(user.getTelephone());
        Response response = new Response();
        if (t_user == null) {
            String t_userName = user.getUserName();
            String t_password = user.getPassword();
            String t_telephone = user.getTelephone();
            //String t_icon = user.getIcon();
            String t_icon = "/profilePhoto/default.jpg";
            String t_petName = "default";
            int t_tag = 1;
            userMapper.add(t_userName, t_password, t_telephone, t_icon, t_petName, t_tag);
            response.setCode(200);
            response.setMessage("注册成功！");
        } else {
            response.setCode(400);
            response.setMessage("该用户名已被注册！");
        }
        return response;
    }

    @Autowired
    AppMapper appMapper;

    public Response getInfo(String telephone) {
        Response res = new Response();
        User t_user = userMapper.queryOne(telephone);
        if (t_user == null) {
            res.setCode(400);
            res.setMessage("用户不存在");
        } else {
            res.setCode(200);
            res.setMessage("获取信息成功");
            System.out.println(telephone);
            String corp = appMapper.findCoprByTel(telephone);
            System.out.println(corp);
            System.out.println(t_user);
            if (corp == null) {
                Map<String, Object> data = new HashMap<String, Object>() {
                    {
                        put("corp", corp);
                        put("user", t_user);
                    }
                };
                res.setData(data);
                // res.setData(t_user);
            } else {
                Map<String, Object> data = new HashMap<String, Object>() {
                    {
                        put("corp", corp);
                        put("user", t_user);
                    }
                };
                res.setData(data);
            }
        }
        return res;

    }

    public Response updateInfo(User user) {
        Response res = new Response();
        User t_user = userMapper.queryOne(user.getTelephone());
        if (t_user != null) {
            userMapper.update(user);
            res.setCode(200);
            res.setMessage("更新成功");
        } else {
            res.setCode(400);
            res.setMessage("查无此人");

        }
        return res;
    }

    public Response updatePw(User user) {
        Response res = new Response();
        User t_user = userMapper.queryOne(user.getTelephone());
        if (t_user != null) {
            userMapper.updatePw(user);
            res.setCode(200);
            res.setMessage("更新成功");
        } else {
            res.setCode(400);
            res.setMessage("查无此人");

        }
        return res;
    }

    public Response searchUser() {
        List<User> t_appList = userMapper.searchUser();
        Response response = new Response();
        response.setCode(200);
        response.setMessage("查询成功");
        response.setData(t_appList);
        return response;
    }

    public Response searchUserByTag(int tag) {
        Response response = new Response();
        List<User> t_appList = userMapper.searchUserByTag(tag);
        response.setCode(200);
        response.setMessage("分类成功");
        response.setData(t_appList);
        return response;
    }

    public Response delUser(String telephone) {
        Response response = new Response();
        User t_user = userMapper.queryOne(telephone);
        if (t_user != null) {
            if (t_user.getTag() == 0) {
                // userMapper.delUserApp(telephone);
                userMapper.delUserCorp(telephone);
                userMapper.delUser(telephone);
                response.setCode(200);
                response.setMessage("注销成功");
                return response;
            } else if (t_user.getTag() == 1) {
                userMapper.delUser(telephone);
                response.setCode(200);
                response.setMessage("注销成功");
            } else if (t_user.getTag() == 100) {
                response.setCode(400);
                response.setMessage("你是不是疯了？！");
            }
        } else {
            response.setCode(400);
            response.setMessage("注销失败");
        }
        return response;
    }

    public Response delUserApp(String telephone) {
        Response response = new Response();
        int t_user = userMapper.delUserApp(telephone);
        if (t_user != 0) {
            response.setCode(200);
            response.setMessage("注销成功");
        }
        return response;
    }

    public Response commitManager(Corp corp) {
        Response response = new Response();
        int telephone = corp.getTelephone();
        String teleString = String.valueOf(telephone);
        userMapper.commitManager(teleString);
        userMapper.addCorp(corp);
        response.setCode(200);
        response.setMessage("提交成功");
        return response;
    }

    public Response commitUser(Corp corp) {
        Response response = new Response();
        // int telephone = corp.getTelephone();
        // String teleString = String.valueOf(telephone);
        userMapper.commitUser(corp);
        userMapper.addCorp(corp);
        response.setCode(200);
        response.setMessage("提交成功");
        return response;
    }

    public Response agreeManager(Corp corp) {
        Response response = new Response();
        int telephone = corp.getTelephone();
        String teleString = String.valueOf(telephone);
        userMapper.commitManager(teleString);
        userMapper.addCorp(corp);
        userMapper.commitDelete(teleString);
        response.setCode(200);
        response.setMessage("提交成功");
        return response;
    }

    public Response disagreeManager(Corp corp) {
        Response response = new Response();
        int telephone = corp.getTelephone();
        String teleString = String.valueOf(telephone);

        userMapper.commitDelete(teleString);
        response.setCode(200);
        response.setMessage("提交成功");
        return response;
    }

    public Response allCommit(){
        Response response = new Response();
        List<Corp> t_corp=userMapper.allCommit();
        response.setData(t_corp);
        response.setCode(200);
        response.setMessage("抓取成功");
        return response;
    }

}
