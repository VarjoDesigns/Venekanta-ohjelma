package model.dao;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import model.Vene;

public class Dao {
	private Connection con=null;
	private ResultSet rs = null;
	private PreparedStatement stmtPrep=null; 
	private String sql;
	private String db ="Venekanta.sqlite";
	
	private Connection yhdista(){
    	Connection con = null;    	
    	String path = System.getProperty("catalina.base");    	
    	path = path.substring(0, path.indexOf(".metadata")).replace("\\", "/");
    	String url = "jdbc:sqlite:"+path+db;    	
    	try {	       
    		Class.forName("org.sqlite.JDBC");
	        con = DriverManager.getConnection(url);	
	        System.out.println("Yhteys tietokantaan avattu onnistuneesti");
	     }catch (Exception e){	
	    	 System.out.println("Yhteyttä kantaan ei pystytty muodostamaan");
	        e.printStackTrace();	         
	     }
	     return con;
	}
	
	public ArrayList<Vene> listaaVeneet(){
		ArrayList<Vene> veneet = new ArrayList<Vene>();
		sql = "SELECT * FROM veneet"; 		
		try {
			con=yhdista();
			if(con!=null){ //jos yhteys onnistui
				stmtPrep = con.prepareStatement(sql);        		
        		rs = stmtPrep.executeQuery();   
				if(rs!=null){ //jos kysely onnistui									
					while(rs.next()){
						Vene vene = new Vene();
						vene.setTunnus(rs.getInt(1));
						vene.setNimi(rs.getString(2));
						vene.setMerkkimalli(rs.getString(3));
						vene.setPituus(rs.getDouble(4));
						vene.setLeveys(rs.getDouble(5));
						vene.setHinta(rs.getInt(6));
						veneet.add(vene);
						}					
				}				
			}
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return veneet;
	}
	
	public ArrayList<Vene> listaaVeneet(String hakusana){
		ArrayList<Vene> veneet = new ArrayList<Vene>();
		sql = "SELECT * FROM veneet WHERE tunnus LIKE ? or nimi LIKE ? or merkkimalli LIKE ? or pituus LIKE ? or leveys LIKE ? or hinta LIKE ?";		
		try {
			con=yhdista();
			if(con!=null){ //jos yhteys onnistui
				stmtPrep = con.prepareStatement(sql);  
				stmtPrep.setString(1, "%" + hakusana + "%");
				stmtPrep.setString(2, "%" + hakusana + "%");   
				stmtPrep.setString(3, "%" + hakusana + "%");
				stmtPrep.setString(4, "%" + hakusana + "%");
				stmtPrep.setString(5, "%" + hakusana + "%");
				stmtPrep.setString(6, "%" + hakusana + "%"); 
        		rs = stmtPrep.executeQuery();   
				if(rs!=null){ //jos kysely onnistui							
					while(rs.next()){
						Vene vene = new Vene();
						vene.setTunnus(rs.getInt(1));
						vene.setNimi(rs.getString(2));
						vene.setMerkkimalli(rs.getString(3));
						vene.setPituus(rs.getDouble(4));
						vene.setLeveys(rs.getDouble(5));
						vene.setHinta(rs.getInt(6));
						veneet.add(vene);
					}						
				}
				con.close();
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return veneet;
	}
	
	public boolean lisaaVene(Vene vene){
		boolean paluuarvo = true;
		ArrayList<Vene> veneet = new ArrayList<Vene>();
		sql = "INSERT INTO veneet VALUES(?,?,?,?,?,?)";       
		try {
			con=yhdista();
				stmtPrep = con.prepareStatement(sql);        		
        		stmtPrep.setString(1, null);
        		stmtPrep.setString(2, vene.getNimi());
        		stmtPrep.setString(3, vene.getMerkkimalli());
        		stmtPrep.setDouble(4, vene.getPituus());
        		stmtPrep.setDouble(5, vene.getLeveys());
        		stmtPrep.setInt(6, vene.getHinta());
        		stmtPrep.executeUpdate();
    		con.close();				
		} catch (Exception e) {
			e.printStackTrace();
			paluuarvo = false;
		}		
		return paluuarvo;
	}
	
	public boolean lisaaVene(Vene vene, int tunnus){
		boolean paluuarvo = true;
		ArrayList<Vene> veneet = new ArrayList<Vene>();
		sql = "INSERT INTO veneet VALUES(?,?,?,?,?,?)";       
		try {
			con=yhdista();
				stmtPrep = con.prepareStatement(sql);   
				stmtPrep.setInt(1, tunnus);
        		stmtPrep.setString(2, vene.getNimi());
        		stmtPrep.setString(3, vene.getMerkkimalli());
        		stmtPrep.setDouble(4, vene.getPituus());
        		stmtPrep.setDouble(5, vene.getLeveys());
        		stmtPrep.setInt(6, vene.getHinta());
        		stmtPrep.executeUpdate();
    		con.close();				
		} catch (Exception e) {
			e.printStackTrace();
			paluuarvo = false;
		}		
		return paluuarvo;
	}
	
	public boolean muutaVene(Vene vene, int tunnus) {
		boolean paluuarvo = true;
		System.out.println("muutaVene():" + tunnus);
		sql="UPDATE veneet SET nimi=?, merkkimalli=?, pituus=?, leveys=?, hinta=? WHERE tunnus=?";
		
		try {
			con = yhdista();
				stmtPrep = con.prepareStatement(sql);   
	    		stmtPrep.setString(1, vene.getNimi());
	    		stmtPrep.setString(2, vene.getMerkkimalli());
	    		stmtPrep.setDouble(3, vene.getPituus());
	    		stmtPrep.setDouble(4, vene.getLeveys());
	    		stmtPrep.setInt(5, vene.getHinta());
	    		stmtPrep.setInt(6, tunnus);
	    		stmtPrep.executeUpdate();
		con.close();
			
		} catch (Exception e) {
			e.printStackTrace();
			paluuarvo = false;
		}
		return paluuarvo;
	}
	
	public boolean poistaVene(String tunnus) {
		boolean paluuArvo=true;
		sql="DELETE FROM veneet WHERE tunnus=?";
		try {
			con = yhdista();
			stmtPrep=con.prepareStatement(sql);
			stmtPrep.setString(1, tunnus);
			stmtPrep.executeUpdate();
			con.close();
		} catch (Exception e) {
			e.printStackTrace();
			paluuArvo = false;
		}
		return paluuArvo;
	}
	
	public Vene etsiVene(String tunnus) {
		Vene vene = null;
		sql = "SELECT * FROM veneet WHERE tunnus=?";
		
		try {
			con = yhdista();
			if (con!=null) {
				stmtPrep = con.prepareStatement(sql);
				stmtPrep.setString(1, tunnus);
				rs = stmtPrep.executeQuery();
				
				if (rs.isBeforeFirst()) {
					rs.next();
					vene = new Vene();
					vene.setTunnus(rs.getInt(1));
					vene.setNimi(rs.getString(2));
					vene.setMerkkimalli(rs.getString(3));
					vene.setPituus(rs.getDouble(4));
					vene.setLeveys(rs.getDouble(5));
					vene.setHinta(rs.getInt(6));
				}
				con.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return vene;
	}
}
