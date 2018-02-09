package com.helpers

class Tutorial {

	String url
	String html
	String englishHtml
	String englishTitle
	String title
	Date dateCreated

	public Tutorial(String title,String englishTitle, String html, String englishHtml, String url){
		this.title = title
		this.englishTitle = englishTitle
		this.html = html
		this.englishHtml = englishHtml
		this.url = url
	}

    static constraints = {
    	
    }

    static mapping ={
    	html type:'text'
    	englishHtml type:'text'
    	sort 'dateCreated'
    }
}
