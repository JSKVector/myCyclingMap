<%@ Page Language="C#" AutoEventWireup="true" CodeFile="MyJourney.aspx.cs" Inherits="MyJourney" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <base target="_self"/>
    
    <link rel="stylesheet" href="css/style.css" />


    <!-- Favicons
     ================================================== -->
    <link rel="shortcut icon" href="images/favicon.ico" />
    <link rel="apple-touch-icon" href="images/apple-touch-icon.png" />
    <link rel="apple-touch-icon" sizes="72x72" href="images/apple-touch-icon-72x72.png" />
    <link rel="apple-touch-icon" sizes="114x114" href="images/apple-touch-icon-114x114.png" />
    <!-- JS
    ================================================== -->
    <script src="http://code.jquery.com/jquery-1.7.2.min.js"></script>
    <script src="js/superfish.js"></script>
    <script src="js/jquery.flexslider.js"></script>
    <script src="js/jquery.tweet.js"></script>
    <script src="js/selectnav.js"></script>
    <script src="js/jquery.fancybox.js"></script>
    <script src="js/functions.js"></script>
    <script type="text/javascript" src="jquery.js"></script> 
    <script type="text/javascript" src="js/ContextMenu.js"></script>
    <script src="http://maps.googleapis.com/maps/api/js"></script>
    <script>
        $(document).ready(function () {
            $(".slider .flexslider").flexslider({
                animation: "slide"
            });
        });
    </script>
   <script>
  $("button").click(function(){
    $("#"+$(this).data('ts')).prop("checked", true);
  }); 
 </script>

   <script type="text/javascript">
       $(document).ready(getLocation);
      
       var currentLat;
       var currentLong;
       var destination;
       var usermarkers = [];
       var ChosenLocation;
       function getLocation() {
           if (navigator.geolocation) {
               navigator.geolocation.getCurrentPosition(showPosition);
           } else {
               alert("Geolocation is not supported by this browser.");
           }
       }
       function showPosition(position) {
           currentLat = position.coords.latitude;
           currentLong = position.coords.longitude;
           init();
       }

       function init() {

           addMarker();
           /*
           var latlng = new google.maps.LatLng(-37.8149819, 144.9644588);
           var myOptions = {
               zoom: 12,
               center: latlng,
               mapTypeId: google.maps.MapTypeId.ROADMAP
           };
           map = new google.maps.Map(document.getElementById("div_showMap"), myOptions);  */
           ////////////////////////////////////////////////////////////////////////
           var latlng = new google.maps.LatLng(-37.8149819, 144.9644588);
           var myOptions = {
               zoom: 14,
               center: latlng,
               mapTypeId: google.maps.MapTypeId.ROADMAP
           };


           var map = new google.maps.Map(document.getElementById('div_showMap'), myOptions);
           google.maps.event.addListener(map, 'click', function (mouseEvent) {
                   var usermarker = new google.maps.Marker({
                   position: mouseEvent.latLng,
                   map: map,
                   animation: google.maps.Animation.G,
                   icon: 'images/MarkerA.png'
                   });
                   destination = mouseEvent.latLng;
                   usermarkers.push(usermarker);
                   DeleteMarker();
           });
           ///////////////////////////////////////////////////////////////////////////
           var myLatlng = new google.maps.LatLng(currentLat, currentLong);
           var marker = new google.maps.Marker({
               position: myLatlng,
               map: map,
               animation: google.maps.Animation.G
           });
       }
       // Removes the markers from the map, but keeps them in the array.
       function DeleteMarker() {

           //Find and remove the marker from the Array

           for (var i = 0; i < usermarkers.length-1; i++) {
                   //Remove the marker from Map                   
                   usermarkers[i].setMap(null);
                   //Remove the marker from array.
                   usermarkers.splice(i, 1);
                   return;
               }
           
       };
       function addMarker() {
           $.ajax(
           {
               type: "GET",
               url: "JsonText.txt",
               dataType: "json",
               success: function (data) {

                   var first = true;
                   var map;
                   var contentString = null; 
                   var infowindows = [];
                   for (var index in data) {

                       if (first == true) {
                           /*center*/
                           var latlng = new google.maps.LatLng(-37.8149819, 144.9644588);
                           var myOptions = {
                               zoom: 15,
                               center: latlng,
                               mapTypeId: google.maps.MapTypeId.ROADMAP 
                         
                           };
                           /*create map*/
                           map = new google.maps.Map(document.getElementById("div_showMap"), myOptions);
                           var myLatlng = new google.maps.LatLng(currentLat, currentLong);
                           var marker = new google.maps.Marker({
                               position: myLatlng,
                               map: map,
                               animation: google.maps.Animation.G
                           });
                           var obj = document.getElementById("DropDownList1");
                           var text = obj.options[obj.selectedIndex].text;
                           first = false;
                       } //End if (first == true) 
                       //create latlng
                       var myLatlng = new google.maps.LatLng(data[index].Latitude, data[index].Longitude);
                       
                       if (text == "Drink Fountains")
                       {
                           contentString = '<div id="content">' + data[index].Description + '<br/>' +'</div>';
                           //add maker
                           var marker = new google.maps.Marker({
                               position: myLatlng,
                               map: map,
                               icon: new google.maps.MarkerImage( "images/fountain-2.JPG" , undefined, undefined, undefined, new google.maps.Size(20, 20)),
                               animation: google.maps.Animation.G,
                               title:'Drink Fountains'
                           });
                           showinfomessage(marker, index);
                       } else if (text == "Food & Drinks venue")
                       {
                           contentString = '<div id="content">' + '<p><b>Category:</b>' + data[index].Category + '<br/>' + '<b>What:</b>' + data[index].What + '<br/>' + '<b>Who:</b>' + data[index].Who + '<br/>' + '<b>Phone:</b>' + data[index].Phone + '<br/>' + '<b>Website:</b>' + data[index].Website + '<br/></p>' + '</div>';

                           var marker = new google.maps.Marker({
                               position: myLatlng,
                               map: map,
                               icon: new google.maps.MarkerImage('images/restaurant.png', undefined, undefined, undefined, new google.maps.Size(20, 20)),
                               animation: google.maps.Animation.G
                           });
                           showinfomessage(marker, index);

                       } else if (text == "Parking Pod")
                       {
                               contentString = '<div id="content">' + 'Featurename:' + data[index].Featurename + '<br/>' + 'Number of bicycle:' + data[index].NBBikes + '<br/>' + '</div>';
                               var marker = new google.maps.Marker({
                               position: myLatlng,
                               map: map,
                               icon: new google.maps.MarkerImage('images/bicycle-24.png', undefined, undefined, undefined, new google.maps.Size(20, 20)),
                               animation: google.maps.Animation.G,

                           });
                           showinfomessage(marker, index);
                       } else if (text == "Public Toilets") {
                           contentString = '<div id="content">' + 'Male:' + data[index].Male + '<br/>' + 'Female:' + data[index].Female + '<br/>' + 'Disabled:' + data[index].Disabled + '<br/>' + 'Unisex:' + data[index].Unisex + '<br/>' + 'Babychange:' + data[index].Babychange + '<br/>' + '</div>';
                           var marker = new google.maps.Marker({
                               position: myLatlng,
                               map: map,
                               icon: new google.maps.MarkerImage('images/toilets.JPG', undefined, undefined, undefined, new google.maps.Size(20, 20)),
                               animation: google.maps.Animation.G,
                               title: 'Public Toilerts'
                           });
                           showinfomessage(marker, index);
                       } else if (text == "Blackspot Area") {
                           var marker = new google.maps.Marker({
                               position: myLatlng,
                               map: map,
                               icon: new google.maps.MarkerImage('images/Blackpot.png', undefined, undefined, undefined, new google.maps.Size(20, 20)),
                               animation: google.maps.Animation.G
                           });
                           showinfomessage(marker, index);

                       }
                       else if (text == "Public Art Works") {
                           contentString = '<div id="content">' + 'Asset Type:' + data[index]["Asset Type"] + '<br/>' + 'Artist:' + data[index].Artist + '<br/>' + 'Respective Author:' + data[index]["Respective Author"] + '<br/>' + 'Structure:' + data[index].Structure + '<br/>' +'</div>';
                           var marker = new google.maps.Marker({
                               position: myLatlng,
                               map: map,
                               icon: new google.maps.MarkerImage('images/Art1.png', undefined, undefined, undefined, new google.maps.Size(20, 20)),
                               animation: google.maps.Animation.G
                           });
                           showinfomessage(marker, index);

                       }
                       else if (text == "LandMarks & Places Of Interest") {
                           contentString = '<div id="content">' + 'Theme:' + data[index].Theme + '<br/>' + 'Sub Theme:' + data[index]["Sub Theme"] + '<br/>' + 'Feature Name:' + data[index]["Feature Name"] + '<br/>' + '</div>';
                           var marker = new google.maps.Marker({
                               position: myLatlng,
                               map: map,
                               icon: new google.maps.MarkerImage('images/landmark.png', undefined, undefined, undefined, new google.maps.Size(20, 20)),
                               animation: google.maps.Animation.G
                           });
                           showinfomessage(marker, index);

                       }
                       else if (text == "Visitor Shuttle Bus Stops") {
                           contentString = '<div id="content">' + 'Name:' + data[index].Name + '<br/>' + 'Address:' + data[index].Address + '<br/>' + '</div>';
                           var marker = new google.maps.Marker({
                               position: myLatlng,
                               map: map,
                               icon: new google.maps.MarkerImage('images/busstop.png', undefined, undefined, undefined, new google.maps.Size(20, 20)),
                               animation: google.maps.Animation.G
                           });
                           showinfomessage(marker, index);
                       }

                   } //End for (var index in data)    

                   function showinfomessage(marker, number) {
                      

                      var infowindow = new google.maps.InfoWindow(
                         {
                             content: contentString,
                            
                         });
                       infowindows.push(infowindow);
                       marker.addListener('click', function () {
                           closeInfoWindows();
                           infowindow.open(map, marker);
                      
                       });

                   }
                   function closeInfoWindows() {
                       for (var i = 0; i < infowindows.length; i++) {
                           infowindows[i].close();
                       }
                   }

                   

                   //add new point
                       google.maps.event.addListener(map, 'click', function (mouseEvent) {
                       var usermarker = new google.maps.Marker({
                           position: mouseEvent.latLng,
                           map: map,
                           animation: google.maps.Animation.G,
                           icon: 'images/MarkerA.png'
                       });
                       destination = mouseEvent.latLng;
                       usermarkers.push(usermarker);
                       DeleteMarker();

                   });
               }     //End success: function (data) 

           });       //End jQuery Ajax
       }             //End function addMarker() 


       function JouneryPlan() {
         
           if (usermarkers.length == 0) {
                    alert("Please select your destiantion in the map, just click it");
                }
                 else
                {
                    var origin = "(" + currentLat + "," + currentLong + ")";
                    document.getElementById('frm_Jou').src = "https://www.google.com/maps/embed/v1/directions?key=AIzaSyAPpKsySHzCcM88cbpyxHRGpqeoCJZ77N8&origin=" + origin + "&destination=" + destination + "&avoid=tolls|highways&mode=bicycling";
                    document.getElementById('div_showMap').style.display = 'none';
                    document.getElementById('div_MapNavigation').style.display = 'block';
                }
       }
       function BacktoMap() {
           document.getElementById('div_showMap').style.display = 'block';
           document.getElementById('div_MapNavigation').style.display = 'none';
       }
    </script>


    <title></title>
