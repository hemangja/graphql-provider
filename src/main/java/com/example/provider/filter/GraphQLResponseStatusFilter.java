package com.example.provider.filter;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import org.springframework.stereotype.Component;
import org.springframework.web.util.ContentCachingResponseWrapper;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
@WebFilter(urlPatterns = "/graphql")
public class GraphQLResponseStatusFilter implements Filter {

	private final ObjectMapper objectMapper = new ObjectMapper();

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		if (!(request instanceof HttpServletRequest) || !(response instanceof HttpServletResponse)) {
			chain.doFilter(request, response);
			return;
		}

		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;

		// Only act on POST /graphql
		if ("/graphql".equals(httpRequest.getRequestURI()) && "POST".equalsIgnoreCase(httpRequest.getMethod())) {
			ContentCachingResponseWrapper wrapped = new ContentCachingResponseWrapper(httpResponse);
			try {
				chain.doFilter(request, wrapped);
			} finally {
				byte[] content = wrapped.getContentAsByteArray();
				if (content != null && content.length > 0) {
					String responseBody = new String(content, StandardCharsets.UTF_8);
					try {
						JsonNode root = objectMapper.readTree(responseBody);
						JsonNode errors = root.get("errors");
						if (errors != null && errors.isArray()) {
							boolean hasInternal = false;
							boolean hasInvalid = false;
							for (JsonNode e : errors) {
								JsonNode msg = e.get("message");
								if (msg != null) {
									String text = msg.asText();
									if (text.contains("Internal Server Error")) {
										hasInternal = true;
										break; // 500 wins
									}
									if (text.contains("Invalid ID format") || text.contains("Invalid ID")) {
										hasInvalid = true;
									}
								}
							}
							if (hasInternal) {
//								wrapped.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
							} else if (hasInvalid) {
//								wrapped.setStatus(HttpServletResponse.SC_BAD_REQUEST);
							}
						}
					} catch (Exception ex) {
						// ignore parse errors
					}
				}
				wrapped.copyBodyToResponse();
			}
		} else {
			chain.doFilter(request, response);
		}
	}
}