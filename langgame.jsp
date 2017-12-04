<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Language Games</title>
		<script src="jquery-2.1.1.min.js"></script>
		<script src="querystring.js"></script>
		<script>
			var vowels = ["a", "e", "i", "o", "u"];
			var consonants = ["b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z"];
			
			var shiftStr = " @ lidx @ 1";
			var encDir = "+";
			var decDir = "-";
			
			$(document).ready(function()
			{
				$("#texttrans").hide();
				$("#blinkendiv").hide();
				$("#emptydiv").hide();
				
				$("#plaintext").bind('input propertychange', function() {
					doGame("plaintext", "gametext", "enc");
				});
				
				$("#gametext").bind('input propertychange', function() {
					doGame("gametext", "plaintext", "dec");
				});
				
				$("#controlselect").change(function() {
					doPageUpdate();
				});
				
				if(typeof QueryString.def !== "undefined") {
					$("#controlselect").val(QueryString.def);
					doPageUpdate();
				}
			});
			
			function doPageUpdate() {
				$("#plaintext").val("");
				$("#gametext").val("");
				
				if($("#controlselect").val() != "default") {
					$("#texttrans").show();
					
					switch($("#controlselect").val()) {
						case "blinken":
							$(".bottom").hide();
							$("#blinkendiv").show();
							break;
						case "barcode":
							$(".bottom").hide();
							$("#emptydiv").show();
							break;
            case "imgcode":
            case "imgcodealpha":
              $(".bottom").hide();
              $("#imgcodediv").show();
              
              if($("#imgcodediv").height() <= $("#imgcodediv").width()) {
                $("#imgcodediv").width($("#imgcodediv").height());
              } else {
                $("#imgcodediv").height($("#imgcodediv").width());
              }
              
              doImgCode("");
              
              break;
						default:
							$(".bottom").hide();
							$("#gametext").show();
							break;
					}
				} else {
					$("#texttrans").hide();
				}
			}
			
			function doGame(plain, out, encDec) {
				$("#" + out).val("");
				
				switch($("#controlselect").val()) {
					case "piglatin":
						doPigLatin($("#plaintext").val());
						break;
					case "encryption":
						$("#" + out).val(doEncryption($("#" + plain).val(), encDec));
						break;
					case "tutnese":
						doTut($("#plaintext").val());
						break;
					case "blinken":
						doBlinken($("#plaintext").val());
						break;
					case "base64":
						doBase64($("#plaintext").val());
						break;
					case "inflate":
						doInflate($("#plaintext").val());
						break;
					case "deflate":
						doDeflate($("#plaintext").val());
						break;
					case "barcode":
						doBarCode($("#plaintext").val());
						break;
					case "uri":
						$("#" + out).val(doURI($("#" + plain).val(), encDec));
						break;
          case "abjad":
            $("#" + out).val(doAbjad($("#" + plain).val()));
            break;
          case "polybius":
            $("#" + out).val(doPolybius($("#" + plain).val()));
            break;
          case "polybiusenc":
            $("#" + out).val(doPolybiusEncode($("#" + plain).val()));
            break;
          case "imgcode":
            $("#" + out).val(doImgCode($("#" + plain).val(), true));
            break;
          case "imgcodealpha":
            $("#" + out).val(doImgCode($("#" + plain).val(), false));
				}
			}
			
			function doURI(toTrans, encDec) {
				if(encDec == "enc") {
					return encodeURIComponent(toTrans);
				} else {
					return decodeURIComponent(toTrans);
				}
			}
			
			function doBarCode(toTrans) {
				var winWidth = $("#emptydiv").width() * 0.9;
				var winHeight = $("#emptydiv").height() * 0.9;
				
				var outStr = "";
				
				/*if((toTrans.length * 11) + 55 > winWidth) {
					var textLen = Math.ceil(((toTrans.length * 11) + 55) / winWidth);
					var re = new RegExp(".{1," + (toTrans.length / textLen) + "}", "g");
					textArr = toTrans.match(re);
					
					imgSize /= textArr.length;
				} else {
					textArr.push(toTrans);
				}*/
				
				/*$.each(textArr, function(idx, val) {
					$.ajax({
						type: "POST",
						url: "barcode.php",
						dataType: "text",
						async: false,
						data: { text: val,
								size: imgSize },
						success: function (output) {
							//outStr += val + ": " + val.length + "<br/>";
							outStr +=  "<img id='barcodeimg' src='data:image/png;base64," + output + "'\><br\><br\>";
						}
					});
				});*/
				
				$.ajax({
					type: "POST",
					url: "bartest.php",
					cache: false,
					dataType: "json",
					async: false,
					data: { text: toTrans,
							width: winWidth,
							height: winHeight },
					success: function (output, status, jqXHR) {
						
						$.each(output, function(idx, val) {
							outStr +=  "<img id='barcodeimg' src='data:image/png;base64," + val + "'\><br\><br\>";
						});
						
						//console.log(output);
						/*$.each(output, function(idx, val) {
							outStr += val + " ";
						});*/
					}
				});
					
				$("#emptydiv").html("");
				$("#emptydiv").prepend(outStr);
			}
			
			function doTut(toTrans) {
				var output = "";
				
				var pairs = {"b":"bub","k":"kuck","s":"sus","c":"cash","l":"lul","t":"tut","d":"dud","m":"mum","v":"vuv","f":"fuf","n":"nun","w":"wack","g":"gug","p":"pub","x":"ex","h":"hash","q":"quack","y":"yub","j":"jay","r":"rug","z":"zub"};
				
				$.each(toTrans.split(''), function(lidx, transLetter) {
					if(/[A-Za-z]+$/.test(transLetter) 
						&& pairs.hasOwnProperty(transLetter.toLowerCase())) {
						var upper = false;
						
						if(/[A-Z]+$/.test(transLetter)) {
							upper = true;
						}
						
						transLetter = transLetter.toLowerCase();
						
						var toAdd = pairs[transLetter];
						
						if(upper) {
							toAdd = toAdd.charAt(0).toUpperCase() + toAdd.slice(1);
						}
						
						output += toAdd;
					} else {
						output += transLetter;
					}
				});
				
				$("#gametext").val(output);
			}
			
			function doInflate(toTrans) {
				var output = "";
				
				var nums = {"one":"two","two":"three","three":"four","four":"five","five":"six","six":"seven","seven":"eight","eight":"nine","nine":"ten","ten":"eleven","eleven":"twelve","twelve":"thirteen","for":"five","once":"twice","twice":"thrice","to":"three"};
				
				$.each(toTrans.split(' '), function(widx, transWord) {
					var outWord = "";
					
					var upper = false;
					
					if(/^[A-Z]/.test(transWord)) {
						upper = true;
					}
					
					$.each(nums, function(k, v) {
						if(transWord.toLowerCase().includes(k)) {
							transWord = transWord.toLowerCase().replace(k, v);
							
							if(upper) {
								transWord = transWord.charAt(0).toUpperCase() + transWord.slice(1);
							}
							
							return false;
						}
					});
					
					output += transWord + " ";
				});
				
				$("#gametext").val(output);
			}
			
			function doEncryption(toTrans, encDec) {
				var output = "";
				
				$.each(toTrans.split(''), function(lidx, transLetter) {
					if(/[A-Za-z]+$/.test(transLetter)) {
						var isUpper = false;
						var outLetter = "";
						var transCode = 0;
						
						if(transLetter.charCodeAt(0) < 97) {
							isUpper = true;
							
							transLetter = transLetter.toLowerCase();
						}
						
						var shiftdir;
						
						if(encDec == "enc") {
							shiftdir = encDir;
						} else {
							shiftdir = decDir;
						}
						
						var keyArr;
						
						if($.inArray(transLetter, consonants) > -1) {
							keyArr = consonants;
						} else {
							keyArr = vowels;
						}
						
						var evalStr = "$.inArray(transLetter, keyArr)" + shiftStr.replace(/@/g,shiftdir);
						
						transCode = eval("$.inArray(transLetter, keyArr)" + shiftStr.replace(/@/g,shiftdir));
						
						if(transCode > keyArr.length - 1) {
							for(; transCode > keyArr.length - 1; transCode -= keyArr.length);
						} else if (transCode < 0) {
							for(; transCode < 0; transCode += keyArr.length);
						}
						
						outLetter = keyArr[transCode];
						
						if(isUpper) {
							outLetter = outLetter.toUpperCase();
						}
					} else {
						outLetter = transLetter;
					}
					
					output += outLetter;
				});
				
				return output;
			}
			
			function encLetter(toCode, keyArr, shift) {
				
				
				return outLetter;
			}
			
			function doDeflate(toTrans) {
				$.ajax({
					type: "POST",
					url: "langgame.php",
					dataType: "text",
					data: { totrans: toTrans },
					success: function (output) {
						$("#gametext").val(output);
					}
				});
			}
			
			function doBlinken(toTrans) {
				$("#blinkentbl").empty();
				
				var row;
				
				$.each(toTrans.split(''), function(idx, transLetter) {
					row = $("<tr></tr>");
					
					var letVal = dec2bin(transLetter.charCodeAt(0));
					letVal = letVal.substring(1);
					
					var checkDigit = 0;
					
					$.each(letVal.split(''), function(idx2, binLetter) {
						if(binLetter == "1") {
							checkDigit++;
						}
					});
					
					if(checkDigit % 2 != 0) {
						letVal = "1" + letVal;
					} else {
						letVal = "0" + letVal;
					}
					
					$.each(letVal.split(''), function(idx2, binLetter) {
						var cell = $("<td></td>").text(" ");
						
						if(binLetter == "1") {
							cell.css("background-color", "red");
						}
						
						row.append(cell);
					});
					
					$("#blinkentbl").append(row);
				});
				
				row = $("<tr></tr>");
				
				for(var i = 1; i <= 8; i++) {
					var cell = $("<td></td>").text(" ").css("background-color", "red");
					
					row.append(cell);
				}
				
				$("#blinkentbl").append(row);
				
				setInterval(function() {
					var firstRow = $("#blinkentbl tr:first");
					$("#blinkentbl tr:first").detach();
					$("#blinkentbl").append(firstRow);
				}, 3000);
			}
			
			function doBase64(toEncrypt) {
				$("#gametext").val(btoa(toEncrypt));
			}
			
			function dec2bin(dec) {
				return (dec >>> 0).toString(2);
			}
      
      function doWordsAbjad() {
        var wordOut = {};
        var wordCount = 0;
        
        $.ajax({
          type: "POST",
          url: "words.json",
          dataType: "json",
          async: false,
          success: function (output) {
            $.each(output.words, function(idx, val) {
              val = val.toLowerCase();
              var newVal = doAbjad(val);
              wordCount++;
              if(wordOut.hasOwnProperty(newVal)) {
                wordOut[newVal].count++;
              } else {
                wordOut[newVal] = {};
                wordOut[newVal]["count"] = 1;
                wordOut[newVal]["words"] = [];
              }
              
              wordOut[newVal]["words"].push(val);
            });
          }
        });
        
        var totalCount = 0;
        $.each(wordOut, function(key, val) {
          if(val.count > 1) {
            var output = key + ": ";
            $.each(val.words, function(idx, val) {
              totalCount++;
              output += val + ", ";
            });
            
            console.log(output);
          }
        });
        
        console.log("Total " + totalCount + " out of " + wordCount);
      }
			
			function doPigLatin(toTrans) {
				$("#gametext").val("");
				
				var output = "";
				
				if(toTrans.length > 0) {
					$.each(toTrans.split(' '), function(idx, transWord) {
						if(typeof transWord != 'undefined') {
							if(/[1-9]/.test(transWord)) {
								output += " " + transWord;
							} else {
								var i, j;
								var preVowel = "";
								var postFix = "ay";
								
								var tempPost = "";
								
								for(j = transWord.length - 1; j > 0 && !/[A-Za-z]/.test(transWord[j]); j--) {
									tempPost = transWord[j] + tempPost;
								}
								
								if(tempPost.length > 0) {
									transWord = transWord.substring(0, transWord.length - tempPost.length);
									
									postFix += tempPost;
								}
                
                var isCap = false;
                
                if(/[A-Z]/.test(transWord[0])) {
                  isCap = true;
                }
                
                transWord = transWord.toLowerCase();
								
								for(i = 0; i < transWord.length && !isVowel(transWord[i]); i++) {
									preVowel += transWord[i];
								}
								
								if(transWord.length > 0) {
									if(preVowel == "") {
										postFix = "y" + postFix;
									} else if(typeof preVowel != 'undefined') {
										postFix = preVowel + postFix;
									}
									
									if(typeof postFix != 'undefined') {
										var toAdd = transWord.slice(i);
										
										if(output != "") {
											output += " ";
										}
                    
                    if(isCap) {
                      toAdd = toAdd.charAt(0).toUpperCase() + toAdd.slice(1);
                    }
										
										output += toAdd + postFix;
									}
								}
							}
						}
					});
				
					$("#gametext").val(output);
				}
			}
      
      function doAbjad(toTrans) {
        var output = "";
        
        $.each(toTrans.split(' '), function(idxWord, valWord) {
          var isCap = false;
          var i = 0;
          
          for(;i < valWord.length && !/[A-Za-z]/.test(valWord.charAt(i)); i++);
          
          if(i < valWord.length) {
            if(/[A-Z]/.test(valWord.charAt(i))) {
              isCap = true;
            }
          }
          
          var word = "";
          
          if(containsConsonant(valWord)) {
            $.each(valWord.split(''), function(idx, val) {
              if(!/[A-Za-z]/.test(val)) {
                word += val;
              } else if(!isVowel(val)) {
                if(isCap) {
                  word += val.toUpperCase();
                  isCap = false;
                } else {
                  word += val;
                }
              }
            });
          } else {
            word = valWord;
          }
          
          output += word + " ";
        });
        
        return output;
      }
      
      function doPolybius(toTrans) {
        var pairs = {"a":"11","b":"12","c":"13","d":"14","e":"15","f":"21","g":"22","h":"23","i":"24","j":"24","k":"25","l":"31","m":"32","n":"33","o":"34","p":"35","q":"41","r":"42","s":"43","t":"44","u":"45","v":"51","w":"52","x":"53","y":"54","z":"55"};
        
        var output = "";
        
        $.each(toTrans.split(''), function(idx, val) {
          if(/[A-Za-z]/.test(val)) {
            output += pairs[val.toLowerCase()] + " ";
          }
        });
        
        return output;
      }
      
      function doPolybiusEncode(toTrans) {
        return doPolybius(doEncryption(toTrans, "enc"));
      }
      
      function doImgCode(toColor, useNonAlpha) {
        var outArr = [];
        
        if(toColor.length == 0) {
          outArr.push("<span style=\"width: #SIZE#; height: #SIZE#; background-color:#000000\">&nbsp;</span>");
        }
        
        for(var i = 0; i < toColor.length; i++) {
          var outStr = "";
          outStr += "<span style=\"width: #SIZE#; height: #SIZE#; background-color:#";
          //outStr += "<span style=\"width: #SIZE#; height: #SIZE#\">";
          
          var j;
          var outTemp = "";
          
          if(useNonAlpha) {
            for(j = 0; i < toColor.length && j < 3; j++,i++) {
              outTemp = Math.round((toColor.charCodeAt(i) - 32) * 2.71).toString(16);
              
              if(outTemp.length == 1) {
                outTemp = "0" + outTemp;
              }
              
              outStr += outTemp;
            }
          } else {
            toColor = toColor.toUpperCase();
            toColor = toColor.replace(/[^ A-Z1-9]/gi, '');
            
            for(j = 0; i < toColor.length && j < 3; j++, i++) {
              if(i < toColor.length) {
                var minusVar = 0;
                
                if(toColor.charCodeAt(i) == 32) {
                  minusVar = 32;
                } else if(toColor.charCodeAt(i) >= 48 && toColor.charCodeAt(i) <= 57) {
                  minusVar = 47;
                } else {
                  minusVar = 54;
                }
                
                outTemp = Math.round((toColor.charCodeAt(i) - minusVar) * 6.89).toString(16);
                
                if(outTemp.length == 1) {
                  outTemp = "0" + outTemp;
                }
                
                outStr += outTemp;
              }
            }
          }
          
          for(; j < 3; j++, i++) {
            outStr += "00";
          }
          
          outStr += "\">&nbsp;</span>";
          //outStr += "</span>";
          
          outArr.push(outStr);
        }
        
        var lenRoot = Math.sqrt(outArr.length);
        var cRoot = Math.ceil(lenRoot);
        var lenSquare = (cRoot * cRoot);
        
        for(; outArr.length < lenSquare; outArr.push("<span style=\"width: #SIZE#; height: #SIZE#; background-color:#000000\">&nbsp;</span>"));
        
        var oaLen = outArr.length;
        
        for(var i = cRoot; i < oaLen; i += cRoot + 1) {
          outArr.splice(i, 0, "<br/>");
        }
        
        var blockSize = 100 / cRoot;
        var output = outArr.join("").replace(/#SIZE#/g, blockSize + "%");
        
        $("#imgcodediv").html(output);
      }
			
			function isVowel(toCheck) {
				if($.inArray(toCheck.toLowerCase(), vowels) > -1) {
					return true;
				} else {
					return false;
				}
			}
      
      function containsConsonant(toCheck) {
        var output = false;
        
        if(toCheck.length = 1) {
          return true;
        }
        
        $.each(toCheck.split(''), function(idx, val) {
          if($.inArray(val.toLowerCase(), consonants) > -1) {
            output = true;
            return false;
          }
        });
        
        return output;
      }
		</script>
		<style>
			.wholePageDiv {
				height: 100%; 
			}
			
			.selectDiv {
				height: 10%;
			}
			
			.outputarea {
				height: 80%;
			}
			
			#controlDiv {
				height: 10%;
			}
			
			#progbar {
				background-color: black;
				width: 0;
			}
			
			td {
				width: 10;
				height: 10;
			}
			
			.bottom {
				width: 100%;
				height: 45%;
				overflow: hidden;
			}
			
			/*#emptydiv {
				overflow-x: scroll;
			}*/
			
			.top {
				width: 100%;
				height: 45%;
				overflow: hidden;
			}
      
      span {
        float: left;
      }
		</style>
	</head>
	<body>
		<div class="wholePageDiv">
			<div class="selectDiv">
				<select id="controlselect">
					<option value="default" selected>Select a game</option>
					<option value="encryption">Encryption</option>
					<option value="piglatin">Pig Latin</option>
					<option value="blinken">Blinkenlights</option>
					<option value="tutnese">Tutnese</option>
					<option value="inflate">Inflationary</option>
					<option value="deflate">Deflate</option>
					<option value="barcode">Bar Code</option>
					<option value="uri">URI</option>
          <option value="abjad">English Abjad</option>
          <option value="polybius">Polybius Square</option>
          <option value="polybiusenc">Polybius Square - Encoded</option>
          <option value="imgcode">Image Code</option>
          <option value="imgcodealpha">Image Code - Alphanumeric Only<option>
				</select>
			</div>
			<div class="outputarea" id="texttrans">
				Plaintext go here:<br/>
				<textarea id="plaintext" class="top"></textarea><br/>
				<textarea id="gametext" class="bottom"></textarea><br/>
				<div id="blinkendiv" class="bottom">
					<table id="blinkentbl"></table>
				</div>
        <div id="imgcodediv" class="bottom">  </div>
				<div id="emptydiv" class="bottom"></div>
			</div>
		</div>
	</body>
</html>