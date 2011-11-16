package ua.com.testes.manager.filter.upload;


public class UploadException extends Exception {
    UploadException(String desc) {

        super(desc);

    }


    UploadException(String desc, Throwable tr) {

        super(desc, tr);

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.filter.upload.UploadException
 * JD-Core Version:    0.6.0
 */