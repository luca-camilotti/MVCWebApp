package luke.models.classes;

/* This class is used for report operations */
public class ReportItem {
	
	private String field;
	private String secondfield;
	private String thirdfield;
	private int value;	
	
	public ReportItem(String field, int value) {
		// super();
		this.field = field;
		this.value = value;
	}
	
	public ReportItem(String field, String secondfield, int value) {
		// super();
		this.field = field;
		this.secondfield = secondfield;
		this.value = value;
	}
	
	public String getField() {
		return field;
	}
	public void setField(String field) {
		this.field = field;
	}
	public int getValue() {
		return value;
	}
	public void setValue(int value) {
		this.value = value;
	}
	public String getSecondfield() {
		return secondfield;
	}
	public void setSecondfield(String secondfield) {
		this.secondfield = secondfield;
	}
	public String getThirdfield() {
		return thirdfield;
	}
	public void setThirdfield(String thirdfield) {
		this.thirdfield = thirdfield;
	}
	

}
