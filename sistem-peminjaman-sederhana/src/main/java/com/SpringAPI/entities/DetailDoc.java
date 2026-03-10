package com.SpringAPI.entities;

import javax.persistence.*;

@Entity
@Table(name = "detaildoc")
public class DetailDoc {

    @EmbeddedId
    private DetailDocId id;

    @Column(name = "SUBTOTAL")
    private double subTotal;

    @Column(name = "TEXT")
    private String text;

	public DetailDocId getId() {
		return id;
	}

	public void setId(DetailDocId id) {
		this.id = id;
	}

	public double getSubTotal() {
		return subTotal;
	}

	public void setSubTotal(double subTotal) {
		this.subTotal = subTotal;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	@Override
	public String toString() {
		return "DetailDoc [id docno=" + id.getDocNo()+ " id index="+id.getId()+ ", subTotal=" + subTotal + ", text=" + text + "]";
	}
	
	

    
}
