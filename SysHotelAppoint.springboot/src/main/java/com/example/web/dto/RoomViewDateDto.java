package com.example.web.dto;

import java.time.LocalDateTime;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class RoomViewDateDto {
    @JsonProperty("Date")
    private LocalDateTime Date;

    @JsonProperty("RoomViews")
    private List<RoomViewDto> RoomViews;

}
