import mapping.URLMapping;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class TestController {
    
    @URLMapping("/test")
    public void handleTest(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("text/html");
        resp.getWriter().println("<h1>Test réussi !</h1>");
        resp.getWriter().println("<p>Cette réponse vient du framework via @URLMapping</p>");
    }
    
    @URLMapping("/user/{id}")
    public void handleUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String userId = (String) req.getAttribute("id");
        resp.setContentType("text/html");
        resp.getWriter().println("<h1>Utilisateur #" + userId + "</h1>");
        resp.getWriter().println("<p>Paramètre ID extrait automatiquement par le framework</p>");
    }
}