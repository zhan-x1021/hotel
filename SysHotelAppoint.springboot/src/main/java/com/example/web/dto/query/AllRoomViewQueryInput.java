package com.example.web.dto.query;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class AllRoomViewQueryInput {

    /**
     * 酒店ID
     */
    @JsonProperty("HotelId")
    private Integer HotelId;

    /**
     * 起始预约时间时间范围
     */
    @JsonProperty("BeginDate")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime BeginDate;
    @JsonProperty("EndDate")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime EndDate;

    /**
     * 是否显示预约单号
     */
    @JsonProperty("AppointId")
    private Integer AppointId;

}
