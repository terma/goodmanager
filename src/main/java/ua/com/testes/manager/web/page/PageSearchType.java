package ua.com.testes.manager.web.page;


public enum PageSearchType {
    FIRM(1), ALL(2), PIPOL(3), CONTACT(4);

    private final int code;

    private PageSearchType(int code) {
        this.code = code;
    }

    public static PageSearchType getByCode(int code) {
        for (PageSearchType error : values()) {
            if (error.code == code) {
                return error;
            }
        }
        return null;

    }

    public int getCode() {
        return this.code;
    }

}