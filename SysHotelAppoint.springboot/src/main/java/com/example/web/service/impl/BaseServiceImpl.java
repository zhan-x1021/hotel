package com.example.web.service.impl;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.example.web.dto.RoomMatchDto;
import com.example.web.dto.query.HotelDataAnalysisQueryInput;
import com.example.web.entity.Appoint;
import com.example.web.entity.FavourableSetting;
import com.example.web.entity.Hotel;
import com.example.web.entity.Room;
import com.example.web.entity.RoomDet;
import com.example.web.entity.RoomMatch;
import com.example.web.entity.RoomPrice;
import com.example.web.enums.AppointStatusEnum;
import com.example.web.mapper.AppUserMapper;
import com.example.web.mapper.AppointMapper;
import com.example.web.mapper.EmployeeMapper;
import com.example.web.mapper.FavourableSettingMapper;
import com.example.web.mapper.GuestInfoMapper;
import com.example.web.mapper.HotelMapper;
import com.example.web.mapper.RoomDetMapper;
import com.example.web.mapper.RoomMapper;
import com.example.web.mapper.RoomMatchMapper;
import com.example.web.mapper.RoomPriceMapper;
import com.example.web.mapper.StorageRecordMapper;
import com.example.web.service.BaseService;
import com.example.web.tools.Extension;

import lombok.SneakyThrows;

@Service
public class BaseServiceImpl implements BaseService {

    @Autowired
    private AppUserMapper AppUserMapper;
    @Autowired
    private RoomMapper RoomMapper;

    @Autowired
    private RoomDetMapper RoomDetMapper;

    @Autowired
    private FavourableSettingMapper FavourableSettingMapper;
    @Autowired
    private RoomPriceMapper RoomPriceMapper;

    @Autowired
    private AppointMapper AppointMapper;
    /**
     * 操作数据库的RoomMatch表mapper对象
     */
    @Autowired
    private RoomMatchMapper RoomMatchMapper;

    @Autowired
    private HotelMapper HotelMapper;

    @Autowired
    private StorageRecordMapper StorageRecordMapper;

    @Autowired
    private EmployeeMapper EmployeeMapper;
    /**
     * 操作数据库的GuestInfo表mapper对象
     */
    @Autowired
    private GuestInfoMapper GuestInfoMapper;

    /**
     * 得到房间选择时间段的价格
     *
     * @param hotelId
     * @param roomId
     * @return
     */
    public Double GetRoomPriceByDateList(Integer hotelId, Integer roomId, LocalDateTime checkInDate,
            LocalDateTime checkOutDate, Boolean isIgnoreFavourable) {
        Double price = 0.0;

        for (LocalDateTime date = checkInDate; date.isBefore(checkOutDate); date = date.plusDays(1)) {
            price += GetRoomPriceByDate(hotelId, roomId, date, isIgnoreFavourable);
        }
        return price;
    }

    /**
     * 得到房间选择某天的价格
     *
     * @param hotelId
     * @param roomId
     * @return
     */
    public Double GetRoomPriceByDate(Integer hotelId, Integer roomId, LocalDateTime date, Boolean isIgnoreFavourable) {
        Room room = RoomMapper.selectById(roomId);
        // 平常价格
        Double price = Extension.ToFixed0(((room.getMaxPrice() + room.getMinPrice()) / 2));

        // 查询当天的价格
        RoomPrice roomPrice = RoomPriceMapper.selectList(Wrappers.<RoomPrice>lambdaQuery()
                .eq(RoomPrice::getHotelId, hotelId)
                .eq(RoomPrice::getRoomId, roomId)
                .le(RoomPrice::getBeginActiveTime, date)
                .ge(RoomPrice::getEndActiveTime, date)).stream().findFirst().orElse(null);
        if (roomPrice != null) {
            price = roomPrice.getPrice();
        }

        // 查询当天满足的折扣

        // 查询当天满足的折扣
        FavourableSetting favourableSetting = FavourableSettingMapper
                .selectList(Wrappers.<FavourableSetting>lambdaQuery()
                        .eq(FavourableSetting::getHotelId, hotelId)
                        .le(FavourableSetting::getBeginActiveTime, date)
                        .ge(FavourableSetting::getEndActiveTime, date))
                .stream().findFirst().orElse(null);
        if (favourableSetting != null) {
            price = Extension.ToFixed0(price * (1 - favourableSetting.getDiscount()));
        }

        return price;
    }

