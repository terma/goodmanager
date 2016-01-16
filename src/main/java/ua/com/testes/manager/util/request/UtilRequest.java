package ua.com.testes.manager.util.request;


public final class UtilRequest {

    public static String addParameter(String request, String parameterName, String parameterValue) {
        if (request.contains("?")) {
            return request + "&" + parameterName + "=" + parameterValue;
        }
        return request + "?" + parameterName + "=" + parameterValue;
    }

}