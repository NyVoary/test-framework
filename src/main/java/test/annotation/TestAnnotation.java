package test.annotation;

import core.MyAnnotation;
import java.lang.reflect.Method;

public class TestAnnotation {
    @MyAnnotation(value = "/hello")
    public void hello() {
        System.out.println("Méthode hello appelée !");
    }

    @MyAnnotation(value = "/bye")
    public void bye() {
        System.out.println("Méthode bye appelée !");
    }

    public static void main(String[] args) throws Exception {
        TestAnnotation obj = new TestAnnotation();
        for (Method m : TestAnnotation.class.getDeclaredMethods()) {
            if (m.isAnnotationPresent(MyAnnotation.class)) {
                MyAnnotation ann = m.getAnnotation(MyAnnotation.class);
                System.out.println("Méthode " + m.getName() + " liée à l'URL : " + ann.value());
                m.invoke(obj);
            }
        }
    }
}
