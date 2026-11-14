local cityBuildConstDef = include("cityBuildConstDef")
local armyBuildingsView = class("armyBuildingsView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("armyBuildingsView")
	end
	return target
end)
function armyBuildingsView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_3616"))
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("common_text_3539"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("armyBuildingsSingle")
	_ENV, _ENV = self.scroll, self.scroll.setSingleCCS
	self.scroll.bid = BUILDID.CHARIOT_PLANT
	self.scroll.isTrain = true
	self.scroll.png = "bg_zjsb_bubing.png"
	_ENV, self.scroll.setSingleCCS[1], self.scroll.name = self.scroll, self.scroll, i18n("buildDes_name_118")
	self.scroll.bid = BUILDID.STABLES
	self.scroll.isTrain = true
	self.scroll.png = "bg_zjsb_qibing.png"
	_ENV, self.scroll.setSingleCCS[2], self.scroll.name = self.scroll, self.scroll, i18n("buildDes_name_116")
	self.scroll.bid = BUILDID.RANGE
	self.scroll.isTrain = true
	self.scroll.png = "bg_zjsb_gongbing.png"
	_ENV, self.scroll.setSingleCCS[3], self.scroll.name = self.scroll, self.scroll, i18n("buildDes_name_117")
	self.scroll.bid = BUILDID.BARRACKS
	self.scroll.isTrain = true
	self.scroll.png = "bg_zjsb_chebing.png"
	_ENV, self.scroll.setSingleCCS[4], self.scroll.name = self.scroll, self.scroll, i18n("buildDes_name_119")
	self.scroll.bid = BUILDID.ELITE_PALACE
	self.scroll.isTrain = true
	self.scroll.png = "bg_zjsb_jinying.png"
	_ENV, self.scroll.setSingleCCS[5], self.scroll.name = self.scroll, self.scroll, i18n("common_text_3129")
	self.scroll.bid = BUILDID.HOSTPITAL
	self.scroll.isTreat = true
	self.scroll.png = "bg_zjsb_jijiuzhangpeng.png"
	_ENV, self.scroll.setSingleCCS[6], self.scroll.name = self.scroll, self.scroll, i18n("buildDes_name_206")
	self.scroll.goodType = gItemType.RECRUIT_SOLDIERS
	self.scroll.isItem = true
	self.scroll.png = "bg_zjsb_xiaochang.png"
	_ENV, self.scroll.setSingleCCS[7], self.scroll.name = self.scroll, self.scroll, i18n("guide_text_167")
	self.scroll.bid = cityBuildConstDef.fixedBuildDef.ResurrectionHall
	self.scroll.key = "OpResuscitate"
	self.scroll.isResurgence = true
	self.scroll.png = "bg_zjsb_fuhuozhishui.png"
	_ENV, self.scroll.setSingleCCS[8], self.scroll.name = self.scroll, self.scroll, i18n("common_text_2499")
	self.scroll.bid = cityBuildConstDef.fixedBuildDef.ResurrectionHall
	self.scroll.key = "OpStringOfLife"
	self.scroll.isResurgence = true
	self.scroll.png = "bg_zjsb_fuhuozhishui.png"
	self.buildingsData, self.scroll.setSingleCCS[9], self.scroll.name = self.scroll.setSingleCCS, self.scroll, i18n("common_text_3459")
	self:initData()
end
function armyBuildingsView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_COOLING_PANEL", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_HOSPTIAL_VIEW", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_RESURRECTION_HALL_VIEW", handler(self, self.initData))
end
function armyBuildingsView:initData()
	_ENV = nil
	;(nil).scroll = self.scroll
	self.scroll:updateScrollView(cc.size(530, 100), self.buildingsData, 1, nil)
end
return armyBuildingsView
