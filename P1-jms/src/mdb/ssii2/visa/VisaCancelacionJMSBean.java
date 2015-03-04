/**
 * Pr&aacute;ctricas de Sistemas Inform&aacute;ticos II
 * VisaCancelacionJMSBean.java
 */

package ssii2.visa;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.ejb.EJBException;
import javax.ejb.MessageDriven;
import javax.ejb.MessageDrivenContext;
import javax.ejb.ActivationConfigProperty;
import javax.jms.MessageListener;
import javax.jms.Message;
import javax.jms.TextMessage;
import javax.jms.JMSException;
import javax.annotation.Resource;
import java.util.logging.Logger;

/**
 * @author jaime
 */
@MessageDriven(mappedName = "jms/VisaPagosQueue")
public class VisaCancelacionJMSBean extends DBTester implements MessageListener {
  static final Logger logger = Logger.getLogger("VisaCancelacionJMSBean");
  @Resource
  private MessageDrivenContext mdc;

  private static final String UPDATE_CANCELA_QRY = 
  "UPDATE pago set codrespuesta = 999 WHERE idautorizacion = ? AND codrespuesta <> 999";

  private static final String RECTIFICA_SALDO_QRY =
  "UPDATE tarjeta set saldo = saldo + (SELECT importe FROM pago WHERE idautorizacion = ?) 
  WHERE numerotarjeta = (SELECT numerotarjeta WHERE idautorizacion = ?";
   // TODO : Definir UPDATE sobre la tabla pagos para poner
   // codRespuesta a 999 dado un código de autorización


  public VisaCancelacionJMSBean() {
  }

  // TODO : Método onMessage de ejemplo
  // Modificarlo para ejecutar el UPDATE definido más arriba,
  // asignando el idAutorizacion a lo recibido por el mensaje
  // Para ello conecte a la BD, prepareStatement() y ejecute correctamente
  // la actualización
  public void onMessage(Message inMessage) {
      TextMessage msg = null;
      int idAutorizacion;
      boolean rs = true;
      PreparedStatement pstmt = null;

      try {
          if (inMessage instanceof TextMessage) {
              msg = (TextMessage) inMessage;
              logger.info("MESSAGE BEAN: Message received: " + msg.getText());
              idAutorizacion = Integer.parseInt(msg.getText());
               String update_cancela  = UPDATE_CANCELA_QRY;
               errorLog(update_cancela);
               pstmt = con.prepareStatement(update_cancela);
               pstmt.setInt(1, idAutorizacion);
               rs = pstmt.execute();  

               if(!rs){
                String rectifica_saldo = RECTIFICA_SALDO_QRY;
               errorLog(rectifica_saldo);
               pstmt = con.prepareStatement(rectifica_saldo);
               pstmt.setInt(1, idAutorizacion);
               pstmt.setInt(2, idAutorizacion);
               rs = pstmt.execute();
               }

          } else {
              logger.warning(
                      "Message of wrong type: "
                      + inMessage.getClass().getName());
          }
      } catch (JMSException e) {
          e.printStackTrace();
          mdc.setRollbackOnly();
      } catch (Throwable te) {
          te.printStackTrace();
      }
  }


}
