package com.example.web.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.web.SysConst;
import com.example.web.dto.*;
import com.example.web.dto.query.*;
import com.example.web.entity.*;
import com.example.web.mapper.*;
import com.example.web.enums.*;
import com.example.web.service.*;
import com.example.web.tools.dto.*;
import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.lang.reflect.InvocationTargetException;
import java.util.stream.Collectors;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import lombok.SneakyThrows;
import java.io.IOException;
import com.example.web.tools.*;
import java.text.DecimalFormat;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * 酒店积分功能实现类
 */
@Service
public class HotelIntegralServiceImpl extends ServiceImpl<HotelIntegralMapper, HotelIntegral>
        implements HotelIntegralService {

    /**
     * 操作数据库AppUser表mapper对象
     */
    @Autowired
    private AppUserMapper AppUserMapper;
    /**
     * 操作数据库的HotelIntegral表mapper对象
     */
    @Autowired
    private HotelIntegralMapper HotelIntegralMapper;
    @Autowired
    private HotelMapper HotelMapper;

    /**
     * 构建表查询sql
     */
    private LambdaQueryWrapper<HotelIntegral> BuilderQuery(HotelIntegralPagedInput input) {
        // 声明一个支持酒店积分查询的(拉姆达)表达式
        LambdaQueryWrapper<HotelIntegral> queryWrapper = Wrappers.<HotelIntegral>lambdaQuery()
                .eq(input.getId() != null && input.getId() != 0, HotelIntegral::getId, input.getId());
        // 如果前端搜索传入查询条件则拼接查询条件
        if (Extension.isNotNullOrEmpty(input.getTitle())) {
            queryWrapper = queryWrapper.like(HotelIntegral::getTitle, input.getTitle());
        }
        if (Extension.isNotNullOrEmpty(input.getRelativeNo())) {
            queryWrapper = queryWrapper.like(HotelIntegral::getRelativeNo, input.getRelativeNo());
        }
        if (Extension.isNotNullOrEmpty(input.getType())) {
            queryWrapper = queryWrapper.like(HotelIntegral::getType, input.getType());
        }

        if (input.getHotelId() != null) {
            queryWrapper = queryWrapper.eq(HotelIntegral::getHotelId, input.getHotelId());
        }

        if (Extension.isNotNullOrEmpty(input.getKeyWord())) {
            queryWrapper = queryWrapper.and(i -> i
                    .like(HotelIntegral::getTitle, input.getKeyWord()).or()
                    .like(HotelIntegral::getRelativeNo, input.getKeyWord()).or()
                    .like(HotelIntegral::getType, input.getKeyWord()).or());

        }

        return queryWrapper;
    }

    /**
     * 处理酒店积分对于的外键数据
     */
    private List<HotelIntegralDto> DispatchItem(List<HotelIntegralDto> items)
            throws InvocationTargetException, IllegalAccessException {

        for (HotelIntegralDto item : items) {

            // 查询出关联的AppUser表信息
            AppUser UserEntity = AppUserMapper.selectById(item.getUserId());
            item.setUserDto(UserEntity != null ? UserEntity.MapToDto() : new AppUserDto());

            // 查询出关联的Hotel表信息
            Hotel HotelEntity = HotelMapper.selectById(item.getHotelId());
            item.setHotelDto(HotelEntity != null ? HotelEntity.MapToDto() : new HotelDto());
        }

        return items;
    }

    /**
     * 酒店积分分页查询
     */
    @SneakyThrows
    @Override
    public PagedResult<HotelIntegralDto> List(HotelIntegralPagedInput input) {
        // 构建where条件+排序
        LambdaQueryWrapper<HotelIntegral> queryWrapper = BuilderQuery(input);
        // 动态排序处理
        if (input.getSortItem() != null) {
            // 根据字段名动态排序
            queryWrapper.last("ORDER BY " + input.getSortItem().getFieldName()
                    + (input.getSortItem().getIsAsc() ? " ASC" : " DESC"));
        } else {
            // 默认按创建时间从大到小排序
            queryWrapper = queryWrapper.orderByDesc(HotelIntegral::getCreationTime);
        }

        // 构建一个分页查询的model
        Page<HotelIntegral> page = new Page<>(input.getPage(), input.getLimit());
        // 从数据库进行分页查询获取酒店积分数据
        IPage<HotelIntegral> pageRecords = HotelIntegralMapper.selectPage(page, queryWrapper);
        // 获取所有满足条件的数据行数
        Long totalCount = HotelIntegralMapper.selectCount(queryWrapper);
        // 把HotelIntegral实体转换成HotelIntegral传输模型
        List<HotelIntegralDto> items = Extension.copyBeanList(pageRecords.getRecords(), HotelIntegralDto.class);

        DispatchItem(items);
        // 返回一个分页结构给前端
        return PagedResult.GetInstance(items, totalCount);

    }

    /**
     * 单个酒店积分查询
     */
    @SneakyThrows
    @Override
    public HotelIntegralDto Get(HotelIntegralPagedInput input) {
        if (input.getId() == null) {
            return new HotelIntegralDto();
        }

        PagedResult<HotelIntegralDto> pagedResult = List(input);
        return pagedResult.getItems().stream().findFirst().orElse(new HotelIntegralDto());
    }

    /**
     * 酒店积分创建或者修改
     */
    @SneakyThrows
    @Override
    public HotelIntegralDto CreateOrEdit(HotelIntegralDto input) {
        // 声明一个酒店积分实体
        HotelIntegral HotelIntegral = input.MapToEntity();
        // 调用数据库的增加或者修改方法
        saveOrUpdate(HotelIntegral);
        // 把传输模型返回给前端
        return HotelIntegral.MapToDto();
    }

    /**
     * 酒店积分删除
     */
    @Override
    public void Delete(IdInput input) {
        HotelIntegral entity = HotelIntegralMapper.selectById(input.getId());
        HotelIntegralMapper.deleteById(entity);
    }

    /**
     * 酒店积分批量删除
     */
    @Override
    public void BatchDelete(IdsInput input) {
        for (Integer id : input.getIds()) {
            IdInput idInput = new IdInput();
            idInput.setId(id);
            Delete(idInput);
        }
    }

    /**
     * 得到用户在该酒店下的积分 求和积分值
     */
    @SneakyThrows
    @Override
    public double GetUserHotelIntegral(HotelIntegralPagedInput input) {
        LambdaQueryWrapper<HotelIntegral> queryWrapper = Wrappers.<HotelIntegral>lambdaQuery()
                .eq(HotelIntegral::getUserId, input.getUserId())
                .eq(HotelIntegral::getHotelId, input.getHotelId());
        List<HotelIntegral> hotelIntegrals = HotelIntegralMapper.selectList(queryWrapper);
        return hotelIntegrals.stream().mapToDouble(HotelIntegral::getIntegralValue).sum();
    }

    /**
     * 得到用户所有酒店对应的积分
     * 根据酒店进行汇总
     */
    @SneakyThrows
    @Override
    public List<Object> GetUserAllHotelIntegral(HotelIntegralPagedInput input) {
        // 查询该用户在所有酒店的积分记录
        LambdaQueryWrapper<HotelIntegral> queryWrapper = Wrappers.<HotelIntegral>lambdaQuery()
                .eq(HotelIntegral::getUserId, input.getUserId());

        // 获取所有积分记录
        List<HotelIntegral> allIntegrals = HotelIntegralMapper.selectList(queryWrapper);

        // 按酒店ID分组，并计算每个酒店的总积分
        Map<Integer, Double> hotelIntegralMap = new HashMap<>();

        for (HotelIntegral integral : allIntegrals) {
            Integer hotelId = integral.getHotelId();
            Double currentValue = hotelIntegralMap.getOrDefault(hotelId, 0.0);
            hotelIntegralMap.put(hotelId, currentValue + integral.getIntegralValue());
        }

        // 构建结果列表
        List<Object> result = new ArrayList<>();

        for (Map.Entry<Integer, Double> entry : hotelIntegralMap.entrySet()) {
            Integer hotelId = entry.getKey();
            Double totalIntegral = entry.getValue();

            // 获取酒店信息
            Hotel hotel = HotelMapper.selectById(hotelId);

            // 构建返回对象
            Map<String, Object> hotelIntegralInfo = new HashMap<>();
            hotelIntegralInfo.put("hotelId", hotelId);
            hotelIntegralInfo.put("Hotel", hotel);
            hotelIntegralInfo.put("TotalIntegral", totalIntegral);

            result.add(hotelIntegralInfo);
        }

        return result;
    }
}
