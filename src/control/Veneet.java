package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

import model.Vene;
import model.dao.Dao;

@WebServlet("/veneet/*")
public class Veneet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	// GET
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Veneet GET");
		String pathInfo = request.getPathInfo();	
		System.out.println("polku: "+pathInfo);	
		Dao dao = new Dao();
		ArrayList<Vene> veneet;
		String strJSON = "";
		
		// Jos polku on tyhj‰, haetaan kaikki: 
		if(pathInfo == null) {
			veneet = dao.listaaVeneet();
			System.out.println("PathInfo oli tyhj‰, haetaan kaikki: " + veneet);
			strJSON = new JSONObject().put("veneet", veneet).toString();
		
		// Jos polku sis‰lt‰‰ merkkijonon "hakusana", haetaan hakusanaa vastaavat tiedot
		} else if (pathInfo.indexOf("hakusana") !=-1) { 
			String hakusana = pathInfo.replace("/hakusana/", "");
			System.out.println("Haetaan hakusanalla: " + hakusana);
			veneet = dao.listaaVeneet(hakusana);
			strJSON = new JSONObject().put("veneet", veneet).toString();
		
		// Muuten oletetaan REST standardin mukaisesti ett‰ kyseess‰ on ID, ja haetaan sill‰
		} else { 
			String tunnus = pathInfo.replace("/", "");
			System.out.println("Tarkoituksena lienee hakea ID:ll‰, ID: " + tunnus);
			Vene vene = dao.etsiVene(tunnus);
			System.out.println("Lˆydettiin vene tiedoilla: " + vene);
			System.out.println(vene);
			if (vene == null) {
				strJSON = "{}";
			} else {   
				JSONObject JSON = new JSONObject();
				JSON.put("tunnus", vene.getTunnus());
				JSON.put("nimi", vene.getNimi());
				JSON.put("merkkimalli", vene.getMerkkimalli());
				JSON.put("pituus", vene.getPituus());
				JSON.put("leveys", vene.getLeveys());
				JSON.put("hinta", vene.getHinta());
				strJSON = JSON.toString();
			}
		}
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		out.println(strJSON);
	}
	
	// POST
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Veneet POST");
		JSONObject jsonObj = new JsonStrToObj().convert(request); //Muutetaan kutsun mukana tuleva json-string json-objektiksi			
		
		Vene vene = new Vene();		
		vene.setNimi(jsonObj.getString("nimi"));
		vene.setMerkkimalli(jsonObj.getString("merkkimalli"));
		vene.setPituus(jsonObj.getDouble("pituus"));
		vene.setLeveys(jsonObj.getDouble("leveys"));
		vene.setHinta(jsonObj.getInt("hinta"));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		
		Dao dao = new Dao();			
		if(dao.lisaaVene(vene)){ //metodi palauttaa true/false
			out.println("{\"response\":1}");  //Veneen lis‰‰minen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //Veneen lis‰‰minen ep‰onnistui {"response":0}
		}		
	}
	
	// PUT
	
	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Veneet PUT");
		JSONObject jsonObj = new JsonStrToObj().convert(request);
		System.out.println(jsonObj);
		int tunnus = jsonObj.getInt("tunnus");
		
		Vene vene = new Vene();
		vene.setNimi(jsonObj.getString("nimi"));
		vene.setMerkkimalli(jsonObj.getString("merkkimalli"));
		vene.setPituus(jsonObj.getDouble("pituus"));
		vene.setLeveys(jsonObj.getDouble("leveys"));
		vene.setHinta(jsonObj.getInt("hinta"));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		
		Dao dao = new Dao();
		if(dao.muutaVene(vene, tunnus)) {
			out.println("{\"response\":1}");
		} else {
			out.println("{\"response\":0}");
		}	
	}

	// DELETE
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Veneet DELETE");
		String pathInfo = request.getPathInfo();	
		System.out.println("polku: "+pathInfo);	
		String poistettavaVene="";
		
		if(pathInfo!=null) {		
			poistettavaVene = pathInfo.replace("/", "");
		}
		
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();
		if(dao.poistaVene(poistettavaVene)) {
			out.println("{\"response\":1}");
		} else {
			out.println("{\"response\":0}");
		}	
	}
}