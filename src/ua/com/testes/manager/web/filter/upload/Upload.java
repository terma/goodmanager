package ua.com.testes.manager.web.filter.upload;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.PageContext;
import java.io.*;
import java.net.URLDecoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Set;
import java.util.TreeSet;

public final class Upload {
    /*  23 */   private final Set<String> ds = new TreeSet();
    /*  24 */   private final Set<String> as = new TreeSet();
    byte[] m_binArray;
    private HttpServletRequest m_request;
    private HttpServletResponse m_response;
    private ServletContext m_application;
    private int m_totalBytes;
    private int m_currentIndex;
    private int m_startData;
    private int m_endData;
    private String m_boundary;
    private long m_totalMaxFileSize;
    private long m_maxFileSize;
    private boolean m_denyPhysicalPath;
    private String m_contentDisposition;
    public static final int SAVE_AUTO = 0;
    public static final int SAVE_VIRTUAL = 1;
    public static final int SAVE_PHYSICAL = 2;
    private UploadFiles m_files;
    private Request m_formRequest;
    /*  44 */   private String charset = "UTF-8";
    private static final int DEFAULT_BLOCK_SIZE = 65000;

    public Upload() {
/*  48 */
        this.m_totalBytes = 0;
/*  49 */
        this.m_currentIndex = 0;
/*  50 */
        this.m_startData = 0;
/*  51 */
        this.m_endData = 0;
/*  52 */
        this.m_boundary = "";
/*  53 */
        this.m_totalMaxFileSize = 0L;
/*  54 */
        this.m_maxFileSize = 0L;
/*  55 */
        this.m_denyPhysicalPath = false;
/*  56 */
        this.m_contentDisposition = "";
/*  57 */
        this.m_files = new UploadFiles();
/*  58 */
        this.m_formRequest = new Request();
    }

    public final void init(ServletConfig config) {
/*  62 */
        this.m_application = config.getServletContext();
    }

    public void service(HttpServletRequest request, HttpServletResponse response) {
/*  66 */
        this.m_request = request;
/*  67 */
        this.m_response = response;
    }

    public final void init(ServletConfig c, HttpServletRequest rq, HttpServletResponse rs) {
/*  71 */
        this.m_application = c.getServletContext();
/*  72 */
        this.m_request = rq;
/*  73 */
        this.m_response = rs;
    }

    public final void initialize(PageContext pageContext) {
/*  77 */
        this.m_application = pageContext.getServletContext();
/*  78 */
        this.m_request = ((HttpServletRequest) pageContext.getRequest());
/*  79 */
        this.m_response = ((HttpServletResponse) pageContext.getResponse());
    }

    public final void init(ServletContext application, HttpServletRequest request, HttpServletResponse response) {
/*  83 */
        this.m_application = application;
/*  84 */
        this.m_request = request;
/*  85 */
        this.m_response = response;
    }

