package edu.sjsu.cpme239.model;

import org.springframework.data.mongodb.core.mapping.Document;
@Document(collection = "map_reduce_output2")
public class MapReduce {
	String _id;
	int value;
	public String get_id() {
		return _id;
	}
	public void set_id(String _id) {
		this._id = _id;
	}
	public int getValue() {
		return value;
	}
	public void setValue(int value) {
		this.value = value;
	}
}
