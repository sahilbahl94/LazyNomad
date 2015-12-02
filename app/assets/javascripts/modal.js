function showModal () {
	$(".more-info").click( function (event) {
		event.preventDefault();
		if (gon.current_user) {
			$("#myModal").focus();
			$(".modal-header").children("h4").text($(this).parent().parent().children("a").children("h3").text())
			$(".modal-images").empty();
			$(".days").empty();
			$(".modal-body .tips").empty();
			$.ajax({
				url: "/show",
				data: {venue_id: $(this).parent().parent().children(".venue-id").text()},
				success: displayContents,
				error: showError
			});
		} else {
			alert("You must be logged in to access this feature.")
		}
	});
}

function displayContents (data) {
	data.images.forEach(function (image_url) {
		$(".modal-images").append("<li><img src='" + image_url + "' class='modal-image'></li>")
	})

	data.timings.forEach(function (time) {
		time.forEach(function (week) {
			$(".days").append("<li>" + week.days + "</li>");
			$(".days").append("<ul class='hours'><li>" + week.open[0].renderedTime + "</li></ul>");
		})
	});

	data.tips.forEach(function (tip) {
		$(".modal-body .tips").append("<p>" + tip + "</p>")
	})
}

function showError(jqXHR, status, errorThrown) {
	alert("Something wrong happened: " + status + ", " + errorThrown);
};