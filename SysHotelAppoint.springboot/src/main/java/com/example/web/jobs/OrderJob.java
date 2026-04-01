package com.example.web.jobs;

import org.springframework.stereotype.Component;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.beans.factory.annotation.Autowired;
import com.example.web.service.AppointService;

@Component
public class OrderJob {

    @Autowired
    private AppointService AppointService;

    // 每隔5s检测一次
    @Scheduled(cron = "0/5 * * * * ?")
    public void execute() {
        AppointService.AutoCancel();
    }
}
