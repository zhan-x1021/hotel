package com.example.web.dto.query;

import com.example.web.tools.dto.PagedInput;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;

/**
 * 酒店查询模型
 */
@NoArgsConstructor
@Data
public class HotelPagedInput extends PagedInput {

    /**
     * Id主键
     */
    @JsonProperty("Id")
    private Integer Id;
    /**
     * 酒店图片模糊查询条件
     */
    @JsonProperty("HotelImages")
    private String HotelImages;
    /**
     * 名称模糊查询条件
     */
    @JsonProperty("Name")
    private String Name;
    /**
     * 省市区模糊查询条件
     */
    @JsonProperty("ProviceCityArea")
    private String ProviceCityArea;
    /**
     * 服务设施模糊查询条件
     */
    @JsonProperty("Services")
    private String Services;
    /**
     * 酒店通知模糊查询条件
     */
    @JsonProperty("Notice")
    private String Notice;
    /**
     * 入住提示模糊查询条件
     */
    @JsonProperty("CheckInTip")
    private String CheckInTip;
    /**
     * 必读模糊查询条件
     */
    @JsonProperty("MustRead")
    private String MustRead;
    /**
     * 酒店详细地址模糊查询条件
     */
    @JsonProperty("Address")
    private String Address;
    /**
     * 酒店负责人
     */
    @JsonProperty("HotelUserId")
    private Integer HotelUserId;
    /**
     * 是否可带宠物
     */
    @JsonProperty("IsPet")
    private Boolean IsPet;
    /**
     * 酒店介绍模糊查询条件
     */
    @JsonProperty("Content")
    private String Content;
    /**
     * 是否审核通过
     * 
     * @return
     */
    @JsonProperty("IsAudit")
    private Boolean IsAudit;

    /**
     * 全局地址
     */
    @JsonProperty("GlobalAddress")
    private String GlobalAddress;

}
