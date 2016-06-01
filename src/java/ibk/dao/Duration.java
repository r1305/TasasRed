/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ibk.dao;

/**
 *
 * @author BP2158
 */
public class Duration {
    public float tasa;
    public int plazo;

    
    public String fecha;
    public float duration;
    public float soles;
    public float usd;

    public Duration() {
    }

    public Duration(float tasa, int plazo, String fecha, float duration, float soles, float usd) {
        this.tasa = tasa;
        this.plazo = plazo;
        this.fecha = fecha;
        this.duration = duration;
        this.soles = soles;
        this.usd = usd;
    }

    public float getTasa() {
        return tasa;
    }

    public void setTasa(float tasa) {
        this.tasa = tasa;
    }

    public int getPlazo() {
        return plazo;
    }

    public void setPlazo(int plazo) {
        this.plazo = plazo;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public float getDuration() {
        return duration;
    }

    public void setDuration(float duration) {
        this.duration = duration;
    }

    public float getSoles() {
        return soles;
    }

    public void setSoles(float soles) {
        this.soles = soles;
    }

    public float getUsd() {
        return usd;
    }

    public void setUsd(float usd) {
        this.usd = usd;
    }
    
    
    
    
}
