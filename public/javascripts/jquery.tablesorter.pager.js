(function($) {
	$.extend({
		tablesorterPager: new function() {
			
			function updatePageDisplay(c) {
				var s = $(c.cssPageDisplay,c.container).val((c.page+1) + c.seperator + c.totalPages);
			}
			
			
			
			function setLinks(table, c){							//C.laborier
				a = "";
				//Suppression des liens existants
				$(c.cssLinksPlace, c.container).empty();
				for(var i = 0 ; i < c.totalPages ; i++){
					var aCss = "";
					if(c.page == i)
						aCss = "current";
					a += "<a id='"+i+"' class='"+aCss+"'>"+(i+1)+"</a>"
				}
				
				//Ajout des liens
				$(c.cssLinksPlace, c.container).append(a);
				
				//Evenement click sur un lien
				$("a", c.cssLinksPlace, c.container).bind("click", function(e){
					e.preventDefault();
					c.page = $(this).attr("id");
					moveToPage(table);
				});
				
				
				//Calcul du margin left du pager
				$(c.container).each(function(){
				
					//initialisation des éléments
					$(this).css("padding-left", "0px");
					$(c.cssLinksPlace).css("width", "auto");
					
					//Si la taille du pager est trop grande
					if($(this).width() >= $("#liste_affaires").width()){
						
						//On ajuste la taille du contenuer de liens de manière à ce que les boutons suivant et précédent tienne sur les bords
						$(c.cssLinksPlace).width(826);
						
						//on réajuste le padding left
						padding_left = ($("#liste_affaires").width() - $(this).width()) / 2;
						$(this).css("padding-left", padding_left+"px");
					}
					else{
						padding_left = ($("#liste_affaires").width() - $(this).width()) / 2;
						$(this).css("padding-left", padding_left+"px");
					}
				});
				
				
			}																//C.laborier
			
			
			function setPageSize(table,size) {
				var c = table.config;
				c.size = size;
				c.totalPages = Math.ceil(c.totalRows / c.size);
				c.pagerPositionSet = false;
				moveToPage(table);
				//fixPosition(table);
			}
			
			function fixPosition(table) {
				var c = table.config;
				if(!c.pagerPositionSet && c.positionFixed) {
					var c = table.config, o = $(table);
					if(o.offset) {
						c.container.css({
							top: o.offset().top + o.height() + 'px',
							position: 'absolute'
						});
					}
					c.pagerPositionSet = true;
				}
			}
			
			function moveToFirstPage(table) {
				var c = table.config;
				c.page = 0;
				moveToPage(table);
			}
			
			function moveToLastPage(table) {
				var c = table.config;
				c.page = (c.totalPages-1);
				moveToPage(table);
			}
			
			function moveToNextPage(table) {
				var c = table.config;
				c.page++;
				if(c.page >= (c.totalPages-1)) {
					c.page = (c.totalPages-1);
				}
				moveToPage(table);
			}
			
			function moveToPrevPage(table) {
				var c = table.config;
				c.page--;
				if(c.page <= 0) {
					c.page = 0;
				}
				moveToPage(table);
			}
						
			
			function moveToPage(table) {
				var c = table.config;
				if(c.page < 0 || c.page > (c.totalPages-1)) {
					c.page = 0;
				}
				renderTable(table,c.rowsCopy);
			}
			
			function renderTable(table,rows) {
				
				var c = table.config;
				var l = rows.length;
				var s = (c.page * c.size);
				var e = (s + c.size);
				if(e > rows.length ) {
					e = rows.length;
				}
				
				
				var tableBody = $(table.tBodies[0]);
				
				// clear the table body
				
				$.tablesorter.clearTableBody(table);
				for(var i = s; i < e; i++) {

					// tableBody.append(rows[i]);
					
					var o = rows[i];
					var l = o.length;
					for(var j=0; j < l; j++) {
						tableBody[0].appendChild(o[j]);

					}
				}
				
        
				//fixPosition(table,tableBody);
				
				$(table).trigger("applyWidgets");
				
				if( c.page >= c.totalPages ) {
        			moveToLastPage(table);
				}
				
				updatePageDisplay(c);
				
				setLinks(table, c);						//C.laborier
        c.initTabFct();               //C.laborier
        
			}
			
			this.appender = function(table,rows) {
				
				var c = table.config;
				
				c.rowsCopy = rows;
				c.totalRows = rows.length;
				c.totalPages = Math.ceil(c.totalRows / c.size);
				
				renderTable(table,rows);

			};
			
			this.defaults = {
				size: 10,
				offset: 0,
				page: 0,
				totalRows: 0,
				totalPages: 0,
				container: null,
				cssNext: '.next',
				cssPrev: '.prev',
				cssFirst: '.first',
				cssLast: '.last',
				cssPageDisplay: '.pagedisplay',
				cssPageSize: '.pagesize',
				cssLinksPlace: '.lst_lien_pager', //C.laborier
				seperator: "/",
				positionFixed: true,
				appender: this.appender, 
				initTabFct: ''                    //C.laborier : paramètre utiliser pour le passage d'une fonction au constructeur qui initialisera le contenu du tableau après chaque action sur un élément (pagination, tri etc... )
			};
			
			this.construct = function(settings) {
				
				return this.each(function() {	
					
					config = $.extend(this.config, $.tablesorterPager.defaults, settings);
					
					var table = this, pager = config.container;
					
					config.size = parseInt($(".pagesize").val());
					
					$(this).trigger("appendCache");
					
					
					
					$(config.cssFirst,pager).click(function() {
						moveToFirstPage(table);
						return false;
					});
					$(config.cssNext,pager).click(function() {
						moveToNextPage(table);
						return false;
					});
					$(config.cssPrev,pager).click(function() {
						moveToPrevPage(table);
						return false;
					});
					$(config.cssLast,pager).click(function() {
						moveToLastPage(table);
						return false;
					});
					$(config.cssPageSize).change(function() {
						setPageSize(table,parseInt($(this).val()));
						return false;
					});
				});
			};
		}
	});
	// extend plugin scope
	$.fn.extend({
        tablesorterPager: $.tablesorterPager.construct
	});
	
})(jQuery);	