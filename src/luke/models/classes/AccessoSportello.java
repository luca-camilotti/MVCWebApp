package luke.models.classes;

import java.sql.Date;

public class AccessoSportello {
	private int id;
	private java.sql.Date data;
	private String beneficiario;
	private String ads;
	private String operatore;
	private String motivoaccesso;
	private String estremipratica;	
	private String giudice;
	private String notagiudice;
	private String note;
	private String recapitotel;
	private String email;
	private String tipoads;  // qualifica ads (es. parente, volontario, etc..)
	private String sede;
	
	public String getSede() {
		return sede;
	}

	public void setSede(String sede) {
		this.sede = sede;
	}

	public String getTipoads() {
		return tipoads;
	}

	public void setTipoads(String tipoads) {
		this.tipoads = tipoads;
	}

	/* Constructor */
	public AccessoSportello(int id, Date data, String beneficiario, String ads, String operatore, String motivoaccesso,
			String estremipratica, String giudice, String notagiudice, String note, String recapitotel, String email, String tipoads, String sede) {
		
		this.id = id;
		this.data = data;
		this.beneficiario = beneficiario;
		this.ads = ads;
		this.operatore = operatore;
		this.motivoaccesso = motivoaccesso;
		this.estremipratica = estremipratica;
		this.giudice = giudice;
		this.notagiudice = notagiudice;
		this.note = note;
		this.recapitotel = recapitotel;
		this.email = email;
		this.tipoads = tipoads;
		this.sede = sede;
	}
	
	public AccessoSportello() {
		this.id = 0;
		this.data = null;
		this.beneficiario = "";
		this.ads = "";
		this.operatore = "";
		this.motivoaccesso = "";
		this.estremipratica = "";
		this.giudice = "";
		this.notagiudice = "";
		this.note = "";
		this.recapitotel = "";
		this.email = "";
		this.tipoads = "";
		this.sede = "";
	}
	
	public AccessoSportello(Date data, String beneficiario, String ads, String operatore, String motivoaccesso,
			String estremipratica, String giudice, String notagiudice, String note, String recapitotel, String email, String tipoads, String sede) {
		
		// this.id = id;
		this.data = data;
		this.beneficiario = beneficiario;
		this.ads = ads;
		this.operatore = operatore;
		this.motivoaccesso = motivoaccesso;
		this.estremipratica = estremipratica;
		this.giudice = giudice;
		this.notagiudice = notagiudice;
		this.note = note;
		this.recapitotel = recapitotel;
		this.email = email;
		this.tipoads = tipoads;
		this.sede = sede;
	}
	
	/* Getters and Setters */
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public java.sql.Date getData() {
		return data;
	}
	public void setData(java.sql.Date date) {
		this.data = date;
	}
	public String getBeneficiario() {
		return beneficiario;
	}
	public void setBeneficiario(String beneficiario) {
		this.beneficiario = beneficiario;
	}
	public String getAds() {
		return ads;
	}
	public void setAds(String ads) {
		this.ads = ads;
	}
	public String getOperatore() {
		return operatore;
	}
	public void setOperatore(String operatore) {
		this.operatore = operatore;
	}
	public String getMotivoaccesso() {
		return motivoaccesso;
	}
	public void setMotivoaccesso(String motivoaccesso) {
		this.motivoaccesso = motivoaccesso;
	}
	public String getEstremipratica() {
		return estremipratica;
	}
	public void setEstremipratica(String estremipratica) {
		this.estremipratica = estremipratica;
	}
	public String getGiudice() {
		return giudice;
	}
	public void setGiudice(String giudice) {
		this.giudice = giudice;
	}
	public String getNotagiudice() {
		return notagiudice;
	}
	public void setNotagiudice(String notagiudice) {
		this.notagiudice = notagiudice;
	}
	public String getNote() {
		return note;
	}
	public void setNote(String note) {
		this.note = note;
	}
	public String getRecapitotel() {
		return recapitotel;
	}
	public void setRecapitotel(String recapitotel) {
		this.recapitotel = recapitotel;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
}
