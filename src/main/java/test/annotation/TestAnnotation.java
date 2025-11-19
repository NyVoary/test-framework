package test.annotation;

import core.annotation.Controller;
import java.lang.reflect.Method;
import java.io.File;

public class TestAnnotation {
    public static void main(String[] args) throws Exception {
        scanDir(new File("build/classes"), "");
    }

    private static void scanDir(File dir, String packageName) throws Exception {
        if (!dir.exists()) return;
        for (File file : dir.listFiles()) {
            if (file.isDirectory()) {
                String nextPackage = packageName.isEmpty() ? file.getName() : packageName + "." + file.getName();
                scanDir(file, nextPackage);
            } else if (file.getName().endsWith(".class")) {
                String className = file.getName().replace(".class", "");
                if (packageName.isEmpty()) continue; // Ignore default package
                Class<?> clazz = Class.forName(packageName + "." + className);

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
}