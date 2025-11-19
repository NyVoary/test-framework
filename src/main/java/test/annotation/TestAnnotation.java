package test.annotation;

import core.annotation.Controller;
import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.List;

public class TestAnnotation {
    public static void main(String[] args) throws Exception {
        // Liste manuelle des classes à scanner (Java ne permet pas de lister dynamiquement sans lib externe)
        List<Class<?>> classes = Arrays.asList(
            HelloController.class,
            ByeController.class
        );

        for (Class<?> clazz : classes) {
            if (clazz.isAnnotationPresent(Controller.class)) {
                Controller ctrlAnn = clazz.getAnnotation(Controller.class);
                System.out.println("Classe " + clazz.getSimpleName() + " annotée @Controller, value=" + ctrlAnn.value());

                Object instance = clazz.getDeclaredConstructor().newInstance();
                for (Method m : clazz.getDeclaredMethods()) {
                    System.out.println("  -> Méthode : " + m.getName());
                    m.invoke(instance);
                }
            }
        }
    }
}