    /**
     * 得到房间剩余数量
     */
    public Long GetRemainingRoomNumber(Integer hotelId, Integer roomId, LocalDateTime checkInDate,
            LocalDateTime checkOutDate) {

        // 总房间数量
        Long roomDetCount = RoomDetMapper.selectCount(Wrappers.<RoomDet>lambdaQuery()
                .eq(RoomDet::getHotelId, hotelId)
                .eq(RoomDet::getRoomId, roomId));

        // 需要求和对应的预约房间数量
        Long appointCount = AppointMapper.selectList(Wrappers.<Appoint>lambdaQuery()
                .eq(Appoint::getHotelId, hotelId)
                .eq(Appoint::getRoomId, roomId)
                .notIn(Appoint::getAppointStatus, AppointStatusEnum.用户取消.index(),
                        AppointStatusEnum.酒店取消.index(), AppointStatusEnum.系统取消.index(),
                        AppointStatusEnum.完成退房.index(), AppointStatusEnum.完成.index())
                .ge(Appoint::getBeginAppointTime, checkInDate)
                .le(Appoint::getEndAppointTime, checkOutDate)).stream().mapToLong(Appoint::getQty).sum();

        return roomDetCount - appointCount;
    }

    /**
     * 得到某天某个房间的使用情况
     */
    @SneakyThrows
    @Override
    public RoomMatchDto GetRoomRoomMatch(Integer hotelId, Integer roomId, Integer roomDetId, LocalDateTime date) {
        RoomMatch roomMatch = RoomMatchMapper.selectList(Wrappers.<RoomMatch>lambdaQuery()
                .eq(RoomMatch::getHotelId, hotelId)
                .eq(RoomMatch::getRoomId, roomId)
                .eq(RoomMatch::getRoomDetId, roomDetId)
                .ge(RoomMatch::getBeginActiveTime, date)
                .le(RoomMatch::getEndActiveTime, date).orderByDesc(RoomMatch::getCreationTime)).stream().findFirst()
                .orElse(null);
        if (roomMatch != null) {
            return roomMatch.MapToDto();
        }
        return null;
    }

    /**
     * 根据地址获取对应的酒店ids
     */
    @SneakyThrows
    @Override
    public List<Integer> GetHotelIdsByAddress(String address) {
        List<Hotel> hotels = HotelMapper.selectList(Wrappers.<Hotel>lambdaQuery()
                .like(Hotel::getProviceCityArea, address));
        return hotels.stream().map(Hotel::getId).collect(Collectors.toList());
    }

