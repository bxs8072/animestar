class VideoApi {
  static String url(String iframelink) {
    return ("""
<!DOCTYPE html>
  <html>
      <head>
        <style>
           html { overflow: auto;}
           html, body, iframe {
                        margin: 0px;
                        padding: 0px;
                        height: 100%;
                        border: none; 
                      }
           iframe {
               display: block;
               width: 100%;
               border: none;
               overflow-y: auto;
               overflow-x: hidden;
              }
           body { background-color: black;}
        </style>
      </head>
    <body>
      <iframe sandbox="allow-same-origin allow-scripts" 
            src="$iframelink" 
            frameborder="0" 
            allowfullscreen="true" 
            frameborder="0" 
            marginwidth="0" 
            marginheight="0" 
            scrolling="no">
      </iframe>
    </body>
  </html>
""");
  }
}
