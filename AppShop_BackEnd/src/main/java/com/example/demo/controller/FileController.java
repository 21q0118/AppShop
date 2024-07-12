package com.example.demo.controller;

import com.example.demo.pojo.App;
import com.example.demo.pojo.Response;
import com.example.demo.service.FileService;
import com.example.demo.service.IconService;
import com.example.demo.service.AppService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 文件上传测试接口
 *
 * @author liyh
 */
@RestController
@RequestMapping("/app")
public class FileController {

    @Autowired
    private FileService fileService;
    @Autowired
    private AppService appService;

    /**
     * 单个文件上传，支持断点续传
     */
    @PostMapping("/upload")
    public Response upload(HttpServletRequest request, HttpServletResponse response) {
        // App tApp = appService.appIdFind(id);
        // if (tApp != null) {
        // String fileName = tApp.getApk();
        // fileService.deleteFile(fileName);
        // }

        Response res = new Response();
        try {
            fileService.upload(request, response);
            res.setCode(200);
            res.setMessage("添加成功");
        } catch (Exception e) {
            e.printStackTrace();
            res.setCode(400);
            res.setMessage("添加失败");
        }
        return res;
    }

    /**
     * 普通文件下载
     */
    @GetMapping("/download")
    public void download(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        fileService.download("Genshin Impact_4.7.0_23093867_23435602_APKPure.apk", request, response);
    }

    /**
     * 分片文件下载
     */
    @GetMapping("/downloads")
    public String downloads() throws IOException {
        fileService.downloads();
        return "下载成功";
    }

    @Autowired
    IconService iconService;

    @PostMapping("/uploadIcon")
    public Response testIcon(@RequestParam MultipartFile icon) {
        Response res = iconService.PhotoUpload(icon);
        return res;
    }
}
