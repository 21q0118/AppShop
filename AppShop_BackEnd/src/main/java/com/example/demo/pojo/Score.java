package com.example.demo.pojo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Score {
   
    private int appID;
    private int num;
    private String score;

    // @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    // @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    // private Date create_time;
}
