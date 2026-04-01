package com.example.web.dto;

import com.example.web.enums.*;
import com.example.web.tools.dto.BaseDto;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import java.sql.Date;
import java.sql.Timestamp;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;
import com.example.web.entity.*;
import org.apache.commons.beanutils.BeanUtils;
import java.lang.reflect.InvocationTargetException;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;

/**
 * 酒店类
 */
@Data
public class HotelDto extends BaseDto {

    /**
     * 是否可带宠物
     */
    @JsonProperty("IsPet")
    private Boolean IsPet;

    /**
     * 经度
     */
    @JsonProperty("Longitude")
    private Double Longitude;

    /**
     * 酒店图片
     */
    @JsonProperty("HotelImages")
    private String HotelImages;

    /**
     * 名称
     */
    @JsonProperty("Name")
    private String Name;

    /**
     * 省市区
     */
    @JsonProperty("ProviceCityArea")
    private String ProviceCityArea;

    /**
     * 酒店介绍
     */
    @JsonProperty("Content")
    private String Content;

    /**
     * 服务设施
     */
    @JsonProperty("Services")
    private String Services;

    /**
     * 酒店通知
     */
    @JsonProperty("Notice")
    private String Notice;

    /**
     * 入住提示
     */
    @JsonProperty("CheckInTip")
    private String CheckInTip;

    /**
     * 必读
     */
    @JsonProperty("MustRead")
    private String MustRead;

    /**
     * 酒店详细地址
     */
    @JsonProperty("Address")
    private String Address;

    /**
     * 纬度
     */
    @JsonProperty("Latitude")
    private Double Latitude;

    /**
     * 酒店负责人
     */
    @JsonProperty("HotelUserId")
    private Integer HotelUserId;

    /**
     * 酒店封面
     */
    @JsonProperty("Cover")
    private String Cover;

    @JsonProperty("HotelUserDto")
    private AppUserDto HotelUserDto;
    /**
     * 是否审核通过
     * 
     * @return
     */
    @JsonProperty("IsAudit")
    private Boolean IsAudit;

    /**
     * 审核结果
     */
    @JsonProperty("AuditResult")
    private String AuditResult;

    /**
     * 评分
     */
    @JsonProperty("CommentScore")
    private Double CommentScore;

    /**
     * 评论数量
     */
    @JsonProperty("CommentCount")
    private Long CommentCount;

    /**
     * 预订人数
     */
    @JsonProperty("TotalAppointCount")
    private Long TotalAppointCount;

    /**
     * 
     * @return
     * @throws InvocationTargetException
     * @throws IllegalAccessException
     */

    /**
     * 把酒店传输模型转换成酒店实体
     */
    public Hotel MapToEntity() throws InvocationTargetException, IllegalAccessException {
        Hotel Hotel = new Hotel();

        BeanUtils.copyProperties(Hotel, this);

        return Hotel;
    }

}
