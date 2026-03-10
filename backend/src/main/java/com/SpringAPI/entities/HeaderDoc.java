package com.SpringAPI.entities;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "headerdoc")
public class HeaderDoc {

    @Id
    @Column(name = "DOCNO")
    private String docNo;

    @Column(name = "CREATORID")
    private int creatorId;

    @Column(name = "CREATORNAME")
    private String creatorName;
    
    @Column(name = "PAYERID")
    private int payerId;

    @Column(name = "PAYERNAME")
    private String payerName;

    @Column(name = "CREATEDDATE")
    private Date createdDate;

    @Column(name = "ALLTOTAL")
    private double allTotal;
    
    @Column(name = "BUNGA")
    private int bunga;

    @Column(name = "STATUS")
    private String status;

	public String getDocNo() {
		return docNo;
	}

	public void setDocNo(String docNo) {
		this.docNo = docNo;
	}

	public int getCreatorId() {
		return creatorId;
	}

	public void setCreatorId(int creatorId) {
		this.creatorId = creatorId;
	}

	public String getCreatorName() {
		return creatorName;
	}

	public void setCreatorName(String creatorName) {
		this.creatorName = creatorName;
	}
	
	public int getPayerId() {
		return payerId;
	}

	public void setPayerId(int payerId) {
		this.payerId = payerId;
	}

	public String getPayerName() {
		return payerName;
	}

	public void setPayerName(String payerName) {
		this.payerName = payerName;
	}

	public Date getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(Date createdDate) {
		this.createdDate = createdDate;
	}

	public double getAllTotal() {
		return allTotal;
	}

	public void setAllTotal(double allTotal) {
		this.allTotal = allTotal;
	}
	

	public int getBunga() {
		return bunga;
	}

	public void setBunga(int bunga) {
		this.bunga = bunga;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	@Override
	public String toString() {
		return "HeaderDoc [docNo=" + docNo + ", creatorId=" + creatorId + ", creatorName=" + creatorName + ", payerId="
				+ payerId + ", payerName=" + payerName + ", createdDate=" + createdDate + ", allTotal=" + allTotal
				+ ", status=" + status + "]";
	}

    
	
}
