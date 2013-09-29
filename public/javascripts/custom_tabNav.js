//top navigation bar
//  based on www.cssnewbie.com/using-javascript-to-style-active-navigation-elements/
	window.onload = setActive;

	function setActive() {
		// looks for an element with given id, then looks at each of the anchor tags inside it
		q = document.getElementById("topNav").getElementsByTagName("a");
		y = document.getElementsByName("line");
		for(idx=0; idx<q.length; idx++ ) {
			// compares the page's URL with the anchor tag’s href
			//if(document.location.href.indexOf(q[idx].href) >= 0) {
			if(document.location.href == q[idx].href ) {
				//q[idx].className="lineVisible";
				y[idx].className="lineVisible";
			}
			//sets everything else to class "notActivehe
			else {
				//q[idx].className="lineHidden";
				y[idx].className="lineHidden";
			}
		}
	}

