local manorCityRead = include("manorCityRead")
local manorCityUtil = include("manorCityUtil")
local manorFarmRead = include("manorFarmRead")
local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local baseComponent = require("fgui.base.baseComponent")
local ManorBuildTip = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorCity/ManorBuildTip", ManorBuildTip)
_ENV = fgui.register_extension
fgui.register_extension.BUILD_YES = 1
fgui.register_extension.BUILD_NO = 2
fgui.register_extension.DETAIL = 11
fgui.register_extension.UPGRADE = 12
fgui.register_extension.RECYCLE = 13
fgui.register_extension.SPEED_UP_TOOL = 14
fgui.register_extension.SPEED_UP_GOLD = 15
fgui.register_extension.SPEED_UP_TOOL_TECH = 16
fgui.register_extension.SPEED_UP_GOLD_TECH = 17
fgui.register_extension.RESEARCH = 21
fgui.register_extension.TRADE = 22
fgui.register_extension.PLANT = 31
fgui.register_extension.RESONANCE = 32
fgui.register_extension.COLLECT = 33
fgui.register_extension.TYPE_CHANGE = 34
fgui.register_extension.FARM_TRADE_WORKSHOP = 41
fgui.register_extension.SEED_COMPOSE = 42
fgui.register_extension.FARM_TRADE_BANK = 43
local _ENV, fgui.register_extension.FARM_HELP, BUTTON_TIP = "ui://ManorCity/ManorBuildTip", 44, fgui.register_extension
_ENV = nil
;(nil).icon = "icon_czhl_g.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.BUILD_YES], (nil).iconScale = nil, 0.6
_ENV = nil
;(nil).icon = "icon_czhl_x.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.BUILD_NO], (nil).iconScale = nil, 0.6
_ENV = nil
;(nil).icon = "icon_building_details.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.DETAIL], (nil).title = nil, "common_text_059"
_ENV = nil
;(nil).icon = "icon_building_levelup.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.UPGRADE], (nil).title = nil, "runningSheep_text_06"
_ENV = nil
;(nil).icon = "icon_building_huishou.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.RECYCLE], (nil).title = nil, "decoration_btn_03"
_ENV = nil
;(nil).icon = "icon_zhuangyuan_jzjs.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.SPEED_UP_TOOL], (nil).title = nil, "common_text_018"
_ENV = nil
;(nil).icon = "icon_building_gold_speedup.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.SPEED_UP_GOLD], (nil).title = nil, "common_text_018"
_ENV = nil
;(nil).icon = "icon_zhuangyuan_yjjs.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.SPEED_UP_TOOL_TECH], (nil).title = nil, "garden_text_45"
_ENV = nil
;(nil).icon = "icon_building_gold_speedup.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.SPEED_UP_GOLD_TECH], (nil).title = nil, "garden_text_45"
_ENV = nil
;(nil).icon = "icon_building_research.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.RESEARCH], (nil).title = nil, "common_text_062"
_ENV = nil
;(nil).icon = "icon_building_trade.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.TRADE], (nil).title = nil, "garden_btn_03"
_ENV = nil
;(nil).icon = "icon_zhuangyuan_zhongzhi.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.PLANT], (nil).title = nil, "farmland_text_15"
_ENV = nil
;(nil).icon = "icon_zhuangyuan_gongming.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.RESONANCE], (nil).title = nil, "farmland_text_47"
_ENV = nil
;(nil).icon = "icon_zhuangyuan_shouji.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.COLLECT], (nil).title = nil, "common_text_057"
_ENV = nil
;(nil).icon = "icon_zhuangyuan_leixing.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.TYPE_CHANGE], (nil).title = nil, "farmland_text_42"
_ENV = nil
;(nil).icon = "icon_zhuangyuan_shangdian.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.FARM_TRADE_WORKSHOP], (nil).title = nil, "farmland_text_01"
_ENV = nil
;(nil).icon = "icon_zhuangyuan_zhongzi.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.SEED_COMPOSE], (nil).title = nil, "farmland_text_82"
_ENV = nil
;(nil).icon = "icon_zhuangyuan_jiaoyi.png"
;("ui://ManorCity/ManorBuildTip")[BUTTON_TIP.FARM_TRADE_BANK], (nil).title = nil, "farmland_text_50"
local BUTTON_TIP_CONFIG = "ui://ManorCity/ManorBuildTip"
function ManorBuildTip:onInit()
	self.btnList, _UPVALUE0_ = nil, nil
end
function ManorBuildTip:onShow()
end
function ManorBuildTip:getBtnByOpType(opType)
	for k, v in pairs(self.btnList) do
		if v.btnType == opType then
			return v
		end
	end
	return nil
end
function ManorBuildTip:setCanPlace(canPlace)
	local obj = self:getBtnByOpType(BUTTON_TIP.BUILD_YES)
	if obj then
		obj:setEnabled(canPlace)
	end
end
function ManorBuildTip:initData(data)
	for __, obj in pairs(self.btnList) do
		obj:removeFromParent()
	end
	self.btnList, _ENV = pairs(self.btnList)
	self.buildID = data.buildID
	self.buildType = manorCityRead.getBuildType(self.buildID)
	self.isInBuild = data.isInBuild
	self.instance = data.instance
	self.isInVisit = data.isInVisit
	self.isInLayoutEdit = data.isInLayoutEdit
	if not data.extra and (not self.instance or not self.instance:getExtra()) then
		if not manorCityCtrl:getMapObjByBid(self.buildID) then
			_ENV = manorCityCtrl:getMapObjByBid(self.buildID)
		end
	end
	self.extra = manorCityCtrl:getMapObjByBid(self.buildID).extra
	self.realId = self.instance:getRealId()
	local buildName = manorCityRead.getBuildName(self.buildID, self.extra)
	self.fields.Text_name:setString(buildName)
	self:updateFarmTypeIcon()
	if self.isInLayoutEdit then
		self.fields.bg_lv:setVisible(false)
		self.fields.Text_lv:setVisible(false)
	else
		local buildLv = 0
		if self.buildType == MANOR_BUILD_TYPE.BUILD then
			buildLv = manorCityCtrl:getBuildLv(self.realId)
		else
			buildLv = manorCityCtrl:getDressLv(self.buildID)
		end
		self.fields.Text_lv:setString(buildLv)
		local showLv = 0 < buildLv
		self.fields.bg_lv:setVisible(showLv)
		self.fields.Text_lv:setVisible(showLv)
	end
	local opList = self:getOpList()
	local btnList = self:getButtonList(opList)
	self:arrangeBtnByCircle(btnList)
	self.btnList = btnList
end
function ManorBuildTip:updateFarmTypeIcon()
