package com.neusoft.service.impl;

import com.neusoft.bean.Manager;
import com.neusoft.dao.ManagerMapper;
import com.neusoft.service.IManagerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class ManagerService implements IManagerService {
    @Autowired
    private ManagerMapper mapper;


    public List<Manager> selectAll(Map map) {
        return mapper.selectAll(map);
    }

    @Transactional(propagation = Propagation.REQUIRED)
    public int saveManager(Manager manager) {
        return mapper.insertSelective(manager);
    }

    //rollbackFor = RuntimeException.class 指定异常回滚，一般不加
    @Transactional(propagation = Propagation.REQUIRED,rollbackFor = RuntimeException.class)
    public void saveManager2(Manager manager) {
         int row=mapper.insertSelective(manager);
        System.out.println("影响的行数："+row);
         //手动抛出异常
         throw  new RuntimeException();
    }

}
