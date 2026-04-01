package com.example.web.dto;

import java.time.LocalDateTime;

import com.example.web.enums.RoomStatusEnum;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

/**
 * 房间明细视图
 */
@Data
public class RoomDetViewDto {

    @JsonProperty("RoomDetId")
    private Integer RoomDetId;

    /**
     * 酒店
     */
    @JsonProperty("HotelId")
    private Integer HotelId;

    /**
     * 楼层
     */
    @JsonProperty("Floor")
    private String Floor;

    /**
     * 房号
     */
    @JsonProperty("No")
    private String No;

    @JsonProperty("RoomStatus")
    private Integer RoomStatus;

    @JsonProperty("RoomStatusFormat")
    public String RoomStatusFormat() {
        return RoomStatusEnum.GetEnum(RoomStatus).toString();
    };

    /**
     * 对应预约编号
     */
    @JsonProperty("AppointId")
    private Integer AppointId;

    /**
     * 房间
     */
    @JsonProperty("RoomId")
    private Integer RoomId;

    @JsonProperty("HotelDto")
    private HotelDto HotelDto;

    @JsonProperty("RoomDto")
    private RoomDto RoomDto;
}
