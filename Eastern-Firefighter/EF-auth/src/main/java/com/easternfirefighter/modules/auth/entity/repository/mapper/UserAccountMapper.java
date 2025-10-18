package com.easternfirefighter.modules.auth.entity.repository.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.easternfirefighter.modules.auth.entity.UserAccount;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserAccountMapper extends BaseMapper<UserAccount> {
} 