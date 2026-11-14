local militaryFortressRead = include("militaryFortressRead")
local militaryFortressCtrl = SoraDGetCtrl("militaryFortressCtrl")
local fortressBuffHaveView = class("fortressBuffHaveView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("fortressBuffHaveView")
end)
function fortressBuffHaveView:ctor(properties)
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self.node, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("fortress_text_01"))
	self.textHeroModulus = SoraDGetChildByName(self.node, "Text_HeroModulus")
	self.scrollItem = SoraDGetChildByName(self.node, "ScrollView_item")
	self.scrollItem = include("commonAutoScrollList").new(self.scrollItem)
	self.scrollItem:setSingleCreate(handler(self, self.createScrollSingle))
	self.scrollItem:setSingleRefresh(handler(self, self.nodeSingleRefresh))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self.textNoBuff = SoraDGetChildByName(self, "Text_NoBuff")
	self.textNoBuff:setString(i18n("fortress_text_19"))
	self.textTips = SoraDGetChildByName(self.node, "Text_Tips")
	self.textTips:setString(i18n("fortress_text_35"))
end
function fortressBuffHaveView:initData(campType)
	self.textHeroModulus:setString(i18n(campType == 1 and "fortress_text_16" or "fortress_text_15"))
	local list = militaryFortressCtrl:getCampBuffList(campType)
	if not next(list) then
		self.textNoBuff:setVisible(true)
	else
		self.textNoBuff:setVisible(false)
	end
	self.scrollItem:updateScrollView(cc.size(550, 40), list, 1)
end
function fortressBuffHaveView:createScrollSingle()
	return self.nodeSingle:clone()
end
function fortressBuffHaveView:nodeSingleRefresh(parent, data)
	local img2 = SoraDGetChildByName(parent, "Image_2")
	local textModulus = SoraDGetChildByName(parent, "Text_Modulus")
	local textBuffName = SoraDGetChildByName(parent, "Text_BuffName")
	img2:setVisible(parent:getTag() % 2 == 0)
	local titleStr, valueStr = militaryFortressRead.getTitleAndValueStr(data.attrID, data.attrValue)
	textBuffName:setString(titleStr)
	textModulus:setString(valueStr)
end
return fortressBuffHaveView
