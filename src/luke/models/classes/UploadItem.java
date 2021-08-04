package luke.models.classes;

import java.sql.Blob;
import java.util.Date;
/*
 * Classe modello per i record della tabella upload (file caricati)
 * */
public class UploadItem {
	
	private int id;
	private Date d;  // java.util.Date
	private String description;
	private String name;
	private long size;
	private int fk;  // foreign key
	private Blob blob;  // file itself
	
	public UploadItem(int id, Date d, String description, String name, long size) {
		// super();
		this.id = id;
		this.d = d;
		this.description = description;
		this.name = name;
		this.size = size;
		this.blob = null;
	}
	public UploadItem(int id, Date d, String description, String name, long size, int fk) {
		// super();
		this.id = id;
		this.d = d;
		this.description = description;
		this.name = name;
		this.size = size;
		this.blob = null;
		this.fk = fk;
	}	
	public int getFk() {
		return fk;
	}
	public void setFk(int fk) {
		this.fk = fk;
	}
	public UploadItem(int id, Date d, String description, String name, long size, Blob blob) {
		// super();
		this.id = id;
		this.d = d;
		this.description = description;
		this.name = name;
		this.size = size;
		this.blob = blob;
	}
	public UploadItem(int id, Date d, String description, String name, long size, Blob blob, int fk) {
		// super();
		this.id = id;
		this.d = d;
		this.description = description;
		this.name = name;
		this.size = size;
		this.blob = blob;
		this.fk = fk;
	}
	public Blob getBlob() {
		return blob;
	}
	public void setBlob(Blob blob) {
		this.blob = blob;
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
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public Date getD() {
		return d;
	}
	public void setD(Date d) {
		this.d = d;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	

}
