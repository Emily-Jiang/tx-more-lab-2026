package com.acme.modres;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.Serial;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/resorts/welcome")
public class WelcomeServlet extends HttpServlet {

  @Serial
  private static final long serialVersionUID = 1L;

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    response.setContentType("text/plain");

    PrintWriter out = response.getWriter();
    out.println(" Enjoy!");
  }
}
