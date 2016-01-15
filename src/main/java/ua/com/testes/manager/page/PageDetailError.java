package ua.com.testes.manager.page;


public enum PageDetailError {
       FIRM_NAME_EMPTY(1), FIRM_NAME_NOT_UNIQUE(2), PIPOL_FIO_EMPTY(3),
       CONTACT_DESCRIPTION_EMPTY(4), SECTION_NOT_SELECT(5), STATUS_NOT_SELECT(6),
       FIRM_NOT_SELECT(7), PIPOL_FIO_NOT_UNIQUE(8), PIPOL_NOT_SELECT(9),
       CONTACT_REPEATE_DATE_INCORRENT(10);

    private int code;


    private PageDetailError(int code) {
        this.code = code;
    }


    public int getCode() {

        return this.code;

    }


    public static PageDetailError getByCode(int code) {

        for (PageDetailError error : values()) {

            if (error.code == code) {

                return error;

            }

        }

        return null;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.page.PageDetailError
 * JD-Core Version:    0.6.0
 */