	$(document).ready(function(){				

		$("#follow-button").click(function(){
			if ($("#follow-button").text() == "+ Follow"){
				// *** State Change: To Following ***      
					$("#follow-button").text("Following");
			}else{
				// *** State Change: Unfollow ***     
				// Change the button back to it's original state
					$("#follow-button").text("+ Follow");
			}
		}); 
	});
