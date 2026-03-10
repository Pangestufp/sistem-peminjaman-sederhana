package com.SpringAPI.dao;

import java.util.List;

import com.SpringAPI.entities.DetailDoc;
import com.SpringAPI.entities.HeaderDoc;
import com.SpringAPI.entities.Payment;
import com.SpringAPI.entities.Workflow;

public interface DocDao {
	public List<HeaderDoc> getAllDoc();
	public String getDocNo(String IdUser);
	public void saveHeaderDoc(HeaderDoc headerDoc);
	public void savePayment(Payment payment);
	public void saveDetailDoc(DetailDoc detailDoc);
	public void saveWorkFlow(Workflow workFlow);
	
	public List<HeaderDoc> getAllHeaderDocByCreatorId(String CreatorId);
	public HeaderDoc getHeaderDocByDocNo(String docNo);
	public List<HeaderDoc> getHeaderDocByPayerId(String payerId);
	public List<Workflow> getWorkFlowByDocNo(String docNo);
	public List<Payment> getPaymentByDocNo(String docNo);
	public List<DetailDoc> getDetailDocByDocNo(String docNo);
	
	public void updateHeaderDoc(HeaderDoc headerDoc);
	public void updateWorkFlow(Workflow workflow);
	public void updatePayment(Payment payment);
	
	public List<Workflow> getWorkFlowByAssignnedId(String assignedId);
}
