package com.example.web.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import org.apache.poi.hpsf.Decimal;
import java.lang.reflect.InvocationTargetException;
import org.apache.commons.beanutils.BeanUtils;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.datatype.jsr310.deser.LocalDateTimeDeserializer;
import com.fasterxml.jackson.datatype.jsr310.ser.LocalDateTimeSerializer;
import java.sql.Date;
import java.sql.Timestamp;
import lombok.Data;
import java.time.LocalDateTime;
import com.example.web.dto.*;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import com.baomidou.mybatisplus.annotation.FieldStrategy;

/**
 * 房间表
 */
@Data
@TableName("`Room`")
public class Room extends BaseEntity {

    /**
     * 早餐类型
     */
    @JsonProperty("BreakfastType")
    @TableField(value = "BreakfastType", updateStrategy = FieldStrategy.IGNORED)
    private Integer BreakfastType;

    /**
     * 房间大小
     */
    @JsonProperty("AreaSize")
    @TableField(value = "AreaSize", updateStrategy = FieldStrategy.IGNORED)
    private Double AreaSize;

    /**
     * 是否立即确定
     */
    @JsonProperty("IsImmediatelyConfirm")
    @TableField(value = "IsImmediatelyConfirm", updateStrategy = FieldStrategy.IGNORED)
    private Boolean IsImmediatelyConfirm;

    /**
     * 最大价格
     */
    @JsonProperty("MaxPrice")
    @TableField(value = "MaxPrice", updateStrategy = FieldStrategy.IGNORED)
    private Double MaxPrice;

    /**
     * 标题
     */
    @JsonProperty("Title")
    @TableField(value = "Title", updateStrategy = FieldStrategy.IGNORED)
    private String Title;

    /**
     * 房型
     */
    @JsonProperty("RoomShape")
    @TableField(value = "RoomShape", updateStrategy = FieldStrategy.IGNORED)
    private Integer RoomShape;

    /**
     * 最小价格
     */
    @JsonProperty("MinPrice")
    @TableField(value = "MinPrice", updateStrategy = FieldStrategy.IGNORED)
    private Double MinPrice;

    /**
     * 房间主图
     */
    @JsonProperty("ImageUrls")
    @TableField(value = "ImageUrls", updateStrategy = FieldStrategy.IGNORED)
    private String ImageUrls;

    /**
     * 可抵积分
     */
    @JsonProperty("Integral")
    @TableField(value = "Integral", updateStrategy = FieldStrategy.IGNORED)
    private Double Integral;

    /**
     * 房间介绍
     */
    @JsonProperty("Content")
    @TableField(value = "Content", updateStrategy = FieldStrategy.IGNORED)
    private String Content;

    /**
     * 积分可抵金额
     */
    @JsonProperty("IntegralExchangeMoney")
    @TableField(value = "IntegralExchangeMoney", updateStrategy = FieldStrategy.IGNORED)
    private Double IntegralExchangeMoney;

    /**
     * 酒店
     */
    @JsonProperty("HotelId")
    @TableField(value = "HotelId", updateStrategy = FieldStrategy.IGNORED)
    private Integer HotelId;

    /**
     * 设施信息
     */
    @JsonProperty("EquipmentInfoIds")
    @TableField(value = "EquipmentInfoIds", updateStrategy = FieldStrategy.IGNORED)
    private String EquipmentInfoIds;

    /**
     * 特色房型
     */
    @JsonProperty("FeaturedRoomShape")
    @TableField(value = "FeaturedRoomShape", updateStrategy = FieldStrategy.IGNORED)
    private Integer FeaturedRoomShape;

    /**
     * 封面
     */
    @JsonProperty("Cover")
    @TableField(value = "Cover", updateStrategy = FieldStrategy.IGNORED)
    private String Cover;

    /**
     * 是否免费取消
     */
    @JsonProperty("IsFreeCancel")
    @TableField(value = "IsFreeCancel", updateStrategy = FieldStrategy.IGNORED)
    private Boolean IsFreeCancel;

    /**
     * 把房间实体转换成房间传输模型
     */
    public RoomDto MapToDto() throws InvocationTargetException, IllegalAccessException {
        RoomDto RoomDto = new RoomDto();

        BeanUtils.copyProperties(RoomDto, this);

        return RoomDto;
    }

}
