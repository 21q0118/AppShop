package com.example.demo.jwt;

import java.io.IOException;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.auth0.jwt.interfaces.Claim;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@WebFilter(filterName = "JwtFilter", urlPatterns = "/secure/*")
public class JwtFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        final HttpServletRequest request = (HttpServletRequest) req;
        final HttpServletResponse response = (HttpServletResponse) res;

        response.setCharacterEncoding("UTF-8");
        // 获取 header里的token
        final String token = request.getHeader("Authorization");
        System.out.println(token);

        if ("OPTIONS".equals(request.getMethod())) {
            response.setStatus(HttpServletResponse.SC_OK);
            chain.doFilter(request, response);
        }
        // Except OPTIONS, other request should be checked by JWT
        else {

            if (token == null) {
                response.sendError(401, "没有token!");
                return;
            }

            Map<String, Claim> userData = JwtUtil.verifyToken(token);
            if (userData == null) {
                response.sendError(402, "token不合法!");
                return;
            }
            String userName = userData.get("phNum").asString();
            String password = userData.get("password").asString();
            // 拦截器 拿到用户信息，放到request中
            request.setAttribute("phNum", userName);
            request.setAttribute("password", password);
            System.out.println("?");
            chain.doFilter(req, res);
        }
    }

    @Override
    public void destroy() {
    }
}
