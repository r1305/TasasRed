
package ibk.dao;


public class CostoOperativo {
    
    float monto;
    float costo;

    public CostoOperativo() {
    }

    public CostoOperativo(float monto, float costo) {
        this.monto = monto;
        this.costo = costo;
    }

    public float getMonto() {
        return monto;
    }

    public void setMonto(float monto) {
        this.monto = monto;
    }

    public float getCosto() {
        return costo;
    }

    public void setCosto(float costo) {
        this.costo = costo;
    }
    
    
}
