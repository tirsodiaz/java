package com.mitocode.highorder;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.function.Predicate;

import com.mitocode.finterface.Operacion;

public class HighApp {

	private Function<String, String> convertirMayusculas = x -> x.toUpperCase();
	private Function<String, String> convertirMinusculas = x -> x.toLowerCase();
	
	//similar al uso de un interfaz funcional
	//Operacion op = (n1,n2) -> n1 + n2;
	//return op.calcular(2, 3);

	public void imprimir(Function<String, String> funcion, String valor) {
		System.out.println(funcion.apply(valor));
	}
	
	public Function<String, String> mostrar(String mensaje) {
		return (String x) -> mensaje + x;
	}
	
	public void filtrar(List<String> lista, Consumer<String> consumidor, int longitud, String cadena){
		//lista.stream().filter(this.getPredicadoLambdaFiltro(longitud)).forEach(consumidor);
		lista.stream().filter(this.getPredicadoLambdaFiltro(cadena)).forEach(consumidor);
	}
	
	public Predicate<String> getPredicadoLambdaFiltro(int longitud){
		return texto -> texto.length() < longitud; //se devuelve un predicado o lambda
	}
	
	public Predicate<String> getPredicadoLambdaFiltro(String cadena){
		return texto -> texto.contains(cadena); //se devuelve un predicado o lambda
	}
		

	public static void main(String[] args) {
		HighApp app = new HighApp();
		app.imprimir(app.convertirMayusculas, "mitocode");
		app.imprimir(app.convertirMinusculas, "MITOCODE");
		
		String rpta = app.mostrar("Hola ").apply("MitoCode");
		System.out.println(rpta);
		app.convertirMayusculas = x -> x.concat(" function redefinida").toUpperCase();
		app.imprimir(app.convertirMayusculas,"mitoooooocode");
			
		List<String> lista = new ArrayList<>();
		lista.add("Mito");
		lista.add("Code");
		lista.add("MitoCode");
		
		//app.filtrar(lista, System.out::println, 5, null);
		app.filtrar(lista, System.out::println, 0, "Code");
		Consumer<String> trazaConsumer = s -> System.out.println("LOG: " + s); //consumer que escribe traza
		app.filtrar(lista, trazaConsumer, 0, "Mito");
		
		List<String> listaSalida = new ArrayList<>();
		Consumer<String> listaConsumer = s -> listaSalida.add(s); //consumer que agrega a otra lista
		app.filtrar(lista, listaConsumer, 0, "Mito");
		
		
	}
}
