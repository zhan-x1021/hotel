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
 * 寄存记录表
 */
@Data
@TableName("`StorageRecord`")
public class StorageRecord extends BaseEntity {

    /**
     * 房间号
     */
    @JsonProperty("No")
    @TableField(value = "No", updateStrategy = FieldStrategy.IGNORED)
    private String No;

    /**
     * 领取时间
     */
    @JsonProperty("TakeTime")
    @TableField(value = "TakeTime", updateStrategy = FieldStrategy.IGNORED)
    @JsonSerialize(using = LocalDateTimeSerializer.class)
    @JsonDeserialize(using = LocalDateTimeDeserializer.class)
    private LocalDateTime TakeTime;

    /**
     * 拍照
     */
    @JsonProperty("TakePicture")
    @TableField(value = "TakePicture", updateStrategy = FieldStrategy.IGNORED)
    private String TakePicture;

    /**
     * 酒店
     */
    @JsonProperty("HotelId")
    @TableField(value = "HotelId", updateStrategy = FieldStrategy.IGNORED)
    private Integer HotelId;

    /**
     * 电话
     */
    @JsonProperty("Phone")
    @TableField(value = "Phone", updateStrategy = FieldStrategy.IGNORED)
    private String Phone;

    /**
     * 物品信息
     */
    @JsonProperty("Name")
    @TableField(value = "Name", updateStrategy = FieldStrategy.IGNORED)
    private String Name;

    /**
     * 记录人
     */
    @JsonProperty("RecordUserId")
    @TableField(value = "RecordUserId", updateStrategy = FieldStrategy.IGNORED)
    private Integer RecordUserId;

    /**
     * 把寄存记录实体转换成寄存记录传输模型
     */
    public StorageRecordDto MapToDto() throws InvocationTargetException, IllegalAccessException {
        StorageRecordDto StorageRecordDto = new StorageRecordDto();

        BeanUtils.copyProperties(StorageRecordDto, this);

        return StorageRecordDto;
    }

}
