package ua.com.testes.manager.web.page;


public enum PageSearchType {
    /*  5 */   FIRM(1), ALL(2), PIPOL(3), CONTACT(4);

    private int code;


    private PageSearchType(int code) {
        this.code = code;
    }


    public int getCode() {

        return this.code;

    }


    public static PageSearchType getByCode(int code) {

        for (PageSearchType error : values()) {

            if (error.code == code) {

                return error;

            }

        }

        return null;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.page.PageSearchType
 * JD-Core Version:    0.6.0
 */