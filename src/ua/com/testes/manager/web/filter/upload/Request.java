package ua.com.testes.manager.web.filter.upload;


import java.util.Enumeration;
import java.util.Hashtable;


public class Request {
    private Hashtable<String, Hashtable<Integer, String>> m_parameters;
    private int m_counter;


    Request() {

        this.m_parameters = new Hashtable();

        this.m_counter = 0;

    }


    protected void putParameter(String name, String value) {

        if (name == null)
            throw new IllegalArgumentException("The name of an element cannot be null.");

        if (this.m_parameters.containsKey(name)) {

            Hashtable values = (Hashtable) this.m_parameters.get(name);

            values.put(new Integer(values.size()), value);

        } else {

            Hashtable values = new Hashtable();

            values.put(new Integer(0), value);

            this.m_parameters.put(name, values);

            this.m_counter += 1;

        }

    }


    public String getParameter(String name) {

        if (name == null)
            throw new IllegalArgumentException("Form's name is invalid or does not exist (1305).");

        Hashtable values = (Hashtable) this.m_parameters.get(name);

        if (values == null) {

            return null;

        }

        return (String) values.get(new Integer(0));

    }


    public Enumeration<String> getParameterNames() {

        return this.m_parameters.keys();

    }


    public String[] getParameterValues(String name) {

        if (name == null)
            throw new IllegalArgumentException("Form's name is invalid or does not exist (1305).");

        Hashtable values = (Hashtable) this.m_parameters.get(name);

        if (values == null)
            return null;

        String[] strValues = new String[values.size()];

        for (int i = 0; i < values.size(); i++) {

            strValues[i] = ((String) values.get(new Integer(i)));

        }

        return strValues;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.filter.upload.Request
 * JD-Core Version:    0.6.0
 */