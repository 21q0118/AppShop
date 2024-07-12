package com.example.demo.config;

import java.io.File;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.springframework.boot.web.servlet.MultipartConfigFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.unit.DataSize;

import jakarta.servlet.MultipartConfigElement;

@Configuration
public class FileServiceConfig {
    /**
     * 编码
     */
    public static final String UTF_8 = "UTF-8";

    /**
     * 文件上传路径(当前项目路径下，也可配置固定路径)
     */
    public static String uploadPath = "D:\\upload\\apks";

    /**
     * 下载指定文件
     */
    public static String downloadFile = "D:\\upload\\apks\\小组汇报.pptx";

    /**
     * 文件下载地址(当前项目路径下，也可配置固定路径)
     */
    public static String downloadPath = "E:\\Java\\test_file\\prac3\\download";

    /**
     * 分片下载每一片大小为50M
     */
    public static final Long PER_SLICE = 1024 * 1024 * 50L;

    /**
     * 定义分片下载线程池
     */
    public static ExecutorService executorService = Executors
            .newFixedThreadPool(Runtime.getRuntime().availableProcessors());

    /**
     * final string
     */
    public static final String RANGE = "Range";

    @Bean
    public MultipartConfigElement multipartConfigElement() {
        MultipartConfigFactory factory = new MultipartConfigFactory();
        File tempFile = new File(uploadPath);
        if (!tempFile.exists()) {
            tempFile.mkdirs();
        }
        factory.setLocation(uploadPath);
        factory.setMaxFileSize(DataSize.ofBytes(1 * 1024 * 1024 * 1024L));
        factory.setMaxRequestSize(DataSize.ofBytes(10 * 1024 * 1024 * 1024L));
        factory.setFileSizeThreshold(DataSize.ofBytes(1024));
        return factory.createMultipartConfig();
    }
}
