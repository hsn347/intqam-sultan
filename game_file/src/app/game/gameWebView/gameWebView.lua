local gameWebView = class("gameWebView", function(webUrl, title)
	return SoraDCreateBasePanel("gameWebView")
end)
function gameWebView:ctor(webUrl, title, htmlString)
	print("webUrl:", webUrl)
	self.isHideCurrentSceneView = true
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	title = title or ""
	self.txtTitle:setString(title)
	self.commonFramTitle_node = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_webView")
	self.webView = nil
	if device.platform == "android" or device.platform == "ios" then
		local bgImage = SoraDGetChildByName(self, "Top_Size_Tile_Image_bg")
		local size = bgImage:getContentSize()
		self.webView = ccexp.WebView:create()
		self.webView:setContentSize(size)
		self.webView:setPosition(0, 0)
		bgImage:addChild(self.webView, 1)
		if webUrl then
			print("------------------加载文件上的内容")
			self.webView:loadURL(webUrl)
			self.webView:setScalesPageToFit(true)
			self.webView:reload()
		elseif htmlString then
			self.webView:loadHTMLString(htmlString)
			self.webView:setScalesPageToFit(true)
		end
	end
end
function gameWebView:initData()
end
function gameWebView:onMessageListener()
end
return gameWebView
