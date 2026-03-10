package com.SpringAPI.entities;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "workflow")
public class Workflow {

    @EmbeddedId
    private WorkflowId id;

    @Column(name = "ASSIGNNEDID")
    private int assignedId;

    @Column(name = "ASSIGNNEDNAME")
    private String assignedName;

    @Column(name = "ASSIGNNEDACTION")
    private String assignedAction;
    
    @Column(name = "ACTION")
    private String action;

    @Column(name = "ACTIONDATE")
    private Date actionDate;
    
    @Column(name = "REASON")
    private String reason;

	public WorkflowId getId() {
		return id;
	}

	public void setId(WorkflowId id) {
		this.id = id;
	}
	
	public int getAssignedId() {
		return assignedId;
	}

	public void setAssignedId(int assignedId) {
		this.assignedId = assignedId;
	}

	public String getAssignedName() {
		return assignedName;
	}

	public void setAssignedName(String assignedName) {
		this.assignedName = assignedName;
	}

	public String getAction() {
		return action;
	}

	public void setAction(String action) {
		this.action = action;
	}
	
	public String getAssignedAction() {
		return assignedAction;
	}

	public void setAssignedAction(String assignedAction) {
		this.assignedAction = assignedAction;
	}

	public Date getActionDate() {
		return actionDate;
	}

	public void setActionDate(Date actionDate) {
		this.actionDate = actionDate;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	@Override
	public String toString() {
		return "Workflow [id doc =" + id.getDocNo()+ " id index="+id.getId()+ ", pararel=" + id.getPararel() + ", assignedId=" + assignedId + ", assignedName="
				+ assignedName + ", action=" + action + ", actionDate=" + actionDate + ", reason=" + reason + "]";
	}

	
	
    
}
