package edu.sjsu.cpme239.model;

import org.springframework.data.mongodb.core.mapping.Document;
@Document(collection = "map_reduce_history")
public class History {
	int _id;
	String[] value;
	public int get_id() {
		return _id;
	}
	public void set_id(int _id) {
		this._id = _id;
	}
	public String[] getValue() {
		return value;
	}
	public void setValue(String[] value) {
		this.value = value;
	}
	
}
