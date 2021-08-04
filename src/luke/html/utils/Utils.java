package luke.html.utils;

import java.util.ArrayList;

import javax.servlet.http.Part;

public class Utils {
	
	
	/* Utility: get the filename to upload */
    private static String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1); // MSIE fix.
            }
        }
        return null;
    }

	/* restituisce le opzioni da inserire negli elementi select */
	public static String printSelectOptions(ArrayList<String> list, String selected) {
		/*
		 * Output Example: 
		<option selected></option>
		<option value="Giudice Tizio">Giudice Tizio</option>
		<option value="Giudice Caio">Giudice Caio</option>
		<option value="Giudice Sempronio">Giudice Sempronio</option>
		<option value="Giudice Sesterzio">Giudice Sesterzio</option> */
		String ret = "";
		if(list == null)
			return "";  // la lista delle options non è stata passata correttamente alla pagina jsp
		// l'elemento "selectet" rappresenta il valore già memorizzato in quel campo
		// e deve comparire nella lista delle opzioni della select, anche se non è
		// presente nella tabella relativa
		if(selected != null && selected.length()>0) {
			if(!list.contains(selected))
				list.add(0, selected);  // se l'elemento non c'è, aggiungilo all'inizio della lista delle option
			else {  // se l'elemento c'è già, spostalo all'inizio della lista (sarà l'elemento selezionato)
				int i = list.indexOf(selected);  // prendi l'indice dell'elemento
				list.remove(i);
				list.add(0, selected);
			}
		}
		else
			list.add(0, "");  // se non c'è un elemento già memorizzato aggiungi la stringa vuota
		for(String opt : list) {
			if(list.indexOf(opt) == 0) // il primo elemento è quello selezionato
				ret += "<option selected>"+opt+"</option>";
			else
				ret += "<option>"+opt+"</option>";
		}
		return ret;
	}
}
