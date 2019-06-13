package com.project.mmic;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/meeting_download_S")
public class meeting_download_S extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public meeting_download_S() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");

		String meeting_id = request.getParameter("meeting_id");
		String location = request.getParameter("location");
		String start = request.getParameter("start");
		String end = request.getParameter("end");
		String attend = request.getParameter("attend");
		String topic = request.getParameter("topic");
		String txt = request.getParameter("txt");
		if (attend.length()>0) {
			attend = attend.replace("· ","");
			attend = attend.replace("\r\n",", ");
			attend = attend.substring(0, attend.length()-2);
		}
		txt = txt.replace("\r\n\r\n","\r\n");
		
		String inputdata = "";
		inputdata = inputdata + "○ 회의 코드 : "+meeting_id+"\n";
		inputdata = inputdata + "○ 주제 : "+topic+"\n";
		inputdata = inputdata + "○ 장소 : "+location+"\n";
		inputdata = inputdata + "○ 시작 시각 : "+start+"\n";
		inputdata = inputdata + "○ 종료 시각 : "+end+"\n";
		inputdata = inputdata + "○ 회의 참석자 : "+attend+"\n";
		inputdata = inputdata + "------------- 회의록 -------------\n";
		inputdata = inputdata + txt;
		
		System.out.println(inputdata);

		
		// 다운받을 파일의 이름을 가져옴
		String fileName = "M-MIC 회의록_"+start+"_"+topic+".txt";
		System.out.println(fileName);
		
		try{
			System.out.println("try진입");
			byte b[] = new byte[4096];
			   
			// page의 ContentType등을 동적으로 바꾸기 위해 초기화시킴
			response.reset();
			response.setContentType("application/octet-stream");
			   
			// 한글 인코딩
			String Encoding = new String(fileName.getBytes("UTF-8"), "8859_1");
			// 파일 링크를 클릭했을 때 다운로드 저장 화면이 출력되게 처리하는 부분
			response.setHeader("Content-Disposition", "attachment; filename = " + Encoding);
			  
			// 파일의 세부 정보를 읽어오기 위해서 선언
			ByteArrayInputStream in = new ByteArrayInputStream(inputdata.getBytes());
			  
			// 파일에서 읽어온 세부 정보를 저장하는 파일에 써주기 위해서 선언
			ServletOutputStream out2 = response.getOutputStream();
			   
			int numRead;
			// 바이트 배열 b의 0번 부터 numRead번 까지 파일에 써줌 (출력)
			while((numRead = in.read(b, 0, b.length)) != -1){
				out2.write(b, 0, numRead);
				System.out.println("읽는중");
			}
		   
		    out2.flush();
		    out2.close();
		    in.close();
		   
		    //////////

		} catch(Exception e){
			  System.out.println("파일저장 실패 : "+e.getMessage());
			  e.printStackTrace();
		}
		  
	} //DoPost끝

}
