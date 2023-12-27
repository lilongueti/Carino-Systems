/*
	Forty by HTML5 UP
	html5up.net | @ajlkn
	Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
*/

(function($) {

	var	$window = $(window),
		$body = $('body'),
		$wrapper = $('#wrapper'),
		$header = $('#header'),
		$banner = $('#banner');

	// Breakpoints.
		breakpoints({
			xlarge:    ['1281px',   '1680px'   ],
			large:     ['981px',    '1280px'   ],
			medium:    ['737px',    '980px'    ],
			small:     ['481px',    '736px'    ],
			xsmall:    ['361px',    '480px'    ],
			xxsmall:   [null,       '360px'    ]
		});

	/**
	 * Applies parallax scrolling to an element's background image.
	 * @return {jQuery} jQuery object.
	 */
	$.fn._parallax = (browser.name == 'ie' || browser.name == 'edge' || browser.mobile) ? function() { return $(this) } : function(intensity) {

		var	$window = $(window),
			$this = $(this);

		if (this.length == 0 || intensity === 0)
			return $this;

		if (this.length > 1) {

			for (var i=0; i < this.length; i++)
				$(this[i])._parallax(intensity);

			return $this;

		}

		if (!intensity)
			intensity = 0.25;

		$this.each(function() {

			var $t = $(this),
				on, off;

			on = function() {

				$t.css('background-position', 'center 100%, center 100%, center 0px');

				$window
					.on('scroll._parallax', function() {

						var pos = parseInt($window.scrollTop()) - parseInt($t.position().top);

						$t.css('background-position', 'center ' + (pos * (-1 * intensity)) + 'px');

					});

			};

			off = function() {

				$t
					.css('background-position', '');

				$window
					.off('scroll._parallax');

			};

			breakpoints.on('<=medium', off);
			breakpoints.on('>medium', on);

		});

		$window
			.off('load._parallax resize._parallax')
			.on('load._parallax resize._parallax', function() {
				$window.trigger('scroll');
			});

		return $(this);

	};

	// Play initial animations on page load.
		$window.on('load', function() {
			window.setTimeout(function() {
				$body.removeClass('is-preload');
			}, 100);
		});

	// Clear transitioning state on unload/hide.
		$window.on('unload pagehide', function() {
			window.setTimeout(function() {
				$('.is-transitioning').removeClass('is-transitioning');
			}, 250);
		});

	// Fix: Enable IE-only tweaks.
		if (browser.name == 'ie' || browser.name == 'edge')
			$body.addClass('is-ie');

	// Scrolly.
		$('.scrolly').scrolly({
			offset: function() {
				return $header.height() - 2;
			}
		});

	// Tiles.
		var $tiles = $('.tiles > article');

		$tiles.each(function() {

			var $this = $(this),
				$image = $this.find('.image'), $img = $image.find('img'),
				$link = $this.find('.link'),
				x;

			// Image.

				// Set image.
					$this.css('background-image', 'url(' + $img.attr('src') + ')');

				// Set position.
					if (x = $img.data('position'))
						$image.css('background-position', x);

				// Hide original.
					$image.hide();

			// Link.
				if ($link.length > 0) {

					$x = $link.clone()
						.text('')
						.addClass('primary')
						.appendTo($this);

					$link = $link.add($x);

					$link.on('click', function(event) {

						var href = $link.attr('href');

						// Prevent default.
							event.stopPropagation();
							event.preventDefault();

						// Target blank?
							if ($link.attr('target') == '_blank') {

								// Open in new tab.
									window.open(href);

							}

						// Otherwise ...
							else {

								// Start transitioning.
									$this.addClass('is-transitioning');
									$wrapper.addClass('is-transitioning');

								// Redirect.
									window.setTimeout(function() {
										location.href = href;
									}, 500);

							}

					});

				}

		});

	// Header.
		if ($banner.length > 0
		&&	$header.hasClass('alt')) {

			$window.on('resize', function() {
				$window.trigger('scroll');
			});

			$window.on('load', function() {

				$banner.scrollex({
					bottom:		$header.height() + 10,
					terminate:	function() { $header.removeClass('alt'); },
					enter:		function() { $header.addClass('alt'); },
					leave:		function() { $header.removeClass('alt'); $header.addClass('reveal'); }
				});

				window.setTimeout(function() {
					$window.triggerHandler('scroll');
				}, 100);

			});

		}

	// Banner.
		$banner.each(function() {

			var $this = $(this),
				$image = $this.find('.image'), $img = $image.find('img');

			// Parallax.
				$this._parallax(0.275);

			// Image.
				if ($image.length > 0) {

					// Set image.
						$this.css('background-image', 'url(' + $img.attr('src') + ')');

					// Hide original.
						$image.hide();

				}

		});

	// Menu.
		var $menu = $('#menu'),
			$menuInner;

		$menu.wrapInner('<div class="inner"></div>');
		$menuInner = $menu.children('.inner');
		$menu._locked = false;

		$menu._lock = function() {

			if ($menu._locked)
				return false;

			$menu._locked = true;

			window.setTimeout(function() {
				$menu._locked = false;
			}, 350);

			return true;

		};

		$menu._show = function() {

			if ($menu._lock())
				$body.addClass('is-menu-visible');

		};

		$menu._hide = function() {

			if ($menu._lock())
				$body.removeClass('is-menu-visible');

		};

		$menu._toggle = function() {

			if ($menu._lock())
				$body.toggleClass('is-menu-visible');

		};

		$menuInner
			.on('click', function(event) {
				event.stopPropagation();
			})
			.on('click', 'a', function(event) {

				var href = $(this).attr('href');

				event.preventDefault();
				event.stopPropagation();

				// Hide.
					$menu._hide();

				// Redirect.
					window.setTimeout(function() {
						window.location.href = href;
					}, 250);

			});

		$menu
			.appendTo($body)
			.on('click', function(event) {

				event.stopPropagation();
				event.preventDefault();

				$body.removeClass('is-menu-visible');

			})
			.append('<a class="close" href="#menu">Close</a>');

		$body
			.on('click', 'a[href="#menu"]', function(event) {

				event.stopPropagation();
				event.preventDefault();

				// Toggle.
					$menu._toggle();

			})
			.on('click', function(event) {

				// Hide.
					$menu._hide();

			})
			.on('keydown', function(event) {

				// Hide on escape.
					if (event.keyCode == 27)
						$menu._hide();

			});

			// Array of random phrases
			const phrases = [
				"「 In doubt, reboot 」",
				"「 Viruses are mostly explicitly accepted, but you didn't notice 」",
				"「 Never trust brands, only reviews 」",
				"「 Always copy your files, never cut them 」",
				"「 Update your system if you have some spare time, otherwise it will update when you don't 」",
				"「 You can't download RAM 」",
				"「 Most cloud services you use are on land, and even underwater 」",
				"「 Clean your keyboard throughly at least twice a year, don't ask why 」",
				"「 Antivirus are malware that hate competition 」",
				"「 All software is licensed, even if it's free 」",
				"「 The less social networks you have, the safer your are 」",
				"「 There's no way you can be %100 anonymous on the internet 」",
				"「 A real backup is made by three copies of your data, on two different types of storage media, with one copy stored offsite 」",
				"「 Data redundancy is not a backup 」",
				"「 Remembering your passwords is a fatal security flaw, use a password manager instead 」"
				/*"「  」",*/
			];
	
			// Function to pick and display a random phrase
			function displayRandomPhrase() {
				const randomIndex = Math.floor(Math.random() * phrases.length);
				const randomPhrase = phrases[randomIndex];
				document.getElementById("random-phrase").textContent = randomPhrase;
			}
			// Call the function to display a random phrase when the page loads
			window.onload = displayRandomPhrase;
			
			//Function for a searchbar in software page
			document.getElementById('searchInput').addEventListener('keyup', function() {
				var searchQuery = this.value.toLowerCase();
				var list = document.getElementById('responsive-table');
				var items = list.getElementsByClassName('table-row');
			
				for (var i = 0; i < items.length; i++) {
					var programName = items[i].getElementsByClassName('col-1')[0];
					if (programName) {
						var textValue = programName.textContent || programName.innerText;
						if (textValue.toLowerCase().indexOf(searchQuery) > -1) {
							items[i].style.display = "";
						} else {
							items[i].style.display = "none";
						}
					}       
				}
			});

			//Copies commands to clipboard
			document.addEventListener('DOMContentLoaded', (event) => {
				document.querySelectorAll('.fedora-button').forEach(element => {
					element.addEventListener('click', function() {
						const text = this.getAttribute('data-text');
						navigator.clipboard.writeText(text).then(() => {
							console.log('Text copied to clipboard');
							// You can add any notification here to show that the text was copied
						}).catch(err => {
							console.error('Error in copying text: ', err);
						});
					});
				});
			});

			document.addEventListener('DOMContentLoaded', (event) => {
				document.querySelectorAll('.windows-button').forEach(element => {
					element.addEventListener('click', function() {
						const text = this.getAttribute('data-text');
						navigator.clipboard.writeText(text).then(() => {
							console.log('Text copied to clipboard');
							// You can add any notification here to show that the text was copied
						}).catch(err => {
							console.error('Error in copying text: ', err);
						});
					});
				});
			});
			
			document.addEventListener('DOMContentLoaded', (event) => {
				document.querySelectorAll('.macos-button').forEach(element => {
					element.addEventListener('click', function() {
						const text = this.getAttribute('data-text');
						navigator.clipboard.writeText(text).then(() => {
							console.log('Text copied to clipboard');
							// You can add any notification here to show that the text was copied
						}).catch(err => {
							console.error('Error in copying text: ', err);
						});
					});
				});
			});

			const albums = [
				{ url: 'https://example.com/album2', image: 'images/lurking/mu_.webp' },
				{ url: 'https://www.youtube.com/watch?v	=bc0sJvtKrRM', image: 'images/lurking/mu_1.webp' },
				{ url: 'https://www.youtube.com/watch?v=YPrs3DqraWM', image: 'images/lurking/mu_2.webp' },
				{ url: 'https://www.youtube.com/watch?v=ZAn3JdtSrnY', image: 'images/lurking/mu_3.webp' },
				{ url: 'https://www.youtube.com/watch?v=ZXu6q-6JKjA', image: 'images/lurking/mu_4.webp' },
				{ url: 'https://www.youtube.com/watch?v=TMAK05tpoI4', image: 'images/lurking/mu_5.webp' },
				{ url: 'https://www.youtube.com/watch?v=Aki1Xn36eJ8', image: 'images/lurking/mu_6.webp' },
				{ url: 'https://www.youtube.com/watch?v=uYU1PXV9Cx8', image: 'images/lurking/mu_7.webp' },
				{ url: 'https://www.youtube.com/watch?v=CZFyqzTCt-I', image: 'images/lurking/mu_8.webp' },
				{ url: 'https://www.youtube.com/watch?v=4D6buHQYhUI', image: 'images/lurking/mu_9.webp' },
				{ url: 'https://www.youtube.com/watch?v=Z-qvTPxUlxg', image: 'images/lurking/mu_10.webp' },
				{ url: 'https://www.youtube.com/watch?v=PCp2iXA1uLE', image: 'images/lurking/mu_11.webp' },
				{ url: 'https://www.youtube.com/watch?v=-jviZGERpqg', image: 'images/lurking/mu_12.webp' },
				{ url: 'https://www.youtube.com/watch?v=rG9CtpWe8rM', image: 'images/lurking/mu_13.webp' },
				{ url: 'https://www.youtube.com/watch?v=e7kJRGPgvRQ', image: 'images/lurking/mu_13.webp' },
				{ url: 'https://www.youtube.com/watch?v=BGVUiMskx_U', image: 'images/lurking/mu_14.webp' },
				{ url: 'https://www.youtube.com/watch?v=y5X2m-tSjZE', image: 'images/lurking/mu_15.webp' },
				{ url: 'https://www.youtube.com/watch?v=2pGoOso53bc', image: 'images/lurking/mu_16.webp' },
				{ url: 'https://www.youtube.com/watch?v=Tt6_65LDZ60', image: 'images/lurking/mu_17.webp' },
				{ url: 'https://www.youtube.com/watch?v=ywAe7okdLBQ', image: 'images/lurking/mu_18.webp' },
				{ url: 'https://www.youtube.com/watch?v=XKRx6V7bqQI', image: 'images/lurking/mu_19.webp' },
				{ url: 'https://www.youtube.com/watch?v=vxoKuhPca-A', image: 'images/lurking/mu_20.webp' },
				{ url: 'https://www.youtube.com/watch?v=poKI_MY0Bkw', image: 'images/lurking/mu_21.webp' },
				{ url: 'https://www.youtube.com/watch?v=BXTcAXEUiaM', image: 'images/lurking/mu_22.webp' },
				{ url: 'https://www.youtube.com/watch?v=cJ1yFhjRnNc', image: 'images/lurking/mu_23.webp' },
				{ url: 'https://example.com/album2', image: 'images/lurking/mu_24.webp' },
				{ url: 'https://www.youtube.com/watch?v=0BqPowGQWW8', image: 'images/lurking/mu_25.webp' },
				{ url: 'https://example.com/album2', image: 'images/lurking/mu_26.webp' },
				{ url: 'https://www.youtube.com/watch?v=Uan2Dv0qBhA', image: 'images/lurking/mu_27.webp' },
				{ url: 'https://www.youtube.com/watch?v=T_lC2O1oIew', image: 'images/lurking/mu_28.webp' },
				{ url: 'https://www.youtube.com/watch?v=moR4uw-NWLY', image: 'images/lurking/mu_29.webp' },
				{ url: 'https://www.youtube.com/watch?v=oO0vP6K9XVg', image: 'images/lurking/mu_30.webp' },
				{ url: 'https://www.youtube.com/watch?v=ZWaOfSeh9C8', image: 'images/lurking/mu_31.webp' },
				{ url: 'https://www.youtube.com/watch?v=1Q3SOrb8AqM', image: 'images/lurking/mu_32.webp' },
				{ url: 'https://www.youtube.com/watch?v=RHpWTC_QrwA', image: 'images/lurking/mu_33.webp' },
				{ url: 'https://example.com/album2', image: 'images/lurking/mu_34.webp' },
				{ url: 'https://www.youtube.com/watch?v=RVVCB2gy6tI', image: 'images/lurking/mu_35.webp' },
				{ url: 'https://www.youtube.com/watch?v=zZuIMcmNZnU', image: 'images/lurking/mu_36.webp' },
				{ url: 'https://www.youtube.com/watch?v=Uan2Dv0qBhA', image: 'images/lurking/mu_37.webp' },
				{ url: 'https://example.com/album2', image: 'images/lurking/mu_38.webp' },
				{ url: 'https://www.youtube.com/watch?v=E3yqv2PGugs', image: 'images/lurking/mu_39.webp' },
				{ url: 'https://www.youtube.com/watch?v=ZCut2rFo1bk', image: 'images/lurking/mu_39.webp' },
				{ url: 'https://www.youtube.com/watch?v=-56x7std2pU', image: 'images/lurking/mu_39.webp' },
				{ url: 'https://www.youtube.com/watch?v=PriNj4gtwBs', image: 'images/lurking/mu_40.webp' },
				{ url: 'https://www.youtube.com/watch?v=hzFLHL-fzV8', image: 'images/lurking/mu_41.webp' },
				{ url: 'https://www.youtube.com/watch?v=xB2K-riHfSc', image: 'images/lurking/mu_42.webp' },
				{ url: 'https://www.youtube.com/watch?v=TiycWq1YOAA', image: 'images/lurking/mu_42.webp' },
				{ url: 'https://www.youtube.com/watch?v=Q0tO5MPGuGk', image: 'images/lurking/mu_42.webp' },
				{ url: 'https://www.youtube.com/watch?v=K4_Qzx-E2LQ', image: 'images/lurking/mu_43.webp' },
				{ url: 'https://www.youtube.com/watch?v=PKRUKalbx3s', image: 'images/lurking/mu_44.webp' },
				{ url: 'https://www.youtube.com/watch?v=Kq_plVrBPx4', image: 'images/lurking/mu_44.webp' },
				{ url: 'https://www.youtube.com/watch?v=VLW1ieY4Izw', image: 'images/lurking/mu_45.webp' },
				{ url: 'https://www.youtube.com/watch?v=PNGbvYSp08A', image: 'images/lurking/mu_46.webp' },
				{ url: 'https://www.youtube.com/watch?v=xMK7IHF69Sc', image: 'images/lurking/mu_47.webp' },
				{ url: 'https://www.youtube.com/watch?v=SRQGOtBVELo', image: 'images/lurking/mu_48.webp' },
				{ url: 'https://www.youtube.com/watch?v=y8VfziFZMGY', image: 'images/lurking/mu_49.webp' },
				{ url: 'https://www.youtube.com/watch?v=eDajkN_GBC4', image: 'images/lurking/mu_49.webp' },
				{ url: 'https://www.youtube.com/watch?v=8Kl_ZhPKCgc', image: 'images/lurking/mu_49.webp' },
				{ url: 'https://www.youtube.com/watch?v=ei7cdynwRMA', image: 'images/lurking/mu_50.webp' },
				{ url: 'https://www.youtube.com/watch?v=3P5F47GEsQA', image: 'images/lurking/mu_50.webp' },
				{ url: 'https://www.youtube.com/watch?v=gc12lP5FNG0', image: 'images/lurking/mu_51.webp' },
				{ url: 'https://www.youtube.com/watch?v=cayMq-CEjmQ', image: 'images/lurking/mu_52.webp' },
				{ url: 'https://www.youtube.com/watch?v=hkL4hW4eniI', image: 'images/lurking/mu_53.webp' },
				{ url: 'https://www.youtube.com/watch?v=3ukCLUdzbUs', image: 'images/lurking/mu_54.webp' },
				{ url: 'https://www.youtube.com/watch?v=20iCZeU35eQ', image: 'images/lurking/mu_55.webp' },
				{ url: 'https://www.youtube.com/watch?v=MiOGtssMuFw', image: 'images/lurking/mu_56.webp' },
				{ url: 'https://www.youtube.com/watch?v=0-EMiEpXLJg', image: 'images/lurking/mu_56.webp' },
				// add more albums here
			];
		
			const grid = document.getElementById('grid');
		
			function addCell(album) {
				const cell = document.createElement('a');
				cell.href = album.url;
				cell.target = '_blank';
				cell.className = 'cell';
				cell.style.backgroundImage = `url(${album.image})`;
				grid.appendChild(cell);
			}
		
			function populateGrid() {
				for (let i = 0; i < 50; i++) {
					addCell(albums[Math.floor(Math.random() * albums.length)]);
				}
			}
		
			function checkScroll() {
				if (grid.scrollTop + grid.clientHeight >= grid.scrollHeight) {
					populateGrid();
				}
			}
		
			populateGrid();
			grid.addEventListener('scroll', checkScroll);
})(jQuery);