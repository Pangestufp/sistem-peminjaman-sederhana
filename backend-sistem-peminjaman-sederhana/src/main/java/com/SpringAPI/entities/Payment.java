package com.SpringAPI.entities;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "payment")
public class Payment {

    @EmbeddedId
    private PaymentId id;
    
    @Column(name = "TOTAL")
    private double total;

    @Column(name = "MAXPAYMENTDATE")
    private Date maxPaymentDate;

    @Column(name = "PAYMENTDATE")
    private Date paymentDate;

    @Column(name = "STATUS")
    private String status;

	public PaymentId getId() {
		return id;
	}

	public void setId(PaymentId id) {
		this.id = id;
	}
	
	public double getTotal() {
		return total;
	}

	public void setTotal(double total) {
		this.total = total;
	}

	public Date getMaxPaymentDate() {
		return maxPaymentDate;
	}

	public void setMaxPaymentDate(Date maxPaymentDate) {
		this.maxPaymentDate = maxPaymentDate;
	}

	public Date getPaymentDate() {
		return paymentDate;
	}

	public void setPaymentDate(Date paymentDate) {
		this.paymentDate = paymentDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	@Override
	public String toString() {
		return "Payment [id docno=" + id.getDocNo()+ " id index="+id.getId()+ ", total=" + total + ", maxPaymentDate=" + maxPaymentDate + ", paymentDate="
				+ paymentDate + ", status=" + status + "]";
	}
	
	

}
