local militaryFortressRead = include("militaryFortressRead")
local militaryFortressCtrl = SoraDGetCtrl("militaryFortressCtrl")
local militaryFortressMainView = class("militaryFortressMainView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("militaryFortressMainView")
end)
function militaryFortressMainView:onEnterPanel()
	militaryFortressCtrl:reqMilitaryFortessInit()
end
function militaryFortressMainView:ctor(properties)
	self.nodeSpace, _ENV = nil, nil
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeCommonFramTitle:setTitle(i18n("fortress_name_01"))
	self.nodeCommonFramTitle:setBtnHelpClickCallBack(handler(self, self.btnHelpClick))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self.btnDetail = SoraDGetChildByName(self, "Button_Detail")
	self.btnDetail:setTitleText(i18n("fortress_text_01"))
	self.btnDetail:addTouchEventListener(handler(self, self.btnDetailClick))
	self.Node_Military = SoraDGetChildByName(self, "Top_Node_Military")
	self.Button_Military = SoraDGetChildByName(self.Node_Military, "Button_Military")
	self.Button_Military:addTouchEventListener(handler(self, self.btnMilitaryClick))
	self.Text_Military = SoraDGetChildByName(self.Node_Military, "Text_Military")
	self.Text_Military:setString(i18n("fortress_title_04"))
	SoraDSetTextWidthHeight(self.Text_Military, cc.size(130, 40))
	self:fitView()
	self:initEffect()
	self:initData()
end
function militaryFortressMainView:fitView()
	local totalHeight = self:getPanelOffsetHeight()
	self.btnDetail:setPositionY((totalHeight / 2 - 335) / 2)
	if totalHeight < 960 then
		self.Node_Military:setPositionY(735)
	end
end
function militaryFortressMainView:initEffect()
	local loop = true
	local cssFilePath = getCCSPath(self._name)
	self.action = cc.CSLoader:createTimeline(cssFilePath)
	self.action:gotoFrameAndPlay(0, loop)
	self:runAction(self.action)
end
function militaryFortressMainView:initData(target, data)
	for fortessType = 1, 4 do
		local single = self.nodeSingle:clone()
		single:addTo(self.node)
		single:setPosition(0, 0)
		SoraDGetChildByName(single, "Button_OpenDetail"):setTag(fortessType)
		self:nodeSingleRefresh(single, fortessType)
		table.insert(self.nodeSpace, single)
	end
	SoraDautoSortPos(self.node, 2, 1, cc.size(280, 370), not SoraDFIsRA())
end
function militaryFortressMainView:nodeSingleRefresh(parent, fortessType)
	local btnOpenDetail = SoraDGetChildByName(parent, "Button_OpenDetail")
	local textName = SoraDGetChildByName(parent, "Text_Name")
	textName:setString(i18n(militaryFortressRead.getFortessTitle(fortessType)))
	SoraDGetChildByName(parent, "Image_Warframe"):ignoreContentAdaptWithSize(true)
	SoraDGetChildByName(parent, "Image_Warframe"):loadTexture(militaryFortressRead.getFortessIcon(fortessType), ccui.TextureResType.plistType)
	btnOpenDetail:addTouchEventListener(handlerEx(self, self.btnOpenDetailClick))
end
function militaryFortressMainView:btnHelpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("fortress_text_18"))
	end
end
function militaryFortressMainView:btnMilitaryClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("heroFactorDetailView")
		panel:show()
	end
end
function militaryFortressMainView:btnDetailClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("campTotalBuffView"):show()
	end
end
function militaryFortressMainView:btnOpenDetailClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local fortessType = target:getTag()
		local panel = SoraDCreatePanel("fortressDetailView")
		panel:initData(fortessType)
		panel:show()
	end
end
return militaryFortressMainView
