package luke.models.classes;

/* Classe Wrapper (di appoggio per i record della tabella dipendente) */
public class Dipendente {

	public Dipendente(int id, String nome, String cognome, int stipendio, String funzione, String filiale,
			int livello) {
		super();
		this.id = id;
		this.nome = nome;
		this.cognome = cognome;
		this.stipendio = stipendio;
		this.funzione = funzione;
		this.filiale = filiale;
		this.livello = livello;
	}
	private int id;
	private String nome;
	private String cognome;
	private int stipendio;
	private String funzione;
	private String filiale;
	private int livello;
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	public String getCognome() {
		return cognome;
	}
	public void setCognome(String cognome) {
		this.cognome = cognome;
	}
	public int getStipendio() {
		return stipendio;
	}
	public void setStipendio(int stipendio) {
		this.stipendio = stipendio;
	}
	public String getFunzione() {
		return funzione;
	}
	public void setFunzione(String funzione) {
		this.funzione = funzione;
	}
	public String getFiliale() {
		return filiale;
	}
	public void setFiliale(String filiale) {
		this.filiale = filiale;
	}
	public int getLivello() {
		return livello;
	}
	public void setLivello(int livello) {
		this.livello = livello;
	}
}
