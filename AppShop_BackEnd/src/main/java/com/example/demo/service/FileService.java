package com.example.demo.service;

import com.example.demo.config.FileServiceConfig;
import com.example.demo.pojo.App;
import com.example.demo.pojo.DownloadFileInfo;
import com.example.demo.pojo.FileInfo;
import com.example.demo.pojo.UploadFileInfo;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClients;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.*;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.Collection;

@Service
public class FileService {

    /**
     * 上传文件
     */
    public void upload(HttpServletRequest request, HttpServletResponse response) throws Exception {

        Collection<Part> items = request.getParts();
        // 获取文件信息
        UploadFileInfo uploadFileInfo = getFileInfo(items);
        // 写入临时文件
        writeTempFile(items, uploadFileInfo);
        // 判断是否合并
        mergeFile(uploadFileInfo);
        // 返回结果
        // response.setCharacterEncoding(FileServiceConfig.UTF_8);
        // response.getWriter().write("上传成功");
    }

    /**
     * 获取文件信息
     *
     * @param items
     * @return
     * @throws UnsupportedEncodingException
     */
    private UploadFileInfo getFileInfo(Collection<Part> items) throws UnsupportedEncodingException, IOException {
        UploadFileInfo uploadFileInfo = new UploadFileInfo();
        for (Part item : items) {
            if (item.getContentType() == null) {
                InputStream is = item.getInputStream();
                BufferedReader reader = new BufferedReader(new InputStreamReader(is, FileServiceConfig.UTF_8));
                String line;
                while ((line = reader.readLine()) != null) {
                    // System.out.println(line);

                    // 获取分片数据
                    if ("chunk".equals(item.getName())) {
                        uploadFileInfo.setCurrentChunk(Integer.parseInt(line));
                    }
                    if ("chunks".equals(item.getName())) {
                        uploadFileInfo.setChunks(Integer.parseInt(line));
                    }
                    if ("name".equals(item.getName())) {
                        uploadFileInfo.setFileName(line);

                    }
                }

            }
        }
        return uploadFileInfo;
    }

    /**
     * 写入临时文件
     *
     * @param items
     * @param uploadFileInfo
     * @throws Exception
     */
    private void writeTempFile(Collection<Part> items, UploadFileInfo uploadFileInfo) {

        // 如果文件夹不存在则创建
        File file = new File(FileServiceConfig.uploadPath);
        if (!file.exists() && !file.isDirectory()) {
            file.mkdirs();
        }
        // 获取文件基本信息后
        for (Part item : items) {
            if (item.getContentType() != null) {
                // 有分片需要临时目录
                String tempFileName = uploadFileInfo.getFileName();
                if (StringUtils.isNotBlank(tempFileName)) {
                    if (uploadFileInfo.getCurrentChunk() != null) {
                        tempFileName = uploadFileInfo.getCurrentChunk() + "_" + uploadFileInfo.getFileName();
                    }
                    // 判断文件是否存在
                    File tempFile = new File(FileServiceConfig.uploadPath, tempFileName);
                    // 断点续传，判断文件是否存在，若存在则不传
                    if (!tempFile.exists()) {
                        try {
                            item.write(tempFile.getAbsolutePath());
                        } catch (Exception e) {
                            System.out.println(e);
                        }
                    }
                }
            }
        }
    }

    /**
     * 判断是否合并
     *
     * @param uploadFileInfo
     * @throws IOException
     * @throws InterruptedException
     */
    private void mergeFile(UploadFileInfo uploadFileInfo) throws IOException, InterruptedException {
        Integer currentChunk = uploadFileInfo.getCurrentChunk();
        Integer chunks = uploadFileInfo.getChunks();
        String fileName = uploadFileInfo.getFileName();
        // 如果当前分片等于总分片那么合并文件
        if (currentChunk != null && chunks != null && currentChunk.equals(chunks - 1)) {
            File tempFile = new File(FileServiceConfig.uploadPath, fileName);
            try (BufferedOutputStream os = new BufferedOutputStream(new FileOutputStream(tempFile))) {
                // 根据之前命名规则找到所有分片
                for (int i = 0; i < chunks; i++) {
                    File file = new File(FileServiceConfig.uploadPath, i + "_" + fileName);
                    // 并发情况，需要判断所有，因为可能最后一个分片传完，之前有的还没传完
                    int t = 0;
                    while (!file.exists() && t < 10) {
                        // 不存在休眠100毫秒后在重新判断
                        Thread.sleep(100);
                        t++;
                    }
                    // 分片存在，读入数组中
                    byte[] bytes = FileUtils.readFileToByteArray(file);
                    os.write(bytes);
                    os.flush();
                    file.delete();
                }
                os.flush();
            }
        }
    }

