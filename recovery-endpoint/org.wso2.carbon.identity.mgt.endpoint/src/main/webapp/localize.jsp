<%--
  ~ Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
  ~
  ~ WSO2 Inc. licenses this file to you under the Apache License,
  ~ Version 2.0 (the "License"); you may not use this file except
  ~ in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~ http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing,
  ~ software distributed under the License is distributed on an
  ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  ~ KIND, either express or implied.  See the License for the
  ~ specific language governing permissions and limitations
  ~ under the License.
  --%>

<%@ page import="java.util.ResourceBundle" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.EncodedControl" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.util.Locale" %>

<%

    String BUNDLE = "org.wso2.carbon.identity.mgt.recovery.endpoint.i18n.Resources";
    ResourceBundle recoveryResourceBundle = ResourceBundle.getBundle(BUNDLE, request.getLocale(), new EncodedControl(StandardCharsets.UTF_8.toString())); ;

    String lang = null;
    String lang_param = null;
    String langCode = "en";
    String countryCode = "GB";

    Cookie[] cookies = request.getCookies();
    lang_param = request.getParameter("lang");

    if (cookies != null && cookies.length != 0){
        for (int i = 0; i < cookies.length; i++) {
            String name = cookies[i].getName();
            String value = cookies[i].getValue();
            if (name.equals("lang")){
                lang = value;
            } else if(lang_param != null) {
                lang = lang_param;
            }
        }
    } else if (lang_param != null) {
        lang = lang_param;
    }

    if (lang != null && !lang.trim().equals("") && lang.indexOf("_") != -1){
        String[] langArray = lang.split("_");
        if(langArray.length == 2){
            langCode = langArray[0];
            countryCode = langArray[1];
            Locale local = new Locale(langCode);
            recoveryResourceBundle = ResourceBundle.getBundle(BUNDLE, local, new EncodedControl(StandardCharsets.UTF_8.toString()));
        }
    } else {
        recoveryResourceBundle = ResourceBundle.getBundle(BUNDLE, request.getLocale(), new EncodedControl(StandardCharsets.UTF_8.toString()));
    }
//    String BUNDLE = "org.wso2.carbon.identity.mgt.recovery.endpoint.i18n.Resources";
//    ResourceBundle recoveryResourceBundle = ResourceBundle.getBundle(BUNDLE, request.getLocale(), new EncodedControl(StandardCharsets.UTF_8.toString()));
%>
