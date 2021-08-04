package luke.models.classes;

public class User {
	
	private int id;
	private String name;
	private String surname;
	private String email;
	private String key;  // private shared key
	
	
	public User(int id, String name, String surname, String email, String key) {
		super();
		this.id = id;
		this.name = name;
		this.surname = surname;
		this.email = email;
		this.key = key;
	}
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getSurname() {
		return surname;
	}
	public void setSurname(String surname) {
		this.surname = surname;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}	

}
