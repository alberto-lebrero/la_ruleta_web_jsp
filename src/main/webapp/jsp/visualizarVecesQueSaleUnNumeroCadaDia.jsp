<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
	    <meta charset="UTF-8">
	    <link rel="stylesheet" href="../css/estilos.css">
	    <title>Visualizar cantidad de veces que sale un número cada día</title>
	</head>
	<body>
	    <form method="post">
	        Número (0-36): <input type="number" name="numero" min="0" max="36" required>
	        <input type="submit" value="Consultar">
	    </form>
	
	    <%
	        String numeroIntroducidoPorElUsuario = request.getParameter("numero");
	        if (numeroIntroducidoPorElUsuario != null) {
	            int numero = Integer.parseInt(numeroIntroducidoPorElUsuario);
	
	            try {
	                Class.forName("oracle.jdbc.OracleDriver");
	
	                // Obtengo la conexión a la BBDD de Oracle
	                try (Connection conexion = DriverManager.getConnection("jdbc:oracle:thin:hr/hr@//localhost:1521/XE")) {
	                    
	                	PreparedStatement sentenciaPreparadaVecesNumeroTiradaCadaDia = conexion.prepareStatement(
	                			"SELECT COUNT(*), DIA FROM RESULTADOS WHERE NUMERO = ? GROUP BY DIA ORDER BY DIA");
	                	sentenciaPreparadaVecesNumeroTiradaCadaDia.setInt(1, numero);
	                    ResultSet tablaTemporalVecesNumeroTiradaCadaDia = sentenciaPreparadaVecesNumeroTiradaCadaDia.executeQuery();
	
	                    out.println("<h3>Resultados para el número " + numero + "</h3>");
	                    while (tablaTemporalVecesNumeroTiradaCadaDia.next()) {
	                        out.println("<p>Veces que ha salido el numero " + numero + " el día " 
	                    				+ tablaTemporalVecesNumeroTiradaCadaDia.getString("DIA") + ": " 
	                        			+ tablaTemporalVecesNumeroTiradaCadaDia.getInt(1) + "</p>");
	                    }
	
	                    tablaTemporalVecesNumeroTiradaCadaDia.close();
	                    sentenciaPreparadaVecesNumeroTiradaCadaDia.close();
	                    conexion.close();
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
