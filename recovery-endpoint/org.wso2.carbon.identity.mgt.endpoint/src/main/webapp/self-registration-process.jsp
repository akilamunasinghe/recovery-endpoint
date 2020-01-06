<%--
  ~ Copyright (c) 2016, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
  ~
  ~  WSO2 Inc. licenses this file to you under the Apache License,
  ~  Version 2.0 (the "License"); you may not use this file except
  ~  in compliance with the License.
  ~  You may obtain a copy of the License at
  ~
  ~    http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing,
  ~ software distributed under the License is distributed on an
  ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  ~ KIND, either express or implied.  See the License for the
  ~ specific language governing permissions and limitations
  ~ under the License.
  --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.IdentityManagementServiceUtil" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.ApiException" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.api.SelfRegisterApi" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.api.UsernameRecoveryApi" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.model.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.client.model.Error" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.IdentityManagementEndpointUtil" %>
<%@ page import="org.wso2.carbon.identity.mgt.endpoint.IdentityManagementEndpointConstants" %>
<%@ page import="org.apache.commons.collections.map.HashedMap" %>
<%@ page import="org.wso2.carbon.base.MultitenantConstants" %>
<jsp:directive.include file="localize.jsp"/>


    <html>
    <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Wso2.identity.server")%></title>

        <link rel="icon" href="images/favicon.png" type="image/x-icon"/>
        <link href="libs/bootstrap_3.3.5/css/bootstrap.min.css" rel="stylesheet">
        <link href="css/Roboto.css" rel="stylesheet">
        <link href="css/custom-common.css" rel="stylesheet">
        <link href="css/joule-custom.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="https://use.fontawesome.com/releases/v5.11.2/css/all.css" integrity="sha384-KA6wR/X5RY4zFAHpv/CnoG2UW1uogYfdnP67Uv7eULvTveboZJg0qUpmJZb5VqzN" crossorigin="anonymous">
        <link rel="stylesheet" type="text/css" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.min.css">

        <!--[if lt IE 9]>
        <script src="js/html5shiv.min.js"></script>
        <script src="js/respond.min.js"></script>
        <![endif]-->
    </head>

    <body onload="setCookieByParam();">

    <script>
        function setCookie() {
            var locale = document.getElementById("lnkChangeLanguage").getAttribute("lang");
            document.cookie = "lang=" + locale + "; path=/;";
            location.reload();
        }

        function setCookieByParam() {
            var urlParams = new URLSearchParams(window.location.search);
            var locale = urlParams.get("lang");
            if (locale) {
                document.cookie = "lang=" + locale + "; path=/;";
            }
        }
    </script>
    <!-- header -->
    <header class="header header-default">
        <div class="header__bar">
            <nav class="align-right horizontal nav nav--utility">
                <ul class="nav__menu nav__menu--social">
                    <li class="icon-utility horizontal"><a href="https://twitter.com/CMA_Docs"><i class="icon-color fab fa-twitter" aria-hidden="true"></i><span class="webaim-hidden">on Twitter</span></a></li>
                    <li class="icon-utility horizontal"><a href="https://www.linkedin.com/company/canadian-medical-association"><i class="icon-color fab fa-linkedin-in" aria-hidden="true"></i><span class="webaim-hidden">on LinkedIn</span></a></li>
                    <li class="icon-utility horizontal"><a href="https://www.instagram.com/cma_docs/"><i class="icon-color fab fa-instagram" aria-hidden="true"></i><span class="webaim-hidden">on Instagram</span></a></li>
                    <li class="icon-utility horizontal"><a href="https://www.facebook.com/CanadianMedicalAssociation"><i class="icon-color fab fa-facebook-f" aria-hidden="true"></i><span class="webaim-hidden">on Facebook</span></a></li>
                    <li class="icon-utility horizontal"><a href="https://www.youtube.com/user/CanadianMedicalAssoc"><i class="icon-color fab fa-youtube" aria-hidden="true"></i><span class="webaim-hidden">on Youtube</span></a></li>
                </ul>
                <ul class="links nav__menu nav__menu--language">
                    <% if (langCode != null && langCode.equals("fr")) { %>
                    <li class="horizontal" onclick="setCookie()"><a id="lnkChangeLanguage" lang="en_GB" href="#" class=" icon-color language-link">English</a></li>
                    <%} else { %>
                    <li class="horizontal" onclick="setCookie()"><a id="lnkChangeLanguage" lang="fr_FR" href="#" class=" icon-color language-link">Français</a></li>
                    <% } %>

                </ul>

            </nav>
        </div>
        <div class="container-fluid">
            <div class="pull-left brand float-remove-xs text-center-xs">
                <a href="https://www.cma.ca">
                    <img src="images/logo-inverse.png" alt=<%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle,
                 "Wso2")%> title=<%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle,
                 "Wso2")%> class="logo">
                    <%--                    <h1><em><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Identity.server")%></em></h1>--%>
                </a>
            </div>
        </div>
    </header>

    <!-- page content -->
    <div class="container-fluid body-wrapper">

        <%
            String ERROR_MESSAGE = "errorMsg";
            String ERROR_CODE = "errorCode";
            String SELF_REGISTRATION_WITH_VERIFICATION_PAGE = "self-registration-with-verification.jsp";
            String SELF_REGISTRATION_WITHOUT_VERIFICATION_PAGE = "self-registration-without-verification.jsp";
            String passwordPatternErrorCode = "20035";
            boolean isSelfRegistrationWithVerification =
                    Boolean.parseBoolean(request.getParameter("isSelfRegistrationWithVerification"));
            
            String userLocale = request.getHeader("Accept-Language");
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String callback = request.getParameter("callback");
            String tenantDomain = request.getParameter("tenantDomain");
            String consent = request.getParameter("consent");
            String policyURL = IdentityManagementServiceUtil.getInstance().getServiceContextURL().replace("/services",
                    "/authenticationendpoint/privacy_policy.do");
            if (StringUtils.isNotEmpty(consent)) {
                consent = IdentityManagementEndpointUtil.buildConsentForResidentIDP
                        (username, consent, "USA",
                                IdentityManagementEndpointConstants.Consent.COLLECTION_METHOD_SELF_REGISTRATION,
                                IdentityManagementEndpointConstants.Consent.LANGUAGE_ENGLISH, policyURL,
                                IdentityManagementEndpointConstants.Consent.EXPLICIT_CONSENT_TYPE,
                                true, false, IdentityManagementEndpointConstants.Consent.INFINITE_TERMINATION);
            }
            if (StringUtils.isBlank(callback)) {
                callback = IdentityManagementEndpointUtil.getUserPortalUrl(
                        application.getInitParameter(IdentityManagementEndpointConstants.ConfigConstants.USER_PORTAL_URL));
            }
            if (StringUtils.isBlank(username)) {
                request.setAttribute("error", true);
                request.setAttribute("errorMsg", IdentityManagementEndpointUtil.i18n(recoveryResourceBundle,
                        "Username.cannot.be.empty"));
                if (isSelfRegistrationWithVerification) {
                    request.getRequestDispatcher("self-registration-with-verification.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("self-registration-without-verification.jsp").forward(request, response);
                }
            }

            if (StringUtils.isBlank(password)) {
                request.setAttribute("error", true);
                request.setAttribute("errorMsg", IdentityManagementEndpointUtil.i18n(recoveryResourceBundle,
                        "Password.cannot.be.empty"));
                if (isSelfRegistrationWithVerification) {
                    request.getRequestDispatcher("self-registration-with-verification.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("self-registration-without-verification.jsp").forward(request, response);
                }
            }

            session.setAttribute("username", username);


            User user = IdentityManagementServiceUtil.getInstance().getUser(username);


            Claim[] claims = new Claim[0];

            List<Claim> claimsList;
            UsernameRecoveryApi usernameRecoveryApi = new UsernameRecoveryApi();
            try {
                claimsList = usernameRecoveryApi.claimsGet(tenantDomain);
                if (claimsList != null) {
                    claims = claimsList.toArray(new Claim[claimsList.size()]);
                }
            } catch (ApiException e) {
                IdentityManagementEndpointUtil.addErrorInformation(request, e);
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }


            List<Claim> userClaimList = new ArrayList<Claim>();
            try {

                for (Claim claim : claims) {
                    if (StringUtils.isNotBlank(request.getParameter(claim.getUri()))) {
                        Claim userClaim = new Claim();
                        userClaim.setUri(claim.getUri());
                        userClaim.setValue(request.getParameter(claim.getUri()));
                        userClaimList.add(userClaim);

                    } else if (claim.getUri().trim().equals("http://wso2.org/claims/locality")
                            && StringUtils.isNotBlank(userLocale)) {

                        Claim localeClaim = new Claim();
                        localeClaim.setUri(claim.getUri());
                        localeClaim.setValue(userLocale.split(",")[0].replace('-','_'));
                        userClaimList.add(localeClaim);

                    }
                }

                SelfRegistrationUser selfRegistrationUser = new SelfRegistrationUser();
                selfRegistrationUser.setUsername(user.getUsername());
                selfRegistrationUser.setTenantDomain(user.getTenantDomain());
                selfRegistrationUser.setRealm(user.getRealm());
                selfRegistrationUser.setPassword(password);
                selfRegistrationUser.setClaims(userClaimList);

                List<Property> properties = new ArrayList<Property>();
                Property sessionKey = new Property();
                sessionKey.setKey("callback");
                sessionKey.setValue(URLEncoder.encode(callback, "UTF-8"));
                
                Property consentProperty = new Property();
                consentProperty.setKey("consent");
                consentProperty.setValue(consent);
                properties.add(sessionKey);
                properties.add(consentProperty);


                SelfUserRegistrationRequest selfUserRegistrationRequest = new SelfUserRegistrationRequest();
                selfUserRegistrationRequest.setUser(selfRegistrationUser);
                selfUserRegistrationRequest.setProperties(properties);

                Map<String, String> requestHeaders = new HashedMap();
                if(request.getParameter("g-recaptcha-response") != null) {
                    requestHeaders.put("g-recaptcha-response", request.getParameter("g-recaptcha-response"));
                }

                SelfRegisterApi selfRegisterApi = new SelfRegisterApi();
                selfRegisterApi.mePostCall(selfUserRegistrationRequest, requestHeaders);
                request.setAttribute("callback", callback);
                request.getRequestDispatcher("self-registration-complete.jsp").forward(request, response);

            } catch (Exception e) {
                IdentityManagementEndpointUtil.addErrorInformation(request, e);
                String errorCode = (String) request.getAttribute("errorCode");
                if (passwordPatternErrorCode.equals(errorCode)) {
                    String i18Resource = IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, errorCode);
                    if (!i18Resource.equals(errorCode)) {
                        request.setAttribute(ERROR_MESSAGE, i18Resource);
                    }
                    if (isSelfRegistrationWithVerification) {
                        request.getRequestDispatcher(SELF_REGISTRATION_WITH_VERIFICATION_PAGE).forward(request,
                                response);
                    } else {
                        request.getRequestDispatcher(SELF_REGISTRATION_WITHOUT_VERIFICATION_PAGE).forward(request,
                                response);
                    }
        
                    return;
                }
            }


        %>
    </div>


    <!-- footer -->
    <footer class="footer">
        <div class="grid">
            <div class="col-sm-6">
                <p class="icon-utility"><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "copyright.canadian.medical.association")%></p>
            </div>
            <div class="col-sm-6">
                <nav class="nav nav--footer-utility pull-right">

                    <ul data-region="utility_footer" class="nav__menu">
                        <% if (langCode != null && langCode.equals("fr")) { %>
                        <li class="horizontal">
                            <a href="https://www.cma.ca/fr/politiques-de-confidentialite-de-lamc-et-de-ses-filiales"><span class="icon-utility icon-color"><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "privacy")%></span></a>
                        </li>
                        <%} else { %>
                        <li class="horizontal">
                            <a href="https://www.cma.ca/privacy-policies-cma-and-its-subsidiaries"><span class="icon-utility icon-color"><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "privacy")%></span></a>
                        </li>
                        <% } %>

                        <% if (langCode != null && langCode.equals("fr")) { %>
                        <li class="horizontal">
                            <a href="https://www.cma.ca/fr/clauses-et-conditions-legales"><span class="icon-utility icon-color"><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "terms.and.conditions")%></span></a>
                        </li>
                        <%} else { %>
                        <li class="horizontal">
                            <a href="https://www.cma.ca/terms-and-conditions"><span class="icon-utility icon-color"><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "terms.and.conditions")%></span></a>
                        </li>
                        <% } %>

                        <% if (langCode != null && langCode.equals("fr")) { %>
                        <li class="horizontal">
                            <a href="https://www.cma.ca/fr/accessibilite"><span class="icon-utility icon-color"><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "accessibility")%></span></a>
                        </li>
                        <%} else { %>
                        <li class="horizontal">
                            <a href="https://www.cma.ca/accessibility"><span class="icon-utility icon-color"><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "accessibility")%></span></a>
                        </li>
                        <% } %>

                    </ul>
                </nav>
            </div>
        </div>
<%--        <div class="container-fluid">--%>
<%--            <p><%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Wso2.identity.server")%> | &copy;--%>
<%--                <script>document.write(new Date().getFullYear());</script>--%>
<%--                <a href="<%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "business.homepage")%>" target="_blank"><i class="icon fw fw-wso2"></i> <%=--%>
<%--                IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "Inc")%></a>.--%>
<%--                <%=IdentityManagementEndpointUtil.i18n(recoveryResourceBundle, "All.rights.reserved")%>--%>
<%--            </p>--%>
<%--        </div>--%>
    </footer>

    <script src="libs/jquery_1.11.3/jquery-1.11.3.js"></script>
    <script src="libs/bootstrap_3.3.5/js/bootstrap.min.js"></script>


    </body>
    </html>
