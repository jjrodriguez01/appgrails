package com.model

class Row {

	String dataRow

	public Row(String dataRow){
		this.dataRow = dataRow
	}

    static constraints = {
    	dataRow nullable:false, blank:false
    }

    static mapping={
    	version false
    }
}
