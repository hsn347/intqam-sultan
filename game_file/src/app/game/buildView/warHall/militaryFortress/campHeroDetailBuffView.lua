local militaryFortressRead = include("militaryFortressRead")
local militaryFortressCtrl = SoraDGetCtrl("militaryFortressCtrl")
local campHeroDetailBuffView = class("campHeroDetailBuffView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("campHeroDetailBuffView")
end)
function campHeroDetailBuffView:ctor(properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.scrollItem = SoraDGetChildByName(self, "ScrollView_item")
	self.scrollItem = include("commonAutoScrollList").new(self.scrollItem)
	self.scrollItem:setSingleCreate(handler(self, self.createScrollSingle))
	self.scrollItem:setSingleRefresh(handler(self, self.nodeSingleRefresh))
	self.textNoBuff = SoraDGetChildByName(self, "Text_NoBuff")
	self.textNoBuff:setString(i18n("fortress_text_19"))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
end
function campHeroDetailBuffView:initData(fortessType, campType)
	self.fortessType = fortessType
	self.campType = campType
	_ENV = nil
	;(nil).name1 = i18n(militaryFortressRead.getFortessTitle(fortessType))
	;(nil).name2 = i18n(militaryFortressRead.getCampTitle(campType))
	self.nodeCommonPopBox:setTitleName(i18n("fortress_text_04", nil))
	local _ENV, list = self.nodeCommonPopBox.setTitleName, self.nodeCommonPopBox.setTitleName
	for i, v in pairs(militaryFortressCtrl:getHeroList(fortessType, campType)) do
		_ENV = militaryFortressCtrl:getHeroList(fortessType, campType)
		militaryFortressCtrl:getHeroList(fortessType, campType).heroID = v
		table.insert(list, militaryFortressCtrl:getHeroList(fortessType, campType))
	end
	if not next(list) then
		self.textNoBuff:setVisible(true)
	else
		self.textNoBuff:setVisible(false)
	end
	_ENV = table.insert
	table.insert.scroll = self.scrollItem
	table.insert.view = self
	self.scrollItem:updateScrollView(cc.size(536, 130), list, 1, table.insert)
end
function campHeroDetailBuffView:createScrollSingle()
	return self.nodeSingle:clone()
end
function campHeroDetailBuffView:nodeSingleRefresh(parent, data)
	local scrollBuff = SoraDGetChildByName(parent, "ScrollView_Buff")
	scrollBuff = include("buffScrollView").new(scrollBuff)
	scrollBuff:setProportion(0.7)
	_ENV = nil
	;(nil).fortessType = self.fortessType
	;(nil).campType = self.campType
	;(nil).heroID = data.heroID
	;(nil).pos = parent:getTag()
	scrollBuff:updateScrollView(cc.size(300, 35), militaryFortressCtrl:getBuffByHeroPos(nil), 1)
	local nodeMilitaryHeroItem = SoraDGetExtendChildFromCCSByName(parent, "CCS_militaryHeroItem")
	nodeMilitaryHeroItem:initData(data.heroID)
end
return campHeroDetailBuffView
