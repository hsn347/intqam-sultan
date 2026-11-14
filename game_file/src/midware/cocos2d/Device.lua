local Device = class("Device")
function Device:measureText(str, txtContentInfo)
	local txt = self:getSampleText(txtContentInfo.isHtml)
	txt:setFontSize(txtContentInfo.fontSize or 20)
	txt:setFontName(txtContentInfo.fontName or fgui.UIConfig.defaultFont)
	txt:setIsHtml(txtContentInfo.isHtml)
	local fontDimensions = txtContentInfo.fontDimensions or cc.size(0, 0)
	if fontDimensions.width == 0 then
		txt:setAutoSize(fgui.AutoSizeType.BOTH)
	elseif 0 < fontDimensions.width then
		txt:setAutoSize(fgui.AutoSizeType.HEIGHT)
	else
		print_error("参数错误fontDimensions", fontDimensions.width, fontDimensions.height)
	end
	txt:setSize(fontDimensions.width, fontDimensions.height)
	txt:setString(str)
	return txt:getContentSize()
end
function Device:is64Bit()
	return false
end
function Device:setIsHtmlTextDebug(gChatDebug)
	return false
end
function Device:getDPI()
	return "Device:getDPI()"
end
function Device:getTextureWidthHeightForText(str, param)
	return self:measureText(str, param)
end
function Device:getSampleText(isHtml)
	local txt
	if not isHtml then
		if not self.__sampleText then
			txt = fgui.GTextField()
			self.__sampleText = txt
		else
			txt = self.__sampleText
		end
	elseif not self.__sampleHtmlText then
		txt = fgui.GRichTextField()
		SoraDSetupEmojies(txt)
		self.__sampleHtmlText = txt
	else
		txt = self.__sampleHtmlText
	end
	return txt
end
return Device
