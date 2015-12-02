function showModal () {
	$(".more-info").click( function (event) {
		event.preventDefault();
		if (gon.current_user) {
			$("#myModal").focus();
			$(".modal-header").children("h4").text($(this).parent().parent().children("a").children("h3").text())
			$(".modal-images").empty();
			$(".table").empty();
			$(".modal-body .tips").empty();
			$(".opening-times h4").empty();
			$(".tips-header h4").text("Tips").empty();
			$.ajax({
				url: "/show",
				data: {venue_id: $(this).parent().parent().children(".venue-id").text()},
				success: displayContents,
				error: showError
			});
		} else {
			alert("You must be logged in to access this feature.")
			$('#myModal').modal('toggle');
		}
	});
}

function displayContents (data) {
	if (data.images.length > 0) {
		data.images.forEach(function (image_url) {
			$(".modal-images").append("<li><img src='" + image_url + "' class='modal-image'></li>")
		})	
	} 
	
	if (data.timings.length > 0) {
		$(".opening-times h4").text("Opening Hours")
		data.timings.forEach(function (time) {
			time.forEach(function (week) {
				$(".time-table").append(
					"<tr class='success'><th>" + week.days + ": </th><td>" +
					week.open[0].renderedTime + "</td></tr>"
				);
			})
		});
	}

	if (data.tips.length > 0) {
		$(".tips-header h4").text("Visitor Comments")
		data.tips.forEach(function (tip) {
		$(".modal-body .tips").append("<span class='user-tip'><p>" + tip + "</p><span>")
		})
	}
}

function showError(jqXHR, status, errorThrown) {
	alert("Something wrong happened: " + status + ", " + errorThrown);
};