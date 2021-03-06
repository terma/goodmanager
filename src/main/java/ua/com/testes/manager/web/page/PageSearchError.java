package ua.com.testes.manager.web.page;


public enum PageSearchError {
       EMPTY_TEXT(1);

    private int code;


    private PageSearchError(int code) {
        this.code = code;
    }


    public int getCode() {

        return this.code;

    }


    public static PageSearchError getByCode(int code) {

        for (PageSearchError error : values()) {

            if (error.code == code) {

                return error;

            }

        }

        return null;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.page.PageSearchError
 * JD-Core Version:    0.6.0
 */