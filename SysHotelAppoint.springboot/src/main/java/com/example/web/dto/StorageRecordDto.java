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
 * 寄存记录类
 */
@Data
public class StorageRecordDto extends BaseDto
{

    
     
    /**
     * 房间号
     */ 
    @JsonProperty("No")
    private String No;
    
     
    /**
     * 领取时间
     */ 
    @JsonSerialize(using= LocalDateTimeSerializer.class)
    @JsonDeserialize(using= LocalDateTimeDeserializer.class)
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @JsonProperty("TakeTime")
    private LocalDateTime TakeTime;             
    
     
    /**
     * 拍照
     */ 
    @JsonProperty("TakePicture")
    private String TakePicture;
    
     
    /**
     * 酒店
     */ 
    @JsonProperty("HotelId")
    private Integer HotelId;          
    
     
    /**
     * 电话
     */ 
    @JsonProperty("Phone")
    private String Phone;
    
     
    /**
     * 物品信息
     */ 
    @JsonProperty("Name")
    private String Name;
    
     
    /**
     * 记录人
     */ 
    @JsonProperty("RecordUserId")
    private Integer RecordUserId;          

     @JsonProperty("HotelDto") 
    private HotelDto HotelDto;                        
   
 	 /**
     * 把寄存记录传输模型转换成寄存记录实体
     */
    public StorageRecord MapToEntity() throws InvocationTargetException, IllegalAccessException {
        StorageRecord StorageRecord= new StorageRecord();
     
         BeanUtils.copyProperties(StorageRecord,this);
        
        return StorageRecord;
    }

}
