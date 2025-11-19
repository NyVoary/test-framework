package test.annotation;

import core.annotation.Controller;
import core.annotation.MyAnnotation;

@Controller(value = "/bye")
public class ByeController {
    @MyAnnotation(value = "/sayBye")
    public void sayBye() {
        System.out.println("ByeController.sayBye()");
    }
}