package com.SpringAPI.daoImpl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.transaction.Transactional;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.SpringAPI.dao.DocDao;
import com.SpringAPI.entities.DetailDoc;
import com.SpringAPI.entities.HeaderDoc;
import com.SpringAPI.entities.Payment;
import com.SpringAPI.entities.Users;
import com.SpringAPI.entities.Workflow;

@Repository
@Transactional
public class DocDaoImpl implements DocDao{
	
	@Autowired
	SessionFactory session;

	@SuppressWarnings("unchecked")
	@Override
	public List<HeaderDoc> getAllDoc() {
		List<HeaderDoc> listDocs=new ArrayList<>();
		Session querySession=session.getCurrentSession();
		try {
			Query query=querySession.createQuery("from HeaderDoc ORDER BY CREATEDDATE");
			listDocs=query.list();
		} catch (Exception e) {
			listDocs=null;
		}
		
		return listDocs;
	}
	



	@Override
	public String getDocNo(String IdUser) {
		List<HeaderDoc> listDocs=getAllDoc();
		Date now = new Date();

        // Format ke MM/YYYY
        SimpleDateFormat formatter = new SimpleDateFormat("/MM/yyyy");
        String formattedDate = formatter.format(now);
		if (listDocs == null ||listDocs.size()==0) {
			return IdUser+"/1001"+formattedDate;
		}
		
		
		HeaderDoc headerDoc=listDocs.get(listDocs.size()-1);
		
		String lastDocNo= headerDoc.getDocNo();
		String[] parts = lastDocNo.split("/");

		String newDocNo="";
		if (parts.length >= 3) {
		    newDocNo = parts[1];
		}
		
		int newDocNoInt=Integer.parseInt(newDocNo.trim())+1;
		
		
		
		return IdUser+"/"+newDocNoInt+formattedDate;
	}




	@Override
	public void saveHeaderDoc(HeaderDoc headerDoc) {
		Session querySession=session.getCurrentSession();
		try {
			querySession.save(headerDoc);
		} catch (Exception e) {
			System.out.println("Error saving header doc "+headerDoc.getDocNo());
		}
		
	}




	@Override
	public void savePayment(Payment payment) {
		Session querySession=session.getCurrentSession();
		try {
			querySession.save(payment);
		} catch (Exception e) {
			System.out.println("Error saving payment "+payment.getId().getDocNo()+" id= "+payment.getId().getId());
		}
		
	}




	@Override
	public void saveDetailDoc(DetailDoc detailDoc) {
		Session querySession=session.getCurrentSession();
		try {
			querySession.save(detailDoc);
		} catch (Exception e) {
			System.out.println("Error saving detail doc "+detailDoc.getId().getDocNo()+" id= "+detailDoc.getId().getId());
		}
	}




	@Override
	public void saveWorkFlow(Workflow workFlow) {
		Session querySession=session.getCurrentSession();
		try {
			querySession.save(workFlow);
		} catch (Exception e) {
			System.out.println("Error saving workflow "+workFlow.getId().getDocNo()+" id= "+workFlow.getId().getId());
		}
		
	}




	@Override
	public HeaderDoc getHeaderDocByDocNo(String docNo) {
		List<HeaderDoc> listDocs=new ArrayList<>();
		HeaderDoc headerDoc=new HeaderDoc();
		Session querySession=session.getCurrentSession();
		try {
			Query query=querySession.createQuery("from HeaderDoc where DOCNO = '"+docNo+"'");
			listDocs=query.list();
			headerDoc=listDocs.get(0);
		} catch (Exception e) {
			headerDoc=null;
		}
		
		return headerDoc;
	}




	@Override
	public List<Workflow> getWorkFlowByDocNo(String docNo) {
		List<Workflow> listWorkflows=new ArrayList<>();
		Session querySession=session.getCurrentSession();
		try {
			Query query=querySession.createQuery("from Workflow where DOCNO = '"+docNo+"' ORDER BY ID, PARAREL");
			listWorkflows=query.list();
		} catch (Exception e) {
			listWorkflows=null;
		}
		
		return listWorkflows;
	}




	@Override
	public List<Payment> getPaymentByDocNo(String docNo) {
		List<Payment> listPayments=new ArrayList<>();
		Session querySession=session.getCurrentSession();
		try {
			Query query=querySession.createQuery("from Payment where DOCNO = '"+docNo+"' ORDER BY ID");
			listPayments=query.list();
		} catch (Exception e) {
			listPayments=null;
		}
		
		return listPayments;
	}




	@Override
	public List<DetailDoc> getDetailDocByDocNo(String docNo) {
		List<DetailDoc> listDetailDocs=new ArrayList<>();
		Session querySession=session.getCurrentSession();
		try {
			Query query=querySession.createQuery("from DetailDoc where DOCNO = '"+docNo+"' ORDER BY ID");
			listDetailDocs=query.list();
		} catch (Exception e) {
			listDetailDocs=null;
		}
		
		return listDetailDocs;
	}




	@Override
	public void updateHeaderDoc(HeaderDoc headerDoc) {
		Session querySession=session.getCurrentSession();
		try {
			querySession.update(headerDoc);
		} catch (Exception e) {
			System.out.println("Error update headerDoc doc "+headerDoc.getDocNo());
		}		
	}




	@Override
	public void updateWorkFlow(Workflow workflow) {
		Session querySession=session.getCurrentSession();
		try {
			querySession.update(workflow);
		} catch (Exception e) {
			System.out.println("Error update workflow doc "+workflow.getId().getDocNo()+" id= "+workflow.getId().getId());
		}
	}




	@Override
	public void updatePayment(Payment payment) {
		Session querySession=session.getCurrentSession();
		try {
			querySession.update(payment);
		} catch (Exception e) {
			System.out.println("Error update payment doc "+payment.getId().getDocNo()+" id= "+payment.getId().getId());
		}
		
	}




	@Override
	public List<HeaderDoc> getAllHeaderDocByCreatorId(String CreatorId) {
		List<HeaderDoc> listDocs=new ArrayList<>();
		Session querySession=session.getCurrentSession();
		try {
			Query query=querySession.createQuery("from HeaderDoc where CREATORID = '"+CreatorId+"' ORDER BY CREATEDDATE");
			listDocs=query.list();
		} catch (Exception e) {
			listDocs=null;
		}
		
		return listDocs;
	}




	@Override
	public List<Workflow> getWorkFlowByAssignnedId(String assignedId) {	
		List<Workflow> listWorkflows=new ArrayList<>();
		Session querySession=session.getCurrentSession();
		try {
			Query query=querySession.createQuery("from Workflow where ASSIGNNEDID='"+assignedId+"' AND ACTION IS NULL");
			listWorkflows=query.list();
		} catch (Exception e) {
			listWorkflows=null;
		}
		
		return listWorkflows;
	}




	@Override
	public List<HeaderDoc> getHeaderDocByPayerId(String payerId) {
		List<HeaderDoc> listDocs=new ArrayList<>();
		Session querySession=session.getCurrentSession();
		try {
			Query query=querySession.createQuery("from HeaderDoc where PAYERID = '"+payerId+"' ORDER BY CREATEDDATE");
			listDocs=query.list();
		} catch (Exception e) {
			listDocs=null;
		}
		
		return listDocs;
	}
	
	
	
	
	
	
}
