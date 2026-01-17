<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="title" value="Доступ запрещен" scope="request" />
<jsp:include page="../templates/base.jsp">
    <jsp:param name="content" value="../includes/error-content.jsp" />
</jsp:include>