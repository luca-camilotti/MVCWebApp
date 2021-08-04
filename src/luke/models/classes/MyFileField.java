package luke.models.classes;

import java.io.InputStream;

/* This class is userd in MultipartParse */
public class MyFileField {
	
	
	private String name;
	private long size;
	private String contentType;
	private InputStream content;

	public MyFileField(String name, long size, String contentType, InputStream content) {
		// super();
		this.name = name;
		this.size = size;
		this.content = content;
		this.contentType = contentType;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public long getSize() {
		return size;
	}
	public void setSize(long size) {
		this.size = size;
	}
	public InputStream getContent() {
		return content;
	}
	public void setContent(InputStream content) {
		this.content = content;
	}
	public String getContentType() {
		return contentType;
	}
	public void setContentType(String contentType) {
		this.contentType = contentType;
	}
	
}
