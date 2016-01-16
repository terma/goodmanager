package ua.com.testes.manager.util.locale;


import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Locale;


public class UtilLocale {

    private static final List<Locale> avaibleLocales;

    static {
        List<Locale> locales = new ArrayList<Locale>();
        locales.add(new Locale("ru"));
        locales.add(new Locale("uk"));
        locales.add(Locale.ENGLISH);
        avaibleLocales = Collections.unmodifiableList(locales);
    }

    public static List<Locale> getAvaibles() {
        return avaibleLocales;
    }

    public static String toString(Locale locale) {
        return locale.getCountry() + "&" + locale.getLanguage() + "&" + locale.getVariant();
    }

    public static Locale toLocale(String string) {
        String[] stringArray = string.split("&");
        return new Locale(stringArray[1], stringArray.length > 1 ? stringArray[0] : "", stringArray.length > 2 ? stringArray[2] : "");
    }

}