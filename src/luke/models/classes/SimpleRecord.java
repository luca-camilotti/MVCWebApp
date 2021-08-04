package luke.models.classes;

/* Classe modello per le tabelle semplici (id e valore) */
public class SimpleRecord implements Comparable<SimpleRecord> {
	
	private int id;
	private String value;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public SimpleRecord(int id, String value) {
		super();
		this.id = id;
		this.value = value;
	}
	@Override
	public int compareTo(SimpleRecord s) {  // to sort elements with Collections.sort(list)
		// TODO Auto-generated method stub
		return this.value.toLowerCase().compareTo(s.value.toLowerCase());
	}

}