    /**
     * 酒店数据综合分析
     */
    @SneakyThrows
    @Override
    public HashMap<String, Object> HotelDataAnalysis(HotelDataAnalysisQueryInput input) {
        HashMap<String, Object> result = new HashMap<>();
        Integer hotelId = input.getHotelId();
        LocalDateTime startDate = input.getStartTime();
        LocalDateTime endDate = input.getEndTime();

        // 查询该时间段内所有预约
        List<Appoint> appoints = AppointMapper.selectList(Wrappers.<Appoint>lambdaQuery()
                .eq(hotelId != null, Appoint::getHotelId, hotelId)
                .ge(startDate != null, Appoint::getBeginAppointTime, startDate)
                .le(endDate != null, Appoint::getEndAppointTime, endDate));

        if (appoints == null || appoints.isEmpty()) {
            result.put("message", "该时间段内无预订数据");
            return result;
        }

        // 1. 预约状态统计
        int totalAppointCount = appoints.size();
        int successAppointCount = 0;
        int cancelByUserCount = 0;
        int cancelByHotelCount = 0;
        int cancelBySystemCount = 0;
        int pendingCount = 0;

        for (int i = 0; i < appoints.size(); i++) {
            Appoint appoint = appoints.get(i);
            Integer status = appoint.getAppointStatus();

            if (status == null)
                continue;

            if (status.equals(AppointStatusEnum.待入住.index())) {
                successAppointCount++;
            } else if (status.equals(AppointStatusEnum.用户取消.index())) {
                cancelByUserCount++;
            } else if (status.equals(AppointStatusEnum.酒店取消.index())) {
                cancelByHotelCount++;
            } else if (status.equals(AppointStatusEnum.系统取消.index())) {
                cancelBySystemCount++;
            } else if (status.equals(AppointStatusEnum.待确定.index())) {
                pendingCount++;
            }
        }

        HashMap<String, Object> statusStats = new HashMap<>();
        statusStats.put("总预约数", totalAppointCount);
        statusStats.put("预约成功数", successAppointCount);
        statusStats.put("用户取消数", cancelByUserCount);
        statusStats.put("酒店取消数", cancelByHotelCount);
        statusStats.put("系统取消数", cancelBySystemCount);
        statusStats.put("待确认数", pendingCount);
        statusStats.put("成功率", totalAppointCount > 0 ? (double) successAppointCount / totalAppointCount : 0);
        statusStats.put("用户取消率", totalAppointCount > 0 ? (double) cancelByUserCount / totalAppointCount : 0);
        result.put("预约状态统计", statusStats);

        // 2. 按季节统计预约量和收入
        HashMap<String, Integer> seasonAppointCount = new HashMap<>();
        HashMap<String, Double> seasonRevenue = new HashMap<>();
        seasonAppointCount.put("春季", 0);
        seasonAppointCount.put("夏季", 0);
        seasonAppointCount.put("秋季", 0);
        seasonAppointCount.put("冬季", 0);
        seasonRevenue.put("春季", 0.0);
        seasonRevenue.put("夏季", 0.0);
        seasonRevenue.put("秋季", 0.0);
        seasonRevenue.put("冬季", 0.0);

        double totalRevenue = 0.0;

        for (int i = 0; i < appoints.size(); i++) {
            Appoint appoint = appoints.get(i);

            if (appoint.getBeginAppointTime() == null)
                continue;

            int month = appoint.getBeginAppointTime().getMonthValue();
            String season;

            if (month >= 3 && month <= 5) {
                season = "春季";
            } else if (month >= 6 && month <= 8) {
                season = "夏季";
            } else if (month >= 9 && month <= 11) {
                season = "秋季";
            } else {
                season = "冬季";
            }

            seasonAppointCount.put(season, seasonAppointCount.get(season) + 1);

            Double price = appoint.getTotalMoney();
            if (price != null) {
                seasonRevenue.put(season, seasonRevenue.get(season) + price);
                totalRevenue += price;
            }
        }

        result.put("季节预约统计", seasonAppointCount);
        result.put("季节收入统计", seasonRevenue);
        result.put("总收入", totalRevenue);

        // 3. 房间类型受欢迎度分析
        if (hotelId != null) {
            List<Room> rooms = RoomMapper.selectList(Wrappers.<Room>lambdaQuery()
                    .eq(Room::getHotelId, hotelId));

            if (rooms != null && !rooms.isEmpty()) {
                HashMap<Integer, String> roomIdToName = new HashMap<>();
                HashMap<String, Integer> roomTypeBookingCount = new HashMap<>();
                HashMap<String, Double> roomTypeRevenue = new HashMap<>();

                for (Room room : rooms) {
                    if (room.getId() != null && room.getTitle() != null) {
                        roomIdToName.put(room.getId(), room.getTitle());
                        roomTypeBookingCount.put(room.getTitle(), 0);
                        roomTypeRevenue.put(room.getTitle(), 0.0);
                    }
                }

                for (int i = 0; i < appoints.size(); i++) {
                    Appoint appoint = appoints.get(i);
                    Integer roomId = appoint.getRoomId();

                    if (roomId != null && roomIdToName.containsKey(roomId)) {
                        String roomName = roomIdToName.get(roomId);
                        roomTypeBookingCount.put(roomName, roomTypeBookingCount.get(roomName) + 1);

                        Double price = appoint.getTotalMoney();
                        if (price != null) {
                            roomTypeRevenue.put(roomName, roomTypeRevenue.get(roomName) + price);
                        }
                    }
                }

                result.put("房型预约统计", roomTypeBookingCount);
                result.put("房型收入统计", roomTypeRevenue);
            }
        }

        // 4. 入住时长分析
        int oneDayStay = 0;
        int twoDayStay = 0;
        int threeDayStay = 0;
        int fourToSevenDayStay = 0;
        int moreThanSevenDayStay = 0;

        for (int i = 0; i < appoints.size(); i++) {
            Appoint appoint = appoints.get(i);

            if (appoint.getBeginAppointTime() != null && appoint.getEndAppointTime() != null) {
                long days = java.time.Duration.between(
                        appoint.getBeginAppointTime(),
                        appoint.getEndAppointTime()).toDays();

                if (days == 1) {
                    oneDayStay++;
                } else if (days == 2) {
                    twoDayStay++;
                } else if (days == 3) {
                    threeDayStay++;
                } else if (days >= 4 && days <= 7) {
                    fourToSevenDayStay++;
                } else if (days > 7) {
                    moreThanSevenDayStay++;
                }
            }
        }

        HashMap<String, Integer> stayDurationStats = new HashMap<>();
        stayDurationStats.put("入住1天", oneDayStay);
        stayDurationStats.put("入住2天", twoDayStay);
        stayDurationStats.put("入住3天", threeDayStay);
        stayDurationStats.put("入住4-7天", fourToSevenDayStay);
        stayDurationStats.put("入住超过7天", moreThanSevenDayStay);
        result.put("入住时长统计", stayDurationStats);

        // 5. 周内/周末预订分析
        int weekdayBookings = 0;
        int weekendBookings = 0;
        double weekdayRevenue = 0.0;
        double weekendRevenue = 0.0;

        for (int i = 0; i < appoints.size(); i++) {
            Appoint appoint = appoints.get(i);

            if (appoint.getBeginAppointTime() != null) {
                int dayOfWeek = appoint.getBeginAppointTime().getDayOfWeek().getValue();
                boolean isWeekend = (dayOfWeek == 6 || dayOfWeek == 7);

                if (isWeekend) {
                    weekendBookings++;
                    if (appoint.getTotalMoney() != null) {
                        weekendRevenue += appoint.getTotalMoney();
                    }
                } else {
                    weekdayBookings++;
                    if (appoint.getTotalMoney() != null) {
                        weekdayRevenue += appoint.getTotalMoney();
                    }
                }
            }
        }

        HashMap<String, Object> weekdayWeekendStats = new HashMap<>();
        weekdayWeekendStats.put("工作日预订数", weekdayBookings);
        weekdayWeekendStats.put("周末预订数", weekendBookings);
        weekdayWeekendStats.put("工作日收入", weekdayRevenue);
        weekdayWeekendStats.put("周末收入", weekendRevenue);
        weekdayWeekendStats.put("周末预订比例", totalAppointCount > 0 ? (double) weekendBookings / totalAppointCount : 0);
        result.put("工作日/周末统计", weekdayWeekendStats);

        // 6. 提前预订天数分析
        int sameDayBooking = 0;
        int oneDayAdvance = 0;
        int twoDaysAdvance = 0;
        int threeToSevenDaysAdvance = 0;
        int moreThanSevenDaysAdvance = 0;

        for (int i = 0; i < appoints.size(); i++) {
            Appoint appoint = appoints.get(i);

            if (appoint.getCreationTime() != null && appoint.getBeginAppointTime() != null) {
                long daysInAdvance = java.time.Duration.between(
                        appoint.getCreationTime(),
                        appoint.getBeginAppointTime()).toDays();

                if (daysInAdvance == 0) {
                    sameDayBooking++;
                } else if (daysInAdvance == 1) {
                    oneDayAdvance++;
                } else if (daysInAdvance == 2) {
                    twoDaysAdvance++;
                } else if (daysInAdvance >= 3 && daysInAdvance <= 7) {
                    threeToSevenDaysAdvance++;
                } else if (daysInAdvance > 7) {
                    moreThanSevenDaysAdvance++;
                }
            }
        }

        HashMap<String, Integer> advanceBookingStats = new HashMap<>();
        advanceBookingStats.put("当天预订", sameDayBooking);
        advanceBookingStats.put("提前1天", oneDayAdvance);
        advanceBookingStats.put("提前2天", twoDaysAdvance);
        advanceBookingStats.put("提前3-7天", threeToSevenDaysAdvance);
        advanceBookingStats.put("提前超过7天", moreThanSevenDaysAdvance);
        result.put("提前预订天数统计", advanceBookingStats);

        return result;
    }

