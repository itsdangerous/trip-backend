<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65"
	crossorigin="anonymous">
<link rel="stylesheet" href="../assets/css/attraction.css">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4"
	crossorigin="anonymous"></script>
<title>Attraction Info</title>
</head>
<body>
	<!--====== SEARCH PART START ======-->
	<div class="search-area">
		<div class="container bg-primary bg-gradient">
			<div class="search-wrapper">
				<form action="#">
					<div class="row justify-content-center">
						<div class="col-lg-3 col-sm-5 col-10">
							<div class="search-input">
								<label for="category"><i
									class="lni lni-grid-alt theme-color"></i></label> <select
									name="category" id="category">
									<option value="none" selected disabled>����</option>
								</select>
							</div>
						</div>
						<div class="col-lg-4 col-sm-5 col-10">
							<div class="search-input">
								<label for="location"><i
									class="lni lni-map-marker theme-color"></i></label> <select
									name="location" id="location">
									<option value="0" selected disabled>��/��/��</option>
								</select>
							</div>
						</div>
						<div class="col-lg-3 col-sm-5 col-10">
							<div class="search-input">
								<label for="contents"><i
									class="lni lni-map-marker theme-color"></i></label> <select
									name="contents" id="contents">
									<option value="0" selected disabled>������ ����</option>
									<option value="12">������</option>
									<option value="14">��ȭ�ü�</option>
									<option value="15">�����������</option>
									<option value="25">�����ڽ�</option>
									<option value="28">������</option>
									<option value="32">����</option>
									<option value="38">����</option>
									<option value="39">������</option>
								</select>
							</div>
						</div>
						<div class="col-lg-6 col-sm-5 col-10">
							<div class="search-input">
								<label for="keyword"><i
									class="lni lni-search-alt theme-color"></i></label> <input type="text"
									name="keyword" id="keyword" placeholder="Ű���带 �Է��ϼ���." />
							</div>
						</div>
						<div class="col-lg-2 col-sm-5 col-10">
							<div class="search-btn">
								<button id='search-btn' class="main-btn btn-hover">
									Search <i class="lni lni-search-alt"></i>
								</button>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	<!--====== SEARCH PART END ======-->

	<!--====== MAP START ======-->
	<div id="map" class="mx-auto"></div>

	<!--====== MAP END ======-->


	<!--====== TABLE START ======-->
	<div class="row">
		<table class="table table-striped" style="display: none">
			<thead>
				<tr>
					<th>��ǥ�̹���</th>
					<th>��������</th>
					<th>������ �з�</th>
					<th>�ּ�</th>
					<th>��ȭ��ȣ</th>
					<th>��ȸ��</th>
				</tr>
			</thead>
			<tbody id="trip-list"></tbody>
		</table>
	</div>
	<!--====== TABLE END ======-->



	<!--====== JAVASCRIPT IMPORT START ======-->
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=493decc2eeb806790cc421e8e9a902e2"></script>
	<script type="text/javascript">
	
		// ================ Sido, Gugun Option START ================
		// index page �ε� �� ������ �õ� ����.
		let areaUrl = "../attraction?action=sido"
		
		fetch(areaUrl, { method: "GET" })
		    .then((response) => response.json())
		    .then((data) => makeOption(data, "category"));
		
		
		const areaSelect = document.querySelector("#category")
