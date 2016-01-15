package ua.com.testes.manager.web.filter.upload;

import java.io.*;
import java.math.BigInteger;
import java.sql.ResultSet;
import java.sql.SQLException;

public final class UploadFile extends InputStream {
    private Upload m_parent;
    private int m_startData;
    private int m_endData;
    private int m_size;
    private int mis_current_pos;
    private int mis_size;
    private String m_fieldname;
    private String m_filename;
    private String m_fileExt;
    private String m_filePathName;
    private String m_contentType;
    private String m_contentDisp;
    private String m_typeMime;
    private String m_subTypeMime;
    private boolean m_isMissing;
       private int mark_position = 0;
    public static final int SAVEAS_AUTO = 0;
    public static final int SAVEAS_VIRTUAL = 1;
    public static final int SAVEAS_PHYSICAL = 2;

    public UploadFile() {

        this.m_startData = 0;

        this.m_endData = 0;

        this.m_size = 0;

        this.m_fieldname = "";

        this.m_filename = "";

        this.m_fileExt = "";

        this.m_filePathName = "";

        this.m_contentType = "";

        this.m_contentDisp = "";

        this.m_typeMime = "";

        this.m_subTypeMime = "";

        this.m_isMissing = true;

        this.mis_current_pos = 0;

        this.mis_size = 0;
    }

    public int read() {

        if (this.mis_current_pos < this.mis_size) {

            return 0xFF & getBinaryData(this.mis_current_pos++);
        }

        return -1;
    }

    public int available() {

        return this.mis_size - this.mis_current_pos;
    }

    public InputStream getInputStream() {

        return this;
    }

    public void saveAs(String destFilePathName) throws UploadException, IOException {

        saveAs(destFilePathName, 0);
    }

    public void saveAs(String destFilePathName, int optionSaveAs) throws UploadException, IOException {

        String path = this.m_parent.getPhysicalPath(destFilePathName, optionSaveAs);

        if (path == null)
 throw new IllegalArgumentException("There is no specified destination file (1140).");
        try {

            File file = new File(path);

            FileOutputStream fileOut = new FileOutputStream(file);

            if ((this.m_size > 0) && (this.m_size + this.m_startData > 0) && (this.m_size + this.m_startData < this.m_parent.m_binArray.length))
 fileOut.write(this.m_parent.m_binArray, this.m_startData, this.m_size);

            fileOut.close();
        } catch (IOException e) {

            e.printStackTrace();

            throw new UploadException("UploadFile can't be saved (1120). file=" + destFilePathName + " ex=" + e);
        }
    }

    public OutputStream out() throws UploadException, IOException {
        try {

            ByteArrayOutputStream out = new ByteArrayOutputStream();

            if ((this.m_size > 0) && (this.m_size + this.m_startData > 0) && (this.m_size + this.m_startData < this.m_parent.m_binArray.length)) {

                out.write(this.m_parent.m_binArray, this.m_startData, this.m_size);
            }

            out.close();

            return out;
        } catch (IOException e) {
            throw new UploadException(e.getMessage());

        }
    }

    public byte[] toByteArray() throws UploadException, IOException {
        try {

            ByteArrayOutputStream out = new ByteArrayOutputStream();

            if ((this.m_size > 0) && (this.m_size + this.m_startData > 0) && (this.m_size + this.m_startData < this.m_parent.m_binArray.length)) {

                out.write(this.m_parent.m_binArray, this.m_startData, this.m_size);
            }

            out.close();

            return out.toByteArray();
        } catch (IOException e) {
            throw new UploadException(e.getMessage());

        }
    }

