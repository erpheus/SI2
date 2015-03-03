package ssii2.visa.dao;

import java.sql.SQLException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import javax.sql.DataSource;
import javax.naming.InitialContext;


/**
 *
 * @author jaime
 */
public class DBTester {

    // Informacion de conexion
    // Para conexiones directas, requerimos: driver, cadena de conexion,
    // usuario y clave
    private static final String JDBC_DRIVER =
           "org.postgresql.Driver";

    // TODO: Definir la cadena de conexion a la base de datos
    /*********************************************************/
    private static final String JDBC_CONNSTRING =
            "jdbc:postgresql://10.1.3.1:5432/visa";
    /*********************************************************/
    private static final String JDBC_USER = "alumnodb";
    private static final String JDBC_PASSWORD = "alumnodb";

    // Para conexion por datasource, solo necesitamos su nombre
    // TODO: Definir el nombre del datasource
    /*************************************************/
    private static final String JDBC_DSN =
            "jdbc/VisaDB";
    /*************************************************/

    // Modo inicial de conexion (directo|dsn)
    private boolean directConnection = false;

    // Datasource para conexiones por pool
    private DataSource ds = null;

    // Informacion de debug
    private int     dsConnectionCount = 0;
    private int     directConnectionCount = 0;

    
    
    public DBTester() {

        try {

            // Para conexiones directas, instanciamos el driver
            Class.forName(JDBC_DRIVER).newInstance();
            //errorLog("Instanciado driver");

            // Para conexiones con pool, preparamos un datasource
            // Buscar el datasource por JNDI
            ds = (DataSource) new InitialContext().lookup(JDBC_DSN);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Obtiene una nueva conexion del pool
    protected synchronized Connection getConnection()
            throws SQLException {

        if (!directConnection) {
            dsConnectionCount++;
            // Obtener una conexion del pool
            return ds.getConnection();
        } else {
            directConnectionCount++;
            // Obtener una nueva conexion
            //errorLog("intentando conectar directamente");
            return DriverManager.getConnection(JDBC_CONNSTRING,
                                               JDBC_USER, JDBC_PASSWORD);
        }
    }

    // Cerrar o devolver la conexion al pool
    protected synchronized void closeConnection(Connection c)
            throws SQLException {
        c.close();
        if (!directConnection) {
            dsConnectionCount--;
        } else {
            directConnectionCount--;
        }
    }

    /*
     * Metodos de ayuda para depuracion
     */


    /**
     * @return the directConnectionCount
     */
    public int getDirectConnectionCount() {
        return directConnectionCount;
    }

    /**
     * @return the dsnConnectionCount
     */
    public int getDSNConnectionCount() {
        return dsConnectionCount;
    }

    /**
     * @return the pooled
     */
    public boolean isDirectConnection() {
        return directConnection;
    }

    /**
     * @param directConnection valor de conexion directa o indirecta
     */
    public void setDirectConnection(boolean directConnection) {
        this.directConnection = directConnection;
    }


}
