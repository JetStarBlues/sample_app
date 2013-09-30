//top navigation bar
//  based on www.cssnewbie.com/using-javascript-to-style-active-navigation-elements/
	window.onload = setActive;

	function setActive() {
		// looks for an element with given id, then looks at each of the anchor tags inside it
		q = document.getElementById("topNav").getElementsByTagName("a");
		y = document.getElementsByName("line");

		// loops through links
		for(idx=0; idx<q.length; idx++ ) {

			// checks if on root page, 
			// if so, sets 'Home' to 'lineVisible'
			if( (document.location.pathname == "/") && (q[idx].pathname == "/home") ) {
				y[idx].className="lineVisible";
			}

			// compares the page's URL with the anchor tag’s href
			  //if(document.location.href.indexOf(q[idx].href) >= 0) {
			else if(document.location.pathname == q[idx].pathname ) {
				y[idx].className="lineVisible";
			}

			// sets everything else to class 'lineHidden'
			else {
				y[idx].className="lineHidden";
			}
		}
	}

