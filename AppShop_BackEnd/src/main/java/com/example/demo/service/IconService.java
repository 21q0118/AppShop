package com.example.demo.service;

import java.io.File;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.mapper.AppMapper;
import com.example.demo.mapper.UserMapper;
import com.example.demo.pojo.Response;

@Service
public class IconService {
    @Value("${SavePath.ProfilePhoto}")
    private String ProfilePhotoSavePath; // 图标图片存储路径
    @Value("${SavePath.ProfilePhotoMapper}")
    private String ProfilePhotoMapperPath; // 图标映射路径

    @Autowired
    AppMapper appMapper;
    @Autowired
    UserMapper userMapper;

    /**
     * 头像上传
     * 
     * @param fileUpload 图片资源
     * @return 图映射的虚拟访问路径
     */
    public Response PhotoUpload(MultipartFile fileUpload) {
        File pDir = new File(ProfilePhotoSavePath);
        if (!pDir.exists() && !pDir.isDirectory()) {
            pDir.mkdirs();
        }

        Response res = new Response();
        // 获取文件名
        String fileName = fileUpload.getOriginalFilename();
        // 获取文件后缀名。也可以在这里添加判断语句，规定特定格式的图片才能上传，否则拒绝保存。
        String suffixName = fileName.substring(fileName.lastIndexOf("."));
        // 为了避免发生图片替换，这里使用了文件名重新生成
        fileName = UUID.randomUUID() + suffixName;
        try {
            // 将图片保存到文件夹里
            fileUpload.transferTo(new File(ProfilePhotoSavePath + fileName));
            res.setCode(200);
            res.setMessage("上传成功");
            res.setData(ProfilePhotoMapperPath + fileName);
        } catch (Exception e) {
            e.printStackTrace();
            res.setCode(400);
            res.setMessage("上传失败");
        }
        return res;
    }
}
