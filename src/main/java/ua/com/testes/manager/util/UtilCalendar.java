package ua.com.testes.manager.util;


import java.util.*;


public class UtilCalendar {

    public static List<Month> getDisplayMonths(Locale locale) {

        GregorianCalendar calendar = new GregorianCalendar();

        Map<String, Integer> monthsMap = calendar.getDisplayNames(2, 2, locale);


        List<Month> months = new ArrayList<Month>(monthsMap.size());

        for (String monthName : monthsMap.keySet()) {

            months.add(new Month(monthName, ((Integer) monthsMap.get(monthName)).intValue()));

        }

        Collections.sort(months, new Comparator<Month>() {

            public final int compare(UtilCalendar.Month o1, UtilCalendar.Month o2) {

                return o1.order - o2.order;

            }

        });

        return Collections.unmodifiableList(months);

    }


    public static List<Day> getDisplayDays(Locale locale) {

        GregorianCalendar calendar = new GregorianCalendar();

        Map<String, Integer> daysMap = calendar.getDisplayNames(7, 2, locale);


        List days = new ArrayList(daysMap.size());

        for (String dayName : daysMap.keySet()) {

            days.add(new Day(dayName, ((Integer) daysMap.get(dayName)).intValue()));

        }

        Collections.sort(days, new Comparator<Day>() {

            public final int compare(UtilCalendar.Day o1, UtilCalendar.Day o2) {

                return o1.order - o2.order;

            }

        });

        return Collections.unmodifiableList(days);

    }


    public static boolean inPeriod(Date start, Date finish, Date value) {

        if (value == null) {

            return false;

        }

        if (start != null) {

            if (finish != null) {

                return (start.before(value)) && (finish.after(value));

            }

            return start.before(value);

        }


        return (finish == null) || (finish.after(value));

    }


    public static final class Day {
        public final String name;
        public final int order;


        public Day(String name, int order) {

            this.name = name;

            this.order = order;

        }


        public int getDisplayOrder() {

            return this.order + 1;

        }

    }


    public static final class Month {
        public final String name;
        public final int order;


        public Month(String name, int order) {

            this.name = name;

            this.order = order;

        }


        public int getDisplayOrder() {

            return this.order + 1;

        }

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.util.UtilCalendar
 * JD-Core Version:    0.6.0
 */