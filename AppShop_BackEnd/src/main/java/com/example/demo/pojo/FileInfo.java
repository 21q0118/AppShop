package com.example.demo.pojo;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class FileInfo {

    private long fileSize;

    private String fileName;

}
