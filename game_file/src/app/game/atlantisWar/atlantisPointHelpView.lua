local atlantisActivityRead = include("atlantisActivityRead")
local atlantisPointHelpView = class("atlantisPointHelpView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("atlantisPointHelpView")
end)
function atlantisPointHelpView:ctor(properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.scrollItem = SoraDGetChildByName(self, "ScrollView_item")
	self.scrollItem = include("commonAutoScrollList").new(self.scrollItem)
	self.scrollItem:setSingleCreate(handler(self, self.createSingle))
	self.scrollItem:setSingleRefresh(handler(self, self.refreshSingle))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
end
function atlantisPointHelpView:initData(data)
	self.rankType = data.rankType
	self.nodeCommonPopBox:setTitleName(data.title)
	self.textTitle:setString(data.detailStr)
	self.scrollItem:updateScrollView(cc.size(520, 34), self:getScrollData(), 1)
end
function atlantisPointHelpView:getScrollData()
	local _ENV, ret
	local power = include("constantRead").getConstValue("ATLANTISWAR_SCORE_KILL_ARMY")
	_ENV = nil
	;(nil).isTitle = true
	;(nil).titleStr = i18n("atlantiswar_text_0129")
	table.insert(ret, nil)
	_ENV = nil
	_ENV = nil
	;(nil).var = string.formatnumberthousands(power)
	;(nil).paramStr = i18n("atlantiswar_text_0130", nil)
	;(nil).value = 1
	;(nil).isBgVisit = false
	table.insert(ret, nil)
	_ENV = nil
	;(nil).isTitle = true
	;(nil).titleStr = i18n("atlantiswar_text_0249")
	table.insert(ret, nil)
	local paramStr = self.rankType == 2 and i18n("atlantiswar_text_0343") or i18n("atlantiswar_text_0344")
	_ENV = i18n("atlantiswar_text_0249")
	i18n("atlantiswar_text_0249").paramStr = paramStr
	i18n("atlantiswar_text_0249").isBgVisit = false
	table.insert(ret, (i18n("atlantiswar_text_0249")))
	_ENV = i18n("atlantiswar_text_0249")
	i18n("atlantiswar_text_0249").isTitle = true
	i18n("atlantiswar_text_0249").titleStr = i18n("atlantiswar_text_0182")
	table.insert(ret, (i18n("atlantiswar_text_0249")))
	for i, v in ipairs(atlantisActivityRead.getBuildPointRule()) do
		table.insert(ret, v)
	end
	return ret
end
function atlantisPointHelpView:createSingle()
	return self.nodeSingle:clone()
end
function atlantisPointHelpView:refreshSingle(parent, data)
	local paramNode = SoraDGetChildByName(parent, "Node_Param")
	local titleNode = SoraDGetChildByName(parent, "Node_Title")
	local isTitle = data.isTitle or false
	titleNode:setVisible(isTitle)
	paramNode:setVisible(not isTitle)
	if isTitle then
		local textTitle = SoraDGetChildByName(titleNode, "Text_Title")
		textTitle:setString(data.titleStr)
	else
		local img2 = SoraDGetChildByName(paramNode, "Image_2")
		local textModulus = SoraDGetChildByName(paramNode, "Text_Modulus")
		local textParam = SoraDGetChildByName(paramNode, "Text_Param")
		textModulus:setString(data.paramStr)
		SoraDSetTextWidthHeight(textModulus, cc.size(480, 30))
		if data.value then
			textParam:setString(string.formatnumberthousands(data.value))
		end
		img2:setVisible(data.isBgVisit)
	end
end
return atlantisPointHelpView
