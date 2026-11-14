local mailDesRead = include("mailDesRead")
local mailItemDetailAttrAnalysis = class("mailItemDetailAttrAnalysis", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("mailItemDetailAttrAnalysis")
end)
function mailItemDetailAttrAnalysis:ctor(properties)
	self.nodeAttr, _ENV, self.nodeTabs, _ENV = nil, nil, nil, nil
	self.tabIndex = 1
	self.title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_mail")
	self.title:setTitle(i18n("mail_2_text_39"))
	self.scrollTab = SoraDGetChildByName(self, "Top_ScrollView_Tab")
	self.nodeTabs[1] = SoraDGetChildByName(self.scrollTab, "Node_TabSingle")
	self.nodeAttrList = SoraDGetChildByName(self, "Top_Node_AttrList")
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self.scrollText = SoraDGetChildByName(self, "Top_ScrollView_Text")
	self.nodeScrollTitle = SoraDGetChildByName(self.scrollText, "Node_Title")
	self.textFont = SoraDGetChildByName(self.nodeScrollTitle, "Text_font")
	self.textFont:setString(i18n("mail_2_text_41"))
	self.textFont = SoraDChangeTextToHtml(self.textFont)
	self.panelText = SoraDGetChildByName(self.scrollText, "Panel_Text")
	self.panelText:setLayoutType(ccui.LayoutType.VERTICAL)
	self.bg = SoraDGetChildByName(self, "Top_Image_8")
	_UPVALUE3_, self.line = SoraDGetChildByName(self, "Top_Image_1"), SoraDGetChildByName(self, "Top_Image_1")
	self.listResetY, SoraDGetChildByName(self, "Top_Image_1")[1] = SoraDGetChildByName(self, "Top_Image_1"), self.line
	self.listResetY, SoraDGetChildByName(self, "Top_Image_1")[2] = SoraDGetChildByName(self, "Top_Image_1"), self.scrollText
	self.listResetY, SoraDGetChildByName(self, "Top_Image_1")[3] = SoraDGetChildByName(self, "Top_Image_1"), self.nodeAttrList
	self:fitView()
	self:initData()
end
function mailItemDetailAttrAnalysis:fitView()
end
function mailItemDetailAttrAnalysis:initData(target, data)
	local singleWidth = 102
	local maxWidth = math.max(612, 6 * singleWidth)
	self.scrollTab:setInnerContainerSize(cc.size(maxWidth, 50))
	for id, v in pairs(mailDesRead.getAttranalysislist()) do
		local single = self.nodeTabs[v.rank]
		if v.rank ~= 1 then
			single = self.nodeTabs[1]:clone()
			self.nodeTabs[v.rank] = single
			single:addTo(self.scrollTab)
		end
		single.attrData = v.attrData
		single:setTag(id)
		single:setPosition(SoraDFPosX(maxWidth - (v.rank - 1) * singleWidth, maxWidth), 0)
		self:nodeTabSingleRefresh(single, v)
		self:setItemSel(single, v.rank == 1)
	end
	if SoraDFIsRA() then
		self.scrollTab:scrollToRight(0, false)
	else
		self.scrollTab:scrollToLeft(0, false)
	end
	self.tabIndex = 1
	self:refreshAttrNode()
end
function mailItemDetailAttrAnalysis:setItemSel(nodeItem, isSel)
	SoraDGetChildByName(nodeItem, "Icon_Choose"):setVisible(isSel)
	SoraDGetChildByName(nodeItem, "Button_Choose"):setBright(not isSel)
	if isSel then
		nodeItem:setLocalZOrder(99)
		SoraDGetChildByName(nodeItem, "label_title"):setColor(cc.c3b(50, 28, 9))
	else
		nodeItem:setLocalZOrder(1)
		SoraDGetChildByName(nodeItem, "label_title"):setColor(cc.c3b(250, 230, 171))
	end