// 		console.log(areaSelect);

		// ������ ����
		areaSelect.addEventListener("change", setSmallArea)

		function setSmallArea() {
		    removeSmallArea();
		    const smallAreaOption = document.querySelector("#location");

		    const sidoCode = document.querySelector("#category").value;
		    let smallAreaUrl = "../attraction?action=gugun&sidoCode="+sidoCode;
		    
		    fetch(smallAreaUrl, { method: "GET" })
		        .then((response) => response.json())
		        .then((data) => makeOption(data, "location"));
		    
		}
		
		function makeOption(data, id) {
// 		    console.log(data);
		    let sel = document.getElementById(id);
		    data.forEach((data) => {
		        let opt = document.createElement("option");
// 		        console.log(data.sidoCode + " " + data.sidoName);
		        opt.setAttribute("value", data.code);
		        opt.appendChild(document.createTextNode(data.name));
				
		        sel.appendChild(opt);
		    });
		}

		function removeSmallArea() {
		    console.log("remove");
		    const smallAreaOptionList = document.querySelectorAll("#location option");
		    console.log("smallAreaOptionList");
		    for (let i = 1; i < smallAreaOptionList.length; i++) {
		        // console.log(smallAreaOptionList[i]);
		        smallAreaOptionList[i].remove();
		    }
		}
		
		// ================ Sido, Gugun Option END ================
			
		// ================ Search Button Start ================
		
		const searchBtn = document.querySelector("#search-btn");
		searchBtn.addEventListener("click", (event) => {
		    let sidoCode = document.getElementById("category").value;
		    if (sidoCode === "none") {
		    	alert("������ �������ּ���!");
		    	return;
		    }
		    
		    let gugunCode = document.getElementById("location").value;
		    let contentTypeId = document.getElementById("contents").value;
		    let keyword = document.getElementById("keyword").value;
// 		    console.log(areaCode, gugunCode, content, keyword);

		    let searchUrl = "../attraction?action=search";

		    searchUrl += "&sidoCode=" + sidoCode;
		    searchUrl += "&gugunCode=" + gugunCode;
		    searchUrl += "&contentTypeId=" + contentTypeId;
		    searchUrl += "&keyword=" + keyword;
		    event.preventDefault();

		    fetch(searchUrl)
		        .then((response) => response.json())
		        .then((data) => makeList(data));
		});
		
		const mapContainer = document.getElementById('map'), // ������ ǥ���� div 
	    mapOption = { 
	        center: new kakao.maps.LatLng(33.450701, 126.570667), // ������ �߽���ǥ
	        level: 3 // ������ Ȯ�� ����
	    };
		// ������ ǥ���� div��  ���� �ɼ�����  ������ �����մϴ�
		const map = new kakao.maps.Map(mapContainer, mapOption);


		let positions = [];
		function makeList(data) {
// 		    console.log(data);
		    document.querySelector("table").setAttribute("style", "display: ;");
		    let tripList = "";
		    positions = [];
		    data.forEach((attraction) => {
		    	
		    	tripList += "<tr onclick=\"moveCenter(" + attraction.latitude + ", " + attraction.longitude + ");\">"
		    		+ "<td><img src=\"" + attraction.firstImage + "\" width=\"100px\"></td>"
		    		+ "<td>" + attraction.title + "</td>"
		    		+ "<td>" + attraction.contentTypeId + "</td>"
		    		+ "<td>" + attraction.addr + "</td>"
		    		+ "<td>" + attraction.tel + "</td>"
		    		+ "<td>" + attraction.readCount + "</td>"
		    		+ "</tr>";

		        let markerInfo = {
		        title: attraction.title,
		        latlng: new kakao.maps.LatLng(attraction.latitude, attraction.longitude),
		        };
		        positions.push(markerInfo);
		    });
		    document.getElementById("trip-list").innerHTML = tripList;
		    displayMarker();
		}
		
		function displayMarker() {
		    // ��Ŀ �̹����� �̹��� �ּ��Դϴ�
		    let imageSrc = "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png";

		    for (var i = 0; i < positions.length; i++) {
		        // ��Ŀ �̹����� �̹��� ũ�� �Դϴ�
		        var imageSize = new kakao.maps.Size(24, 35);

		        // ��Ŀ �̹����� �����մϴ�
		        var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);

		        // ��Ŀ�� �����մϴ�
		        var marker = new kakao.maps.Marker({
		        map: map, // ��Ŀ�� ǥ���� ����
		        position: positions[i].latlng, // ��Ŀ�� ǥ���� ��ġ
		        title: positions[i].title, // ��Ŀ�� Ÿ��Ʋ, ��Ŀ�� ���콺�� �ø��� Ÿ��Ʋ�� ǥ�õ˴ϴ�
		        image: markerImage, // ��Ŀ �̹���
		        });
		    }

		    // ù��° �˻� ������ �̿��Ͽ� ���� �߽��� �̵� ��ŵ�ϴ�
		    map.setCenter(positions[0].latlng);
		}

		
		function moveCenter(lat, lng) {
		    map.setCenter(new kakao.maps.LatLng(lat, lng));
		}

		
		</script>
	<!--====== JAVASCRIPT IMPORT START ======-->
</body>
</html>