    public void upload() throws UploadException, IOException {
/*  89 */
        System.out.println("UPLOAD: Start");
/*  90 */
        long totalFileSize = 0L;
/*  91 */
        boolean found = false;
/*  92 */
        String fileName = "";
/*  93 */
        String fileExt = "";
/*  94 */
        String filePathName = "";
/*  95 */
        String contentType = "";
/*  96 */
        String contentDisp = "";
/*  97 */
        String typeMIME = "";
/*  98 */
        String subTypeMIME = "";
/*  99 */
        this.m_totalBytes = this.m_request.getContentLength();

        DataInputStream dis = new DataInputStream(this.m_request.getInputStream());

        if (this.m_totalBytes >= 0) this.m_binArray = new byte[this.m_totalBytes];
        else
            throw new UploadException("Unable to upload. (m_totalBytes<0)");
        try {

            dis.readFully(this.m_binArray);
        } catch (IOException ex) {

            throw new UploadException("Unable to upload. DataInputStream.readFully()\n", ex);
        }

        for (; (!found) && (this.m_currentIndex < this.m_totalBytes); this.m_currentIndex += 1) {

            char c = (char) this.m_binArray[this.m_currentIndex];

            if (c == '\r') found = true;
            else
                this.m_boundary = new StringBuilder().append(this.m_boundary).append(c).toString();
        }

        if (this.m_currentIndex == 1) return;

        this.m_currentIndex += 1;
        while (true) {

            System.out.println("UPLOAD: File");

            if (this.m_currentIndex >= this.m_totalBytes) break;

            String dataHeader = getDataHeader();

            this.m_currentIndex += 2;

            boolean isFile = dataHeader.indexOf("filename") > 0;

            String fieldName = getDataFieldValue(dataHeader, "name");

            if (isFile) {

                filePathName = getDataFieldValue(dataHeader, "filename");

                fileName = getFileName(filePathName);

                fileExt = getFileExt(fileName);

                contentType = getContentType(dataHeader);

                contentDisp = getContentDisp(dataHeader);

                typeMIME = getTypeMIME(contentType);

                subTypeMIME = getSubTypeMIME(contentType);

                isFile = fileName.trim().length() > 0;
            }

            getDataSection();

            String lowerExt = fileExt.toLowerCase();

            if ((isFile) && (fileName.length() > 0)) {

                if (this.ds.contains(lowerExt)) {

                    throw new SecurityException(new StringBuilder().append("The extension of the file (").append(lowerExt).append(") is denied to be uploaded (1015).").toString());
                }

                if ((!this.as.isEmpty()) && (!this.as.contains(lowerExt))) {

                    throw new SecurityException(new StringBuilder().append("The extension of the file (").append(lowerExt).append(") is not allowed to be uploaded (1010).").toString());
                }

                if ((this.m_maxFileSize > 0L) && (this.m_endData - this.m_startData + 1 > this.m_maxFileSize)) {

                    throw new SecurityException(new StringBuilder().append("Size (").append(this.m_endData - this.m_startData + 1).append(" bytes) exceeded (").append(this.m_maxFileSize).append(" bytes) for this file: ").append(fileName).append(" (1105).").toString());
                }

                totalFileSize += this.m_endData - this.m_startData + 1;

                if ((this.m_totalMaxFileSize > 0L) && (totalFileSize > this.m_totalMaxFileSize)) {

                    throw new SecurityException(new StringBuilder().append("Total UploadFile Size (").append(this.m_totalMaxFileSize).append(" bytes) exceeded (").append(totalFileSize).append(") (1110).").toString());
                }

                UploadFile newFile = new UploadFile();

                newFile.setParent(this);

                newFile.setFieldName(fieldName);

                newFile.setFileName(fileName);

                newFile.setFileExt(lowerExt);

                newFile.setFilePathName(filePathName);

                newFile.setIsMissing(filePathName.length() == 0);

                newFile.setContentType(contentType);

                newFile.setContentDisp(contentDisp);

                newFile.setTypeMIME(typeMIME);

                newFile.setSubTypeMIME(subTypeMIME);

                if (contentType.indexOf("application/x-macbinary") > 0) this.m_startData += 128;

                newFile.setSize(this.m_endData - this.m_startData + 1);

                newFile.setStartData(this.m_startData);

                newFile.setEndData(this.m_endData);

                this.m_files.addFile(newFile);
            } else {

                String value = "";

                if ((this.m_startData >= 0) && (this.m_endData >= 0) && (this.m_endData - this.m_startData + 1 > 0)) {
                    try {

                        value = new String(this.m_binArray, this.m_startData, this.m_endData - this.m_startData + 1, this.charset);
                    } catch (Exception ex) {

                        ex.printStackTrace();
                    }
                }

                this.m_formRequest.putParameter(fieldName, value);
            }

            if ((char) this.m_binArray[(this.m_currentIndex + 1)] == '-') break;

            this.m_currentIndex += 2;
        }
    }

    public int save(String destPathName) throws UploadException, IOException {

        return save(destPathName, 0);
    }

    public int save(String destPathName, int option) throws UploadException, IOException {

        int count = 0;

        if (destPathName == null) destPathName = this.m_application.getRealPath("/");

        if (destPathName.indexOf("/") != -1) {

            if (destPathName.charAt(destPathName.length() - 1) != '/') {

                destPathName = String.valueOf(destPathName).concat("/");
            }
        } else if (destPathName.charAt(destPathName.length() - 1) != '\\') {

            destPathName = String.valueOf(destPathName).concat("\\");
        }


        for (int i = 0; i < this.m_files.getCount(); i++) {

            if (!this.m_files.getFile(i).isMissing()) {

                this.m_files.getFile(i).saveAs(new StringBuilder().append(destPathName).append(this.m_files.getFile(i).getFileName()).toString(), option);

                count++;
            }
        }

        return count;
    }

    public int getSize() {

        return this.m_totalBytes;
    }

    public byte getBinaryData(int index) {

        return this.m_binArray[index];
    }

    public UploadFiles getFiles() {

        return this.m_files;
    }

