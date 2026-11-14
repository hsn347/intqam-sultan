local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
local nebulaWarRead = include("nebulaWarRead")
local nebulaAllStarUtil = include("nebulaAllStarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaAllStarQuitRoomPanel = class("NebulaAllStarQuitRoomPanel", baseFguiPanel)
function NebulaAllStarQuitRoomPanel:ctor(...)
	NebulaAllStarQuitRoomPanel.super.ctor(self, ...)
	print("NebulaAllStarQuitRoomPanel:ctor", self.viewName)
	self.selfCamp = nebulaAllStarCtrl:getSelfCamp()
end
function NebulaAllStarQuitRoomPanel:onInit()
	print("=======NebulaAllStarQuitRoomPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_3351"))
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Text_time:setTimeLast(function(timeStr)
		_ENV = nil
		;(nil).time = timeStr
		return i18n("NebulaAllstar_28", nil)
	end)
	self.fields.Text_time:setTimeEndListener(function()
		self.fields.Text_time:setVisible(false)
	end)
	self.fields.Label_rank:setString(i18n("Anchor_btn_04"))
	local _fields = fguiHelper.get_fields(self.fields.Com_rankTitle)
	_fields.Text_camp:setString(i18n("nebulaemperor_text_96"))
	_fields.Text_time:setString(i18n("legendaryking_title_01"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_quit:setString(i18n("common_text_054"))
	self.fields.Button_quit:addClickListener(handler(self, self.onClickBtnQuit))
	self.fields.Text_quit:setString(i18n("NebulaAllstar_29"))
	if not SoraDFIsRA() then
		self.fields.Com_rankTitle:fixChildrenPos()
	end
end
function NebulaAllStarQuitRoomPanel:onShow()
	print("=======NebulaAllStarQuitRoomPanel:onShow")
	local remainTime = nebulaAllStarCtrl:getWarEndRemainTime()
	if 0 < remainTime then
		self.fields.Text_time:beginTime(remainTime)
	end
	self.campInfo = nebulaAllStarUtil.getOccupyPalaceSecsCampInfo()
	dump(self.campInfo, "==self.campInfo==")
	self.fields.List:setNumItems(#self.campInfo)
end
function NebulaAllStarQuitRoomPanel:onItemRenderer(index, obj)
	local regionId = index + 1
	local data = self.campInfo[regionId]
	local _fields = fguiHelper.get_fields(obj)
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
	local regionName = nebulaWarRead.getAreaName(regionId)
	_fields.Text_camp:setString(regionName)
	local time = data.occupyPalaceSecs or 0
	_fields.Text_time:setString(SoraDConvertSecondToString(time))
	_fields.Image_light:setVisible(regionId % 2 == 1)
	local c_self = obj:getController("c_self")
	if self.selfCamp == regionId then
		c_self:setSelectedIndex(1)
	else
		c_self:setSelectedIndex(0)
	end
end
function NebulaAllStarQuitRoomPanel:onClickBtnQuit()
	SoraDPlaySound()
	nebulaAllStarCtrl:reqQuitRoom()
	SoraDShowLoading(self:displayObject())
end
return NebulaAllStarQuitRoomPanel
