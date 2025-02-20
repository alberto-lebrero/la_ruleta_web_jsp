<%@ page import="java.sql.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<link rel="stylesheet" href="../css/estilos.css">
	    <title>Generar Resultados</title>
	</head>
	<body>
	    <h2>Generar resultados para un día</h2>
	    <form method="post">
	        Fecha (dd/mm/yyyy): <input type="text" name="fecha" required>
	        <input type="submit" value="Generar">
	    </form>
	
		<%
		    String fecha = request.getParameter("fecha");
			int numeroDeTiradasTotales = 0;
			
		    if (fecha != null) {        
		        try {
					Class.forName("oracle.jdbc.OracleDriver");
					
					// Obtengo la conexión a la BBDD de Oracle
					try (Connection conexion = DriverManager.getConnection("jdbc:oracle:thin:hr/hr@//localhost:1521/XE")) {
						
						PreparedStatement sentenciaInsercionTirada = conexion.prepareStatement("INSERT INTO RESULTADOS VALUES (?, ?, ?)");
					    Random numeroAleatorio = new Random();
					    
					    for (int numeroOrdenTirada = 1; numeroOrdenTirada <= 500; numeroOrdenTirada++) {
					        int numeroGenerado = numeroAleatorio.nextInt(0, 37);
					        
					        sentenciaInsercionTirada.setString(1, fecha);
					        sentenciaInsercionTirada.setInt(2, numeroOrdenTirada);
					        sentenciaInsercionTirada.setInt(3, numeroGenerado);
					        sentenciaInsercionTirada.executeUpdate();
					        
					        numeroDeTiradasTotales++;
					    }
					    
					    sentenciaInsercionTirada.close();
					    out.println("<p>Se han insertado " + numeroDeTiradasTotales + " tiradas para el día " + fecha + ".</p>");
					} 
				} catch (ClassNotFoundException cNFE) {
					out.println("<p>Error al cargar el driver JDBC de Oracle.</p>");
				} catch (SQLException sqlEx) {
					out.println("<p>Error en la base de datos: " + sqlEx.getMessage() + "</p>");
				}
		    }
		%>
		
		<a class="volver" target="_self" href="../html/index.html"> Volver a atrás </a>
	</body>
	<footer>
		<div> &copy; 2025 - Alberto Lebrero Pizarro - 2ºDAM</div>
	</footer>
</html>
