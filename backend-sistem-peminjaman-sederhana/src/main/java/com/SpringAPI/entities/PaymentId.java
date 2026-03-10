package com.SpringAPI.entities;

import java.io.Serializable;
import javax.persistence.*;

@Embeddable
public class PaymentId implements Serializable {

	private static final long serialVersionUID = -985701101109485213L;

	@Column(name = "DOCNO")
    private String docNo;

    @Column(name = "ID")
    private int id;

	public String getDocNo() {
		return docNo;
	}

	public void setDocNo(String docNo) {
		this.docNo = docNo;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

    
}
