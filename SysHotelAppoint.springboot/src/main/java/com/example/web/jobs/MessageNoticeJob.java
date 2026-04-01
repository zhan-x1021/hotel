package com.example.web.jobs;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import com.example.web.service.MessageNoticeService;

@Component
public class MessageNoticeJob {

    @Autowired
    private MessageNoticeService MessageNoticeService;

    /**
     * 每隔10s检测一次 是否需要发送邮件
     */
    @Scheduled(cron = "0/10 * * * * ?")
    public void AutoSendEmail() {
        MessageNoticeService.AutoSendEmail();
    }
}
