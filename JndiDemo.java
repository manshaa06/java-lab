package com.shopsphere.demo;

import com.shopsphere.rmi.InventoryService;
import java.util.Hashtable;
import javax.naming.Context;
import javax.naming.InitialContext;

/**
 * JNDI demo: looks up the RMI inventory service through a JNDI InitialContext that is backed by the RMI registry.
 * Start com.shopsphere.rmi.RmiServer first.
 */
public class JndiDemo {
    public static void main(String[] args) throws Exception {
        Hashtable<String, String> env = new Hashtable<>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.rmi.registry.RegistryContextFactory");
        env.put(Context.PROVIDER_URL, "rmi://localhost:1099");

        Context ctx = new InitialContext(env);
        InventoryService svc = (InventoryService) ctx.lookup("InventoryService");   // naming lookup
        System.out.println("JNDI lookup OK. Stock of product 1 = " + svc.getStock(1));
        ctx.close();
    }
}