    public void fileToField(ResultSet rs, String cn)
            throws SQLException, UploadException {

        int blockSize = 65536;


        int pos = 0;

        if (rs == null) throw new IllegalArgumentException("The RecordSet cannot be null (1145).");

        if (cn == null) throw new IllegalArgumentException("The cn cannot be null (1150).");

        if (cn.length() == 0) throw new IllegalArgumentException("The cn cannot be empty (1155).");

        long numBlocks = BigInteger.valueOf(this.m_size).divide(BigInteger.valueOf(blockSize)).longValue();

        int leftOver = BigInteger.valueOf(this.m_size).mod(BigInteger.valueOf(blockSize)).intValue();
        try {

            for (int i = 1; i < numBlocks; i++) {

                rs.updateBinaryStream(cn, new ByteArrayInputStream(this.m_parent.m_binArray, pos, blockSize), blockSize);

                pos = pos != 0 ? pos : 1;

                pos = i * blockSize;
            }

            if (leftOver > 0)
                rs.updateBinaryStream(cn, new ByteArrayInputStream(this.m_parent.m_binArray, pos, leftOver), leftOver);
        } catch (SQLException e) {

            byte[] binByte2 = new byte[this.m_size];

            System.arraycopy(this.m_parent.m_binArray, this.m_startData, binByte2, 0, this.m_size);

            rs.updateBytes(cn, binByte2);
        } catch (Exception e) {

            throw new UploadException("Unable to save file in the DataBase (1130).");
        }
    }

    public boolean isMissing() {

        return this.m_isMissing;
    }

    public String getFieldName() {

        return this.m_fieldname;
    }

    public String getFileName() {

        return this.m_filename;
    }

    public String getFilePathName() {

        return this.m_filePathName;
    }

    public String getFileExt() {

        return this.m_fileExt;
    }

    public String getContentType() {

        return this.m_contentType;
    }

    public String getContentDisp() {

        return this.m_contentDisp;
    }

    public String getContentString() {

        return new String(this.m_parent.m_binArray, this.m_startData, this.m_size);
    }

    public String getTypeMIME() {

        return this.m_typeMime;
    }

    public String getSubTypeMIME() {

        return this.m_subTypeMime;
    }

    public int getSize() {

        return this.m_size;
    }

    protected int getStartData() {

        return this.m_startData;
    }

    protected int getEndData() {

        return this.m_endData;
    }

    protected void setParent(Upload parent) {

        this.m_parent = parent;
    }

    protected void setStartData(int startData) {

        this.m_startData = startData;
    }

    protected void setEndData(int endData) {

        this.m_endData = endData;
    }

    protected void setSize(int size) {

        this.m_size = size;

        this.mis_size = size;
    }

    protected void setIsMissing(boolean isMissing) {

        this.m_isMissing = isMissing;
    }

    protected void setFieldName(String fieldName) {

        this.m_fieldname = fieldName;
    }

    protected void setFileName(String fileName) {

        this.m_filename = fileName;
    }

    protected void setFilePathName(String filePathName) {

        this.m_filePathName = filePathName;
    }

    protected void setFileExt(String fileExt) {

        this.m_fileExt = fileExt;
    }

    protected void setContentType(String contentType) {

        this.m_contentType = contentType;
    }

    protected void setContentDisp(String contentDisp) {

        this.m_contentDisp = contentDisp;
    }

    protected void setTypeMIME(String typeMime) {

        this.m_typeMime = typeMime;
    }

    protected void setSubTypeMIME(String subTypeMime) {

        this.m_subTypeMime = subTypeMime;
    }

    public byte getBinaryData(int index) {

        if (this.m_startData + index > this.m_endData)
            throw new ArrayIndexOutOfBoundsException("Index Out of range (1115).");

        if (this.m_startData + index <= this.m_endData) return this.m_parent.m_binArray[(this.m_startData + index)];

        return 0;
    }

    public synchronized void reset() {

        this.mis_current_pos = this.mark_position;
    }

    public boolean markSupported() {

        return true;
    }

    public synchronized void mark(int readlimit) {

        this.mark_position = this.mis_current_pos;
    }
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.filter.upload.UploadFile
 * JD-Core Version:    0.6.0
 */