    /**
     * 酒店运营综合分析统计
     * 
     * @param input 查询参数
     * @return 多维度统计数据
     */
    @SneakyThrows
    @Override
    public HashMap<String, Object> SynthesizeStatistics(HotelDataAnalysisQueryInput input) {
        HashMap<String, Object> result = new HashMap<>();
        Integer hotelId = input.getHotelId();
        LocalDateTime startDate = input.getStartTime();
        LocalDateTime endDate = input.getEndTime();

        // 查询该时间段内所有预约
        List<Appoint> appoints = AppointMapper.selectList(Wrappers.<Appoint>lambdaQuery()
                .eq(hotelId != null, Appoint::getHotelId, hotelId)
                .ge(startDate != null, Appoint::getBeginAppointTime, startDate)
                .le(endDate != null, Appoint::getEndAppointTime, endDate));

        if (appoints == null || appoints.isEmpty()) {
            result.put("message", "该时间段内无数据记录");
            return result;
        }

        // 1. 预约数量统计和分析
        int totalAppoints = appoints.size();
        result.put("总预约数量", totalAppoints);

        // 2. 预约状态分布
        int pendingCount = 0;
        int confirmedCount = 0;
        int completedCount = 0;
        int userCanceledCount = 0;
        int hotelCanceledCount = 0;
        int systemCanceledCount = 0;

        for (int i = 0; i < appoints.size(); i++) {
            Appoint appoint = appoints.get(i);
            Integer status = appoint.getAppointStatus();
            if (status == null)
                continue;

            if (status.equals(AppointStatusEnum.待确定.index())) {
                pendingCount++;
            } else if (status.equals(AppointStatusEnum.待入住.index())) {
                confirmedCount++;
            } else if (status.equals(AppointStatusEnum.完成.index())) {
                completedCount++;
            } else if (status.equals(AppointStatusEnum.用户取消.index())) {
                userCanceledCount++;
            } else if (status.equals(AppointStatusEnum.酒店取消.index())) {
                hotelCanceledCount++;
            } else if (status.equals(AppointStatusEnum.系统取消.index())) {
                systemCanceledCount++;
            }
        }

        HashMap<String, Object> statusStats = new HashMap<>();
        statusStats.put("待确定", pendingCount);
        statusStats.put("待入住", confirmedCount);
        statusStats.put("已完成", completedCount);
        statusStats.put("用户取消", userCanceledCount);
        statusStats.put("酒店取消", hotelCanceledCount);
        statusStats.put("系统取消", systemCanceledCount);

        // 计算各状态比例
        if (totalAppoints > 0) {
            statusStats.put("待确定比例", (double) pendingCount / totalAppoints);
            statusStats.put("待入住比例", (double) confirmedCount / totalAppoints);
            statusStats.put("已完成比例", (double) completedCount / totalAppoints);
            statusStats.put("用户取消比例", (double) userCanceledCount / totalAppoints);
            statusStats.put("酒店取消比例", (double) hotelCanceledCount / totalAppoints);
            statusStats.put("系统取消比例", (double) systemCanceledCount / totalAppoints);
        }

        result.put("预约状态分布", statusStats);

        // 3. 预约时间分布分析（按月份）
        HashMap<Integer, Integer> monthlyBookings = new HashMap<>();
        HashMap<Integer, Double> monthlyRevenue = new HashMap<>();
        for (int i = 1; i <= 12; i++) {
            monthlyBookings.put(i, 0);
            monthlyRevenue.put(i, 0.0);
        }

        for (int i = 0; i < appoints.size(); i++) {
            Appoint appoint = appoints.get(i);
            if (appoint.getBeginAppointTime() != null) {
                int month = appoint.getBeginAppointTime().getMonthValue();
                monthlyBookings.put(month, monthlyBookings.get(month) + 1);

                if (appoint.getTotalMoney() != null) {
                    monthlyRevenue.put(month, monthlyRevenue.get(month) + appoint.getTotalMoney());
                }
            }
        }

        result.put("月度预约数量", monthlyBookings);
        result.put("月度收入", monthlyRevenue);

        // 4. 高峰期分析
        HashMap<String, Integer> peakTimeAnalysis = new HashMap<>();
        int morningBookings = 0; // 6:00-12:00
        int afternoonBookings = 0; // 12:00-18:00
        int eveningBookings = 0; // 18:00-22:00
        int nightBookings = 0; // 22:00-6:00

        for (int i = 0; i < appoints.size(); i++) {
            Appoint appoint = appoints.get(i);
            if (appoint.getCreationTime() != null) {
                int hour = appoint.getCreationTime().getHour();

                if (hour >= 6 && hour < 12) {
                    morningBookings++;
                } else if (hour >= 12 && hour < 18) {
                    afternoonBookings++;
                } else if (hour >= 18 && hour < 22) {
                    eveningBookings++;
                } else {
                    nightBookings++;
                }
            }
        }

        peakTimeAnalysis.put("早晨预约(6:00-12:00)", morningBookings);
        peakTimeAnalysis.put("下午预约(12:00-18:00)", afternoonBookings);
        peakTimeAnalysis.put("晚间预约(18:00-22:00)", eveningBookings);
        peakTimeAnalysis.put("夜间预约(22:00-6:00)", nightBookings);
        result.put("预约时段分布", peakTimeAnalysis);

        // 5. 房间类型受欢迎度和收入贡献
        if (hotelId != null) {
            List<Room> rooms = RoomMapper.selectList(Wrappers.<Room>lambdaQuery()
                    .eq(Room::getHotelId, hotelId));

            if (rooms != null && !rooms.isEmpty()) {
                HashMap<String, Integer> roomTypeBookingCount = new HashMap<>();
                HashMap<String, Double> roomTypeRevenue = new HashMap<>();
                HashMap<String, Double> roomTypeOccupancyRate = new HashMap<>();

                // 初始化房间类型统计数据
                for (int i = 0; i < rooms.size(); i++) {
                    Room room = rooms.get(i);
                    if (room.getTitle() != null) {
                        roomTypeBookingCount.put(room.getTitle(), 0);
                        roomTypeRevenue.put(room.getTitle(), 0.0);
                        roomTypeOccupancyRate.put(room.getTitle(), 0.0);
                    }
                }

                // 统计每种房型的预约数和收入
                for (int i = 0; i < appoints.size(); i++) {
                    Appoint appoint = appoints.get(i);
                    Integer roomId = appoint.getRoomId();

                    if (roomId != null) {
                        Room room = RoomMapper.selectById(roomId);
                        if (room != null && room.getTitle() != null) {
                            String roomType = room.getTitle();
                            roomTypeBookingCount.put(roomType, roomTypeBookingCount.getOrDefault(roomType, 0) + 1);

                            if (appoint.getTotalMoney() != null) {
                                roomTypeRevenue.put(roomType,
                                        roomTypeRevenue.getOrDefault(roomType, 0.0) + appoint.getTotalMoney());
                            }
                        }
                    }
                }

                // 计算入住率
                for (int i = 0; i < rooms.size(); i++) {
                    Room room = rooms.get(i);
                    if (room.getTitle() != null) {
                        String roomType = room.getTitle();

                        // 获取该类型房间的总数
                        long roomCount = RoomDetMapper.selectCount(Wrappers.<RoomDet>lambdaQuery()
                                .eq(RoomDet::getHotelId, hotelId)
                                .eq(RoomDet::getRoomId, room.getId()));

                        if (roomCount > 0) {
                            int bookingCount = roomTypeBookingCount.getOrDefault(roomType, 0);
                            double occupancyRate = (double) bookingCount / roomCount;
                            roomTypeOccupancyRate.put(roomType, occupancyRate);
                        }
                    }
                }

                HashMap<String, Object> roomAnalysis = new HashMap<>();
                roomAnalysis.put("房型预约数量", roomTypeBookingCount);
                roomAnalysis.put("房型收入贡献", roomTypeRevenue);
                roomAnalysis.put("房型入住率", roomTypeOccupancyRate);
                result.put("房型分析", roomAnalysis);
            }
        }

        // 6. 客户分析
        HashMap<String, Object> customerAnalysis = new HashMap<>();

        // 获取所有预约的用户ID
        List<Integer> userIds = appoints.stream()
                .map(Appoint::getToUserId)
                .filter(id -> id != null)
                .distinct()
                .collect(Collectors.toList());

        int newCustomerCount = 0;
        int returningCustomerCount = 0;

        HashMap<Integer, Integer> userBookingFrequency = new HashMap<>();

        for (int i = 0; i < userIds.size(); i++) {
            Integer userId = userIds.get(i);
            if (userId == null)
                continue;

            long userBookings = appoints.stream()
                    .filter(appoint -> userId.equals(appoint.getToUserId()))
                    .count();

            userBookingFrequency.put(userId, (int) userBookings);

            if (userBookings == 1) {
                newCustomerCount++;
            } else {
                returningCustomerCount++;
            }
        }

        customerAnalysis.put("新客户数量", newCustomerCount);
        customerAnalysis.put("回头客数量", returningCustomerCount);
        customerAnalysis.put("回头率", userIds.isEmpty() ? 0 : (double) returningCustomerCount / userIds.size());

        // 客户行为分析
        int avgStayDuration = 0;
        int totalDays = 0;
        int validBookingsForDuration = 0;

        for (int i = 0; i < appoints.size(); i++) {
            Appoint appoint = appoints.get(i);
            if (appoint.getBeginAppointTime() != null && appoint.getEndAppointTime() != null) {
                int days = (int) java.time.Duration.between(
                        appoint.getBeginAppointTime(),
                        appoint.getEndAppointTime()).toDays();

                if (days > 0) {
                    totalDays += days;
                    validBookingsForDuration++;
                }
            }
        }

        if (validBookingsForDuration > 0) {
            avgStayDuration = totalDays / validBookingsForDuration;
        }

        customerAnalysis.put("平均入住天数", avgStayDuration);
        result.put("客户分析", customerAnalysis);

        // 7. 收入和盈利能力分析
        HashMap<String, Object> financialAnalysis = new HashMap<>();

        double totalRevenue = 0.0;
        for (int i = 0; i < appoints.size(); i++) {
            Appoint appoint = appoints.get(i);
            if (appoint.getTotalMoney() != null) {
                totalRevenue += appoint.getTotalMoney();
            }
        }

        financialAnalysis.put("总收入", totalRevenue);

        // 计算每间房平均收入
        if (hotelId != null) {
            long roomCount = RoomDetMapper.selectCount(Wrappers.<RoomDet>lambdaQuery()
                    .eq(RoomDet::getHotelId, hotelId));

            if (roomCount > 0) {
                financialAnalysis.put("每间房平均收入", totalRevenue / roomCount);
            }
        }

        result.put("财务分析", financialAnalysis);

        // 8. 预约提前时间分析
        HashMap<String, Integer> advanceBookingAnalysis = new HashMap<>();
        int sameDay = 0;
        int oneToThreeDays = 0;
        int fourToSevenDays = 0;
        int eightToFourteenDays = 0;
        int fifteenToThirtyDays = 0;
        int moreThanThirtyDays = 0;

        for (int i = 0; i < appoints.size(); i++) {
            Appoint appoint = appoints.get(i);
            if (appoint.getCreationTime() != null && appoint.getBeginAppointTime() != null) {
                long daysInAdvance = java.time.Duration.between(
                        appoint.getCreationTime(),
                        appoint.getBeginAppointTime()).toDays();

                if (daysInAdvance <= 0) {
                    sameDay++;
                } else if (daysInAdvance <= 3) {
                    oneToThreeDays++;
                } else if (daysInAdvance <= 7) {
                    fourToSevenDays++;
                } else if (daysInAdvance <= 14) {
                    eightToFourteenDays++;
                } else if (daysInAdvance <= 30) {
                    fifteenToThirtyDays++;
                } else {
                    moreThanThirtyDays++;
                }
            }
        }

        advanceBookingAnalysis.put("当天预订", sameDay);
        advanceBookingAnalysis.put("提前1-3天", oneToThreeDays);
        advanceBookingAnalysis.put("提前4-7天", fourToSevenDays);
        advanceBookingAnalysis.put("提前8-14天", eightToFourteenDays);
        advanceBookingAnalysis.put("提前15-30天", fifteenToThirtyDays);
        advanceBookingAnalysis.put("提前30天以上", moreThanThirtyDays);
        result.put("预订提前时间分析", advanceBookingAnalysis);

        return result;
    }
}
