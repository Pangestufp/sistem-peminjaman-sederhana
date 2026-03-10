package com.SpringAPI.controllers;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.SpringAPI.config.JwtTokenUtil;
import com.SpringAPI.entities.DetailDoc;
import com.SpringAPI.entities.DetailDocId;
import com.SpringAPI.entities.HeaderDoc;
import com.SpringAPI.entities.Payment;
import com.SpringAPI.entities.PaymentId;
import com.SpringAPI.entities.Users;
import com.SpringAPI.entities.UsersAccess;
import com.SpringAPI.entities.UsersView;
import com.SpringAPI.entities.Workflow;
import com.SpringAPI.entities.WorkflowId;
import com.SpringAPI.services.DocServices;
import com.SpringAPI.services.UserServices;

@Controller
public class AppPeminjamanController {
	
	@Autowired
	UserServices userServices;
	
	@Autowired
	DocServices docServices;
	
	@Autowired
    private JwtTokenUtil jwtTokenUtil;
	
	@RequestMapping(value = "/peminjaman/createDoc", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> createDocument(HttpServletRequest requestHeader,@RequestBody Map<String, Object> request) {
		List<Payment> listPayments=new ArrayList<>();
		List<DetailDoc> listDocs=new ArrayList<>();
		List<Workflow> listWorkflows=new ArrayList<>();
		int indexDetail=1;
		int indexPayment=1;
		Double totalAll=0.0;
		
		Map<String, Object> map = new HashMap<>();
		
	    String creatorName = (String) request.get("creatorName");
	    int bunga = (int) request.get("bunga");
	    //System.out.println("Creator Name: " + creatorName);
	    
	    UsersView userviewC=new UsersView();
		userviewC=userServices.findUserByUsername(creatorName);

	    String docNo = docServices.getDocNo(Integer.toString(userviewC.getIdUser()));
	    
	    
	    String payerName = (String) request.get("payerName");
	    //System.out.println("Payer Name: " + payerName);
	    
	    UsersView userviewP=new UsersView();
		userviewP=userServices.findUserByUsername(payerName);
	    
	    
	    
	    final String requestTokenHeader = requestHeader.getHeader("Authorization");
		String userNameKey="";
		try {
			String jwtToken = requestTokenHeader.substring(7);
			final String userNameFromToken = jwtTokenUtil.getUsernameFromToken(jwtToken);
			userNameKey=userNameFromToken;
			System.out.println("userNameFromToken :"+userNameFromToken);
		} catch (Exception e) {
			System.out.println("gagal Mendapatkan username");
		}
	    
		if (!creatorName.equals(userNameKey)) {
	        map.put("status", "403");
	        map.put("message", "Forbidden, you cannot create document using other username");
	        return map;
	    }
	    
	    
		Date date = new Date();
	    
	    
	    
	    // Ambil detail sebagai List of Map
	    List<Map<String, Object>> details = (List<Map<String, Object>>) request.get("detail");

	    if (details != null) {
	        for (Map<String, Object> item : details) {
	            String text = (String) item.get("text");
	            int subtotalint = (int) item.get("subtotal");
	            Double subtotal=Double.parseDouble(Integer.toString(subtotalint));
	            
	            //System.out.println("Text: " + text + ", Subtotal: " + subtotal);
	            
	            DetailDocId detailDocId=new DetailDocId();
	            detailDocId.setDocNo(docNo);
	            detailDocId.setId(indexDetail);
	            indexDetail++;
	            
	            DetailDoc detailDoc=new DetailDoc();
	            detailDoc.setId(detailDocId);
	            detailDoc.setSubTotal(subtotal);
	            detailDoc.setText(text);
	            totalAll=totalAll+subtotal;
	            
	            listDocs.add(detailDoc);
	            
	        }
	    } else {
	        System.out.println("Details is null");
	    }

	    // Ambil payment sebagai List of Map
	    List<Map<String, Object>> payments = (List<Map<String, Object>>) request.get("payment");

	    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
	    
	    if (payments != null) {
	        for (Map<String, Object> item : payments) {
	            String maxPaymentDateStr = (String) item.get("maxPaymentDate");
	            Date maxPaymentDate;
	            try {
	                maxPaymentDate = sdf.parse(maxPaymentDateStr);
	            } catch (ParseException e) {
	            	maxPaymentDate=date;
	            }
	            int totalint = (int) item.get("total");
	            Double total=Double.parseDouble(Integer.toString(totalint));

	            //System.out.println("maxPaymentDate: " + maxPaymentDate + ", total: " + total);
	            
	            PaymentId paymentId=new PaymentId();
	            paymentId.setDocNo(docNo);
	            paymentId.setId(indexPayment);
	            indexPayment++;
	            
	            Payment payment=new Payment();
	            payment.setId(paymentId);
	            payment.setTotal(total);
	            payment.setMaxPaymentDate(maxPaymentDate);
	            payment.setStatus("UNPAID");
	            listPayments.add(payment);
	            
	            
	        }
	        
	    } else {
	        System.out.println("Payments is null");
	    }
	    
	    
	 // Ambil payment sebagai List of Map
	    List<Map<String, Object>> assigns = (List<Map<String, Object>>) request.get("assign");
	    
	    if (assigns != null) {
	        for (Map<String, Object> item : assigns) {
	        	int index = (int) item.get("index");
	        	int pararel = (int) item.get("pararel");
	        	String assignnedName = (String) item.get("assignnedName");
	        	String action = (String) item.get("action");
	        	
	        	WorkflowId workflowId=new WorkflowId();
	        	workflowId.setDocNo(docNo);
	        	workflowId.setId(index);
	        	workflowId.setPararel(pararel);
	        	
	        	
	        	Workflow workflow=new Workflow();
	        	workflow.setId(workflowId);
	        	
	        	
	        	UsersView userviewAs=new UsersView();
	        	userviewAs=userServices.findUserByUsername(assignnedName);
	        	
	        	workflow.setAssignedId(userviewAs.getIdUser());
	        	workflow.setAssignedName(userviewAs.getUserName());
	        	workflow.setAssignedAction(action);
	        	
	        	listWorkflows.add(workflow);
	            
	        }
	        
	    } else {
	        System.out.println("Assigns is null");
	    }
	   
	    HeaderDoc headerDoc =new HeaderDoc();

	    headerDoc.setDocNo(docNo);
	    headerDoc.setCreatorId(userviewC.getIdUser());
	    headerDoc.setCreatorName(userviewC.getUserName());
	    headerDoc.setPayerId(userviewP.getIdUser());
	    headerDoc.setPayerName(userviewP.getUserName());
	    headerDoc.setCreatedDate(date);
	    headerDoc.setAllTotal(totalAll);
	    headerDoc.setBunga(bunga);
	    headerDoc.setStatus("OPEN");

	    
	    System.out.println(headerDoc.toString());
	    docServices.saveHeaderDoc(headerDoc);
	    
	    for (DetailDoc doc : listDocs) {
			System.out.println(doc.toString());
			docServices.saveDetailDoc(doc);
		}
	    
	    for (Payment pay : listPayments) {
			System.out.println(pay.toString());
			docServices.savePayment(pay);
		}
	    
	    
	 // Pertama, kita butuh Map untuk menyimpan data yang sama berdasarkan docNo dan id
	    Map<String, List<Workflow>> groupByDocNoAndId = new HashMap<>();

	    for (Workflow workFlow : listWorkflows) {
	        // Key unik = gabungan docNo dan id
	        String key = workFlow.getId().getDocNo() + "_" + workFlow.getId().getId();
	        
	        groupByDocNoAndId.putIfAbsent(key, new ArrayList<>());
	        groupByDocNoAndId.get(key).add(workFlow);
	    }

	    // Sekarang update pararel
	    for (List<Workflow> workflows : groupByDocNoAndId.values()) {
	        if (workflows.size() == 1) {
	            // Kalau cuma satu data, pastikan pararel = 0
	            workflows.get(0).getId().setPararel(0);
	        } else {
	            // Kalau ada lebih dari satu, set pararel mulai dari 1, 2, dst
	            int pararelCounter = 1;
	            for (Workflow wf : workflows) {
	                wf.getId().setPararel(pararelCounter++);
	            }
	        }
	    }

	    
	    
	    for (Workflow workFlow : listWorkflows) {
			System.out.println(workFlow.toString());
			docServices.saveWorkFlow(workFlow);
		}
	    

	    if (docNo != null) {
	        map.put("status", "200");
	        map.put("message", "Document created");
	        map.put("data", docNo);
	    } else {
	        map.put("status", "404");
	        map.put("message", "Can't create document");
	    }
	    return map;
	}

	
	

	@RequestMapping(value = "/peminjaman/getAllUserDoc",method = RequestMethod.GET)
	public @ResponseBody Map<String, Object> getAllUserDoc(HttpServletRequest requestHeader) {
		
		
		final String requestTokenHeader = requestHeader.getHeader("Authorization");
		String userNameKey="";
		try {
			String jwtToken = requestTokenHeader.substring(7);
			final String userNameFromToken = jwtTokenUtil.getUsernameFromToken(jwtToken);
			userNameKey=userNameFromToken;
			System.out.println("userNameFromToken :"+userNameFromToken);
		} catch (Exception e) {
			System.out.println("gagal Mendapatkan username");
		}
		
		UsersView userview=userServices.findUserByUsername(userNameKey);
		Map<String, Object> map = new HashMap<String,Object>();
		List<Map<String, Object>> dataList = new ArrayList<>();
		
		
		List<HeaderDoc> listHeaderDocs=docServices.getAllHeaderDocByCreatorId(Integer.toString(userview.getIdUser()));
		
		
		
		 for (HeaderDoc headerDoc : listHeaderDocs) {
		        List<DetailDoc> listDetailDocs = docServices.getDetailDocByDocNo(headerDoc.getDocNo());
		        List<Payment> listPayments = docServices.getPaymentByDocNo(headerDoc.getDocNo());
		        List<Workflow> listWorkflows =docServices.getWorkFlowByDocNo(headerDoc.getDocNo());

		        Map<String, Object> dataEntry = new HashMap<>();
		        dataEntry.put("header", headerDoc);
		        dataEntry.put("details", listDetailDocs);
		        dataEntry.put("payments", listPayments);
		        dataEntry.put("workflows", listWorkflows);

		        dataList.add(dataEntry);
		    }
		
		if(listHeaderDocs !=null) {
			map.put("status", "200");
			map.put("message", "Data found");
			map.put("data", dataList);
		}else {
			map.put("status", "404");
			map.put("message", "Data not found");
		}
		return map;
	}
	
	
	@RequestMapping(value = "/peminjaman/getDocbyDocNo",method = RequestMethod.GET)
	public @ResponseBody Map<String, Object> getDocbyDocNo(HttpServletRequest requestHeader,@RequestParam("docNo") String docNo) {
		
		Map<String, Object> map = new HashMap<String,Object>();
		List<Map<String, Object>> dataList = new ArrayList<>();
		
		HeaderDoc headerDoc = docServices.getHeaderDocByDocNo(docNo);

		List<DetailDoc> listDetailDocs = docServices.getDetailDocByDocNo(headerDoc.getDocNo());
		List<Payment> listPayments = docServices.getPaymentByDocNo(headerDoc.getDocNo());
		List<Workflow> listWorkflows = docServices.getWorkFlowByDocNo(headerDoc.getDocNo());

		Map<String, Object> dataEntry = new HashMap<>();
		dataEntry.put("header", headerDoc);
		dataEntry.put("details", listDetailDocs);
		dataEntry.put("payments", listPayments);
		dataEntry.put("workflows", listWorkflows);

		dataList.add(dataEntry);

		if(headerDoc !=null) {
			map.put("status", "200");
			map.put("message", "Data found");
			map.put("data", dataList);
		}else {
			map.put("status", "404");
			map.put("message", "Data not found");
		}
		return map;
	}
	
	
	@RequestMapping(value = "/peminjaman/approve",method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> approveDocument(HttpServletRequest requestHeader, @RequestBody Map<String, Object> request) {
		
		Date date = new Date();
		final String requestTokenHeader = requestHeader.getHeader("Authorization");
		String userNameKey="";
		try {
			String jwtToken = requestTokenHeader.substring(7);
			final String userNameFromToken = jwtTokenUtil.getUsernameFromToken(jwtToken);
			userNameKey=userNameFromToken;
			System.out.println("userNameFromToken :"+userNameFromToken);
		} catch (Exception e) {
			System.out.println("gagal Mendapatkan username");
		}
		
		int result=0;
		UsersView userview=userServices.findUserByUsername(userNameKey);
		String docNo = (String) request.get("docNo");
	    String action = (String) request.get("action");
	    String reason = (String) request.get("reason");
	    HeaderDoc headerDoc=docServices.getHeaderDocByDocNo(docNo);
	    Map<String, Object> map = new HashMap<String,Object>();
		List<Workflow> listWorkflows = docServices.getWorkFlowByDocNo(docNo);
		List<Workflow> listPararelWorkflows = new ArrayList<>();
		Workflow soloWorkflow = null;
		
		
		if (headerDoc.getStatus().equals("CLOSED")||headerDoc.getStatus().equals("REJECTED")) {
			map.put("status", "404");
			map.put("message", "Document is "+headerDoc.getStatus());
		
			return map;
		}
		
		int access=0;
		for (Workflow workflow : listWorkflows) {
			if(Integer.toString(workflow.getAssignedId()).equals(Integer.toString(userview.getIdUser()))) {
				access=1;
			}
		}
		
		if (access==0) {
			map.put("status", "404");
			map.put("message", "You have no access to approve");
		
			return map;
		}

		// Temukan baris pertama yang belum memiliki action
		for (Workflow workflow : listWorkflows) {
			if (workflow.getAction() == null || workflow.getAction().trim().isEmpty()) {
				int currentId = workflow.getId().getId();
				int currentPararel = workflow.getId().getPararel();

				if (currentPararel == 0) {
					soloWorkflow = workflow;

					break;
				} else {
					for (Workflow wf : listWorkflows) {
						if (wf.getAction() == null || wf.getAction().trim().isEmpty()) {
							if (wf.getId().getId() == currentId) {
								listPararelWorkflows.add(wf);
							}
						}
					}

					break;
				}
			}
		}

		    // Debug output
		    if (soloWorkflow != null) {
		        System.out.println("Solo workflow:");
		        System.out.println("docNo: " + soloWorkflow.getId().getDocNo() + ", id: " + soloWorkflow.getId().getId()+" assign to "+soloWorkflow.getAssignedName());
		        if(Integer.toString(soloWorkflow.getAssignedId()).equals(Integer.toString(userview.getIdUser()))){
		        	soloWorkflow.setActionDate(date);
		        	if(action.equals("APPROVE")) {
		        		soloWorkflow.setAction(action);
		        	}
		        	soloWorkflow.setReason(reason);
		        	docServices.updateWorkFlow(soloWorkflow);
		        	result=1;
		        }
		    } else if (!listPararelWorkflows.isEmpty()) {
		        System.out.println("Pararel workflows:");
		        int PIC=0;
		        for (Workflow wf:listPararelWorkflows) {
		        	if (Integer.toString(wf.getAssignedId()).equals(Integer.toString(userview.getIdUser()))) {
		        		PIC=1;
		        		break;
					}
		        }
		        
		        if (PIC==1) {
		        	for (Workflow wf : listPararelWorkflows) {
			            System.out.println("docNo: " + wf.getId().getDocNo() + ", id: " + wf.getId().getId() + ", pararel: " + wf.getId().getPararel()+" assign to "+wf.getAssignedName());
			            wf.setActionDate(date);
			            
			        	if(action.equals("APPROVE")) {
			        		wf.setAction(action);
			        	}
			        	if (Integer.toString(wf.getAssignedId()).equals(Integer.toString(userview.getIdUser()))) {
			        		wf.setReason(reason);
			        	}else {
			        		wf.setReason("APPROVE BY "+userview.getUserName());
			        	}
			        	docServices.updateWorkFlow(wf);
			        	result=1;
			            
			        }
				}
		    } else {
		        System.out.println("Tidak ada workflow yang bisa diproses.");
		    }
		 
		 

		
		if(result >0) {
			
				headerDoc.setStatus("APPROVED");
			
			if(listWorkflows.get(listWorkflows.size()-1).getAction()!=null) {
				headerDoc.setStatus("CLOSED");
			}
			
			docServices.updateHeaderDoc(headerDoc);
			
			map.put("status", "200");
			map.put("message", "Approve Done");
			map.put("data", "Success");
		}else {
			map.put("status", "404");
			map.put("message", "Unsuccess");
		}
		return map;
	}
	
	@RequestMapping(value = "/peminjaman/reject",method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> rejectDocument(HttpServletRequest requestHeader, @RequestBody Map<String, Object> request) {
		
		Date date = new Date();
		final String requestTokenHeader = requestHeader.getHeader("Authorization");
		String userNameKey="";
		try {
			String jwtToken = requestTokenHeader.substring(7);
			final String userNameFromToken = jwtTokenUtil.getUsernameFromToken(jwtToken);
			userNameKey=userNameFromToken;
			System.out.println("userNameFromToken :"+userNameFromToken);
		} catch (Exception e) {
			System.out.println("gagal Mendapatkan username");
		}
		
		int result=0;
		UsersView userview=userServices.findUserByUsername(userNameKey);
		String docNo = (String) request.get("docNo");
	    String action = (String) request.get("action");
	    String reason = (String) request.get("reason");
	    HeaderDoc headerDoc=docServices.getHeaderDocByDocNo(docNo);
	    Map<String, Object> map = new HashMap<String,Object>();
		List<Workflow> listWorkflows = docServices.getWorkFlowByDocNo(docNo);
		List<Workflow> listPararelWorkflows = new ArrayList<>();
		Workflow soloWorkflow = null;
		
		
		if (headerDoc.getStatus().equals("CLOSED")||headerDoc.getStatus().equals("REJECTED")) {
			map.put("status", "404");
			map.put("message", "Document is "+headerDoc.getStatus());
		
			return map;
		}
		
		int access=0;
		for (Workflow workflow : listWorkflows) {
			if(Integer.toString(workflow.getAssignedId()).equals(Integer.toString(userview.getIdUser()))) {
				access=1;
			}
		}
		
		if (access==0) {
			map.put("status", "404");
			map.put("message", "You have no access to reject");
		
			return map;
		}

		// Temukan baris pertama yang belum memiliki action
		for (Workflow workflow : listWorkflows) {
			if (workflow.getAction() == null || workflow.getAction().trim().isEmpty()) {
				int currentId = workflow.getId().getId();
				int currentPararel = workflow.getId().getPararel();

				if (currentPararel == 0) {
					soloWorkflow = workflow;

					break;
				} else {
					for (Workflow wf : listWorkflows) {
						if (wf.getAction() == null || wf.getAction().trim().isEmpty()) {
							if (wf.getId().getId() == currentId) {
								listPararelWorkflows.add(wf);
							}
						}
					}

					break;
				}
			}
		}

		    // Debug output
		    if (soloWorkflow != null) {
		        System.out.println("Solo workflow:");
		        System.out.println("docNo: " + soloWorkflow.getId().getDocNo() + ", id: " + soloWorkflow.getId().getId()+" assign to "+soloWorkflow.getAssignedName());
		        if(Integer.toString(soloWorkflow.getAssignedId()).equals(Integer.toString(userview.getIdUser()))){
		        	soloWorkflow.setActionDate(date);
		        	if(action.equals("REJECT")) {
		        		soloWorkflow.setAction(action);
		        	}
		        	soloWorkflow.setReason(reason);
		        	docServices.updateWorkFlow(soloWorkflow);
		        	result=1;
		        }
		    } else if (!listPararelWorkflows.isEmpty()) {
		        System.out.println("Pararel workflows:");
		        int PIC=0;
		        for (Workflow wf:listPararelWorkflows) {
		        	if (Integer.toString(wf.getAssignedId()).equals(Integer.toString(userview.getIdUser()))) {
		        		PIC=1;
		        		break;
					}
		        }
		        
		        if (PIC==1) {
		        	for (Workflow wf : listPararelWorkflows) {
			            System.out.println("docNo: " + wf.getId().getDocNo() + ", id: " + wf.getId().getId() + ", pararel: " + wf.getId().getPararel()+" assign to "+wf.getAssignedName());
			            wf.setActionDate(date);
			            
			        	if(action.equals("REJECT")) {
			        		wf.setAction(action);
			        	}
			        	if (Integer.toString(wf.getAssignedId()).equals(Integer.toString(userview.getIdUser()))) {
			        		wf.setReason(reason);
			        	}else {
			        		wf.setReason("REJECT BY "+userview.getUserName());
			        	}
			        	docServices.updateWorkFlow(wf);
			        	result=1;
			            
			        }
				}
		    } else {
		        System.out.println("Tidak ada workflow yang bisa diproses.");
		    }
		 
		 

		
		if(result >0) {
			
			headerDoc.setStatus("REJECTED");
			docServices.updateHeaderDoc(headerDoc);
			
			map.put("status", "200");
			map.put("message", "Reject Done");
			map.put("data", "Success");
		}else {
			map.put("status", "404");
			map.put("message", "Unsuccess");
		}
		return map;
	}
	
	
	
	@RequestMapping(value = "/peminjaman/payment",method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> payment(HttpServletRequest requestHeader, @RequestBody Map<String, Object> request) {
		
		Date date = new Date();
		final String requestTokenHeader = requestHeader.getHeader("Authorization");
		String userNameKey="";
		try {
			String jwtToken = requestTokenHeader.substring(7);
			final String userNameFromToken = jwtTokenUtil.getUsernameFromToken(jwtToken);
			userNameKey=userNameFromToken;
			System.out.println("userNameFromToken :"+userNameFromToken);
		} catch (Exception e) {
			System.out.println("gagal Mendapatkan username");
		}
		
		int result=0;
		UsersView userview=userServices.findUserByUsername(userNameKey);
		String docNo = (String) request.get("docNo");
		
	    HeaderDoc headerDoc=docServices.getHeaderDocByDocNo(docNo);
	    Map<String, Object> map = new HashMap<String,Object>();
		
	   
		
		
		if (!headerDoc.getStatus().equals("CLOSED")) {
			map.put("status", "404");
			map.put("message", "Document Status is "+headerDoc.getStatus());
		
			return map;
		}
		
		int access=0;
		if(Integer.toString(userview.getIdUser()).equals(Integer.toString(headerDoc.getCreatorId()))) {
			access=1;
		}
		
		if (access==0) {
			map.put("status", "404");
			map.put("message", "You have no access to pay");
		
			return map;
		}
		
		 List<Payment> listPayments=docServices.getPaymentByDocNo(docNo);
		 Payment currentPayment=null;
		// Temukan baris pertama yang belum memiliki action
		for (Payment py : listPayments) {
			if (py.getStatus().equals("UNPAID")) {
					currentPayment=py;
					break;
				
			}
		}

		    // Debug output
		    if (currentPayment != null) {
		        System.out.println("Payment:");
		        System.out.println("docNo: " + currentPayment.getId().getDocNo() + ", id: " + currentPayment.getId().getId()+" total "+currentPayment.getTotal());
		        
		        currentPayment.setPaymentDate(date);
		        
		        if (currentPayment.getMaxPaymentDate().after(date)) {
		            currentPayment.setStatus("PAID");
		        } else {
		            currentPayment.setStatus("OVERDUE");
		        }
		        
		        docServices.updatePayment(currentPayment);
		        result=1;
		        
		    }  else {
		        map.put("status", "404");
				map.put("message", "Tidak ada Pembayaran yang bisa diproses");
				return map;
		        
		    }
		 
		 

		
		if(result >0) {
			map.put("status", "200");
			map.put("message", "Payment Done");
			map.put("data", "Success");
		}else {
			map.put("status", "404");
			map.put("message", "Unsuccess");
		}
		return map;
	}
	
	
	@RequestMapping(value = "/peminjaman/CountPayment",method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> CountPayment(@RequestBody Map<String, Object> request) {
		Map<String, Object> map = new HashMap<String,Object>();
		
		
		double principal = Double.parseDouble(request.get("total").toString());
        int durasiBulan = Integer.parseInt(request.get("durasiBulan").toString());
        double annualRate = Double.parseDouble(request.get("bunga").toString()) / 100.0;
        double monthlyRate = annualRate / 12;

        // Anuitas bulanan
        double monthlyPayment = (principal * monthlyRate * Math.pow(1 + monthlyRate, durasiBulan)) /
                                (Math.pow(1 + monthlyRate, durasiBulan) - 1);

        // Tanggal mulai
        String startDateStr = request.get("startdate").toString(); // format: dd/MM/yyyy
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        LocalDate startDate = LocalDate.parse(startDateStr, formatter);

        List<Map<String, Object>> paymentList = new ArrayList<>();

        for (int i = 0; i < durasiBulan; i++) {
            LocalDate paymentDate = startDate.plusMonths(i);
            Map<String, Object> payment = new HashMap<>();
            payment.put("maxPaymentDate", paymentDate.format(formatter));
            payment.put("total", (int) Math.round(monthlyPayment));
            paymentList.add(payment);
        }

		
		if(paymentList.size() >0) {
			map.put("status", "200");
			map.put("message", "Count Success");
			map.put("data", paymentList);
		}else {
			map.put("status", "404");
			map.put("message", "Unsuccess");
		}
		return map;
	}
	
	@RequestMapping(value = "/peminjaman/getAssignedWorkflow",method = RequestMethod.GET)
	public @ResponseBody Map<String, Object> getAssignedWorkflow(HttpServletRequest requestHeader) {
		
		final String requestTokenHeader = requestHeader.getHeader("Authorization");
		String userNameKey="";
		try {
			String jwtToken = requestTokenHeader.substring(7);
			final String userNameFromToken = jwtTokenUtil.getUsernameFromToken(jwtToken);
			userNameKey=userNameFromToken;
			System.out.println("userNameFromToken :"+userNameFromToken);
		} catch (Exception e) {
			System.out.println("gagal Mendapatkan username");
		}
		
		UsersView userview=userServices.findUserByUsername(userNameKey);
		Map<String, Object> map = new HashMap<String,Object>();
		
		List<String> listDocno=new ArrayList<>();
		List<Workflow> listAvailableWorkflows=new ArrayList<>();
		
		List<Workflow> listAssignnedWorkflows=docServices.getWorkFlowByAssignnedId(Integer.toString(userview.getIdUser()));
		for (Workflow workflow : listAssignnedWorkflows) {
			if(!listDocno.contains(workflow.getId().getDocNo())) {
				if(!docServices.getHeaderDocByDocNo(workflow.getId().getDocNo()).getStatus().equals("REJECTED")&&!docServices.getHeaderDocByDocNo(workflow.getId().getDocNo()).getStatus().equals("CLOSED")) {
				listDocno.add(workflow.getId().getDocNo());
				}
			}
		}
		
		for (String docNo : listDocno) {
			List<Workflow> listPararelWorkflows = new ArrayList<>();
			Workflow soloWorkflow = null;
			
			List<Workflow> listWorkflows=docServices.getWorkFlowByDocNo(docNo);
			
			for (Workflow workflow : listWorkflows) {
				if (workflow.getAction() == null || workflow.getAction().trim().isEmpty()) {
					int currentId = workflow.getId().getId();
					int currentPararel = workflow.getId().getPararel();

					if (currentPararel == 0) {
						soloWorkflow = workflow;

						break;
					} else {
						for (Workflow wf : listWorkflows) {
							if (wf.getAction() == null || wf.getAction().trim().isEmpty()) {
								if (wf.getId().getId() == currentId) {
									listPararelWorkflows.add(wf);
								}
							}
						}

						break;
					}
				}
			}
			
			if (soloWorkflow != null&&Integer.toString(soloWorkflow.getAssignedId()).equals(Integer.toString(userview.getIdUser()))) {
				listAvailableWorkflows.add(soloWorkflow);
			} else if (!listPararelWorkflows.isEmpty()) {

				for (Workflow workflow : listPararelWorkflows) {
					if(Integer.toString(workflow.getAssignedId()).equals(Integer.toString(userview.getIdUser()))) {
						listAvailableWorkflows.add(workflow);
					}
				}
			} else {
				System.out.println("Tidak ada workflow yang bisa diproses.");
			}
			
			
		}
		
		
	
		
		if(!listAvailableWorkflows.isEmpty()) {
			map.put("status", "200");
			map.put("message", "Data found");
			map.put("data", listAvailableWorkflows);
		}else {
			map.put("status", "404");
			map.put("message", "Data not found");
		}
		return map;
	}
	
	
	@RequestMapping(value = "/peminjaman/getDocbyPayerId", method = RequestMethod.GET)
	public @ResponseBody Map<String, Object> getDocbyPayerId(HttpServletRequest requestHeader) {

		final String requestTokenHeader = requestHeader.getHeader("Authorization");
		String userNameKey = "";
		try {
			String jwtToken = requestTokenHeader.substring(7);
			final String userNameFromToken = jwtTokenUtil.getUsernameFromToken(jwtToken);
			userNameKey = userNameFromToken;
			System.out.println("userNameFromToken :" + userNameFromToken);
		} catch (Exception e) {
			System.out.println("gagal Mendapatkan username");
		}

		UsersView userview = userServices.findUserByUsername(userNameKey);
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> dataList = new ArrayList<>();

		List<HeaderDoc> listHeaderDocs = docServices.getHeaderDocByPayerId(Integer.toString(userview.getIdUser()));

		for (HeaderDoc headerDoc : listHeaderDocs) {
			List<DetailDoc> listDetailDocs = docServices.getDetailDocByDocNo(headerDoc.getDocNo());
			List<Payment> listPayments = docServices.getPaymentByDocNo(headerDoc.getDocNo());
			List<Workflow> listWorkflows = docServices.getWorkFlowByDocNo(headerDoc.getDocNo());

			Map<String, Object> dataEntry = new HashMap<>();
			dataEntry.put("header", headerDoc);
			dataEntry.put("details", listDetailDocs);
			dataEntry.put("payments", listPayments);
			dataEntry.put("workflows", listWorkflows);

			dataList.add(dataEntry);
		}

		if (listHeaderDocs != null) {
			map.put("status", "200");
			map.put("message", "Data found");
			map.put("data", dataList);
		} else {
			map.put("status", "404");
			map.put("message", "Data not found");
		}
		return map;
	}
	
}
