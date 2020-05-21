package model;

public class Vene {
	private int tunnus;
	private String nimi, merkkimalli;
	private double pituus, leveys;
	private int hinta;
	
	// Konstruktorit
	
	public Vene() {
		super();
	}

	public Vene(int tunnus, String nimi, String merkkimalli, double pituus, double leveys, int hinta) {
		super();
		this.tunnus = tunnus;
		this.nimi = nimi;
		this.merkkimalli = merkkimalli;
		this.pituus = pituus;
		this.leveys = leveys;
		this.hinta = hinta;
	}
	
	
	// Getterit
	
	public int getTunnus() {
		return tunnus;
	}

	public String getNimi() {
		return nimi;
	}

	public String getMerkkimalli() {
		return merkkimalli;
	}

	public double getPituus() {
		return pituus;
	}

	public double getLeveys() {
		return leveys;
	}

	public int getHinta() {
		return hinta;
	}

	
	// Setterit
	
	public void setTunnus(int tunnus) {
		this.tunnus = tunnus;
	}

	public void setNimi(String nimi) {
		this.nimi = nimi;
	}

	public void setMerkkimalli(String merkkimalli) {
		this.merkkimalli = merkkimalli;
	}

	public void setPituus(double pituus) {
		this.pituus = pituus;
	}

	public void setLeveys(double leveys) {
		this.leveys = leveys;
	}

	public void setHinta(int hinta) {
		this.hinta = hinta;
	}

	
	// To string
	
	@Override
	public String toString() {
		return "Vene [tunnus=" + tunnus + ", nimi=" + nimi + ", merkkimalli=" + merkkimalli + ", pituus=" + pituus
				+ ", leveys=" + leveys + ", hinta=" + hinta + "]";
	}
}
