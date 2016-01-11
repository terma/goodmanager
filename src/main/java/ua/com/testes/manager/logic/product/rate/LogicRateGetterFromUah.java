package ua.com.testes.manager.logic.product.rate;


import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


final class LogicRateGetterFromUah
        implements LogicRateGetter {
    private static String USE_URL = "http://www.bank.gov.ua/Kurs/kurs_val.jsc";

    private static SimpleDateFormat format = new SimpleDateFormat("dd.MM.yy");


    private String getContent() {

        URL url;

        try {

            url = new URL(USE_URL);

        } catch (MalformedURLException exception) {

            exception.printStackTrace();

            return null;

        }

        try {

            URLConnection connection = url.openConnection();

            connection.connect();

            InputStreamReader reader = new InputStreamReader(connection.getInputStream());

            BufferedReader buffered = new BufferedReader(reader);

            String line = buffered.readLine();

            StringBuffer content = new StringBuffer();

            while (line != null) {

                content.append(line);

                line = buffered.readLine();

            }

            buffered.close();

            return content.toString();

        } catch (IOException exception) {

            exception.printStackTrace();

        }

        return null;

    }


    private List<LogicRateItem> parse(String content) {

        String tempContext = content.replaceAll("\\s*", "");

        tempContext = tempContext.replaceAll("'|\\+", "");

        List rates = new ArrayList();

        Pattern patternDate = Pattern.compile("<tdclass=\"date\">(.*)</td><tdclass=\"date", 8);


        Matcher matcherDate = patternDate.matcher(tempContext);

        Date date = null;

        while (matcherDate.find()) {

            try {

                date = format.parse(matcherDate.group(1));

            } catch (ParseException e) {

                e.printStackTrace();

            }

        }

        if (date == null) return null;


        Pattern patternRate = Pattern.compile("<fontclass=\"dig\">(\\d+\\.\\d+)</font>", 8);


        Matcher matcherRate = patternRate.matcher(tempContext);

        try {

            matcherRate.find();

            rates.add(new LogicRateItem(date, Float.parseFloat(matcherRate.group(1)) / 100.0F, "USA"));

            matcherRate.find();

            rates.add(new LogicRateItem(date, Float.parseFloat(matcherRate.group(1)) / 100.0F, "EURO"));

            matcherRate.find();

            rates.add(new LogicRateItem(date, Float.parseFloat(matcherRate.group(1)) / 10.0F, "RUB"));

        } catch (NumberFormatException exception) {

            exception.printStackTrace();

            return null;

        }

        return rates;

    }


    public List<LogicRateItem> get() {

        String content = getContent();

        if (content != null) {

            return parse(content);

        }

        return null;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.logic.product.rate.LogicRateGetterFromUah
 * JD-Core Version:    0.6.0
 */