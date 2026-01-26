package com.mitocode.methodReference;

@FunctionalInterface //es opcional pero recomendable
public interface Operacion {

	void saludar(); //solo puede tener 1 método abstracto, pero puede incluir métodos default y static adicionales sin problema
	
	default void log(String msg) {
		System.out.println(msg);
    }

    static void info() {
    	System.out.println("Interfaz funcional");
    }
}
