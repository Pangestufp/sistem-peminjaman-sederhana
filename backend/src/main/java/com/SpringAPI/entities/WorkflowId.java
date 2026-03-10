package com.SpringAPI.entities;

import java.io.Serializable;
import javax.persistence.*;

@Embeddable
public class WorkflowId implements Serializable {

	private static final long serialVersionUID = 8191480244350416134L;

	@Column(name = "DOCNO")
    private String docNo;

    @Column(name = "ID")
    private int id;
    
    
    @Column(name = "PARAREL")
    private int pararel;
    

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

	public int getPararel() {
		return pararel;
	}

	public void setPararel(int pararel) {
		this.pararel = pararel;
	}

	
    
}