</head>
<body >
    <form id="form1" runat="server">
     <div id="wrapper">

            <div class="main">
                <div class="container">

                    <!-- Header - weather
                ================================================== -->
                    <div class="sixteen columns header">
                        <div class="phone"></div>
                        <div class="social">
                        </div>
                    </div>
                    <div class="clear"></div>

                    <!-- Header - Logo & Navigation
                ================================================== -->
                   <div class="sixteen columns top">
                    <div class="logo four columns alpha"><a href="http://cyclingplusplus.azurewebsites.net/"><img src="images/logo.png" alt="" /></a></div>
                    <div class="navigation twelve columns alpha omega">
                        <ul id="nav" class="sf-menu sf-shadow">
                            <li><a data-description="Welcome Page" href="index.aspx">Home</a></li>
                            <li class="active"><a data-description="Get Directions" href="MyJourney.aspx">My Journey</a></li>
                            <li><a data-description="Know more about Melbourne" >About Melbourne</a>
                                  <ul>
									    <li><a href="Art.aspx">Art,Theatre&Culture</a></li>
                                        <li><a href="Food.aspx">Food and Wine</a></li>
									    <li><a href="Shopping.aspx">Shopping</a></li>
									    <li><a href="Nature.aspx">Nature and Wildlife</a></li>
                                        <li><a href="History.aspx">History and Heritage</a></li>  
								 </ul>
                            </li>
                            <li><a data-description="Contact Us" href="contact.aspx">About US</a></li>
               
                        </ul>
                    </div>
                    <div class="clear"></div>
                    <div id="separator"><span></span></div>

                </div>
                <div class="clear"></div>

                    <!-- Slider
                ================================================== -->
                    <div class="contact sixteen columns row">
                        <h2 class="separator_title"><span>Select Category</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span>Journey Planning</span></h2>
                        &nbsp;<div class="btn_nav">              
                            <asp:DropDownList ID="DropDownList1" Name="DropDownList1" CssClass="select"  width="35%" runat="server" AutoPostBack="True"  OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged" onclick="BacktoMap()" Height="48px"> 
                                <asp:ListItem Value="MyJourney">My Journey</asp:ListItem>  
                                <asp:ListItem Value="Drink Fountain">Drink Fountains</asp:ListItem>  
                                <asp:ListItem Value="Nournishment Hub">Food & Drinks venue</asp:ListItem>
                                <asp:ListItem Value="Parking Pod">Parking Pod</asp:ListItem>
                                <asp:ListItem Value="Public Commode">Public Toilets</asp:ListItem>
                                <asp:ListItem Value="Blackspot">Blackspot Area</asp:ListItem> 
                                <asp:ListItem Value="Art">Public Art Works</asp:ListItem>  
                                <asp:ListItem Value="LandMarks">LandMarks & Places Of Interest</asp:ListItem>
                                <asp:ListItem Value="Stops">Visitor Shuttle Bus Stops</asp:ListItem>            
                            </asp:DropDownList>
                        </div>
                        <input type="button" id="btn_planJounery" value="Get Directions" onclick="JouneryPlan()" style="position: relative; background: #F0F0F0; padding: 5px; text-decoration: none; cursor: pointer; width:27%; height:47px; top: -1px; left: 326px; font-size:18px; color:#86AE3F" />  
		               </div>    
                            <div id="div_showMap" runat="server" style="width:100%;height:500px"></div> <br/>
                            <div id="div_MapNavigation" runat="server" style="display:none">
						        <iframe id="frm_Jou" width="100%" src="https://www.google.com/maps/embed/v1/directions?key=AIzaSyAPpKsySHzCcM88cbpyxHRGpqeoCJZ77N8&origin=(-37.8149819, 144.9644588)&destination=(-37.9240333,145.1326841)&avoid=tolls|highways&mode=bicycling" height="500px" frameborder="0" style="border:0" ></iframe>
                            </div>
                    </div>
                <!-- END main -->
            </div>   
        </div>


         <div id="footer">
		<div id="f_line"></div>
		<div class="container">
			<div class="footer sixteen columns">
				<div class="three columns alpha">
					<h3>NAVIGATE</h3>
					<ul>
						<li><a href="#">Home</a></li>
						<li><a href="#">MyJourney</a></li>
						<li><a href="#">About Melbourne</a></li>
						<li><a href="#">Contacts</a></li>
					</ul>
				</div>
				<div class="three columns">
					<h3>About Melbourne</h3>
					<ul>
						<li><a href="#">Art,Theatre&Culture</a></li>
						<li><a href="#">Food and Wine</a></li>
						<li><a href="#">Shopping</a></li>
						<li><a href="#">Nature and Wildlife</a></li>
						<li><a href="#">History and Heritage</a></li>
					</ul>
				</div>
                 <div class="three columns">
					<h3>Helpful Link</h3>
					<ul>
						<li><a href="http://www.melbournebikeshare.com.au/">Melbourne Bike Share</a></li>
						<li><a href="http://www.melbournebikeshare.com.au/">Visit Melbourne</a></li>
						<li><a href="http://www.melbournebikeshare.com.au/">City of Melbourne</a></li>
					</ul>
				</div>

			</div>
		</div>		
	</div>
<div id="footer_bottom">
		<div class="container">
			<div class="sixteen columns">
				<div class="copyright ten columns alpha">Copyright &copy; 2015 JSK Vector. All Rights Reserved</div>
				
			</div>
		</div>
	</div>

     
    </form>
</body>
</html>
