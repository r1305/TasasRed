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
public class Prima {
    
    String color;
    String prima;
    String color_txt;

    public Prima() {
    }

    public Prima(String color, String prima, String color_txt) {
        this.color = color;
        this.prima = prima;
        this.color_txt = color_txt;
    }

    public String getColor_txt() {
        return color_txt;
    }

    public void setColor_txt(String color_txt) {
        this.color_txt = color_txt;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getPrima() {
        return prima;
    }

    public void setPrima(String prima) {
        this.prima = prima;
    }
    
    
    
}
