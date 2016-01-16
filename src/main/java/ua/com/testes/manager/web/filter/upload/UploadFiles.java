package ua.com.testes.manager.web.filter.upload;


import java.util.Collection;
import java.util.Map;
import java.util.TreeMap;


public final class UploadFiles {
    private final Map<Integer, UploadFile> m_files = new TreeMap();
    private int m_counter;


    public UploadFiles() {

        this.m_counter = 0;

    }


    protected void addFile(UploadFile newFile) {

        if (newFile == null) {

            throw new IllegalArgumentException("newFile cannot be null.");

        }

        this.m_files.put(Integer.valueOf(this.m_counter), newFile);

        this.m_counter += 1;

    }


    public UploadFile getFile(int index) {

        if (index < 0)
            throw new IllegalArgumentException("UploadFile's index cannot be a negative value (1210).");

        UploadFile retval = (UploadFile) this.m_files.get(Integer.valueOf(index));

        if (retval == null) {

            throw new IllegalArgumentException("UploadFiles' name is invalid or does not exist (1205).");

        }

        return retval;

    }


    public int getCount() {

        return this.m_counter;

    }


    public long getSize() {

        long tmp = 0L;

        for (int i = 0; i < this.m_counter; i++) {

            tmp += getFile(i).getSize();

        }

        return tmp;

    }


    public Collection<UploadFile> getCollection() {

        return this.m_files.values();

    }


    public Collection<UploadFile> getEnumeration() {

        return this.m_files.values();

    }

}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.filter.upload.UploadFiles
 * JD-Core Version:    0.6.0
 */