    public Request getRequest() {

        return this.m_formRequest;
    }

    public void downloadFile(String sourceFilePathName) throws IOException {

        downloadFile(sourceFilePathName, null, null);
    }

    public void downloadFile(String sourceFilePathName, String contentType) throws IOException {

        downloadFile(sourceFilePathName, contentType, null);
    }

    public void downloadFile(String sourceFilePathName, String contentType, String destFileName)
            throws IOException {

        downloadFile(sourceFilePathName, contentType, destFileName, 65000);
    }

    public void downloadFile(String sourceFilePathName, String contentType, String destFileName, int blockSize)
            throws IOException {

        if ("".equals(sourceFilePathName)) {

            throw new IllegalArgumentException(new StringBuilder().append("UploadFile '").append(sourceFilePathName).append("' not found (1040).").toString());
        }

        if ((!isVirtual(sourceFilePathName)) && (this.m_denyPhysicalPath))
            throw new SecurityException("Physical path is denied (1035).");

        if (isVirtual(sourceFilePathName)) sourceFilePathName = this.m_application.getRealPath(sourceFilePathName);

        File file = new File(sourceFilePathName);


        long fileLen = file.length();


        int totalRead = 0;

        byte[] b = new byte[blockSize];

        if (contentType == null) this.m_response.setContentType("application/x-msdownload");

        else if (contentType.length() == 0) this.m_response.setContentType("application/x-msdownload");
        else {

            this.m_response.setContentType(contentType);
        }

        this.m_response.setContentLength((int) fileLen);

        this.m_contentDisposition = (this.m_contentDisposition != null ? this.m_contentDisposition : "attachment;");

        if (destFileName == null) {

            this.m_response.setHeader("Content-Disposition", new StringBuilder().append(this.m_contentDisposition).append(" filename=").append(sourceFilePathName).toString());
        } else {

            this.m_response.setHeader("Content-Disposition", new StringBuilder().append(this.m_contentDisposition).append(destFileName.length() == 0 ? "" : new StringBuilder().append(" filename=").append(destFileName).toString()).toString());
        }


        FileInputStream fileIn = new FileInputStream(file);

        while (totalRead < fileLen) {

            int readBytes = fileIn.read(b, 0, blockSize);

            totalRead += readBytes;

            this.m_response.getOutputStream().write(b, 0, readBytes);
        }

        fileIn.close();
    }

    public void downloadField(ResultSet rs, String columnName, String contentType, String destFileName) throws SQLException, IOException {

        if (rs == null) throw new IllegalArgumentException("The RecordSet cannot be null (1045).");

        if (columnName == null) throw new IllegalArgumentException("The columnName cannot be null (1050).");

        if (columnName.length() == 0) throw new IllegalArgumentException("The columnName cannot be empty (1055).");

        byte[] b = rs.getBytes(columnName);

        if (contentType == null) this.m_response.setContentType("application/x-msdownload");

        else if (contentType.length() == 0) this.m_response.setContentType("application/x-msdownload");
        else {

            this.m_response.setContentType(contentType);
        }

        this.m_response.setContentLength(b.length);

        if (destFileName == null) this.m_response.setHeader("Content-Disposition", "attachment;");

        else if (destFileName.length() == 0) this.m_response.setHeader("Content-Disposition", "attachment;");
        else {

            this.m_response.setHeader("Content-Disposition", "attachment; filename=".concat(String.valueOf(destFileName)));
        }

        this.m_response.getOutputStream().write(b, 0, b.length);
    }

    public void fieldToFile(ResultSet rs, String columnName, String destFilePathName) throws UploadException {
        try {

            if (this.m_application.getRealPath(destFilePathName) != null) {

                destFilePathName = this.m_application.getRealPath(destFilePathName);
            }

            InputStream is_data = rs.getBinaryStream(columnName);

            FileOutputStream file = new FileOutputStream(destFilePathName);
            int c;

            while ((c = is_data.read()) != -1) file.write(c);

            file.close();
        } catch (Exception e) {

            throw new UploadException("Unable to save file from the DataBase (1020).");
        }
    }

