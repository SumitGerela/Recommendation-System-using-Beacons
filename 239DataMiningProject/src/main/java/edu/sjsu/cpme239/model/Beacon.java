package edu.sjsu.cpme239.model;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
@Document(collection = "beacons")
public class Beacon {
	@Autowired
	@Id
	String _id;
	String uuid;
	String major_id;
	String minor_id;
	String[] products;
	public String get_id() {
		return _id;
	}
	public void set_id(String _id) {
		this._id = _id;
	}
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getMajor_id() {
		return major_id;
	}
	public void setMajor_id(String major_id) {
		this.major_id = major_id;
	}
	public String getMinor_id() {
		return minor_id;
	}
	public void setMinor_id(String minor_id) {
		this.minor_id = minor_id;
	}
	public String[] getProducts() {
		return products;
	}
	public void setProducts(String[] products) {
		this.products = products;
	}

	
	
}