end
function mailItemDetailAttrAnalysis:nodeTabSingleRefresh(parent, data)
	local btnChoose = SoraDGetChildByName(parent, "Button_Choose")
	btnChoose:setSwallowTouches(false)
	btnChoose:setTag(data.rank)
	btnChoose:addTouchEventListener(handler(self, self.btnChooseClick))
	local spChoose = SoraDGetChildByName(parent, "Icon_Choose")
	local textTitle = SoraDGetChildByName(parent, "label_title")
	local spSoild = SoraDGetChildByName(parent, "icon_Soild")
	textTitle:setString(i18n(data.titleName))
	spSoild:setSpriteFrame(data.titleIcon)
	spChoose:setVisible(false)
end
_UPVALUE5_, mailItemDetailAttrAnalysis.refreshAttrNode = function(self)
	local attrData = self.nodeTabs[self.tabIndex].attrData
	dump(attrData, "mailItemDetailAttrAnalysis:refreshAttrNode")
	self.lineCount = math.ceil(#attrData / 4)
	for i, id in ipairs(attrData) do
		local single = self.nodeAttr[i]
		if not single then
			single = self.nodeSingle:clone()
			single:addTo(self.nodeAttrList)
			self.nodeAttr[i] = single
		end
		single:setVisible(true)
		self:nodeSingleRefresh(single, id)
	end
	for i = #attrData + 1, #self.nodeAttr do
		self.nodeAttr[i]:setVisible(false)
	end
	self.lastCheckNode = self.nodeAttr[1]:getChildByName("CheckBox")
	self:refreshLabelScroll(self.lastCheckNode:getTag())
	self.lastCheckNode:setSelected(true)
	self.lastCheckNode:getChildByName("icon_czhl_g"):setVisible(true)
	if not self.listOrginnaYs then
		self.listOrginnaYs, _ENV = self.listOrginnaYs, self.listOrginnaYs
		for i, v in ipairs(self.listResetY) do
			self.listOrginnaYs[i] = v:getPositionY()
		end
	end
	local offsetY = 100 - 50 * self.lineCount
	for i, v in ipairs(self.listResetY) do
		if v == self.nodeAttrList then
			self.nodeAttrList:setPositionY(self.listOrginnaYs[i] + offsetY / 2)
		else
			local newY = self.listOrginnaYs[i] + offsetY
			v:setPositionY(newY)
		end
	end
	SoraDautoSortPos(self.nodeAttrList, 4, SoraDFIsRA() and 2 or 0, cc.size(145, 50), SoraDFIsRA())
end, function(self)
	local attrData = self.nodeTabs[self.tabIndex].attrData
	dump(attrData, "mailItemDetailAttrAnalysis:refreshAttrNode")
	self.lineCount = math.ceil(#attrData / 4)
	for i, id in ipairs(attrData) do
		local single = self.nodeAttr[i]
		if not single then
			single = self.nodeSingle:clone()
			single:addTo(self.nodeAttrList)
			self.nodeAttr[i] = single
		end
		single:setVisible(true)
		self:nodeSingleRefresh(single, id)
	end
	for i = #attrData + 1, #self.nodeAttr do
		self.nodeAttr[i]:setVisible(false)
	end
	self.lastCheckNode = self.nodeAttr[1]:getChildByName("CheckBox")
	self:refreshLabelScroll(self.lastCheckNode:getTag())
	self.lastCheckNode:setSelected(true)
	self.lastCheckNode:getChildByName("icon_czhl_g"):setVisible(true)
	if not self.listOrginnaYs then
		self.listOrginnaYs, _ENV = self.listOrginnaYs, self.listOrginnaYs
		for i, v in ipairs(self.listResetY) do
			self.listOrginnaYs[i] = v:getPositionY()
		end
	end
	local offsetY = 100 - 50 * self.lineCount
	for i, v in ipairs(self.listResetY) do
		if v == self.nodeAttrList then
			self.nodeAttrList:setPositionY(self.listOrginnaYs[i] + offsetY / 2)
		else
			local newY = self.listOrginnaYs[i] + offsetY
			v:setPositionY(newY)
		end
	end
	SoraDautoSortPos(self.nodeAttrList, 4, SoraDFIsRA() and 2 or 0, cc.size(145, 50), SoraDFIsRA())
end
;(function(self)
	local attrData = self.nodeTabs[self.tabIndex].attrData
	dump(attrData, "mailItemDetailAttrAnalysis:refreshAttrNode")
	self.lineCount = math.ceil(#attrData / 4)
	for i, id in ipairs(attrData) do
		local single = self.nodeAttr[i]
		if not single then
			single = self.nodeSingle:clone()
			single:addTo(self.nodeAttrList)
			self.nodeAttr[i] = single
		end
		single:setVisible(true)
		self:nodeSingleRefresh(single, id)
	end
	for i = #attrData + 1, #self.nodeAttr do
		self.nodeAttr[i]:setVisible(false)
	end
	self.lastCheckNode = self.nodeAttr[1]:getChildByName("CheckBox")
	self:refreshLabelScroll(self.lastCheckNode:getTag())
	self.lastCheckNode:setSelected(true)
	self.lastCheckNode:getChildByName("icon_czhl_g"):setVisible(true)
	if not self.listOrginnaYs then
		self.listOrginnaYs, _ENV = self.listOrginnaYs, self.listOrginnaYs
		for i, v in ipairs(self.listResetY) do
			self.listOrginnaYs[i] = v:getPositionY()
		end
	end
	local offsetY = 100 - 50 * self.lineCount
	for i, v in ipairs(self.listResetY) do
		if v == self.nodeAttrList then
			self.nodeAttrList:setPositionY(self.listOrginnaYs[i] + offsetY / 2)
		else
			local newY = self.listOrginnaYs[i] + offsetY
			v:setPositionY(newY)
		end
	end
	SoraDautoSortPos(self.nodeAttrList, 4, SoraDFIsRA() and 2 or 0, cc.size(145, 50), SoraDFIsRA())
end)[1] = "common_text_1536"
;(function(self)
	local attrData = self.nodeTabs[self.tabIndex].attrData
	dump(attrData, "mailItemDetailAttrAnalysis:refreshAttrNode")
	self.lineCount = math.ceil(#attrData / 4)
	for i, id in ipairs(attrData) do
		local single = self.nodeAttr[i]
		if not single then
			single = self.nodeSingle:clone()
			single:addTo(self.nodeAttrList)
			self.nodeAttr[i] = single
		end
		single:setVisible(true)
		self:nodeSingleRefresh(single, id)
	end
	for i = #attrData + 1, #self.nodeAttr do
		self.nodeAttr[i]:setVisible(false)
	end
	self.lastCheckNode = self.nodeAttr[1]:getChildByName("CheckBox")
	self:refreshLabelScroll(self.lastCheckNode:getTag())
	self.lastCheckNode:setSelected(true)
	self.lastCheckNode:getChildByName("icon_czhl_g"):setVisible(true)
	if not self.listOrginnaYs then
		self.listOrginnaYs, _ENV = self.listOrginnaYs, self.listOrginnaYs
		for i, v in ipairs(self.listResetY) do
			self.listOrginnaYs[i] = v:getPositionY()
		end
	end
	local offsetY = 100 - 50 * self.lineCount
	for i, v in ipairs(self.listResetY) do
		if v == self.nodeAttrList then
			self.nodeAttrList:setPositionY(self.listOrginnaYs[i] + offsetY / 2)
		else
			local newY = self.listOrginnaYs[i] + offsetY
			v:setPositionY(newY)
		end
	end
	SoraDautoSortPos(self.nodeAttrList, 4, SoraDFIsRA() and 2 or 0, cc.size(145, 50), SoraDFIsRA())
end)[2] = "common_name_01"
;(function(self)
	local attrData = self.nodeTabs[self.tabIndex].attrData
	dump(attrData, "mailItemDetailAttrAnalysis:refreshAttrNode")
	self.lineCount = math.ceil(#attrData / 4)
	for i, id in ipairs(attrData) do
		local single = self.nodeAttr[i]
		if not single then
			single = self.nodeSingle:clone()
			single:addTo(self.nodeAttrList)
			self.nodeAttr[i] = single
		end
		single:setVisible(true)
		self:nodeSingleRefresh(single, id)
	end
	for i = #attrData + 1, #self.nodeAttr do
		self.nodeAttr[i]:setVisible(false)
	end
	self.lastCheckNode = self.nodeAttr[1]:getChildByName("CheckBox")
	self:refreshLabelScroll(self.lastCheckNode:getTag())
	self.lastCheckNode:setSelected(true)
	self.lastCheckNode:getChildByName("icon_czhl_g"):setVisible(true)
	if not self.listOrginnaYs then
		self.listOrginnaYs, _ENV = self.listOrginnaYs, self.listOrginnaYs
		for i, v in ipairs(self.listResetY) do
			self.listOrginnaYs[i] = v:getPositionY()
		end
	end
	local offsetY = 100 - 50 * self.lineCount
	for i, v in ipairs(self.listResetY) do
		if v == self.nodeAttrList then
			self.nodeAttrList:setPositionY(self.listOrginnaYs[i] + offsetY / 2)
		else
			local newY = self.listOrginnaYs[i] + offsetY
			v:setPositionY(newY)
		end
	end
	SoraDautoSortPos(self.nodeAttrList, 4, SoraDFIsRA() and 2 or 0, cc.size(145, 50), SoraDFIsRA())
end)[3] = "mail_2_text_50"
;(function(self)
	local attrData = self.nodeTabs[self.tabIndex].attrData
	dump(attrData, "mailItemDetailAttrAnalysis:refreshAttrNode")
	self.lineCount = math.ceil(#attrData / 4)
	for i, id in ipairs(attrData) do
		local single = self.nodeAttr[i]
		if not single then
			single = self.nodeSingle:clone()
			single:addTo(self.nodeAttrList)
			self.nodeAttr[i] = single
		end
		single:setVisible(true)
		self:nodeSingleRefresh(single, id)
	end
	for i = #attrData + 1, #self.nodeAttr do
		self.nodeAttr[i]:setVisible(false)
	end
	self.lastCheckNode = self.nodeAttr[1]:getChildByName("CheckBox")
	self:refreshLabelScroll(self.lastCheckNode:getTag())
	self.lastCheckNode:setSelected(true)
	self.lastCheckNode:getChildByName("icon_czhl_g"):setVisible(true)
	if not self.listOrginnaYs then
		self.listOrginnaYs, _ENV = self.listOrginnaYs, self.listOrginnaYs
		for i, v in ipairs(self.listResetY) do
			self.listOrginnaYs[i] = v:getPositionY()
		end
	end
	local offsetY = 100 - 50 * self.lineCount
	for i, v in ipairs(self.listResetY) do
		if v == self.nodeAttrList then
			self.nodeAttrList:setPositionY(self.listOrginnaYs[i] + offsetY / 2)
		else
			local newY = self.listOrginnaYs[i] + offsetY
			v:setPositionY(newY)
		end
	end
	SoraDautoSortPos(self.nodeAttrList, 4, SoraDFIsRA() and 2 or 0, cc.size(145, 50), SoraDFIsRA())
end)[4] = "mail_2_text_51"
local (function(self)
	local attrData = self.nodeTabs[self.tabIndex].attrData
	dump(attrData, "mailItemDetailAttrAnalysis:refreshAttrNode")
	self.lineCount = math.ceil(#attrData / 4)
	for i, id in ipairs(attrData) do
		local single = self.nodeAttr[i]
		if not single then
			single = self.nodeSingle:clone()
			single:addTo(self.nodeAttrList)
			self.nodeAttr[i] = single
		end
		single:setVisible(true)
		self:nodeSingleRefresh(single, id)
	end
	for i = #attrData + 1, #self.nodeAttr do
		self.nodeAttr[i]:setVisible(false)
	end
	self.lastCheckNode = self.nodeAttr[1]:getChildByName("CheckBox")
	self:refreshLabelScroll(self.lastCheckNode:getTag())
	self.lastCheckNode:setSelected(true)
	self.lastCheckNode:getChildByName("icon_czhl_g"):setVisible(true)
	if not self.listOrginnaYs then
		self.listOrginnaYs, _ENV = self.listOrginnaYs, self.listOrginnaYs
		for i, v in ipairs(self.listResetY) do
			self.listOrginnaYs[i] = v:getPositionY()
		end
	end
	local offsetY = 100 - 50 * self.lineCount
	for i, v in ipairs(self.listResetY) do
		if v == self.nodeAttrList then
			self.nodeAttrList:setPositionY(self.listOrginnaYs[i] + offsetY / 2)
		else
			local newY = self.listOrginnaYs[i] + offsetY
			v:setPositionY(newY)
		end
	end
	SoraDautoSortPos(self.nodeAttrList, 4, SoraDFIsRA() and 2 or 0, cc.size(145, 50), SoraDFIsRA())
end)[5], titleStr = "common_text_312", function(self)
	local attrData = self.nodeTabs[self.tabIndex].attrData
	dump(attrData, "mailItemDetailAttrAnalysis:refreshAttrNode")
	self.lineCount = math.ceil(#attrData / 4)
	for i, id in ipairs(attrData) do
		local single = self.nodeAttr[i]
		if not single then
			single = self.nodeSingle:clone()
			single:addTo(self.nodeAttrList)
			self.nodeAttr[i] = single
		end
		single:setVisible(true)
		self:nodeSingleRefresh(single, id)
	end
	for i = #attrData + 1, #self.nodeAttr do
		self.nodeAttr[i]:setVisible(false)
	end
	self.lastCheckNode = self.nodeAttr[1]:getChildByName("CheckBox")
	self:refreshLabelScroll(self.lastCheckNode:getTag())
	self.lastCheckNode:setSelected(true)
	self.lastCheckNode:getChildByName("icon_czhl_g"):setVisible(true)
	if not self.listOrginnaYs then
		self.listOrginnaYs, _ENV = self.listOrginnaYs, self.listOrginnaYs
		for i, v in ipairs(self.listResetY) do
			self.listOrginnaYs[i] = v:getPositionY()
		end
	end
	local offsetY = 100 - 50 * self.lineCount
	for i, v in ipairs(self.listResetY) do
		if v == self.nodeAttrList then
			self.nodeAttrList:setPositionY(self.listOrginnaYs[i] + offsetY / 2)
		else
			local newY = self.listOrginnaYs[i] + offsetY
			v:setPositionY(newY)
		end
	end
	SoraDautoSortPos(self.nodeAttrList, 4, SoraDFIsRA() and 2 or 0, cc.size(145, 50), SoraDFIsRA())
end
function mailItemDetailAttrAnalysis:refreshLabelScroll(id)
	dump(id, "mailItemDetailAttrAnalysis:refreshLabelScroll")
	local info = mailDesRead.getAttranAlysisDataById(id)
	if not info then
		return
	end
	local attrInfo = mailDesRead.getAttranalysislistById(self.nodeTabs[self.tabIndex]:getTag())
	local str = ""
	if SoraDFIsRA() then
		_ENV = self.nodeTabs[self.tabIndex]:getTag()
		self.nodeTabs[self.tabIndex]:getTag().param = "#" .. attrInfo.titleIcon
		self.nodeTabs[self.tabIndex]:getTag().name = "img"
		self.nodeTabs[self.tabIndex]:getTag().width = 32
		self.nodeTabs[self.tabIndex]:getTag().height = 32
		self.nodeTabs[self.tabIndex]:getTag().custom = "Sprite"
		self.nodeTabs[self.tabIndex]:getTag().offsety = 8
		str = string.format("%s%s%s %s", i18n("mail_2_text_41"), SoraDWrapReplaceTag(self.nodeTabs[self.tabIndex]:getTag()), i18n(info.attrName), i18n(attrInfo.titleName))
	else
		_ENV = i18n(info.attrName)
		i18n(info.attrName).param = "#" .. attrInfo.titleIcon
		i18n(info.attrName).name = "img"
		i18n(info.attrName).width = 32
		i18n(info.attrName).height = 32
		i18n(info.attrName).custom = "Sprite"
		i18n(info.attrName).offsety = 8
		str = string.format("%s%s%s %s", i18n("mail_2_text_41"), SoraDWrapReplaceTag((i18n(info.attrName))), i18n(attrInfo.titleName), i18n(info.attrName))
	end
	self.textFont:setString(str)
	local textHeight = SoraDGetAutoHeightLabel(self.textFont, 600)
	local index = 1
	local totalHeight = 0
	self.panelText:removeAllChildren()
	while info["funText" .. index] do
		local strList = info["funText" .. index]
		if next(strList) then
			local _ENV, i18nStrList = next(strList), next(strList)
			local str = string.format("[ %s ] ", i18n(titleStr[index]))
			for i = 1, #strList do
				if i == #strList then
					str = str .. string.format("%s", i18n(strList[i]))
				else
					str = str .. string.format("%s、 ", i18n(strList[i]))
				end
			end
			_ENV = 1
			;(1).fontSize = 22
			;(1).color = cc.c3b(102, 50, 12)
			;(1).autoHeight = true
			_ENV, (1).linearLayoutType = ccui.LinearGravity.centerHorizontal, ccui.LinearGravity.centerHorizontal
			ccui.LinearGravity.centerHorizontal.left = SoraDFPosX(0, 10)
			ccui.LinearGravity.centerHorizontal.top = 10
			ccui.LinearGravity.centerHorizontal.right = SoraDFPosX(10, 10)
			;(1).margin, ccui.LinearGravity.centerHorizontal.bottom = ccui.LinearGravity.centerHorizontal, 10
			;(1).str = _p(str)
			;(1).AlignH = SoraDFLabelR()
			local textSingle, autoHeight = include("mailNodeFactory"):createTextLayout(1)
			textSingle:addTo(self.panelText)
			totalHeight = totalHeight + autoHeight
		end
		index = index + 1
	end
	self.panelText:setContentSize(cc.size(612, totalHeight))
	local newHeight = totalHeight + textHeight
	self.scrollText:setContentSize(cc.size(612, newHeight + 20))
	self.scrollText:setInnerContainerSize(cc.size(612, newHeight))
	self.bg:setContentSize(cc.size(612, totalHeight + textHeight + 50 + 50 * self.lineCount))
	self.nodeScrollTitle:setPositionY(newHeight - textHeight / 2)
	self.panelText:setPositionY(newHeight - textHeight)
end
function mailItemDetailAttrAnalysis:nodeSingleRefresh(parent, id)
	local textName = SoraDGetChildByName(parent, "Text_Name")
	local checkBox = SoraDGetChildByName(parent, "CheckBox")
	checkBox:setTouchEnabled(true)
	checkBox:setSelected(false)
	checkBox:getChildByName("icon_czhl_g"):setVisible(false)
	checkBox:setTag(id)
	if not checkBox.isAddFun then
		checkBox:addEventListener(handler(self, self.checkBoxEventCallBack))
		checkBox.isAddFun = true
	end
	local info = mailDesRead.getAttranAlysisDataById(id)
	if not info then
		return
	end
	textName:setString(i18n(info.attrName))
end
function mailItemDetailAttrAnalysis:btnChooseClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		if tag == self.tabIndex then
			return
		end
		self:setItemSel(self.nodeTabs[self.tabIndex], false)
		self.tabIndex = tag
		self:setItemSel(self.nodeTabs[self.tabIndex], true)
		self:refreshAttrNode()
	end
end
function mailItemDetailAttrAnalysis:checkBoxEventCallBack(target, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		local tag = target:getTag()
		target:setTouchEnabled(false)
		target:getChildByName("icon_czhl_g"):setVisible(true)
		self.lastCheckNode:setTouchEnabled(true)
		self.lastCheckNode:setSelected(false)
		self.lastCheckNode:getChildByName("icon_czhl_g"):setVisible(false)
		self.lastCheckNode = target
		self:refreshLabelScroll(tag)
	elseif eventType == ccui.CheckBoxEventType.unselected then
		local tag = target:getTag()
	end
end
return mailItemDetailAttrAnalysis