    /**
     * 文件下载
     *
     * @param request
     * @param response
     * @throws IOException
     */
    public void download(String apkName, HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 获取文件
        File file = new File(FileServiceConfig.uploadPath, apkName);
        // 获取下载文件信息
        DownloadFileInfo downloadFileInfo = getDownloadFileInfo(file.length(), request, response);
        // 设置响应头
        setResponse(response, file.getName(), downloadFileInfo);
        // 下载文件
        try (InputStream is = new BufferedInputStream(new FileInputStream(file));
                OutputStream os = new BufferedOutputStream(response.getOutputStream())) {
            // 跳过已经读取文件
            is.skip(downloadFileInfo.getPos());
            byte[] buffer = new byte[1024];
            long sum = 0;
            // 读取
            while (sum < downloadFileInfo.getRangeLength()) {
                int length = is.read(buffer, 0,
                        (downloadFileInfo.getRangeLength() - sum) <= buffer.length
                                ? (int) (downloadFileInfo.getRangeLength() - sum)
                                : buffer.length);
                sum = sum + length;
                os.write(buffer, 0, length);
            }
        }
    }

    /**
     * 有两个map，我要去判断里面相同键的值一致不一致，除了双重for循环，有没有别的好办法
     */
    private DownloadFileInfo getDownloadFileInfo(long fSize, HttpServletRequest request, HttpServletResponse response) {
        long pos = 0;
        long last = fSize - 1;
        // 判断前端是否需要分片下载
        if (request.getHeader(FileServiceConfig.RANGE) != null) {
            response.setStatus(HttpServletResponse.SC_PARTIAL_CONTENT);
            String numRange = request.getHeader(FileServiceConfig.RANGE).replace("bytes=", "");
            String[] strRange = numRange.split("-");
            if (strRange.length == 2) {
                pos = Long.parseLong(strRange[0].trim());
                last = Long.parseLong(strRange[1].trim());
                // 若结束字节超出文件大小，取文件大小
                if (last > fSize - 1) {
                    last = fSize - 1;
                }
            } else {
                // 若只给一个长度，开始位置一直到结束
                pos = Long.parseLong(numRange.replace("-", "").trim());
            }
        }
        long rangeLength = last - pos + 1;
        String contentRange = "bytes " + pos + "-" + last + "/" + fSize;
        return new DownloadFileInfo(fSize, pos, last, rangeLength, contentRange);
    }

    /**
     * 分片下载
     *
     * @throws IOException
     */
    public void downloads() throws IOException {
        File file = new File(FileServiceConfig.downloadPath);
        // 如果文件夹不存在则创建
        if (!file.exists() && !file.isDirectory()) {
            file.mkdirs();
        }
        // 探测下载，获取文件相关信息
        FileInfo fileInfoDto = sliceDownload(1, 10, -1, null);
        // 如果不为空，执行分片下载
        if (fileInfoDto != null) {
            // 计算有多少分片
            long pages = fileInfoDto.getFileSize() / FileServiceConfig.PER_SLICE;
            // 适配最后一个分片
            for (long i = 0; i <= pages; i++) {
                long start = i * FileServiceConfig.PER_SLICE;
                long end = (i + 1) * FileServiceConfig.PER_SLICE - 1;
                FileServiceConfig.executorService
                        .execute(new SliceDownloadRunnable(start, end, i, fileInfoDto.getFileName()));
            }
        }
    }

