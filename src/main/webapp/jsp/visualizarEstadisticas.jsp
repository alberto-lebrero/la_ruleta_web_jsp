<%@ page import="java.sql.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
	<head>
	    <meta charset="UTF-8">
	    <link rel="stylesheet" href="../css/estilos.css">
	    <title>Visualizar estadísticas</title>
	</head>
	<body>
	    <h2>Visualizar Estadísticas de un Día</h2>
	    <form method="post">
	        Fecha (dd/mm/yyyy): <input type="text" name="fecha" required>
	        <input type="submit" value="Consultar">
	    </form>
		
	    <%! boolean esPar(int numero) { return numero % 2 == 0; } %>
		
	    <%
	        List<Integer> negros = Arrays.asList(2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35);
	        List<Integer> rojos = Arrays.asList(1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36);
	        List<Integer> falta = Arrays.asList(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18);
	        List<Integer> pasa = Arrays.asList(19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36);
	
	        String fechaEstadisticas = request.getParameter("fecha");
	        if (fechaEstadisticas != null) {
	            try {
	                Class.forName("oracle.jdbc.OracleDriver");
	
	                //Obtengo la conexión a la BBDD de Oracle
	                try (Connection conexion = DriverManager.getConnection("jdbc:oracle:thin:hr/hr@//localhost:1521/XE")) {
	                    PreparedStatement sentenciaPreparadaConsulta = conexion.prepareStatement("SELECT NUMERO FROM RESULTADOS WHERE DIA = ?");
	                    sentenciaPreparadaConsulta.setString(1, fechaEstadisticas);
	                    ResultSet tablatemporalParaConsultarResultados = sentenciaPreparadaConsulta.executeQuery();
	
	                    int totalTiradas = 0;
	                    int contadorCero = 0;
	
	                    int contadorPares = 0, contadorImpares = 0;
	                    int contadorFalta = 0, contadorPasa = 0;
	                    int contadorNegros = 0, contadorRojos = 0;
	
	                    while (tablatemporalParaConsultarResultados.next()) {
	                        int numero = tablatemporalParaConsultarResultados.getInt("NUMERO");
	                        totalTiradas++;
	
	                        if (numero == 0) {
	                            contadorCero++;
	                        }
							
	                        if (esPar(numero)) {
	                            contadorPares++;
	                        } else {
	                            contadorImpares++;
	                        }
							
	                        if (falta.contains(numero)) {
	                            contadorFalta++;
	                        }
							
	                        if (pasa.contains(numero)) {
	                            contadorPasa++;
	                        }
							
	                        if (negros.contains(numero)) {
	                            contadorNegros++;
	                        }
							
	                        if (rojos.contains(numero)) {
	                            contadorRojos++;
	                        }
	                    }
						
	                    PreparedStatement sentenciaFechaExistente = conexion.prepareStatement("SELECT DIA FROM RESULTADOS WHERE DIA = ?");
	                    sentenciaFechaExistente.setString(1, fechaEstadisticas);
	                    ResultSet tablatemporalParaConsultarResultadosFechaExistente = sentenciaFechaExistente.executeQuery();
						
	                    if (tablatemporalParaConsultarResultadosFechaExistente.next()) {
	                        out.println("<p>Número de tiradas: " + totalTiradas + "</p>");
	                        out.println("<p>Veces que ha salido el 0: " + contadorCero + "</p>");
	                        out.println("<p>Veces que el número es impar: " + contadorImpares + "</p>");
	                        out.println("<p>Veces que el número es par: " + contadorPares + "</p>");
	                        out.println("<p>Veces que el número es falta: " + contadorFalta + "</p>");
	                        out.println("<p>Veces que el número es pasa: " + contadorPasa + "</p>");
	                        out.println("<p>Veces que el número es negro: " + contadorNegros + "</p>");
	                        out.println("<p>Veces que el número es rojo: " + contadorRojos + "</p>");
	                    } else {
	                        out.println("<p>Ese día no hubo ninguna tirada.</p>");
	                    }
						
	                    tablatemporalParaConsultarResultados.close();
	                    sentenciaPreparadaConsulta.close();
	                    sentenciaFechaExistente.close();
	                    tablatemporalParaConsultarResultadosFechaExistente.close();
	                }
	            } catch (ClassNotFoundException cNFE) {
	                out.println("<p>Error al cargar el driver JDBC de Oracle.</p>");
	            } catch (SQLException sqlEx) {
	                out.println("<p>Error en la base de datos: " + sqlEx.getMessage() + "</p>");
	            }
	            //Si recargo la página me muestra el else dado que no hay ninguna fecha escrita en el input
	        }//else{out.println("<p>Por favor, introduce una fecha</p>");}
	    %>
		
	    <a class="volver" target="_self" href="../html/index.html"> Volver a atrás </a>
		
	</body>
	<footer>
	    <div> &copy; 2025 - Alberto Lebrero Pizarro - 2ºDAM</div>
	</footer>
</html>
