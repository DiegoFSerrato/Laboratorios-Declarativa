package org.example;

import alice.tuprolog.Prolog;
import alice.tuprolog.SolveInfo;
import alice.tuprolog.Struct;
import alice.tuprolog.Term;
import alice.tuprolog.Theory;

import java.io.InputStream;

/**
 * Puente entre Java y Prolog.
 * Carga el archivo calculo.pl y le envia las consultas.
 */
public class Connection {

    private final Prolog engine = new Prolog();

    public Connection() throws Exception {
        try (InputStream in = getClass().getResourceAsStream("/calculo.pl")) {
            if (in == null) {
                throw new IllegalStateException("No se encontro calculo.pl");
            }
            engine.setTheory(new Theory(in));
        }
    }

    /**
     * Arma y ejecuta la consulta en Prolog.
     *
     * @param predicado "d" para derivar, "s" para integrar
     * @param expresion la funcion escrita por el usuario, por ejemplo "3*x^2 + 2*x"
     * @return el resultado ya escrito con operadores, o un mensaje si no hubo solucion
     *
     * Nota: se envia el atomo x como primer argumento (y no una variable libre),
     * porque las reglas empiezan con atomic(Var) y una variable sin ligar no es
     * atomic, asi que la consulta fallaria para casos como "x" o una constante.
     */
    public String consultar(String predicado, String expresion) throws Exception {
        SolveInfo info = engine.solve(predicado + "(x, " + expresion + ", R).");
        return info.isSuccess() ? formatear(info.getTerm("R"))
                                : "Sin solución para esa expresión";
    }

    /**
     * Consulta de aritmetica basica: suma(A, B, R) o resta(A, B, R).
     *
     * @param predicado "suma" o "resta"
     * @param a primer valor escrito en la interfaz
     * @param b segundo valor escrito en la interfaz
     */
    public String operar(String predicado, String a, String b) throws Exception {
        SolveInfo info = engine.solve(predicado + "(" + a + ", " + b + ", R).");
        return info.isSuccess() ? formatear(info.getTerm("R"))
                                : "Sin solución para esos valores";
    }

    // ------------------------------------------------------------
    //  Impresion del resultado
    //
    //  Term.toString() de tuProlog devuelve notacion canonica, por
    //  ejemplo '+'('*'(6,'^'(x,1)),2), que es ilegible para el usuario.
    //  Prolog.toString(Term) solo arregla el operador de primer nivel.
    //  Por eso se recorre el termino y se reconstruye la expresion con
    //  sus operadores, poniendo parentesis solo donde hacen falta.
    // ------------------------------------------------------------

    /** Prioridad de cada operador, igual que en la tabla estandar de Prolog. */
    private static int prioridad(String op) {
        switch (op) {
            case "+":
            case "-":
                return 500;
            case "*":
            case "/":
                return 400;
            case "^":
                return 200;
            default:
                return -1;
        }
    }

    private static String formatear(Term t) {
        return formatear(t, 1200);
    }

    private static String formatear(Term term, int prioridadMaxima) {
        Term t = term.getTerm();

        if (t instanceof Struct) {
            Struct st = (Struct) t;
            String nombre = st.getName();
            int aridad = st.getArity();

            if (aridad == 0) {
                return nombre;
            }

            int prio = (aridad == 2) ? prioridad(nombre) : -1;
            if (prio > 0) {
                // ^ es xfx (ambos lados mas ajustados); + - * / son yfx
                boolean yfx = !"^".equals(nombre);
                String izq = formatear(st.getArg(0), yfx ? prio : prio - 1);
                String der = formatear(st.getArg(1), prio - 1);

                // Se deja espacio solo alrededor de + y - para que se lean
                // los terminos: 3*x^2 + 2*x
                String sep = (prio == 500) ? " " + nombre + " " : nombre;
                String texto = izq + sep + der;
                return (prio > prioridadMaxima) ? "(" + texto + ")" : texto;
            }

            // Functor normal: log(x)
            StringBuilder sb = new StringBuilder(nombre).append("(");
            for (int i = 0; i < aridad; i++) {
                if (i > 0) {
                    sb.append(", ");
                }
                sb.append(formatear(st.getArg(i), 999));
            }
            return sb.append(")").toString();
        }

        return t.toString();
    }
}
