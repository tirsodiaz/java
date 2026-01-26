package com.mitocode.methodReference;

@FunctionalInterface
public interface IPersona {

	Persona crear(int id, String nombre); //solo puede tener 1 método abstracto, pero puede incluir métodos default y static adicionales sin problema
	
	default void log(String msg) {
        System.out.println(msg);
    }

    static void info() {
        System.out.println("Interfaz funcional");
    }
}
