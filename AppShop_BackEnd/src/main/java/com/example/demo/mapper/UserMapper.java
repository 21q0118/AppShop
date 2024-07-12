package com.example.demo.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.pojo.Corp;
import com.example.demo.pojo.User;

import jakarta.annotation.Resource;

import java.util.List;

import javax.print.DocFlavor.STRING;

@Mapper
@Resource
public interface UserMapper {
    int add(String userName, String password, String telephone, String icon,
            String petName, int tag);

    User queryOne(String telephone);

    User queryTwo(User user);

    int update(User user);

    int updatePw(User user);

    List<User> searchUser();

    List<User> searchUserByTag(int tag);

    int delUser(String telephone);

    int delUserCorp(String telephone);

    int delUserApp(String telephone);

    int commitManager(String telephone);

    int addCorp(Corp corp);

    int commitUser(Corp corp);

    int commitDelete(String telephone);

    List<Corp>allCommit();
}
