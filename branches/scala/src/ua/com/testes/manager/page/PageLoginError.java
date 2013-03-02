package ua.com.testes.manager.page;


public enum PageLoginError {
    /*  5 */   NOT_CORRENT(1), BLOCK(2);

    private int code;


    private PageLoginError(int code) {
        this.code = code;
    }


    public int getCode() {

        return this.code;

    }


    public static PageLoginError getByCode(int code) {

        for (PageLoginError error : values()) {

            if (error.code == code) {

                return error;

            }

        }

        return null;

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.page.PageLoginError
 * JD-Core Version:    0.6.0
 */