    /**
     * 分片下载
     *
     * @param start 分片起始位置
     * @param end   分片结束位置
     * @param page  第几个分片, page=-1时是探测下载
     */
    private FileInfo sliceDownload(long start, long end, long page, String fName) throws IOException {
        // 断点下载
        File file = new File(FileServiceConfig.downloadPath, page + "-" + fName);
        // 如果当前文件已经存在，并且不是探测任务，并且文件的长度等于分片的大小，那么不用下载当前文件
        if (file.exists() && page != -1 && file.length() == FileServiceConfig.PER_SLICE) {
            return null;
        }
        // 创建HttpClient
        HttpClient client = HttpClients.createDefault();
        HttpGet httpGet = new HttpGet("http://localhost:8080/file/download");
        httpGet.setHeader(FileServiceConfig.RANGE, "bytes=" + start + "-" + end);
        HttpResponse httpResponse = client.execute(httpGet);
        String fSize = httpResponse.getFirstHeader("fSize").getValue();
        fName = URLDecoder.decode(httpResponse.getFirstHeader("fName").getValue(), FileServiceConfig.UTF_8);
        HttpEntity entity = httpResponse.getEntity();
        // 下载
        try (InputStream is = entity.getContent();
                FileOutputStream fos = new FileOutputStream(file)) {
            byte[] buffer = new byte[1024];
            int ch;
            while ((ch = is.read(buffer)) != -1) {
                fos.write(buffer, 0, ch);
            }
            fos.flush();
        }
        // 判断是否是最后一个分片，如果是那么合并
        if (end - Long.parseLong(fSize) > 0) {
            mergeFile(fName, page);
        }
        return new FileInfo(Long.parseLong(fSize), fName);
    }

    private void mergeFile(String fName, long page) throws IOException {
        File file = new File(FileServiceConfig.downloadPath, fName);

        try (BufferedOutputStream os = new BufferedOutputStream(new FileOutputStream(file))) {
            for (int i = 0; i <= page; i++) {
                File tempFile = new File(FileServiceConfig.downloadPath, i + "-" + fName);
                // 文件不存在或文件没写完
                while (!tempFile.exists() || (i != page && tempFile.length() < FileServiceConfig.PER_SLICE)) {
                    Thread.sleep(100);
                }
                byte[] bytes = FileUtils.readFileToByteArray(tempFile);
                os.write(bytes);
                os.flush();
                tempFile.delete();
            }
            // 删除文件
            File f = new File(FileServiceConfig.downloadPath, "-1" + "-null");
            if (f.exists()) {
                f.delete();
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    private class SliceDownloadRunnable implements Runnable {
        private final long start;
        private final long end;
        private final long page;
        private final String fName;

        private SliceDownloadRunnable(long start, long end, long page, String fName) {
            this.start = start;
            this.end = end;
            this.page = page;
            this.fName = fName;
        }

        @Override
        public void run() {
            try {
                sliceDownload(start, end, page, fName);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 设置响应头
     */
    private void setResponse(HttpServletResponse response, String fileName, DownloadFileInfo downloadFileInfo)
            throws UnsupportedEncodingException {
        response.setCharacterEncoding(FileServiceConfig.UTF_8);
        response.setContentType("application/x-download");
        response.addHeader("Content-Disposition",
                "attachment;filename=" + URLEncoder.encode(fileName, FileServiceConfig.UTF_8));
        // 支持分片下载
        response.setHeader("Accept-Range", "bytes");
        response.setHeader("fSize", String.valueOf(downloadFileInfo.getFSize()));
        response.setHeader("fName", URLEncoder.encode(fileName, FileServiceConfig.UTF_8));
        // range响应头
        response.setHeader("Content-Range", downloadFileInfo.getContentRange());
        response.setHeader("Content-Length", String.valueOf(downloadFileInfo.getRangeLength()));
    }

    public void deleteFile(String fileName) {
        File t = new File(FileServiceConfig.uploadPath, fileName);
        if (t.exists()) {
            t.delete();
        }
    }

    public String getFileSize(String fileName) {
        File t = new File(FileServiceConfig.uploadPath, fileName);
        long size = t.length() / (1024 * 1024);
        return Long.toString(size);
    }

    public Date getCurTime() {
        SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        java.util.Date utilDate = new java.util.Date();
        java.sql.Date sqlDate = new java.sql.Date(0);
        f.format(utilDate);
        f.format(sqlDate);
        sqlDate = new java.sql.Date(utilDate.getTime());
        System.out.println(sqlDate);
        return sqlDate;
    }

    
}
