package test.annotation;

import core.annotation.Controller;
import core.annotation.MyAnnotation;

@Controller(value = "/hello")
public class HelloController {
    @MyAnnotation(value = "/sayHello")
    public void sayHello() {
        System.out.println("HelloController.sayHello()");
    }
}