package com.mitocode.finterface;

public class FuncInterApp {

	public double operar(double x, double y){
		Operacion op1 = (n1,n2) -> n1 + n2;
		Operacion op2 = (n1,n2) -> n1 - n2;
		          op2 = (n1,n2) -> this.restar(n1,n2); //equivalente a la línea anterior
				  op2 = this::restar; //clase::restar (si static) //equivalente a la línea anterior
	  //          op2 = (n1,n2) -> this::restar(n1,n2); //no válido, no pueden pasarse parámetros porque no puede usarse ()->
		return op1.calcular(x, y) + op2.calcular(x, y);	//paso de parámetros tanto a la expresión predicado lambda como al método referenciado
	}
	
	public double restar(double x, double y){
		return x - y;		
	}
	
	
	public static void main(String[] args) {
		FuncInterApp app = new FuncInterApp();
		double rpta = app.operar(2, 3);
		System.out.println(rpta);
		
		Operacion op = app::operar; //(n1,n2)->app::operar(n1,n2); no pueden pasarse parámetros en la referencia a método porque no puede usarse ()->
		System.out.println(op.calcular(1,2)); //paso de parámetros	
	}	
}
