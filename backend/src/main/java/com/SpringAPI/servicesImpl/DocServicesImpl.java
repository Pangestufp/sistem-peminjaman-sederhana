package com.SpringAPI.servicesImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.SpringAPI.dao.DocDao;
import com.SpringAPI.entities.DetailDoc;
import com.SpringAPI.entities.HeaderDoc;
import com.SpringAPI.entities.Payment;
import com.SpringAPI.entities.Workflow;
import com.SpringAPI.services.DocServices;

@Service
public class DocServicesImpl implements DocServices{

	@Autowired
	DocDao docDao;

	@Override
	public List<HeaderDoc> getAllDoc() {
		// TODO Auto-generated method stub
		return docDao.getAllDoc();
	}

	@Override
	public String getDocNo(String IdUser) {
		// TODO Auto-generated method stub
		return docDao.getDocNo(IdUser);
	}

	@Override
	public void saveHeaderDoc(HeaderDoc headerDoc) {
		docDao.saveHeaderDoc(headerDoc);
		
	}

	@Override
	public void savePayment(Payment payment) {
		// TODO Auto-generated method stub
		docDao.savePayment(payment);
		
	}

	@Override
	public void saveDetailDoc(DetailDoc detailDoc) {
		// TODO Auto-generated method stub
		docDao.saveDetailDoc(detailDoc);
		
	}

	@Override
	public void saveWorkFlow(Workflow workFlow) {
		docDao.saveWorkFlow(workFlow);
		
	}

	@Override
	public HeaderDoc getHeaderDocByDocNo(String docNo) {
		// TODO Auto-generated method stub
		return docDao.getHeaderDocByDocNo(docNo);
	}

	@Override
	public List<Workflow> getWorkFlowByDocNo(String docNo) {
		// TODO Auto-generated method stub
		return docDao.getWorkFlowByDocNo(docNo);
	}

	@Override
	public List<Payment> getPaymentByDocNo(String docNo) {
		// TODO Auto-generated method stub
		return docDao.getPaymentByDocNo(docNo);
	}

	@Override
	public List<DetailDoc> getDetailDocByDocNo(String docNo) {
		// TODO Auto-generated method stub
		return docDao.getDetailDocByDocNo(docNo);
	}

	@Override
	public void updateHeaderDoc(HeaderDoc headerDoc) {
		// TODO Auto-generated method stub
		docDao.updateHeaderDoc(headerDoc);
	}

	@Override
	public void updateWorkFlow(Workflow workflow) {
		// TODO Auto-generated method stub
		docDao.updateWorkFlow(workflow);
	}

	@Override
	public void updatePayment(Payment payment) {
		// TODO Auto-generated method stub
		docDao.updatePayment(payment);
	}

	@Override
	public List<HeaderDoc> getAllHeaderDocByCreatorId(String CreatorId) {
		// TODO Auto-generated method stub
		return docDao.getAllHeaderDocByCreatorId(CreatorId);
	}

	@Override
	public List<Workflow> getWorkFlowByAssignnedId(String assignedId) {
		// TODO Auto-generated method stub
		return docDao.getWorkFlowByAssignnedId(assignedId);
	}

	@Override
	public List<HeaderDoc> getHeaderDocByPayerId(String payerId) {
		// TODO Auto-generated method stub
		return docDao.getHeaderDocByPayerId(payerId);
	}
	
	

	
	
	
	
	
}
