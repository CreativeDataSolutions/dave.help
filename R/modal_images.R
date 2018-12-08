#modal image

#htm, css and js

#html use class: image_modal

#css:
#' @title modal_img_css
#' @export
modal_img_css<-function(){'
   /* Style the Image Used to Trigger the Modal */
  .myImg {
  border-radius: 5px;
  cursor: pointer;
  transition: 0.3s;
  }
  
  .myImg:hover {opacity: 0.7;}
  
  /* The Modal (background) */
  .modal {
  display: none; /* Hidden by default */
  position: fixed; /* Stay in place */
  z-index: 1; /* Sit on top */
  padding-top: 100px; /* Location of the box */
  left: 0;
  top: 0;
  width: 100%; /* Full width */
  height: 100%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
  background-color: rgb(0,0,0); /* Fallback color */
  background-color: rgba(0,0,0,0.9); /* Black w/ opacity */
  }
  
  /* Modal Content (Image) */
  .modal-content {
  margin: auto;
  display: block;
  width: 80%;
  max-width: 900px;
  }
  
  /* Caption of Modal Image (Image Text) - Same Width as the Image */
  #caption {
  margin: auto;
  display: block;
  width: 80%;
  max-width: 900px;
  text-align: center;
  color: #ccc;
  padding: 10px 0;
  height: 150px;
  }
  
  /* Add Animation - Zoom in the Modal */
  .modal-content, #caption {
  -webkit-animation-name: zoom;
  -webkit-animation-duration: 0.6s;
  animation-name: zoom;
  animation-duration: 0.6s;
  }
  
  @-webkit-keyframes zoom {
  from {-webkit-transform:scale(0)}
  to {-webkit-transform:scale(1)}
  }
  
  @keyframes zoom {
  from {transform:scale(0)}
  to {transform:scale(1)}
  }
  
  /* The Close Button */
  .close {
  position: absolute;
  top: 15px;
  right: 35px;
  color: #f1f1f1;
  font-size: 40px;
  font-weight: bold;
  transition: 0.3s;
  }
  
  .close:hover,
  .close:focus {
  color: #bbb;
  text-decoration: none;
  cursor: pointer;
  }
  
  /* 100% Image Width on Smaller Screens */
  @media only screen and (max-width: 700px){
  .modal-content {
  width: 100%;
  }
}'
}

#js
#' @title modal_img_js
#' @export
modal_img_js<-function(){'
  // Get the modal
  var modal = document.getElementById(\'myModal\');
  
  // Get the image and insert it inside the modal - use its "alt" text as a caption
  var img = $(\'.myImg\');
  var modalImg = $("#img01");
  var captionText = document.getElementById("caption");
  $(\'.myImg\').click(function(){
      modal.style.display = "block";
      var newSrc = this.src;
      modalImg.attr(\'src\', newSrc);
      captionText.innerHTML = this.alt;
  });
  
  // Get the <span> element that closes the modal
  var span = document.getElementsByClassName("close")[0];
  
  // When the user clicks on <span> (x), close the modal
  span.onclick = function() {
    modal.style.display = "none";
  }'
}

#modal html
#' @title base_modal_img
#' @export
modal_img_base_html<-function(){'
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
  <div id="myModal" class="modal">
  
    <!-- The Close Button -->
    <span class="close" onclick="document.getElementById(\'myModal\').style.display=\'none\'">&times;</span>
  
    <!-- Modal Content (The Image) -->
    <img class="modal-content" id="img01">
  
    <!-- Modal Caption (Image Text) -->
    <div id="caption"></div>
  </div>'
}

#combined
#TODO write distributed version 

modal_img<-function(img,caption=NULL,css=modal_img_css(),js=modal_img_js(),
                    base_html=modal_img_base_html()){
  #create html 
  #binding
  # .css:style
  # .js:script
  
  css<-make_tag(.css,tag="style")
  js<-make_tag(.js,tag="script")
  #image  an html_modal
  html<-paste0('<img class="myImg" src="',img,'" 
  alt="',caption,'">')
  html<-paste0(html,base_html)
  
  paste0(css,html,js,collapse = '<br>')
}

test<-function(){
  img<-'http://www.chinabuddhismencyclopedia.com/en/images/thumb/b/b8/Nature.jpg/240px-Nature.jpg'
  caption<-'foo bar bazz'
  
  modal_img(img,caption,modal_img_css(),modal_img_js(),modal_img_base_html()) %>%
    cat()
}