    private String getDataFieldValue(String dataHeader, String fieldName) {

        String value = "";

        String token = new StringBuilder().append(fieldName).append("=").append("\"").toString();

        int pos = dataHeader.indexOf(token);

        if (pos > 0) {

            int start = pos + token.length();

            int end = dataHeader.indexOf("\"", start);

            if ((start > 0) && (end > 0)) value = dataHeader.substring(start, end);
        }

        if ((value != null) && (value.length() >= 1)) {
            try {

                String decoded_value = URLDecoder.decode(value, this.charset);

                if (!value.equals(decoded_value)) return decoded_value.trim();
            } catch (IllegalArgumentException iae) {

                return value.trim();
            } catch (UnsupportedEncodingException uee) {

                uee.printStackTrace();
            }
        }


        return value;
    }

    private String getFileExt(String fileName) {

        String value = "";


        if (fileName == null) return null;

        int start = fileName.lastIndexOf(46) + 1;

        int end = fileName.length();

        if (start > 0) value = fileName.substring(start, end);

        if (fileName.lastIndexOf(46) > 0) return value;

        return "";
    }

    private String getContentType(String dataHeader) {

        String value = "";


        String token = "Content-Type:";

        int start = dataHeader.indexOf(token) + token.length();

        if (start > 0) {

            value = dataHeader.substring(start, dataHeader.length());
        }

        return value;
    }

    private String getTypeMIME(String contentType) {

        String value = "";

        int pos = contentType.indexOf("/");

        if ((pos == -1) || (contentType.length() <= 0)) return value;

        if (pos > contentType.length()) pos = contentType.length();

        return contentType.substring(1, pos);
    }

    private String getSubTypeMIME(String contentType) {

        int start = contentType.indexOf("/") + 1;

        int end = contentType.length();

        if ((start > 0) && (end > start)) return contentType.substring(start, end);

        return contentType;
    }

    private String getContentDisp(String dataHeader) {

        int start = dataHeader.indexOf(":") + 1;

        int end = dataHeader.indexOf(";");

        if ((start > 0) && (end > start)) return dataHeader.substring(start, end);

        return dataHeader;
    }

    private void getDataSection() {

        boolean found = false;

        int searchPos = this.m_currentIndex;

        int keyPos = 0;

        int boundaryLen = this.m_boundary.length();

        this.m_startData = this.m_currentIndex;


        while (searchPos < this.m_totalBytes) {

            if (this.m_binArray[searchPos] == (byte) this.m_boundary.charAt(keyPos)) {

                if (keyPos == boundaryLen - 1) {

                    found = true;

                    this.m_endData = (searchPos - boundaryLen - 2);

                    break;
                }

                searchPos++;

                keyPos++;
                continue;
            }

            searchPos++;

            keyPos = 0;
        }


        if (!found) this.m_endData = this.m_startData;

        this.m_currentIndex = (searchPos + 1);
    }

    private String getDataHeader() {

        int start = this.m_currentIndex;

        int end = 0;

        boolean found = false;

        while (!found) {
            try {

                if ((this.m_binArray[this.m_currentIndex] == 13) && (this.m_binArray[(this.m_currentIndex + 2)] == 13)) {

                    found = true;

                    end = this.m_currentIndex - 1;

                    this.m_currentIndex += 2;
                } else {

                    this.m_currentIndex += 1;
                }
            } catch (Exception ex) {

                found = true;

                end = this.m_currentIndex;
            }
        }

        String dataHeader = "";

        if ((start >= 0) && (end - start + 1 > 0)) {
            try {

                dataHeader = new String(this.m_binArray, start, end - start + 1, this.charset);
            } catch (UnsupportedEncodingException ex) {

                dataHeader = new String(this.m_binArray, start, end - start + 1);
            }
        }

        return dataHeader;
    }

    private String getFileName(String filePathName) {

        int pos = filePathName.lastIndexOf(47);

        if (pos != -1) return filePathName.substring(pos + 1, filePathName.length());

        pos = filePathName.lastIndexOf(92);

        if (pos != -1) return filePathName.substring(pos + 1, filePathName.length());

        return filePathName;
    }

    public final void denied(String df) {

        if (df == null) {

            this.ds.clear();

            return;
        }

        String[] da = df.split(";|,");

        for (String d : da)

            this.ds.add(d);
    }

    public final void allow(String af) {

        if (af == null) {

            this.as.clear();

            return;
        }

        String[] aa = af.split(";|,");

        for (String a : aa)

            this.as.add(a);
    }

    public void setDenyPhysicalPath(boolean deny) {

        this.m_denyPhysicalPath = deny;
    }

    public final void setContentDisposition(String contentDisposition) {

        this.m_contentDisposition = contentDisposition;
    }

    public final void setTotalMaxFileSize(long totalMaxFileSize) {

        this.m_totalMaxFileSize = totalMaxFileSize;
    }

