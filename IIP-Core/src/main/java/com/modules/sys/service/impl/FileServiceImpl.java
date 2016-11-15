package com.modules.sys.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.modules.sys.dao.FileDAO;
import com.modules.sys.dto.Result;
import com.modules.sys.entity.FileInfo;
import com.modules.sys.service.FileService;

@Service("fileService")
public class FileServiceImpl implements FileService {

	@Autowired
	private FileDAO dao;
	
	@Override
	public Result save(FileInfo file) {
		try{
			dao.save(file);
			return Result.ok();
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public Result delt(String id) {
		try{
			dao.delt(id);
			return Result.ok();
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public FileInfo findOne(String id) {
		if(!StringUtils.isEmpty(id)){
			return dao.getById(id);
		}
		return null;
	}

}