    public final void setMaxFileSize(long maxFileSize) {

        this.m_maxFileSize = maxFileSize;
    }

    protected final String getPhysicalPath(String filePathName, int option) {

        String fileSeparator = System.getProperty("file.separator");

        if (filePathName == null)
            throw new IllegalArgumentException("There is no specified destination file (1140).");

        if (filePathName.equals(""))
            throw new IllegalArgumentException("There is no specified destination file (1140).");

        String fileName = null;

        String path = null;

        if (filePathName.lastIndexOf("\\") >= 0) {

            path = filePathName.substring(0, filePathName.lastIndexOf("\\"));

            fileName = filePathName.substring(filePathName.lastIndexOf("\\") + 1);
        }

        if (filePathName.lastIndexOf("/") >= 0) {

            path = filePathName.substring(0, filePathName.lastIndexOf("/"));

            fileName = filePathName.substring(filePathName.lastIndexOf("/") + 1);
        }

        path = (path == null) || (path.length() < 1) ? "/" : path;

        File physicalPath = new File(path);

        boolean isPhysical = physicalPath.exists();

        if (option == 0) {

            if (isVirtual(path)) {

                path = this.m_application.getRealPath(path);

                if (path.endsWith(fileSeparator)) path = new StringBuilder().append(path).append(fileName).toString();
                else

                    path = String.valueOf(new StringBuilder(String.valueOf(path)).append(fileSeparator).append(fileName));

                return path;
            }

            if (isPhysical) {

                if (this.m_denyPhysicalPath)

                    throw new IllegalArgumentException(new StringBuilder().append("The physical [").append(physicalPath).append("] path is denied (1125).").toString());

                return filePathName;
            }

            throw new IllegalArgumentException(new StringBuilder().append("The physical [").append(physicalPath).append("] path does not exist (1135).").toString());
        }

        if (option == 1) {

            if (isVirtual(path)) {

                path = this.m_application.getRealPath(path);

                if (path.endsWith(fileSeparator)) path = new StringBuilder().append(path).append(fileName).toString();
                else

                    path = String.valueOf(new StringBuilder(String.valueOf(path)).append(fileSeparator).append(fileName));

                return path;
            }

            if (isPhysical) throw new IllegalArgumentException("The path is not a virtual path.");

            throw new IllegalArgumentException("This path does not exist (1135).");
        }

        if (option == 2) {

            if (isPhysical) {

                if (this.m_denyPhysicalPath) throw new IllegalArgumentException("Physical path is denied (1125).");

                return filePathName;

            }
            if (isVirtual(path)) throw new IllegalArgumentException("The path is not a physical path.");

            throw new IllegalArgumentException("This path does not exist (1135).");

        }
        return null;
    }

    public final void uploadInFile(String destFilePathName) throws UploadException {

        int pos = 0;


        if (destFilePathName == null)
            throw new IllegalArgumentException("There is no specified destination file (1025).");

        if (destFilePathName.length() == 0)
            throw new IllegalArgumentException("There is no specified destination file (1025).");

        if ((!isVirtual(destFilePathName)) && (this.m_denyPhysicalPath))
            throw new SecurityException("Physical path is denied (1035).");

        int intsize = this.m_request.getContentLength();

        this.m_binArray = new byte[intsize];
        int readBytes;

        for (; pos < intsize; pos += readBytes) {
            try {

                readBytes = this.m_request.getInputStream().read(this.m_binArray, pos, intsize - pos);
            } catch (Exception e) {

                throw new UploadException("Unable to upload.");
            }
        }

        if (isVirtual(destFilePathName)) destFilePathName = this.m_application.getRealPath(destFilePathName);
        try {

            File file = new File(destFilePathName);

            FileOutputStream fileOut = new FileOutputStream(file);

            fileOut.write(this.m_binArray);

            fileOut.close();
        } catch (Exception e) {

            throw new UploadException("The Form cannot be saved in the specified file (1030).");
        }
    }

    private boolean isVirtual(String pathName) {

        if (this.m_application.getRealPath(pathName) != null) {

            File virtualFile = new File(this.m_application.getRealPath(pathName));

            return virtualFile.exists();

        }
        return false;
    }

    public void setCharset(String charset) {

        this.charset = charset;
    }
}

/* Location:           C:\artem\work\goodmanager\web\WEB-INF\classes\
 * Qualified Name:     ua.com.testes.manager.web.filter.upload.Upload
 * JD-Core Version:    0.6.0
 */